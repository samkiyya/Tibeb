import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'audio_metadata.dart';

/// Parses ID3v2 (versions 2.2, 2.3, 2.4) and ID3v1 tags from MP3 files.
/// Handles: extended headers, unsynchronization, padding, and all common
/// text encodings (ISO-8859-1, UTF-16 LE/BE with or without BOM, UTF-8).
class Id3Parser {
  Id3Parser._();

  // ── Entry points ──────────────────────────────────────────────────────────

  /// Parses an ID3v2 tag from [raf].
  /// [header] = first 12 bytes already read by the caller.
  static Future<AudioMetadata> parseId3v2(
    RandomAccessFile raf,
    List<int> header,
  ) async {
    final version = header[3]; // 2=v2.2, 3=v2.3, 4=v2.4
    final flags = header[5];
    final hasUnsync = (flags & 0x80) != 0;
    final hasExtHeader = (flags & 0x40) != 0;

    // Synchsafe tag size (excludes 10-byte header)
    final tagSize = _synchsafeInt(header, 6);
    if (tagSize <= 0) {
      return AudioMetadata.empty;
    }

    // Read the full tag body with a reliable read loop
    List<int> tagBytes = await _readExact(raf, tagSize);
    if (tagBytes.isEmpty) {
      return AudioMetadata.empty;
    }

    // Apply unsynchronization decoding if flag is set (v2.3 tag-level flag)
    if (hasUnsync && version != 4) {
      tagBytes = _decodeUnsync(tagBytes);
    }

    // Skip the extended header if present
    int offset = 0;
    if (hasExtHeader) {
      offset = _skipExtendedHeader(tagBytes, version);
    }

    return version == 2
        ? _parseFramesV22(tagBytes, offset)
        : _parseFramesV23V24(tagBytes, version, offset);
  }

