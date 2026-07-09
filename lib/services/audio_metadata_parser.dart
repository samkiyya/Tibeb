import 'dart:io';
import 'package:flutter/foundation.dart';
import 'audio_metadata.dart';
import 'id3_parser.dart';
import 'mpeg4_parser.dart';

export 'audio_metadata.dart';

/// Detects the audio container format from the file's magic bytes and
/// delegates parsing to the appropriate format-specific parser.
///
/// Supported formats:
/// - MP3 with ID3v2.2 / ID3v2.3 / ID3v2.4 tags  → [Id3Parser.parseId3v2]
/// - MP3 with ID3v1 fallback                      → [Id3Parser.parseId3v1]
/// - MPEG-4 containers (M4A, M4B, AAC)            → [Mpeg4Parser.parse]
class AudioMetadataParser {
  AudioMetadataParser._();

  // Magic-byte signatures
  static const _id3Sig = [0x49, 0x44, 0x33]; // "ID3"
  static const _ftypSig = [0x66, 0x74, 0x79, 0x70]; // "ftyp" at offset 4
  static const _moovSig = [0x6d, 0x6f, 0x6f, 0x76]; // "moov" at offset 4

  /// Parses [filePath] and returns [AudioMetadata], or null if the file
  /// does not exist, is too short to detect, or no tags were found.
  static Future<AudioMetadata?> parseFile(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      debugPrint('AudioMetadataParser: file not found — $filePath');
      return null;
    }

    RandomAccessFile? raf;
    try {
      raf = await file.open(mode: FileMode.read);
      final fileLen = await raf.length();
      if (fileLen < 12) return null;

      // Read the first 12 bytes to detect the container format
      final header = await raf.read(12);

      // ── MP3 / ID3v2 ──────────────────────────────────────────────────────
      if (_matchesAt(header, 0, _id3Sig)) {
        debugPrint('AudioMetadataParser: detected ID3v2 tag in $filePath');
        final meta = await Id3Parser.parseId3v2(raf, header);
        if (meta.hasContent) return meta;
        // ID3v2 found but empty — fall through to ID3v1
        debugPrint('AudioMetadataParser: ID3v2 empty, trying ID3v1');
      }

      // ── MPEG-4 (M4A / M4B / AAC) ─────────────────────────────────────────
      if (_matchesAt(header, 4, _ftypSig) || _matchesAt(header, 4, _moovSig)) {
        debugPrint('AudioMetadataParser: detected MPEG-4 container in $filePath');
        final meta = await Mpeg4Parser.parse(raf, fileLen);
        if (meta.hasContent) return meta;
        debugPrint('AudioMetadataParser: MPEG-4 parsing returned no metadata');
        return null;
      }

      // ── ID3v1 (MP3 without ID3v2, or ID3v2 was empty) ────────────────────
      if (fileLen >= 128) {
        debugPrint('AudioMetadataParser: trying ID3v1 fallback in $filePath');
        final meta = await Id3Parser.parseId3v1(raf, fileLen);
        if (meta.hasContent) return meta;
      }

      debugPrint('AudioMetadataParser: no metadata found in $filePath');
      return null;
    } catch (e, st) {
      debugPrint('AudioMetadataParser: error parsing $filePath\n$e\n$st');
      return null;
    } finally {
      await raf?.close();
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Returns true if [bytes] at [offset] match all bytes in [sig].
  static bool _matchesAt(List<int> bytes, int offset, List<int> sig) {
    if (offset + sig.length > bytes.length) return false;
    for (int i = 0; i < sig.length; i++) {
      if (bytes[offset + i] != sig[i]) return false;
    }
    return true;
  }
}
