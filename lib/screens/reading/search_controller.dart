import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import '../../models/search_result_model.dart';

/// Handles full-text search for both EPUB and PDF formats.
/// All methods are pure functions or operate on injected data — no Riverpod.
class ReaderSearchController {
  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  void dispose() {
    textController.dispose();
    focusNode.dispose();
  }

  // ── EPUB Search ───────────────────────────────────────────────────────────

  Future<List<SearchResult>> searchEpub(
    String query,
    List<EpubChapter> chapters,
    String Function(String) stripHtml,
  ) async {
    if (query.trim().isEmpty) return [];

    final List<SearchResult> results = [];

    for (int i = 0; i < chapters.length; i++) {
      final chapter = chapters[i];
      final content = chapter.HtmlContent ?? '';
      final plain = stripHtml(content);
      int startIndex = 0;

      while (true) {
        final index =
            plain.toLowerCase().indexOf(query.toLowerCase(), startIndex);
        if (index == -1) break;
        final s = (index - 40).clamp(0, plain.length);
        final e = (index + query.length + 60).clamp(0, plain.length);
        final snippet =
            plain.substring(s, e).replaceAll('\n', ' ').trim();
        results.add(SearchResult(
          pageIndex: i,
          title: chapter.Title ?? 'Chapter ${i + 1}',
          snippet: '...$snippet...',
          query: query,
          scrollProgress: index / plain.length,
        ));
        startIndex = index + query.length;
        if (results.length > 30) break;
      }
      if (results.length > 30) break;
    }
    return results;
  }

  // ── PDF Search ────────────────────────────────────────────────────────────

  Future<List<SearchResult>> searchPdf(
    String query,
    PdfViewerController? controller,
    PdfTextSearcher? searcher,
  ) async {
    if (query.trim().isEmpty || controller == null) return [];

    final List<SearchResult> results = [];

    await controller.useDocument((doc) async {
      if (searcher != null) {
        searcher.startTextSearch(
          query,
          goToFirstMatch: false,
          searchImmediately: true,
        );
        for (int i = 0; i < doc.pages.length; i++) {
          final page = doc.pages[i];
          final pageText = await page.loadText();
          final plain = pageText!.fullText;
          final lowerPlain = plain.toLowerCase();
          final lowerQuery = query.toLowerCase();
          int startIndex = 0;

          while (true) {
            final index = lowerPlain.indexOf(lowerQuery, startIndex);
            if (index == -1) break;
            final s = (index - 40).clamp(0, plain.length);
            final e = (index + query.length + 60).clamp(0, plain.length);
            final snippet =
                plain.substring(s, e).replaceAll('\n', ' ').trim();
            final match = PdfPageTextRange(
              pageText: pageText as PdfPageText,
              start: index,
              end: index + query.length,
            );
            results.add(SearchResult(
              pageIndex: i,
              title: 'Page ${i + 1}',
              snippet: '...$snippet...',
              query: query,
              metadata: match,
            ));
            startIndex = index + query.length;
            if (results.length >= 30) break;
          }
          if (results.length >= 30) break;
        }
      }
    });

    return results;
  }
}
