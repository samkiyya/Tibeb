import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class AudioMetadata {
  final String? title;
  final String? author;
  final Uint8List? coverBytes;
  final String? coverMime;

  AudioMetadata({this.title, this.author, this.coverBytes, this.coverMime});
}

class AudioMetadataParser {
  /// Parses the given audio file and extracts title, author, and cover art.
  static Future<AudioMetadata?> parseFile(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) return null;

    RandomAccessFile? raf;
    try {
      raf = await file.open(mode: FileMode.read);
      final len = await raf.length();
      if (len < 12) return null;

      // Read initial signature to determine file type
      final header = await raf.read(12);
      
      // Check for MP3 (ID3v2)
      if (header[0] == 0x49 && header[1] == 0x44 && header[2] == 0x33) { // "ID3"
        final meta = await _parseId3(raf, header);
        if (meta.title != null || meta.author != null || meta.coverBytes != null) {
          return meta;
        }
      }
      
      // Check for M4A / M4B / MP4 (MPEG-4 container)
      if ((header[4] == 0x66 && header[5] == 0x74 && header[6] == 0x79 && header[7] == 0x70) || // "ftyp"
          (header[4] == 0x6d && header[5] == 0x6f && header[6] == 0x6f && header[7] == 0x76)) { // "moov"
        return await _parseM4a(raf, len);
      }

      // Fallback: ID3v1 if it is an MP3 but has no ID3v2 or ID3v2 failed
      if (len >= 128) {
        return await _parseId3v1(raf, len);
      }
    } catch (e) {
      debugPrint('Error parsing audio metadata: $e');
    } finally {
      await raf?.close();
    }
    return null;
  }

  // ── ID3v2 Parser (MP3) ──────────────────────────────────────────────────────

  static Future<AudioMetadata> _parseId3(RandomAccessFile raf, List<int> header) async {
    final version = header[3]; // 2 = v2.2, 3 = v2.3, 4 = v2.4
    
    // Size is a 4-byte synchsafe integer starting at offset 6
    final tagSize = ((header[6] & 0x7F) << 21) |
                    ((header[7] & 0x7F) << 14) |
                    ((header[8] & 0x7F) << 7) |
                    (header[9] & 0x7F);

    if (tagSize <= 0) return AudioMetadata();

    // Read the entire ID3 tag body
    final tagBytes = await raf.read(tagSize);
    int offset = 0;

    String? title;
    String? author;
    Uint8List? coverBytes;
    String? coverMime;

    // Support ID3v2.2 (3-byte frame ID, 3-byte size, 6-byte header)
    if (version == 2) {
      while (offset + 6 < tagBytes.length) {
        final frameId = String.fromCharCodes(tagBytes.sublist(offset, offset + 3)).trim();
        if (frameId.length < 3 || frameId.codeUnits.any((u) => u < 0x20 || u > 0x7E)) break;

        final fs = tagBytes.sublist(offset + 3, offset + 6);
        final frameSize = ((fs[0] & 0xFF) << 16) | ((fs[1] & 0xFF) << 8) | (fs[2] & 0xFF);

        if (frameSize <= 0 || offset + 6 + frameSize > tagBytes.length) break;

        final frameBody = tagBytes.sublist(offset + 6, offset + 6 + frameSize);

        if (frameId == 'TT2') { // Title
          title = _parseId3Text(frameBody);
        } else if (frameId == 'TP1' || frameId == 'TP2') { // Author / Artist
          author = _parseId3Text(frameBody);
        } else if (frameId == 'PIC') { // Cover art (ID3v2.2)
          try {
            final result = _parseId3v22Pic(frameBody);
            if (result != null) {
              coverBytes = result['bytes'] as Uint8List?;
              coverMime = result['mime'] as String?;
            }
          } catch (e) {
            debugPrint('Error parsing v2.2 PIC frame: $e');
          }
        }

        offset += 6 + frameSize;
      }
    } else {
      // ID3v2.3 / ID3v2.4 (4-byte frame ID, 4-byte size, 10-byte header)
      while (offset + 10 < tagBytes.length) {
        final frameId = String.fromCharCodes(tagBytes.sublist(offset, offset + 4)).trim();
        if (frameId.length < 4 || frameId.codeUnits.any((u) => u < 0x20 || u > 0x7E)) break;
        
        int frameSize;
        if (version == 4) {
          final fs = tagBytes.sublist(offset + 4, offset + 8);
          frameSize = ((fs[0] & 0x7F) << 21) |
                      ((fs[1] & 0x7F) << 14) |
                      ((fs[2] & 0x7F) << 7) |
                      (fs[3] & 0x7F);
        } else {
          final data = ByteData.sublistView(Uint8List.fromList(tagBytes.sublist(offset + 4, offset + 8)));
          frameSize = data.getUint32(0);
        }

        if (frameSize <= 0 || offset + 10 + frameSize > tagBytes.length) break;

        final frameBody = tagBytes.sublist(offset + 10, offset + 10 + frameSize);

        if (frameId == 'TIT2') { // Title
          title = _parseId3Text(frameBody);
        } else if (frameId == 'TPE1' || frameId == 'TPE2') { // Author / Artist
          author = _parseId3Text(frameBody);
        } else if (frameId == 'APIC') { // Cover art
          try {
            final result = _parseId3Apic(frameBody);
            if (result != null) {
              coverBytes = result['bytes'] as Uint8List?;
              coverMime = result['mime'] as String?;
            }
          } catch (e) {
            debugPrint('Error parsing APIC frame: $e');
          }
        }

        offset += 10 + frameSize;
      }
    }

    return AudioMetadata(
      title: title,
      author: author,
      coverBytes: coverBytes,
      coverMime: coverMime,
    );
  }

  static String? _parseId3Text(List<int> bytes) {
    if (bytes.isEmpty) return null;
    final encoding = bytes[0];
    final textBytes = bytes.sublist(1);

    if (encoding == 1 || encoding == 2) { // UTF-16 with BOM or without BOM
      return _decodeUtf16(textBytes);
    } else { // ASCII / UTF-8
      final trimmed = textBytes.takeWhile((b) => b != 0).toList();
      return utf8Decode(trimmed);
    }
  }

  static String _decodeUtf16(List<int> bytes) {
    if (bytes.length < 2) return '';
    int start = 0;
    bool le = true;
    if (bytes[0] == 0xFF && bytes[1] == 0xFE) {
      start = 2;
      le = true;
    } else if (bytes[0] == 0xFE && bytes[1] == 0xFF) {
      start = 2;
      le = false;
    }

    final chars = <int>[];
    for (int i = start; i + 1 < bytes.length; i += 2) {
      final code = le ? (bytes[i] | (bytes[i + 1] << 8)) : ((bytes[i] << 8) | bytes[i + 1]);
      if (code == 0) break;
      chars.add(code);
    }
    return String.fromCharCodes(chars).trim();
  }

  static Map<String, dynamic>? _parseId3Apic(List<int> bytes) {
    if (bytes.length < 5) return null;
    final encoding = bytes[0];
    
    int mimeIndex = 1;
    while (mimeIndex < bytes.length && bytes[mimeIndex] != 0) {
      mimeIndex++;
    }
    if (mimeIndex >= bytes.length) return null;
    final mime = String.fromCharCodes(bytes.sublist(1, mimeIndex));

    int descIndex = mimeIndex + 2; // skip picture type byte
    if (encoding == 1 || encoding == 2) { // UTF-16
      while (descIndex + 1 < bytes.length && (bytes[descIndex] != 0 || bytes[descIndex + 1] != 0)) {
        descIndex += 2;
      }
      descIndex += 2;
    } else { // UTF-8 / ASCII
      while (descIndex < bytes.length && bytes[descIndex] != 0) {
        descIndex++;
      }
      descIndex++;
    }

    if (descIndex >= bytes.length) return null;

    final imgBytes = Uint8List.fromList(bytes.sublist(descIndex));
    return {
      'mime': mime,
      'bytes': imgBytes,
    };
  }

  static Map<String, dynamic>? _parseId3v22Pic(List<int> bytes) {
    if (bytes.length < 6) return null;
    final encoding = bytes[0];
    
    // Format is 3 bytes (e.g. "JPG", "PNG")
    final formatStr = String.fromCharCodes(bytes.sublist(1, 4)).toUpperCase();
    final mime = formatStr == 'PNG' ? 'image/png' : 'image/jpeg';

    int descIndex = 5; // encoding(1) + format(3) + pictureType(1)
    if (encoding == 1 || encoding == 2) { // UTF-16
      while (descIndex + 1 < bytes.length && (bytes[descIndex] != 0 || bytes[descIndex + 1] != 0)) {
        descIndex += 2;
      }
      descIndex += 2;
    } else { // UTF-8 / ASCII
      while (descIndex < bytes.length && bytes[descIndex] != 0) {
        descIndex++;
      }
      descIndex++;
    }

    if (descIndex >= bytes.length) return null;

    final imgBytes = Uint8List.fromList(bytes.sublist(descIndex));
    return {
      'mime': mime,
      'bytes': imgBytes,
    };
  }

  // ── ID3v1 Fallback Parser ──────────────────────────────────────────────────

  static Future<AudioMetadata> _parseId3v1(RandomAccessFile raf, int len) async {
    await raf.setPosition(len - 128);
    final bytes = await raf.read(128);
    if (bytes.length == 128 && bytes[0] == 0x54 && bytes[1] == 0x41 && bytes[2] == 0x47) { // "TAG"
      final titleBytes = bytes.sublist(3, 33).takeWhile((b) => b != 0).toList();
      final artistBytes = bytes.sublist(33, 63).takeWhile((b) => b != 0).toList();
      
      return AudioMetadata(
        title: utf8Decode(titleBytes).trim(),
        author: utf8Decode(artistBytes).trim(),
      );
    }
    return AudioMetadata();
  }

  // ── M4A / M4B Parser (MPEG-4) ──────────────────────────────────────────────

  static Future<AudioMetadata> _parseM4a(RandomAccessFile raf, int totalLen) async {
    await raf.setPosition(0);
    String? title;
    String? author;
    Uint8List? coverBytes;
    String? coverMime;

    // Scan for udta -> meta -> ilst boxes
    Future<void> findInBoxes(int offset, int endOffset) async {
      int pos = offset;
      while (pos + 8 < endOffset) {
        await raf.setPosition(pos);
        final sizeBytes = await raf.read(4);
        final typeBytes = await raf.read(4);
        
        final size = ByteData.sublistView(Uint8List.fromList(sizeBytes)).getUint32(0);
        final type = String.fromCharCodes(typeBytes);

        if (size <= 0 || pos + size > endOffset) break;

        if (type == 'moov' || type == 'udta' || type == 'ilst') {
          await findInBoxes(pos + 8, pos + size);
        } else if (type == 'meta') {
          // The 'meta' box is sometimes a Full Box (has a 4-byte header: version + flags)
          // Scan dynamically for 'ilst' within 'meta' to bypass any variation of metadata header.
          await raf.setPosition(pos + 8);
          final metaContent = await raf.read(size - 8);
          
          // Check for 'ilst' tag inside the meta box payload
          for (int i = 0; i + 8 < metaContent.length; i++) {
            if (metaContent[i] == 0x69 && metaContent[i + 1] == 0x6c &&
                metaContent[i + 2] == 0x73 && metaContent[i + 3] == 0x74) { // "ilst"
              final ilstSize = ByteData.sublistView(Uint8List.fromList(metaContent.sublist(i - 4, i))).getUint32(0);
              final ilstOffset = pos + 8 + i + 4;
              await findInBoxes(ilstOffset, ilstOffset + ilstSize - 8);
              break;
            }
          }
        } else if (type == '\u00a9nam') { // Title
          title = await _parseMpeg4DataBox(raf, pos + size);
        } else if (type == '\u00a9ART' || type == 'aART') { // Artist / Author
          author = await _parseMpeg4DataBox(raf, pos + size);
        } else if (type == 'covr') { // Cover image
          final image = await _parseMpeg4DataBoxRaw(raf, pos + size);
          if (image != null) {
            coverBytes = image['bytes'] as Uint8List?;
            coverMime = image['mime'] as String?;
          }
        }

        pos += size;
      }
    }

    await findInBoxes(0, totalLen);

    return AudioMetadata(
      title: title,
      author: author,
      coverBytes: coverBytes,
      coverMime: coverMime,
    );
  }

  static Future<String?> _parseMpeg4DataBox(RandomAccessFile raf, int endPos) async {
    final result = await _parseMpeg4DataBoxRaw(raf, endPos);
    if (result == null) return null;
    final bytes = result['bytes'] as Uint8List;
    return utf8Decode(bytes);
  }

  static Future<Map<String, dynamic>?> _parseMpeg4DataBoxRaw(RandomAccessFile raf, int endPos) async {
    final currentPos = await raf.position();
    int pos = currentPos;
    while (pos + 8 < endPos) {
      await raf.setPosition(pos);
      final sizeBytes = await raf.read(4);
      final typeBytes = await raf.read(4);

      final size = ByteData.sublistView(Uint8List.fromList(sizeBytes)).getUint32(0);
      final type = String.fromCharCodes(typeBytes);

      if (size <= 0 || pos + size > endPos) break;

      if (type == 'data') {
        final flagBytes = await raf.read(4);
        await raf.read(4); // skip locale/zero

        final flag = ByteData.sublistView(Uint8List.fromList(flagBytes)).getUint32(0);
        final payloadSize = size - 16;
        if (payloadSize <= 0) return null;

        final payload = await raf.read(payloadSize);
        final bytes = Uint8List.fromList(payload);

        String mime = 'image/jpeg';
        if (flag == 13) {
          mime = 'image/jpeg';
        } else if (flag == 14) {
          mime = 'image/png';
        }

        return {
          'bytes': bytes,
          'mime': mime,
        };
      }
      pos += size;
    }
    return null;
  }

  static String utf8Decode(List<int> bytes) {
    try {
      return const Utf8Decoder().convert(bytes);
    } catch (_) {
      return String.fromCharCodes(bytes);
    }
  }
}
