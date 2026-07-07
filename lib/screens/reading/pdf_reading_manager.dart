import 'package:pdfrx/pdfrx.dart';

/// Manages all PDF-specific state: page tracking, outline, chapter display,
/// and jump-to-page logic. Kept pure (no Flutter/Riverpod imports) so it
/// is easy to unit-test.
class PdfReadingManager {
  // ── State ─────────────────────────────────────────────────────────────────
  int pdfPages = 0;
  int pdfCurrentPage = 0;
  bool isPdfReady = false;
  String currentChapter = 'Chapter 1';
  List<PdfOutlineNode> pdfOutline = [];
  List<PdfOutlineNode> tocPdfOutline = [];
  PdfOutlineNode? currentPdfNode;

  // ── Outline ───────────────────────────────────────────────────────────────

  /// Recursively flattens a hierarchical PDF outline into a single list.
  List<PdfOutlineNode> flattenOutline(List<PdfOutlineNode> nodes) {
    final result = <PdfOutlineNode>[];
    for (final node in nodes) {
      result.add(node);
      if (node.children.isNotEmpty) {
        result.addAll(flattenOutline(node.children));
      }
    }
    return result;
  }

  /// Load outline from the viewer and set all outline fields.
  void loadOutline(List<PdfOutlineNode> rawOutline) {
    tocPdfOutline = rawOutline;
    pdfOutline = flattenOutline(rawOutline);
  }

  // ── Page management ───────────────────────────────────────────────────────

  /// Update page state and chapter display. Returns the scroll fraction (0–1).
  double setPage(int page, {int? totalPages}) {
    if (totalPages != null) pdfPages = totalPages;
    pdfCurrentPage = page;
    final fraction = pdfPages > 1
        ? (page / (pdfPages - 1)).clamp(0.0, 1.0)
        : 1.0;
    updateCurrentChapter();
    return fraction;
  }

  // ── Current chapter ───────────────────────────────────────────────────────

  /// Derive the display chapter name from the flat outline and current page.
  void updateCurrentChapter() {
    if (pdfOutline.isEmpty) {
      currentChapter = 'Page ${pdfCurrentPage + 1}';
      return;
    }
    PdfOutlineNode? best;
    for (final node in pdfOutline) {
      final pageNum = node.dest?.pageNumber;
      if (pageNum != null && pageNum <= pdfCurrentPage + 1) {
        if (best == null || (best.dest?.pageNumber ?? 0) <= pageNum) {
          best = node;
        }
      }
    }
    currentPdfNode = best;
    currentChapter = best?.title ?? 'Page ${pdfCurrentPage + 1}';
  }

  // ── Jump ──────────────────────────────────────────────────────────────────

  /// Clamp [pageNumber] (1-indexed) to valid range.
  /// Returns null if not ready; otherwise returns the clamped 1-indexed target.
  int? clampedTarget(int pageNumber) {
    if (!isPdfReady || pdfPages <= 0) return null;
    return pageNumber.clamp(1, pdfPages);
  }

  // ── Reset ─────────────────────────────────────────────────────────────────

  void reset() {
    pdfPages = 0;
    pdfCurrentPage = 0;
    isPdfReady = false;
    currentChapter = 'Chapter 1';
    pdfOutline = [];
    tocPdfOutline = [];
    currentPdfNode = null;
  }
}
