import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:epubx/epubx.dart';
import 'package:image/image.dart' as img;
import 'package:collection/collection.dart';

/// Extracted metadata and cover information from an EPUB file.
class EpubMetadata {
  const EpubMetadata({
    required this.title,
    required this.author,
    required this.genre,
    this.series,
    this.coverBytes,
  });

  final String title;
  final String author;
  final String genre;

  /// Populated from the first publisher entry (used as series hint).
  final String? series;

  /// Raw JPEG bytes of the cover image, or null if none was found.
  final Uint8List? coverBytes;
}

/// Parses EPUB file metadata and extracts the cover image.
///
/// All logic is static so it can be called without instantiating the class,
/// keeping [BookService] free of implementation details.
class EpubMetadataParser {
  EpubMetadataParser._();

  /// Reads [file], parses the EPUB, and returns an [EpubMetadata] record.
  /// Returns null if the file cannot be read or is not a valid EPUB.
  static Future<EpubMetadata?> parse(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final book = await EpubReader.readBook(bytes);
      return EpubMetadata(
        title: _resolveTitle(book, file),
        author: _resolveAuthor(book),
        genre: _resolveGenre(book),
        series: _resolveSeries(book),
        coverBytes: await _resolveCoverBytes(book),
      );
    } catch (e) {
      return null;
    }
  }

  // ── Field resolution ────────────────────────────────────────────────────

  static String _resolveTitle(EpubBook book, File file) {
    String title = book.Title ?? '';
    if (title.trim().isEmpty) {
      final titles = book.Schema?.Package?.Metadata?.Titles;
      if (titles != null && titles.isNotEmpty) title = titles.first;
    }
    if (title.trim().isEmpty) title = p.basenameWithoutExtension(file.path);
    return title;
  }

  static String _resolveAuthor(EpubBook book) {
    // 1. OPF creators
    final creators = book.Schema?.Package?.Metadata?.Creators;
    if (creators != null) {
      for (final c in creators) {
        final name = c.Creator?.trim() ?? '';
        if (name.isNotEmpty) return name;
      }
    }
    // 2. Top-level Author field
    final topLevel = book.Author ?? '';
    if (topLevel.trim().isNotEmpty &&
        topLevel.toLowerCase() != 'unknown') {
      return topLevel.trim();
    }
    // 3. Contributors as last resort
    final contributors = book.Schema?.Package?.Metadata?.Contributors;
    if (contributors != null) {
      for (final c in contributors) {
        final name = c.Contributor?.trim() ?? '';
        if (name.isNotEmpty) return name;
      }
    }
    return 'Unknown';
  }

  static String _resolveGenre(EpubBook book) {
    final subjects = book.Schema?.Package?.Metadata?.Subjects;
    if (subjects != null && subjects.isNotEmpty) return subjects.first;
    return 'Unknown';
  }

  static String? _resolveSeries(EpubBook book) {
    final publishers = book.Schema?.Package?.Metadata?.Publishers;
    if (publishers != null && publishers.isNotEmpty) return publishers.first;
    return null;
  }

  static Future<Uint8List?> _resolveCoverBytes(EpubBook book) async {
    // 1. Pre-decoded CoverImage
    if (book.CoverImage != null) {
      try {
        return Uint8List.fromList(img.encodeJpg(book.CoverImage!, quality: 85));
      } catch (_) {}
    }
    // 2. Manual manifest search — prefer files named 'cover'
    final images = book.Content?.Images;
    if (images != null && images.isNotEmpty) {
      final coverEntry = images.values.firstWhereOrNull(
            (f) => f.FileName?.toLowerCase().contains('cover') ?? false,
          ) ??
          images.values.firstOrNull;
      if (coverEntry?.Content != null) {
        return Uint8List.fromList(coverEntry!.Content!);
      }
    }
    return null;
  }
}
