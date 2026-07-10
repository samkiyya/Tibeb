import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';

import 'package:tibeb/models/book_model.dart';
import 'book_cover_storage.dart';
import 'epub_metadata_parser.dart';
import 'pdf_cover_renderer.dart';
import 'pdf_metadata_parser.dart';

/// Orchestrates book-file processing.
///
/// Responsibilities:
/// - File picking via the OS picker
/// - Delegating format-specific parsing to [EpubMetadataParser] /
///   [PdfMetadataParser] / [PdfCoverRenderer]
/// - Persisting cover images via [BookCoverStorage]
/// - Assembling the final [Book] record
///
/// Does NOT contain any parsing logic itself.
class BookService {
  // ── File picking ──────────────────────────────────────────────────────────

  /// Always returns true — permission is handled by the OS picker on Android.
  Future<bool> requestPermissions() async => true;

  /// Opens the system file picker filtered to EPUB, PDF, TXT, and Markdown files.
  /// Returns an empty list if the user cancels or picks nothing.
  Future<List<File>> pickBookFiles() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['epub', 'pdf', 'txt', 'md'],
      allowMultiple: true,
    );

    if (result == null || result.files.isEmpty) {
      return [];
    }

    return result.files
        .where((f) => f.path != null)
        .map((f) => File(f.path!))
        .toList();
  }

  // ── Entry point ───────────────────────────────────────────────────────────

  /// Processes a single book file and returns a [Book] ready for insertion,
  /// or null if the format is unsupported or parsing fails.
  Future<Book?> processFile(File file) async {
    final ext = p.extension(file.path).toLowerCase();
    switch (ext) {
      case '.epub':
        return _processEpub(file);
      case '.pdf':
        return _processPdf(file);
      case '.txt':
      case '.md':
        return _processTxtMd(file);
      default:
        return null;
    }
  }

  // ── EPUB ──────────────────────────────────────────────────────────────────

  Future<Book?> _processEpub(File file) async {
    try {
      final meta = await EpubMetadataParser.parse(file);
      if (meta == null) return null;

      final coverPath = meta.coverBytes != null
          ? await BookCoverStorage.saveBytes(meta.coverBytes!)
          : '';

      return Book(
        title: meta.title,
        author: meta.author,
        coverPath: coverPath,
        filePath: file.path,
        addedAt: DateTime.now(),
        folderPath: p.dirname(file.path),
        contentHash: await BookCoverStorage.md5Hash(file),
        genre: meta.genre,
        series: meta.series,
      );
    } catch (e) {
      return null;
    }
  }

  // ── PDF ───────────────────────────────────────────────────────────────────

  Future<Book?> _processPdf(File file) async {
    try {
      // Parse text metadata and render the cover concurrently
      final results = await Future.wait([
        PdfMetadataParser.parse(file),
        PdfCoverRenderer.render(file),
      ]);

      final meta = results[0] as PdfMetadata;
      final render = results[1] as PdfRenderResult;

      final title =
          meta.effectiveTitle ?? p.basenameWithoutExtension(file.path);
      final author = meta.effectiveAuthor ?? 'Unknown';
      final genre = (meta.effectiveSubject?.isNotEmpty ?? false)
          ? meta.effectiveSubject!
          : 'Unknown';

      final coverPath = render.coverBytes != null
          ? await BookCoverStorage.saveBytes(render.coverBytes!)
          : '';

      return Book(
        title: title,
        author: author,
        coverPath: coverPath,
        filePath: file.path,
        addedAt: DateTime.now(),
        folderPath: p.dirname(file.path),
        contentHash: await BookCoverStorage.md5Hash(file),
        genre: genre,
        totalPages: render.totalPages,
      );
    } catch (e) {
      return null;
    }
  }

  // ── Cover utilities (delegated) ───────────────────────────────────────────

  /// Downloads a cover from [url] and saves it to the covers directory.
  /// Returns the saved path, or empty string on failure.
  Future<String> downloadCover(String url) =>
      BookCoverStorage.downloadCover(url);

  /// Copies a local cover [file] into the app's covers directory.
  /// Returns the new path, or empty string on failure.
  Future<String> saveLocalCover(File file) =>
      BookCoverStorage.saveLocalFile(file);

  // ── TXT & Markdown ────────────────----------------────────────────────────

  Future<Book?> _processTxtMd(File file) async {
    try {
      final name = p.basenameWithoutExtension(file.path);
      final content = await file.readAsString();

      String title = name;
      String author = 'Unknown';
      String genre = p.extension(file.path).toLowerCase() == '.md'
          ? 'Markdown'
          : 'Plain Text';
      String coverPath = '';

      final lines = content.split('\n');

      // 1. Try parsing YAML frontmatter
      if (lines.isNotEmpty && lines.first.trim() == '---') {
        int endFrontmatterIdx = -1;
        for (int i = 1; i < lines.length; i++) {
          if (lines[i].trim() == '---') {
            endFrontmatterIdx = i;
            break;
          }
        }
        if (endFrontmatterIdx != -1) {
          for (int i = 1; i < endFrontmatterIdx; i++) {
            final line = lines[i];
            final colonIdx = line.indexOf(':');
            if (colonIdx != -1) {
              final key = line.substring(0, colonIdx).trim().toLowerCase();
              final val = line.substring(colonIdx + 1).trim();
              final cleanVal = val.replaceAll(
                RegExp("^[\"']|[\"']\$"),
                '',
              ); // strip quotes
              if (key == 'title') {
                title = cleanVal;
              } else if (key == 'author') {
                author = cleanVal;
              } else if (key == 'genre' || key == 'subject') {
                genre = cleanVal;
              } else if (key == 'cover') {
                coverPath = cleanVal;
              }
            }
          }
        }
      }

      // 2. Fall back to H1 heading (# Title or % Title)
      if (title == name || title.isEmpty) {
        for (final line in lines) {
          final trimmed = line.trim();
          if (trimmed.startsWith('# ')) {
            title = trimmed.substring(2).trim();
            break;
          } else if (trimmed.startsWith('% ')) {
            title = trimmed.substring(2).trim();
            break;
          }
        }
      }

      // 3. Fall back to first markdown image as cover
      if (coverPath.isEmpty) {
        final imgRegex = RegExp(r'!\[.*?\]\((.*?)\)');
        final match = imgRegex.firstMatch(content);
        if (match != null) {
          coverPath = match.group(1) ?? '';
        }
      }

      // 4. Resolve local relative cover paths relative to the file directory
      if (coverPath.isNotEmpty &&
          !coverPath.startsWith('http') &&
          !p.isAbsolute(coverPath)) {
        final absPath = p.normalize(p.join(p.dirname(file.path), coverPath));
        if (File(absPath).existsSync()) {
          coverPath = absPath;
        }
      }

      return Book(
        title: title,
        author: author,
        coverPath: coverPath,
        filePath: file.path,
        addedAt: DateTime.now(),
        folderPath: p.dirname(file.path),
        contentHash: await BookCoverStorage.md5Hash(file),
        genre: genre,
        totalPages: 0,
      );
    } catch (e) {
      return null;
    }
  }
}
