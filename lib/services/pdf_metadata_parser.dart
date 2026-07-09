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

  static Future<PdfMetadata> parse(File file) async {
    String? title, author, subject, keywords;
    PdfDocument? document;
    try {
      final List<int> bytes = await file.readAsBytes();
      // Initialize the native binary stream interpreter engine
      document = PdfDocument(inputBytes: bytes);
      
      // Access the inner parsed document properties block safely
      final PdfDocumentInformation info = document.documentInformation;
      title = info.title;
      author = info.author;
      subject = info.subject;
      keywords = info.keywords;

      if ( author.trim().isEmpty) {
        if (info.keywords.contains('creator')) {
          keywords = info.keywords;
        }
      }

    } catch (e, stack) {
      debugPrint('[CRITICAL FAILURE] Engine parsing threw an unexpected exception: $e');
      debugPrint(stack.toString());
    } finally {
      // Always close the memory stream allocations to prevent leaks
      document?.dispose();
    }

    return PdfMetadata(
      title: title,
      author: author,
      subject: subject,
      keywords: keywords,
    );
  }
}
