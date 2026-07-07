import 'package:epub_view/epub_view.dart';
import 'package:pdfrx/pdfrx.dart';
import '../../models/book_model.dart';
import '../../models/bookmark_model.dart';
import '../../models/highlight_model.dart';
import '../../models/search_result_model.dart';
import 'epub_reading_manager.dart';
import 'pdf_reading_manager.dart';

/// Centralises all navigation decisions: TOC taps, bookmark taps,
/// highlight taps, search-result taps, and percent/page jumps.
///
/// Each method returns a [NavigationTarget] describing what the screen
/// must do (set state + call layer keys). This keeps the manager
/// dependency-free from Flutter widgets and layer keys.
class NavigationManager {
  NavigationManager({required this.epub, required this.pdf});

  final EpubReadingManager epub;
  final PdfReadingManager pdf;

  // ── Helpers ───────────────────────────────────────────────────────────────

  bool _isEpub(Book book) =>
      book.filePath.toLowerCase().endsWith('.epub');

  // ── TOC chapter tap (EPUB) ────────────────────────────────────────────────

  /// Returns the target chapter index if a jump is needed, or null.
  int? onEpubChapterTap(int index) {
    if (index == epub.currentChapterIndex) return null;
    return index;
  }

  // ── PDF outline tap ───────────────────────────────────────────────────────

  /// Returns the 1-indexed page number to jump to, or null.
  int? onPdfOutlineTap(PdfOutlineNode node) {
    final page = node.dest?.pageNumber;
    if (page == null) return null;
    if (page - 1 == pdf.pdfCurrentPage) return null;
    return page;
  }

  // ── Jump to page (PDF) ────────────────────────────────────────────────────

  /// Returns the clamped 1-indexed page if a jump is needed, or null.
  int? onJumpToPage(int page) {
    if (page - 1 == pdf.pdfCurrentPage) return null;
    return page.clamp(1, pdf.pdfPages > 0 ? pdf.pdfPages : page);
  }

  // ── Jump to percent ───────────────────────────────────────────────────────

  EpubJumpTarget? onJumpToPercentEpub(double percent) {
    final r = epub.resolvePercent(percent);
    return EpubJumpTarget(
      chapterIndex: r.chapterIndex,
      scrollFraction: r.scrollFraction,
      chapterTitle: r.chapterIndex < epub.chapters.length
          ? (epub.chapters[r.chapterIndex].Title ??
              'Chapter ${r.chapterIndex + 1}')
          : 'Chapter ${r.chapterIndex + 1}',
    );
  }

  int? onJumpToPercentPdf(double percent) {
    if (!pdf.isPdfReady || pdf.pdfPages <= 0) return null;
    return (percent * (pdf.pdfPages - 1)).toInt() + 1;
  }

  // ── Highlight tap ─────────────────────────────────────────────────────────

  EpubJumpTarget? onEpubHighlightTap(Highlight h, List<EpubChapter> chapters) {
    if (!h.position.contains(':')) return null;
    final parts = h.position.split(':');
    final index = int.tryParse(parts[0]) ?? h.chapterIndex;
    final progress = double.tryParse(parts.last) ?? 0.0;
    if (index < 0 || index >= chapters.length) return null;
    return EpubJumpTarget(
      chapterIndex: index,
      scrollFraction: progress,
      chapterTitle: chapters[index].Title ?? 'Chapter ${index + 1}',
    );
  }

  int? onPdfHighlightTap(Highlight h) {
    if (h.chapterIndex == pdf.pdfCurrentPage) return null;
    return h.chapterIndex + 1;
  }

  // ── Bookmark tap ──────────────────────────────────────────────────────────

  EpubJumpTarget? onEpubBookmarkTap(
      Bookmark bookmark, List<EpubChapter> chapters) {
    if (bookmark.position.contains(':')) {
      final parts = bookmark.position.split(':');
      final index = int.tryParse(parts[0]) ?? 0;
      final progress = double.tryParse(parts[1]) ?? 0.0;
      if (index < 0 || index >= chapters.length) return null;
      return EpubJumpTarget(
        chapterIndex: index,
        scrollFraction: progress,
        chapterTitle: chapters[index].Title ?? 'Chapter ${index + 1}',
        isCfiJump: false,
      );
    } else {
      final index = int.tryParse(bookmark.position);
      if (index != null && index >= 0 && index < chapters.length) {
        return EpubJumpTarget(
          chapterIndex: index,
          scrollFraction: 0.0,
          chapterTitle: chapters[index].Title ?? 'Chapter ${index + 1}',
          isCfiJump: false,
        );
      }
      // Fall back to CFI jump
      return EpubJumpTarget(
        chapterIndex: -1,
        scrollFraction: 0.0,
        chapterTitle: '',
        isCfiJump: true,
        cfi: bookmark.position,
      );
    }
  }

  int? onPdfBookmarkTap(Bookmark bookmark) {
    final page = int.tryParse(bookmark.position) ?? 1;
    if (page - 1 == pdf.pdfCurrentPage) return null;
    return page;
  }

  // ── Search result ─────────────────────────────────────────────────────────

  SearchNavTarget onSearchResult(SearchResult result, Book book) {
    if (_isEpub(book)) {
      return SearchNavTarget(
        isEpub: true,
        epubChapterIndex: result.pageIndex,
        scrollFraction: result.scrollProgress,
        query: result.query,
      );
    } else {
      return SearchNavTarget(
        isEpub: false,
        pdfPageIndex: result.pageIndex,
        pdfMatch: result.metadata is PdfPageTextRange
            ? result.metadata as PdfPageTextRange
            : null,
        query: result.query,
      );
    }
  }
}

// ── Value objects ─────────────────────────────────────────────────────────────

class EpubJumpTarget {
  const EpubJumpTarget({
    required this.chapterIndex,
    required this.scrollFraction,
    required this.chapterTitle,
    this.isCfiJump = false,
    this.cfi,
  });
  final int chapterIndex;
  final double scrollFraction;
  final String chapterTitle;
  final bool isCfiJump;
  final String? cfi;
}

class SearchNavTarget {
  const SearchNavTarget({
    required this.isEpub,
    this.epubChapterIndex,
    this.scrollFraction,
    this.pdfPageIndex,
    this.pdfMatch,
    required this.query,
  });
  final bool isEpub;
  final int? epubChapterIndex;
  final double? scrollFraction;
  final int? pdfPageIndex;
  final PdfPageTextRange? pdfMatch;
  final String query;
}
