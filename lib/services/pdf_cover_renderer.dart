import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:pdfrx/pdfrx.dart' as pdfrx;

/// Result of a PDF cover render operation.
class PdfRenderResult {
  const PdfRenderResult({
    required this.coverBytes,
    required this.totalPages,
  });

  /// JPEG-encoded bytes of the first page thumbnail, or null on failure.
  final Uint8List? coverBytes;

  /// Total page count from the opened document.
  final int totalPages;
}

/// Renders the first page of a PDF as a JPEG thumbnail and reports
/// the document's total page count.
///
/// All logic is static — no instance state.
class PdfCoverRenderer {
  PdfCoverRenderer._();

  /// Maximum width of the thumbnail in logical pixels.
  static const double _maxWidth = 600.0;

  /// JPEG quality (0–100).
  static const int _jpegQuality = 85;

  /// Opens [file], counts pages, renders page 1 at up to [_maxWidth] wide,
  /// and returns the result.  Never throws — failures are logged and the
  /// result will have [PdfRenderResult.coverBytes] == null.
  static Future<PdfRenderResult> render(File file) async {
    int totalPages = 0;
    Uint8List? coverBytes;

    try {
      final doc = await pdfrx.PdfDocument.openFile(file.path);
      totalPages = doc.pages.length;

      if (doc.pages.isNotEmpty) {
        coverBytes = await _renderFirstPage(doc.pages.first);
      }

      await doc.dispose();
    } catch (_) { }

    return PdfRenderResult(coverBytes: coverBytes, totalPages: totalPages);
  }

  static Future<Uint8List?> _renderFirstPage(pdfrx.PdfPage page) async {
    try {
      final scale = (_maxWidth / page.width).clamp(1.0, 3.0);
      final renderW = (page.width * scale).toInt();
      final renderH = (page.height * scale).toInt();

      final pdfImage = await page.render(
        fullWidth: renderW.toDouble(),
        fullHeight: renderH.toDouble(),
      );

      if (pdfImage == null) return null;

      // pdfrx pixels are always BGRA
      final decoded = img.Image.fromBytes(
        width: pdfImage.width,
        height: pdfImage.height,
        bytes: pdfImage.pixels.buffer,
        numChannels: 4,
        order: img.ChannelOrder.bgra,
      );
      pdfImage.dispose();

      return Uint8List.fromList(img.encodeJpg(decoded, quality: _jpegQuality));
    } catch (e) {
      return null;
    }
  }
}
