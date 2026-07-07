import 'package:flutter/material.dart';

import '../../models/book_model.dart';
import '../../models/search_result_model.dart';
import '../../widgets/reading/epub_reader_layer.dart';
import '../../widgets/reading/pdf_reader_layer.dart';
import 'epub_reading_manager.dart';
import 'navigation_manager.dart';
import 'pdf_reading_manager.dart';
import 'reading_ui_state.dart';
import 'search_controller.dart';

/// Handles full-text search execution and navigation to search results.
/// Delegates the actual searching to [ReaderSearchController] and
/// navigation decisions to [NavigationManager].
class ReadingSearchManager {
  ReadingSearchManager({
    required this.search,
    required this.nav,
    required this.epub,
    required this.pdf,
    required this.ui,
    required this.epubLayerKey,
    required this.pdfLayerKey,
    required this.scrollProgressNotifier,
  });

  final ReaderSearchController search;
  final NavigationManager nav;
  final EpubReadingManager epub;
  final PdfReadingManager pdf;
  final ReadingUiState ui;
  final GlobalKey<EpubReaderLayerState> epubLayerKey;
  final GlobalKey<PdfReaderLayerState> pdfLayerKey;
  final ValueNotifier<double> scrollProgressNotifier;

  // ── Execute search ────────────────────────────────────────────────────────

  /// Runs the search and returns results. Caller is responsible for calling
  /// [setState] around this and updating [ui] fields.
  Future<List<SearchResult>> runSearch(String query, Book book) async {
    if (query.trim().isEmpty) return [];

    if (book.filePath.toLowerCase().endsWith('.pdf')) {
      return search.searchPdf(
        query,
        pdfLayerKey.currentState?.pdfController,
        pdfLayerKey.currentState?.pdfSearcher,
      );
    } else {
      return search.searchEpub(
        query,
        epub.chapters,
        (h) => h.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ').trim(),
      );
    }
  }

  // ── Navigate to result ────────────────────────────────────────────────────

  /// Applies a search result to the UI state and triggers the layer jump.
  /// [onStateChanged] is called once so the screen can call setState.
  void goToResult(SearchResult result, Book book, VoidCallback onStateChanged) {
    final target = nav.onSearchResult(result, book);

    ui.isJumpingFromToc = true;
    ui.activeSearchQuery = target.query;
    ui.isSearchResultsCollapsed = true;

    if (target.isEpub) {
      final idx = target.epubChapterIndex!;
      if (idx != epub.currentChapterIndex) {
        epub.currentChapterIndex = idx;
        epub.currentChapter =
            epub.chapters[idx].Title ?? 'Chapter ${idx + 1}';
      }
      if (target.scrollFraction != null) {
        epub.initialScrollProgress = target.scrollFraction!;
      }
      onStateChanged();
      epubLayerKey.currentState?.jumpToChapter(idx);
    } else {
      final idx = target.pdfPageIndex!;
      if (idx != pdf.pdfCurrentPage) {
        pdf.setPage(idx);
        scrollProgressNotifier.value = pdf.pdfPages > 1
            ? (idx / (pdf.pdfPages - 1)).clamp(0.0, 1.0)
            : 1.0;
      }
      onStateChanged();
      if (target.pdfMatch != null) {
        pdfLayerKey.currentState?.goToMatch(target.pdfMatch!);
      } else {
        pdfLayerKey.currentState?.jumpToPage(idx + 1);
      }
    }
  }
}
