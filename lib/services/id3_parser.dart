import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'audio_metadata.dart';

/// Parses ID3v2 (versions 2.2, 2.3, 2.4) and ID3v1 tags from MP3 files.
///
/// All public methods are static — no instance state is needed.
class Id3Parser {
  Id3Parser._();

  // ── Entry points ──────────────────────────────────────────────────────────

  /// Parses an ID3v2 tag from [raf].
  ///
  /// [header] must be the first 12 bytes of the file (already read by the
  /// caller so the file position is left just after byte 9 — i.e. at the
  /// start of the tag body).
  static Future<AudioMetadata> parseId3v2(
    RandomAccessFile raf,
    List<int> header,
  ) async {
    final version = header[3]; // 2 = v2.2, 3 = v2.3, 4 = v2.4

    // Tag size is a 4-byte synchsafe integer (7 bits per byte)
    final tagSize = ((header[6] & 0x7F) << 21) |
        ((header[7] & 0x7F) << 14) |
        ((header[8] & 0x7F) << 7) |
        (header[9] & 0x7F);

    if (tagSize <= 0) return AudioMetadata.empty;

    final tagBytes = await raf.read(tagSize);

    return version == 2
        ? _parseFramesV22(tagBytes)
        : _parseFramesV23V24(tagBytes, version);
  }

  /// Reads the last 128 bytes of [raf] and tries to parse an ID3v1 tag.
  /// Returns [AudioMetadata.empty] if none is found.
  static Future<AudioMetadata> parseId3v1(
    RandomAccessFile raf,
    int fileLength,
  ) async {
    await raf.setPosition(fileLength - 128);
    final bytes = await raf.read(128);

    // Signature: "TAG" = 0x54 0x41 0x47
    if (bytes.length != 128 ||
        bytes[0] != 0x54 ||
        bytes[1] != 0x41 ||
        bytes[2] != 0x47) {
      return AudioMetadata.empty;
    }

    final title = _trimNulls(bytes.sublist(3, 33));
    final artist = _trimNulls(bytes.sublist(33, 63));

    return AudioMetadata(
      title: title.isEmpty ? null : title,
      author: artist.isEmpty ? null : artist,
    );
  }

  // ── ID3v2.2 frames ────────────────────────────────────────────────────────

  static AudioMetadata _parseFramesV22(List<int> tagBytes) {
    int offset = 0;
    String? title, author;
    Uint8List? coverBytes;
    String? coverMime;

    while (offset + 6 < tagBytes.length) {
      final frameId =
          String.fromCharCodes(tagBytes.sublist(offset, offset + 3)).trim();
      if (!_isValidFrameId(frameId, 3)) break;

      final fs = tagBytes.sublist(offset + 3, offset + 6);
      final frameSize =
          ((fs[0] & 0xFF) << 16) | ((fs[1] & 0xFF) << 8) | (fs[2] & 0xFF);

      if (frameSize <= 0 || offset + 6 + frameSize > tagBytes.length) break;

      final body = tagBytes.sublist(offset + 6, offset + 6 + frameSize);

      switch (frameId) {
        case 'TT2': // Title
          title = _decodeTextFrame(body);
        case 'TP1': // Lead artist
        case 'TP2': // Band / orchestra
          author ??= _decodeTextFrame(body);
      }

      if (frameId == 'PIC') {
        try {
          final r = _decodePicFrame(body);
          if (r != null) {
            coverBytes = r.bytes;
            coverMime = r.mime;
          }
        } catch (e) {
          debugPrint('Id3Parser: v2.2 PIC frame error: $e');
        }
      }

      offset += 6 + frameSize;
    }

    return AudioMetadata(
      title: title,
      author: author,
      coverBytes: coverBytes,
      coverMime: coverMime,
    );
  }

  // ── ID3v2.3 / ID3v2.4 frames ──────────────────────────────────────────────

  static AudioMetadata _parseFramesV23V24(List<int> tagBytes, int version) {
    int offset = 0;
    String? title, author;
    Uint8List? coverBytes;
    String? coverMime;

    while (offset + 10 < tagBytes.length) {
      final frameId =
          String.fromCharCodes(tagBytes.sublist(offset, offset + 4)).trim();
      if (!_isValidFrameId(frameId, 4)) break;

      final int frameSize;
      if (version == 4) {
        // v2.4 uses synchsafe frame size
        final fs = tagBytes.sublist(offset + 4, offset + 8);
        frameSize = ((fs[0] & 0x7F) << 21) |
            ((fs[1] & 0x7F) << 14) |
            ((fs[2] & 0x7F) << 7) |
            (fs[3] & 0x7F);
      } else {
        // v2.3 uses plain big-endian uint32
        frameSize = ByteData.sublistView(
          Uint8List.fromList(tagBytes.sublist(offset + 4, offset + 8)),
        ).getUint32(0);
      }

      if (frameSize <= 0 || offset + 10 + frameSize > tagBytes.length) break;

      final body = tagBytes.sublist(offset + 10, offset + 10 + frameSize);

      switch (frameId) {
        case 'TIT2': // Title
          title = _decodeTextFrame(body);
        case 'TPE1': // Lead performer
        case 'TPE2': // Band / orchestra
          author ??= _decodeTextFrame(body);
      }

      if (frameId == 'APIC') {
        try {
          final r = _decodeApicFrame(body);
          if (r != null) {
            coverBytes = r.bytes;
            coverMime = r.mime;
          }
        } catch (e) {
          debugPrint('Id3Parser: APIC frame error: $e');
        }
      }

      offset += 10 + frameSize;
    }

    return AudioMetadata(
      title: title,
      author: author,
      coverBytes: coverBytes,
      coverMime: coverMime,
    );
  }

