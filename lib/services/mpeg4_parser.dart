import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'audio_metadata.dart';

/// Parses MPEG-4 container files (M4A, M4B, MP4) by walking their box tree
/// and extracting the iTunes metadata atoms from the `ilst` box.
///
/// All public methods are static.
class Mpeg4Parser {
  Mpeg4Parser._();

  // ── Entry point ───────────────────────────────────────────────────────────

  /// Scans [raf] (which must be positioned at byte 0) for iTunes metadata.
  /// [fileLength] is the total byte length of the file.
  static Future<AudioMetadata> parse(
    RandomAccessFile raf,
    int fileLength,
  ) async {
    await raf.setPosition(0);

    final _MetaAccumulator acc = _MetaAccumulator();
    await _walkBoxes(raf, 0, fileLength, acc);

    return AudioMetadata(
      title: acc.title,
      author: acc.author,
      coverBytes: acc.coverBytes,
      coverMime: acc.coverMime,
    );
  }

  // ── Box walker ────────────────────────────────────────────────────────────

  static Future<void> _walkBoxes(
    RandomAccessFile raf,
    int start,
    int end,
    _MetaAccumulator acc,
  ) async {
    int pos = start;

    while (pos + 8 < end) {
      await raf.setPosition(pos);

      final sizeBytes = await raf.read(4);
      if (sizeBytes.length < 4) break;
      final typeBytes = await raf.read(4);
      if (typeBytes.length < 4) break;

      final boxSize = _readUint32(sizeBytes);
      final boxType = String.fromCharCodes(typeBytes);

      // A size of 0 means "extends to end of file" per ISO 14496-12
      final effectiveEnd = boxSize == 0 ? end : pos + boxSize;

      if (boxSize != 0 && (boxSize < 8 || effectiveEnd > end)) break;

      switch (boxType) {
        // Container boxes — recurse into children
        case 'moov':
        case 'udta':
        case 'ilst':
          await _walkBoxes(raf, pos + 8, effectiveEnd, acc);

        case 'meta':
          // 'meta' is a FullBox — it has a 4-byte version+flags header before
          // its children. Rather than assuming the offset, scan for 'ilst'.
          await _walkMetaBox(raf, pos + 8, effectiveEnd, acc);

        // iTunes metadata leaf boxes
        case '\u00a9nam': // ©nam — title
          acc.title ??= await _readStringDataBox(raf, pos + 8, effectiveEnd);

        case '\u00a9ART': // ©ART — lead artist
        case 'aART': //  aART — album artist (fallback)
          acc.author ??= await _readStringDataBox(raf, pos + 8, effectiveEnd);

        case 'covr': // cover art
          if (acc.coverBytes == null) {
            final cover = await _readBinaryDataBox(raf, pos + 8, effectiveEnd);
            if (cover != null) {
              acc.coverBytes = cover.bytes;
              acc.coverMime = cover.mime;
            }
          }
      }

      if (boxSize == 0) break; // last box
      pos = effectiveEnd;
    }
  }

  /// Handles the 'meta' FullBox which carries a 4-byte version+flags header
  /// before its child boxes. Searches the payload for an 'ilst' marker.
  static Future<void> _walkMetaBox(
    RandomAccessFile raf,
    int metaBodyStart,
    int metaEnd,
    _MetaAccumulator acc,
  ) async {
    // Read the entire meta payload so we can scan it for the 'ilst' signature.
    final payloadLen = metaEnd - metaBodyStart;
    if (payloadLen <= 0) return;

    await raf.setPosition(metaBodyStart);
    final payload = await raf.read(payloadLen);

    // Scan for the 4-byte ASCII sequence 'ilst'
    for (int i = 4; i + 4 < payload.length; i++) {
      if (payload[i] == 0x69 &&
          payload[i + 1] == 0x6c &&
          payload[i + 2] == 0x73 &&
          payload[i + 3] == 0x74) {
        // The 4 bytes before 'ilst' are its box size
        final ilstSize = _readUint32(payload.sublist(i - 4, i));
        final ilstContentStart = metaBodyStart + i + 4;
        final ilstContentEnd = ilstContentStart + ilstSize - 8;
        await _walkBoxes(raf, ilstContentStart, ilstContentEnd, acc);
        return;
      }
    }

    // No 'ilst' found — try walking as normal child boxes (some encoders omit
    // the FullBox header version/flags or place ilst directly)
    await _walkBoxes(raf, metaBodyStart + 4, metaEnd, acc);
  }

  // ── 'data' box readers ────────────────────────────────────────────────────

  /// Reads the first `data` child box as a UTF-8 string.
  static Future<String?> _readStringDataBox(
    RandomAccessFile raf,
    int start,
    int end,
  ) async {
    final raw = await _readBinaryDataBox(raf, start, end);
    if (raw == null) return null;
    return _utf8Decode(raw.bytes);
  }

  /// Reads the first `data` child box and returns its payload + MIME type.
  static Future<_BoxPayload?> _readBinaryDataBox(
    RandomAccessFile raf,
    int start,
    int end,
  ) async {
    int pos = start;

    while (pos + 8 < end) {
      await raf.setPosition(pos);
      final sizeBytes = await raf.read(4);
      final typeBytes = await raf.read(4);

      if (sizeBytes.length < 4 || typeBytes.length < 4) break;

      final size = _readUint32(sizeBytes);
      final type = String.fromCharCodes(typeBytes);

      if (size < 16 || pos + size > end) break;

      if (type == 'data') {
        // 4 bytes: version(1) + flags(3)
        final flagBytes = await raf.read(4);
        await raf.read(4); // locale — always 0

        final flags = _readUint32(flagBytes);
        final payloadLen = size - 16;
        if (payloadLen <= 0) return null;

        final payload = Uint8List.fromList(await raf.read(payloadLen));

        // flags: 1 = UTF-8 text, 13 = JPEG, 14 = PNG
        final mime = flags == 14 ? 'image/png' : 'image/jpeg';
        return _BoxPayload(bytes: payload, mime: mime);
      }

      pos += size;
    }
    return null;
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  static int _readUint32(List<int> b) {
    return ((b[0] & 0xFF) << 24) |
        ((b[1] & 0xFF) << 16) |
        ((b[2] & 0xFF) << 8) |
        (b[3] & 0xFF);
  }

  static String _utf8Decode(List<int> bytes) {
    try {
      return const Utf8Decoder().convert(bytes).trim();
    } catch (_) {
      return String.fromCharCodes(bytes).trim();
    }
  }
}

// ── Internal accumulator ──────────────────────────────────────────────────────

class _MetaAccumulator {
  String? title;
  String? author;
  Uint8List? coverBytes;
  String? coverMime;
}

// ── Internal value object ─────────────────────────────────────────────────────

class _BoxPayload {
  const _BoxPayload({required this.bytes, required this.mime});
  final Uint8List bytes;
  final String mime;
}
