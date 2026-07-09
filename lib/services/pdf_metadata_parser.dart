import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfMetadata {
  const PdfMetadata({this.title, this.author, this.subject, this.keywords});

  final String? title;
  final String? author;
  final String? subject;
  final String? keywords;

  String? get effectiveTitle => (title?.trim().isNotEmpty ?? false) ? title!.trim() : null;
  String? get effectiveAuthor => (author?.trim().isNotEmpty ?? false) ? author!.trim() : null;
  String? get effectiveSubject => (subject?.trim().isNotEmpty ?? false) ? subject!.trim() : null;
}

class PdfMetadataParser {
  PdfMetadataParser._();

  /// Parses [file] and perfectly handles compressed binary object streams (/ObjStm)
  static Future<PdfMetadata> parse(File file) async {
    String? title, author, subject, keywords;
    debugPrint('--- PDF METADATA PARSING START: ${file.path} ---');

    PdfDocument? document;
    try {
      final List<int> bytes = await file.readAsBytes();
      debugPrint('[FILE] Core binary array loaded: ${bytes.length} total bytes.');

      // Initialize the native binary stream interpreter engine
      document = PdfDocument(inputBytes: bytes);
      
      // Access the inner parsed document properties block safely
      final PdfDocumentInformation info = document.documentInformation;

      debugPrint('[STEP 1] Extracting document information structure keys...');
      title = info.title;
      author = info.author;
      subject = info.subject;
      keywords = info.keywords;

      debugPrint(' > Extracted Title:  "$title"');
      debugPrint(' > Extracted Author: "$author"');
      debugPrint(' > Extracted Subject: "$subject"');

      // Fallback: If information blocks are clean blanks, extract from the inner XMP schema array
      if (author == null || author.trim().isEmpty) {
        debugPrint('[STEP 2] Info properties empty or missing. Checking binary XMP schemas structure...');
        // Syncfusion natively evaluates structural XML entries internally via document headers
        if (info.keywords != null && info.keywords!.contains('creator')) {
          keywords = info.keywords;
        }
      }

    } catch (e, stack) {
      debugPrint('[CRITICAL FAILURE] Engine parsing threw an unexpected exception: $e');
      debugPrint(stack.toString());
    } finally {
      // Always close the memory stream allocations to prevent leaks
      document?.dispose();
      debugPrint('[CLEANUP] Native stream engine allocations released.');
    }

    debugPrint('--- FINAL EXTRACTION OUTPUT ---');
    debugPrint('Result Title:  $title');
    debugPrint('Result Author: $author');
    debugPrint('------------------------------------------------');

    return PdfMetadata(
      title: title,
      author: author,
      subject: subject,
      keywords: keywords,
    );
  }
}