  // ── Text frame decoding ───────────────────────────────────────────────────

  /// Decodes an ID3 text frame body (first byte = encoding, rest = text).
  static String? _decodeTextFrame(List<int> bytes) {
    if (bytes.isEmpty) return null;
    final encoding = bytes[0];
    final textBytes = bytes.sublist(1);

    final String result;
    if (encoding == 1 || encoding == 2) {
      // encoding 1 = UTF-16 with BOM, encoding 2 = UTF-16BE without BOM
      result = _decodeUtf16(textBytes);
    } else {
      // encoding 0 = ISO-8859-1, encoding 3 = UTF-8 — both handled by UTF-8 decoder
      final trimmed = textBytes.takeWhile((b) => b != 0).toList();
      result = _utf8Decode(trimmed);
    }

    final cleaned = result.trim();
    return cleaned.isEmpty ? null : cleaned;
  }

  static String _decodeUtf16(List<int> bytes) {
    if (bytes.length < 2) return '';
    int start = 0;
    bool littleEndian = true;

    if (bytes[0] == 0xFF && bytes[1] == 0xFE) {
      start = 2; // BOM: LE
      littleEndian = true;
    } else if (bytes[0] == 0xFE && bytes[1] == 0xFF) {
      start = 2; // BOM: BE
      littleEndian = false;
    }
    // No BOM — assume little-endian (most common in ID3v2.3)

    final chars = <int>[];
    for (int i = start; i + 1 < bytes.length; i += 2) {
      final code = littleEndian
          ? (bytes[i] | (bytes[i + 1] << 8))
          : ((bytes[i] << 8) | bytes[i + 1]);
      if (code == 0) break; // null terminator
      chars.add(code);
    }
    return String.fromCharCodes(chars).trim();
  }

  // ── Cover art frame decoding ──────────────────────────────────────────────

  /// Decodes an ID3v2.3/v2.4 APIC frame.
  static _CoverData? _decodeApicFrame(List<int> bytes) {
    if (bytes.length < 5) return null;
    final encoding = bytes[0];

    // MIME type: null-terminated ASCII starting at byte 1
    int mimeEnd = 1;
    while (mimeEnd < bytes.length && bytes[mimeEnd] != 0) {
      mimeEnd++;
    }
    if (mimeEnd >= bytes.length) return null;
    final mime = String.fromCharCodes(bytes.sublist(1, mimeEnd));

    // Skip: picture type byte (1) + null terminator of mime (already at mimeEnd)
    // Description starts after: mimeEnd + 1 (picture type) + description + null
    int descStart = mimeEnd + 2; // +1 for null, +1 for picture type
    if (encoding == 1 || encoding == 2) {
      // UTF-16 description: scan for double-null
      while (descStart + 1 < bytes.length &&
          !(bytes[descStart] == 0 && bytes[descStart + 1] == 0)) {
        descStart += 2;
      }
      descStart += 2; // skip the double-null
    } else {
      // ASCII/UTF-8 description: scan for single null
      while (descStart < bytes.length && bytes[descStart] != 0) {
        descStart++;
      }
      descStart++; // skip the null
    }

    if (descStart >= bytes.length) return null;

    return _CoverData(
      bytes: Uint8List.fromList(bytes.sublist(descStart)),
      mime: _normaliseMime(mime),
    );
  }

  /// Decodes an ID3v2.2 PIC frame.
  static _CoverData? _decodePicFrame(List<int> bytes) {
    if (bytes.length < 6) return null;
    final encoding = bytes[0];

    // Format: 3-byte ASCII (e.g. "JPG", "PNG") instead of MIME
    final format =
        String.fromCharCodes(bytes.sublist(1, 4)).toUpperCase().trim();
    final mime = format == 'PNG' ? 'image/png' : 'image/jpeg';

    // Skip: encoding(1) + format(3) + pictureType(1) = 5 bytes, then description
    int descStart = 5;
    if (encoding == 1 || encoding == 2) {
      while (descStart + 1 < bytes.length &&
          !(bytes[descStart] == 0 && bytes[descStart + 1] == 0)) {
        descStart += 2;
      }
      descStart += 2;
    } else {
      while (descStart < bytes.length && bytes[descStart] != 0) {
        descStart++;
      }
      descStart++;
    }

    if (descStart >= bytes.length) return null;

    return _CoverData(
      bytes: Uint8List.fromList(bytes.sublist(descStart)),
      mime: mime,
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  static bool _isValidFrameId(String id, int expectedLen) {
    if (id.length != expectedLen) return false;
    return id.codeUnits.every((u) => u >= 0x20 && u <= 0x7E);
  }

  static String _trimNulls(List<int> bytes) {
    return _utf8Decode(bytes.takeWhile((b) => b != 0).toList()).trim();
  }

  static String _utf8Decode(List<int> bytes) {
    try {
      return const Utf8Decoder().convert(bytes);
    } catch (_) {
      return String.fromCharCodes(bytes);
    }
  }

  static String _normaliseMime(String raw) {
    final lower = raw.toLowerCase();
    if (lower.contains('png')) return 'image/png';
    if (lower.contains('jpeg') || lower.contains('jpg')) return 'image/jpeg';
    return lower.isEmpty ? 'image/jpeg' : lower;
  }
}

// ── Internal value object ─────────────────────────────────────────────────────

class _CoverData {
  const _CoverData({required this.bytes, required this.mime});
  final Uint8List bytes;
  final String mime;
}
