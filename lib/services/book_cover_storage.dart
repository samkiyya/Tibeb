import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

/// Handles all cover-image I/O and file hashing for the book pipeline.
///
/// All methods are static — no instance state.
class BookCoverStorage {
  BookCoverStorage._();

  // ── Cover persistence ───────────────────────────────────────────────────

  /// Saves [bytes] as a JPEG in the app's covers directory and returns the
  /// absolute path.  Returns an empty string on failure.
  static Future<String> saveBytes(Uint8List bytes) async {
    if (bytes.isEmpty) return '';
    try {
      final coversDir = await _coversDirectory();
      final path = p.join(
        coversDir.path,
        '${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await File(path).writeAsBytes(bytes);
      return path;
    } catch (e) {
      debugPrint('BookCoverStorage.saveBytes: $e');
      return '';
    }
  }

  /// Downloads the image at [url] and saves it to the covers directory.
  /// Returns an empty string on failure or non-200 response.
  static Future<String> downloadCover(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return saveBytes(response.bodyBytes);
      }
    } catch (e) {
      debugPrint('BookCoverStorage.downloadCover: $e');
    }
    return '';
  }

  /// Copies a local image [file] to the covers directory and returns the new
  /// path.  Preserves the original file extension.
  static Future<String> saveLocalFile(File file) async {
    try {
      final coversDir = await _coversDirectory();
      final dest = p.join(
        coversDir.path,
        '${DateTime.now().millisecondsSinceEpoch}${p.extension(file.path)}',
      );
      await file.copy(dest);
      return dest;
    } catch (e) {
      debugPrint('BookCoverStorage.saveLocalFile: $e');
      return '';
    }
  }

  // ── File hashing ─────────────────────────────────────────────────────────

  /// Returns the MD5 hex digest of [file]'s contents, or an empty string on
  /// failure.
  static Future<String> md5Hash(File file) async {
    try {
      final bytes = await file.readAsBytes();
      return md5.convert(bytes).toString();
    } catch (e) {
      debugPrint('BookCoverStorage.md5Hash: $e');
      return '';
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  static Future<Directory> _coversDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final coversDir = Directory(p.join(appDir.path, 'covers'));
    if (!await coversDir.exists()) await coversDir.create(recursive: true);
    return coversDir;
  }
}
