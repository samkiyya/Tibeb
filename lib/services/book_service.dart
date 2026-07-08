import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:epubx/epubx.dart';
import 'package:image/image.dart' as img;
import 'package:file_picker/file_picker.dart';
import 'package:tibeb/models/book_model.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:collection/collection.dart';
import 'package:pdfrx/pdfrx.dart' as pdfrx;

class BookService {
  Future<Book?> processFile(File file) async {
    final extension = p.extension(file.path).toLowerCase();
    if (extension == '.epub') {
      return await _processEpub(file);
    } else if (extension == '.pdf') {
      return await _processPdf(file);
    }
    return null;
  }

  Future<bool> requestPermissions() async {
    return true;
  }

  Future<List<File>> pickBookFiles() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['epub', 'pdf'],
      allowMultiple: true,
    );

    if (result == null || result.files.isEmpty) {
      debugPrint('No files picked');
      return [];
    }

    return result.files
        .where((f) => f.path != null)
        .map((f) => File(f.path!))
        .toList();
  }

  // ── EPUB Processing ─────────────────────────────────────────────────────────

  Future<Book?> _processEpub(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final epubBook = await EpubReader.readBook(bytes);

      // 1. Resolve Title
      String title = epubBook.Title ?? '';
      if (title.trim().isEmpty) {
        final titles = epubBook.Schema?.Package?.Metadata?.Titles;
        if (titles != null && titles.isNotEmpty) {
          title = titles.first;
        }
      }
      if (title.trim().isEmpty) {
        title = p.basenameWithoutExtension(file.path);
      }

      // 2. Resolve Author (check creators, package metadata, fallback to book author, then contributors)
      String author = '';
      final creators = epubBook.Schema?.Package?.Metadata?.Creators;
      if (creators != null && creators.isNotEmpty) {
        for (final c in creators) {
          if (c.Creator != null && c.Creator!.trim().isNotEmpty) {
            author = c.Creator!.trim();
            break;
          }
        }
      }
      if (author.isEmpty) {
        author = epubBook.Author ?? '';
      }
      if (author.trim().isEmpty || author.toLowerCase() == 'unknown') {
        final contributors = epubBook.Schema?.Package?.Metadata?.Contributors;
        if (contributors != null && contributors.isNotEmpty) {
          for (final c in contributors) {
            if (c.Contributor != null && c.Contributor!.trim().isNotEmpty) {
              author = c.Contributor!.trim();
              break;
            }
          }
        }
      }
      if (author.trim().isEmpty) {
        author = 'Unknown';
      }

      // Extract genre/subject from the OPF metadata
      String genre = 'Unknown';
      final subjects = epubBook.Schema?.Package?.Metadata?.Subjects;
      if (subjects != null && subjects.isNotEmpty) {
        genre = subjects.first;
      }

      // Extract publisher
      String? series;
      final publishers = epubBook.Schema?.Package?.Metadata?.Publishers;
      if (publishers != null && publishers.isNotEmpty) {
        series = publishers.first;
      }

      // 3. Resolve Cover Page bytes (automatic fallback to manual file manifest search)
      Uint8List? coverBytes;
      if (epubBook.CoverImage != null) {
        try {
          coverBytes = Uint8List.fromList(img.encodeJpg(epubBook.CoverImage!, quality: 85));
        } catch (e) {
          debugPrint('Error encoding epubBook.CoverImage: $e');
        }
      }

      if (coverBytes == null) {
        // Search manifest images manually for filename matching 'cover'
        final images = epubBook.Content?.Images;
        if (images != null && images.isNotEmpty) {
          final coverFile = images.values.firstWhereOrNull(
            (f) => f.FileName?.toLowerCase().contains('cover') ?? false,
          ) ?? images.values.firstOrNull;

          if (coverFile != null && coverFile.Content != null) {
            coverBytes = Uint8List.fromList(coverFile.Content!);
          }
        }
      }

      String coverPath = '';
      if (coverBytes != null && coverBytes.isNotEmpty) {
        final appDir = await getApplicationDocumentsDirectory();
        final coversDir = Directory(p.join(appDir.path, 'covers'));
        if (!await coversDir.exists()) await coversDir.create();

        coverPath = p.join(
          coversDir.path,
          '${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        await File(coverPath).writeAsBytes(coverBytes);
      }

      return Book(
        title: title,
        author: author,
        coverPath: coverPath,
        filePath: file.path,
        addedAt: DateTime.now(),
        folderPath: p.dirname(file.path),
        contentHash: await _calculateFileHash(file),
        genre: genre,
        series: series,
      );
    } catch (e) {
      debugPrint('Error processing epub: $e');
      return null;
    }
  }

  // ── PDF Processing ──────────────────────────────────────────────────────────

  Future<Book?> _processPdf(File file) async {
    try {
      // 1. Extract metadata from the raw PDF /Info dictionary
      final pdfMeta = await _extractPdfMetadata(file);
      final title = (pdfMeta['title'] != null && pdfMeta['title']!.trim().isNotEmpty)
          ? pdfMeta['title']!.trim()
          : p.basenameWithoutExtension(file.path);
      final author = (pdfMeta['author'] != null && pdfMeta['author']!.trim().isNotEmpty)
          ? pdfMeta['author']!.trim()
          : 'Unknown';
      final subject = pdfMeta['subject'] ?? '';
      final genre = subject.isNotEmpty ? subject : 'Unknown';

      // 2. Generate cover thumbnail from page 1 via pdfrx
      String coverPath = '';
      int totalPages = 0;
      try {
        final doc = await pdfrx.PdfDocument.openFile(file.path);
        totalPages = doc.pages.length;

        if (doc.pages.isNotEmpty) {
          final page = doc.pages.first;
          // Render at 2x scale for crisp thumbnails (max ~600px wide)
          final scale = (600 / page.width).clamp(1.0, 3.0);
          final renderW = (page.width * scale).toInt();
          final renderH = (page.height * scale).toInt();

          final pdfImage = await page.render(
            fullWidth: renderW.toDouble(),
            fullHeight: renderH.toDouble(),
          );

          if (pdfImage != null) {
            // Convert raw RGBA/BGRA pixels to a JPG via the `image` package
            // pdfrx's PdfImage pixels are always in BGRA format.
            final decoded = img.Image.fromBytes(
              width: pdfImage.width,
              height: pdfImage.height,
              bytes: pdfImage.pixels.buffer,
              numChannels: 4,
              order: img.ChannelOrder.bgra,
            );

            final appDir = await getApplicationDocumentsDirectory();
            final coversDir = Directory(p.join(appDir.path, 'covers'));
            if (!await coversDir.exists()) await coversDir.create(recursive: true);

            coverPath = p.join(
              coversDir.path,
              '${DateTime.now().millisecondsSinceEpoch}.jpg',
            );
            await File(coverPath).writeAsBytes(img.encodeJpg(decoded, quality: 85));

            pdfImage.dispose();
          }
        }
        await doc.dispose();
      } catch (e) {
        debugPrint('PDF cover/page-count extraction failed (non-fatal): $e');
      }

      return Book(
        title: title,
        author: author,
        coverPath: coverPath,
        filePath: file.path,
        addedAt: DateTime.now(),
        folderPath: p.dirname(file.path),
        contentHash: await _calculateFileHash(file),
        genre: genre,
        totalPages: totalPages,
      );
    } catch (e) {
      debugPrint('Error processing pdf: $e');
      return null;
    }
  }

  /// Parses the raw PDF bytes to find the /Info dictionary and extract
  /// /Title, /Author, /Subject, /Keywords metadata strings.
  /// This is a best-effort parser — some PDFs have no metadata at all.
  Future<Map<String, String?>> _extractPdfMetadata(File file) async {
    final result = <String, String?>{
      'title': null,
      'author': null,
      'subject': null,
      'keywords': null,
    };

    try {
      // Read the tail of the file where cross-ref/trailer/info usually live.
      // Most PDF metadata is in the last ~8KB, but read up to 64KB to be safe.
      final raf = await file.open(mode: FileMode.read);
      final fileLen = await raf.length();
      final readLen = fileLen < 65536 ? fileLen : 65536;
      await raf.setPosition(fileLen - readLen);
      final tailBytes = await raf.read(readLen);
      await raf.close();

      // Also read the first ~8KB for linearized PDFs with metadata at the top
      final headRaf = await file.open(mode: FileMode.read);
      final headLen = fileLen < 8192 ? fileLen : 8192;
      final headBytes = await headRaf.read(headLen);
      await headRaf.close();

      final combined = String.fromCharCodes([...headBytes, ...tailBytes]);

      // Look for PDF metadata keys in the /Info dictionary
      for (final key in ['Title', 'Author', 'Subject', 'Keywords']) {
        final value = _extractPdfStringValue(combined, '/$key');
        if (value != null && value.isNotEmpty) {
          result[key.toLowerCase()] = value;
        }
      }

      // Merge with XMP metadata if missing
      final xmpMeta = _extractXmpMetadata(combined);
      if (result['title'] == null && xmpMeta['title'] != null) {
        result['title'] = xmpMeta['title'];
      }
      if (result['author'] == null && xmpMeta['author'] != null) {
        result['author'] = xmpMeta['author'];
      }
      if (result['subject'] == null && xmpMeta['subject'] != null) {
        result['subject'] = xmpMeta['subject'];
      }
    } catch (e) {
      debugPrint('PDF metadata extraction failed (non-fatal): $e');
    }
    return result;
  }

  Map<String, String?> _extractXmpMetadata(String content) {
    final result = <String, String?>{};
    final startIdx = content.indexOf('<x:xmpmeta');
    if (startIdx >= 0) {
      final endIdx = content.indexOf('</x:xmpmeta>', startIdx);
      if (endIdx > startIdx) {
        final xmp = content.substring(startIdx, endIdx);

        final title = _extractXmlTagContent(xmp, 'title');
        if (title != null && title.isNotEmpty) {
          result['title'] = title;
        }

        final creator = _extractXmlTagContent(xmp, 'creator') ?? _extractXmlTagContent(xmp, 'Author');
        if (creator != null && creator.isNotEmpty) {
          result['author'] = creator;
        }

        final subject = _extractXmlTagContent(xmp, 'subject');
        if (subject != null && subject.isNotEmpty) {
          result['subject'] = subject;
        }
      }
    }
    return result;
  }

  String? _extractXmlTagContent(String xml, String tagName) {
    final reg = RegExp('<[^:>]*:?$tagName[^>]*>(.*?)</[^:>]*:?$tagName>', caseSensitive: false, dotAll: true);
    final match = reg.firstMatch(xml);
    if (match != null) {
      String inner = match.group(1) ?? '';
      final liReg = RegExp('<rdf:li[^>]*>(.*?)</rdf:li>', caseSensitive: false, dotAll: true);
      final liMatch = liReg.firstMatch(inner);
      if (liMatch != null) {
        return _cleanXmlText(liMatch.group(1) ?? '');
      }
      return _cleanXmlText(inner);
    }
    return null;
  }

  String _cleanXmlText(String text) {
    return text
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&apos;', "'")
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .trim();
  }

  /// Extracts a PDF string value after the given key marker.
  /// Handles both literal strings (`/Key (value)`) and hex strings (`/Key <hex>`).
  String? _extractPdfStringValue(String content, String key) {
    final keyIndex = content.indexOf(key);
    if (keyIndex < 0) return null;

    // Scan forward from key position for ( or <
    final afterKey = content.substring(keyIndex + key.length).trimLeft();

    if (afterKey.startsWith('(')) {
      // Literal string: extract content between matching parentheses
      int depth = 0;
      int start = -1;
      for (int i = 0; i < afterKey.length && i < 2048; i++) {
        if (afterKey[i] == '(' && (i == 0 || afterKey[i - 1] != '\\')) {
          if (depth == 0) start = i + 1;
          depth++;
        } else if (afterKey[i] == ')' && afterKey[i - 1] != '\\') {
          depth--;
          if (depth == 0) {
            final raw = afterKey.substring(start, i);
            return _decodePdfLiteralString(raw);
          }
        }
      }
    } else if (afterKey.startsWith('<')) {
      // Hex string: extract between < and >
      final end = afterKey.indexOf('>');
      if (end > 1) {
        final hex = afterKey.substring(1, end).replaceAll(RegExp(r'\s'), '');
        return _decodePdfHexString(hex);
      }
    }
    return null;
  }

  String _decodePdfLiteralString(String raw) {
    // Handle PDF escape sequences
    return raw
        .replaceAll('\\n', '\n')
        .replaceAll('\\r', '\r')
        .replaceAll('\\t', '\t')
        .replaceAll('\\(', '(')
        .replaceAll('\\)', ')')
        .replaceAll('\\\\', '\\');
  }

  String _decodePdfHexString(String hex) {
    // Check for UTF-16 BOM (FEFF)
    if (hex.length >= 4 && hex.substring(0, 4).toUpperCase() == 'FEFF') {
      final bytes = <int>[];
      for (int i = 4; i + 3 < hex.length; i += 4) {
        bytes.add(int.parse(hex.substring(i, i + 4), radix: 16));
      }
      return String.fromCharCodes(bytes);
    }
    // Otherwise treat as byte pairs → Latin-1
    final bytes = <int>[];
    for (int i = 0; i + 1 < hex.length; i += 2) {
      bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    return String.fromCharCodes(bytes);
  }

  // ── Shared utilities ────────────────────────────────────────────────────────

  Future<String> downloadCover(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final appDir = await getApplicationDocumentsDirectory();
        final coversDir = Directory(p.join(appDir.path, 'covers'));
        if (!await coversDir.exists()) await coversDir.create();

        final coverPath = p.join(
          coversDir.path,
          '${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        await File(coverPath).writeAsBytes(response.bodyBytes);
        return coverPath;
      }
    } catch (e) {
      debugPrint('Error downloading cover: $e');
    }
    return '';
  }

  Future<String> saveLocalCover(File file) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final coversDir = Directory(p.join(appDir.path, 'covers'));
      if (!await coversDir.exists()) await coversDir.create();

      final coverPath = p.join(
        coversDir.path,
        '${DateTime.now().millisecondsSinceEpoch}${p.extension(file.path)}',
      );
      await file.copy(coverPath);
      return coverPath;
    } catch (e) {
      debugPrint('Error saving local cover: $e');
    }
    return '';
  }

  Future<String> _calculateFileHash(File file) async {
    try {
      final bytes = await file.readAsBytes();
      return md5.convert(bytes).toString();
    } catch (e) {
      debugPrint('Error calculating file hash: $e');
      return '';
    }
  }
}