  /// Parses an ID3v1 tag from the last 128 bytes of [raf].
  static Future<AudioMetadata> parseId3v1(
    RandomAccessFile raf,
    int fileLength,
  ) async {
    await raf.setPosition(fileLength - 128);
    final bytes = await _readExact(raf, 128);
    if (bytes.length < 128 ||
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

  // ── Extended header skip ──────────────────────────────────────────────────

  static int _skipExtendedHeader(List<int> bytes, int version) {
    if (bytes.length < 4) return 0;
    if (version == 4) {
      // v2.4: synchsafe size includes itself
      final size = _synchsafeInt(bytes, 0);
      return size;
    } else {
      // v2.3: plain uint32, does NOT include the 4-byte size field itself
      final size = _uint32BE(bytes, 0);
      return 4 + size;
    }
  }

  // ── ID3v2.2 frames ────────────────────────────────────────────────────────

  static AudioMetadata _parseFramesV22(List<int> tagBytes, int startOffset) {
    int offset = startOffset;
    String? title, author;
    Uint8List? coverBytes;
    String? coverMime;

    while (offset + 6 < tagBytes.length) {
      // Padding: end of frames
      if (tagBytes[offset] == 0x00) break;

      final frameIdBytes = tagBytes.sublist(offset, offset + 3);
      if (!_allPrintableAscii(frameIdBytes)) {
        break;
      }
      final frameId = String.fromCharCodes(frameIdBytes);

      final fs = tagBytes.sublist(offset + 3, offset + 6);
      final frameSize =
          ((fs[0] & 0xFF) << 16) | ((fs[1] & 0xFF) << 8) | (fs[2] & 0xFF);

      if (frameSize <= 0 || offset + 6 + frameSize > tagBytes.length) {
        break;
      }

      final body = tagBytes.sublist(offset + 6, offset + 6 + frameSize);
      switch (frameId) {
        case 'TT2':
          title = _decodeTextFrame(body);
        case 'TP1':
        case 'TP2':
          author ??= _decodeTextFrame(body);
        case 'PIC':
          try {
            final r = _decodePicFrame(body);
            if (r != null) {
              coverBytes = r.bytes;
              coverMime = r.mime;
            }
          } catch (_) {}
      }

      offset += 6 + frameSize;
    }

    return AudioMetadata(
        title: title, author: author, coverBytes: coverBytes, coverMime: coverMime);
  }

  // ── ID3v2.3 / ID3v2.4 frames ──────────────────────────────────────────────

  static AudioMetadata _parseFramesV23V24(
      List<int> tagBytes, int version, int startOffset) {
    int offset = startOffset;
    String? title, author;
    Uint8List? coverBytes;
    String? coverMime;

    while (offset + 10 < tagBytes.length) {
      // Padding: end of frames
      if (tagBytes[offset] == 0x00) break;

      final frameIdBytes = tagBytes.sublist(offset, offset + 4);
      if (!_allPrintableAscii(frameIdBytes)) {
       break;
      }
      final frameId = String.fromCharCodes(frameIdBytes);

      // Frame flags at offset+8, offset+9 — not needed for basic parsing

      final int frameSize;
      if (version == 4) {
        // v2.4 frame size is synchsafe
        frameSize = _synchsafeInt(tagBytes, offset + 4);
      } else {
        // v2.3 frame size is plain big-endian uint32
        frameSize = _uint32BE(tagBytes, offset + 4);
      }

      if (frameSize <= 0 || offset + 10 + frameSize > tagBytes.length) {
       break;
      }

      List<int> body = tagBytes.sublist(offset + 10, offset + 10 + frameSize);

      // v2.4 per-frame unsynchronization (frame flag bit 1 of second flags byte)
      if (version == 4) {
        final frameFlags2 = tagBytes[offset + 9];
        if ((frameFlags2 & 0x02) != 0) {
          body = _decodeUnsync(body);
        }
      }
      
      switch (frameId) {
        case 'TIT2':
          title = _decodeTextFrame(body);
        case 'TPE1':
        case 'TPE2':
          author ??= _decodeTextFrame(body);
        case 'TALB':
          // Album — useful fallback if title is missing
        case 'APIC':
          try {
            final r = _decodeApicFrame(body);
            if (r != null) {
              coverBytes = r.bytes;
              coverMime = r.mime;
              }
          } catch (_) {}
      }

      offset += 10 + frameSize;
    }
 
  return AudioMetadata(
        title: title, author: author, coverBytes: coverBytes, coverMime: coverMime);
  }

  // ── Text frame decoding ───────────────────────────────────────────────────

  static String? _decodeTextFrame(List<int> bytes) {
    if (bytes.isEmpty) return null;
    final encoding = bytes[0];
    final textBytes = bytes.sublist(1);

    final String result;
    switch (encoding) {
      case 0: // ISO-8859-1 (Latin-1)
        final trimmed = textBytes.takeWhile((b) => b != 0).toList();
        result = _latin1Decode(trimmed);
      case 1: // UTF-16 with BOM
        result = _decodeUtf16(textBytes);
      case 2: // UTF-16BE without BOM
        result = _decodeUtf16BE(textBytes);
      case 3: // UTF-8
        final trimmed = textBytes.takeWhile((b) => b != 0).toList();
        result = _utf8Decode(trimmed);
      default:
        // Unknown encoding — try UTF-8 first, fall back to Latin-1
        final trimmed = textBytes.takeWhile((b) => b != 0).toList();
        final u = _utf8DecodeLenient(trimmed);
        result = u ?? _latin1Decode(trimmed);
    }

    final cleaned = result.trim();
    return cleaned.isEmpty ? null : cleaned;
  }

  // ── UTF-16 decoders ───────────────────────────────────────────────────────

  static String _decodeUtf16(List<int> bytes) {
    if (bytes.length < 2) return '';
    int start = 0;
    bool le = true; // default: little-endian

    if (bytes[0] == 0xFF && bytes[1] == 0xFE) {
      start = 2;
      le = true;
    } else if (bytes[0] == 0xFE && bytes[1] == 0xFF) {
      start = 2;
      le = false;
    }

    return _utf16CodeUnits(bytes, start, le);
  }

  static String _decodeUtf16BE(List<int> bytes) {
    if (bytes.length < 2) return '';
    // Check for accidental BOM
    if (bytes[0] == 0xFE && bytes[1] == 0xFF) {
      return _utf16CodeUnits(bytes, 2, false);
    }
    return _utf16CodeUnits(bytes, 0, false);
  }

  static String _utf16CodeUnits(List<int> bytes, int start, bool le) {
    final chars = <int>[];
    for (int i = start; i + 1 < bytes.length; i += 2) {
      final code =
          le ? (bytes[i] | (bytes[i + 1] << 8)) : ((bytes[i] << 8) | bytes[i + 1]);
      if (code == 0) break;
      chars.add(code);
    }
    return String.fromCharCodes(chars).trim();
  }

  // ── Cover art decoders ────────────────────────────────────────────────────

  static _CoverData? _decodeApicFrame(List<int> bytes) {
    if (bytes.length < 5) return null;
    final encoding = bytes[0];

    // MIME type: null-terminated ASCII at bytes[1..]
    int mimeEnd = 1;
    while (mimeEnd < bytes.length && bytes[mimeEnd] != 0) {
      mimeEnd++;
    }
    if (mimeEnd >= bytes.length) return null;

    final mimeRaw = String.fromCharCodes(bytes.sublist(1, mimeEnd));
    // picture type byte
    // description (null-terminated, encoding-dependent)
    int descStart = mimeEnd + 2; // skip null-terminator + picture-type byte

    if (encoding == 1 || encoding == 2) {
      // UTF-16: scan for double-null
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
      mime: _normaliseMime(mimeRaw),
    );
  }

  static _CoverData? _decodePicFrame(List<int> bytes) {
    if (bytes.length < 6) return null;
    final encoding = bytes[0];
    final format = String.fromCharCodes(bytes.sublist(1, 4)).toUpperCase().trim();
    final mime = format == 'PNG' ? 'image/png' : 'image/jpeg';

    int descStart = 5; // encoding(1) + format(3) + pictureType(1)
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
    return _CoverData(bytes: Uint8List.fromList(bytes.sublist(descStart)), mime: mime);
  }

  // ── Unsynchronization ─────────────────────────────────────────────────────

  /// Decodes unsynchronized bytes: replaces 0xFF 0x00 → 0xFF.
  static List<int> _decodeUnsync(List<int> bytes) {
    final out = <int>[];
    for (int i = 0; i < bytes.length; i++) {
      out.add(bytes[i]);
      if (bytes[i] == 0xFF && i + 1 < bytes.length && bytes[i + 1] == 0x00) {
        i++; // skip the stuffed 0x00
      }
    }
    return out;
  }

  // ── Binary helpers ────────────────────────────────────────────────────────

  /// 4-byte synchsafe integer (7 bits per byte, MSB first).
  static int _synchsafeInt(List<int> bytes, int offset) {
    if (offset + 4 > bytes.length) return 0;
    return ((bytes[offset] & 0x7F) << 21) |
        ((bytes[offset + 1] & 0x7F) << 14) |
        ((bytes[offset + 2] & 0x7F) << 7) |
        (bytes[offset + 3] & 0x7F);
  }

  /// Plain big-endian uint32.
  static int _uint32BE(List<int> bytes, int offset) {
    if (offset + 4 > bytes.length) return 0;
    return ((bytes[offset] & 0xFF) << 24) |
        ((bytes[offset + 1] & 0xFF) << 16) |
        ((bytes[offset + 2] & 0xFF) << 8) |
        (bytes[offset + 3] & 0xFF);
  }

  /// Checks all bytes are valid ID3 frame ID characters: [A-Z0-9].
  static bool _allPrintableAscii(List<int> bytes) {
    for (final b in bytes) {
      // Valid: uppercase A-Z (0x41-0x5A), digits 0-9 (0x30-0x39)
      final isDigit = b >= 0x30 && b <= 0x39;
      final isUpper = b >= 0x41 && b <= 0x5A;
      if (!isDigit && !isUpper) return false;
    }
    return true;
  }

  /// Reads exactly [count] bytes from [raf], retrying until fulfilled or EOF.
  static Future<List<int>> _readExact(RandomAccessFile raf, int count) async {
    final result = <int>[];
    int remaining = count;
    while (remaining > 0) {
      final chunk = await raf.read(remaining);
      if (chunk.isEmpty) break; // EOF
      result.addAll(chunk);
      remaining -= chunk.length;
    }
    return result;
  }

  static String _utf8Decode(List<int> bytes) {
    try {
      return const Utf8Decoder().convert(bytes);
    } catch (_) {
      // Fall back to Latin-1 if UTF-8 fails (e.g. raw ISO-8859-1 data)
      return _latin1Decode(bytes);
    }
  }

  /// Returns null if bytes are not valid UTF-8.
  static String? _utf8DecodeLenient(List<int> bytes) {
    try {
      return const Utf8Decoder(allowMalformed: false).convert(bytes);
    } catch (_) {
      return null;
    }
  }

  static String _latin1Decode(List<int> bytes) {
    // Latin-1: each byte maps directly to its Unicode code point
    return String.fromCharCodes(bytes);
  }

  static String _trimNulls(List<int> bytes) {
    return _utf8Decode(bytes.takeWhile((b) => b != 0).toList()).trim();
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
