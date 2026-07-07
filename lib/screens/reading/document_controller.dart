import 'dart:io' as io;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:epub_view/epub_view.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';

import '../../models/book_model.dart';
import '../../models/reader_settings_model.dart';
import '../../models/search_result_model.dart';
import '../../providers/library_provider.dart';
import '../../providers/database_providers.dart';
import '../../widgets/reading/navigation_sheet.dart';
import 'progress_controller.dart';
import 'bookmark_controller.dart';
import 'export_helper.dart';
import 'search_controller.dart';

/// Manages EPUB and PDF document states, layout controls, pagination event handlings,
/// search selections and NavigationSheet bottom sheet configuration.
class DocumentController {
  // ── Document controllers ────────────────────────────────────────────────
  EpubController? epubController;
  EpubBook? epubBook;
  PdfViewerController? pdfController;
  PdfTextSearcher? pdfSearcher;
  PageController? pageController;

  // ── EPUB state ──────────────────────────────────────────────────────────
  List<EpubChapter> chapters = [];
  List<int> epubChapterLengths = [];
  int epubTotalLength = 0;
  String currentChapter = 'Chapter 1';
  int currentChapterIndex = 0;

  // ── PDF state ───────────────────────────────────────────────────────────
  int pdfPages = 0;
  int pdfCurrentPage = 0;
  bool isPdfReady = false;
  List<PdfOutlineNode> pdfOutline = [];
  List<PdfOutlineNode> tocPdfOutline = [];
  PdfOutlineNode? currentPdfNode;

  // ── UI state ────────────────────────────────────────────────────────────
  bool shouldJumpToBottom = false;
  double initialScrollProgress = 0.0;
  bool isJumpingFromToc = false;
  DateTime? epubPointerDownTime;
  Offset? epubPointerDownPosition;

  // ── Search State ────────────────────────────────────────────────────────
  bool isSearching = false;
  List<SearchResult> searchResults = [];
  bool isSearchLoading = false;
  String? activeSearchQuery;
  bool isSearchResultsCollapsed = false;

  VoidCallback? onStateChanged;

  void notify() => onStateChanged?.call();

  void reset(BookmarkController bookmarks, ProgressController progress) {
    epubController?.dispose();
    epubController = null;
    epubBook = null;
    pdfController = null;
    pdfPages = 0;
    pdfCurrentPage = 0;
    isPdfReady = false;
    progress.initialized = false;
    pdfOutline = [];
    tocPdfOutline = [];
    currentPdfNode = null;
    currentChapter = 'Chapter 1';
    currentChapterIndex = 0;
    pageController?.dispose();
    pageController = null;
    progress.pagesReadThisSession.clear();
    progress.epubChaptersReadThisSession.clear();
    pdfSearcher?.dispose();
    pdfSearcher = null;
    epubChapterLengths = [];
    epubTotalLength = 0;

    // Reset search
    isSearching = false;
    searchResults = [];
    isSearchLoading = false;
    activeSearchQuery = null;
    isSearchResultsCollapsed = false;

    bookmarks.reset();
    notify();
  }

  double currentProgress(Book book, double scrollProgress) {
    return ProgressController.calculateCurrentProgress(
      book: book,
      epubChapterLengths: epubChapterLengths,
      epubTotalLength: epubTotalLength,
      currentChapterIndex: currentChapterIndex,
      scrollProgress: scrollProgress,
      chaptersLength: chapters.length,
      pdfPages: pdfPages,
      pdfCurrentPage: pdfCurrentPage,
    );
  }

  List<EpubChapter> _flattenChapters(List<EpubChapter> list) {
    final List<EpubChapter> flattened = [];
    for (final chapter in list) {
      flattened.add(chapter);
      if (chapter.SubChapters != null && chapter.SubChapters!.isNotEmpty) {
        flattened.addAll(_flattenChapters(chapter.SubChapters!));
      }
    }
    return flattened;
  }

  List<PdfOutlineNode> _flattenPdfOutline(List<PdfOutlineNode> nodes) {
    final List<PdfOutlineNode> flattened = [];
    for (final node in nodes) {
      flattened.add(node);
      if (node.children.isNotEmpty) {
        flattened.addAll(_flattenPdfOutline(node.children));
      }
    }
    return flattened;
  }

  void jumpToPdfPage(int pageNumber, ProgressController progress) {
    if (pdfController == null || !isPdfReady || pdfPages <= 0) return;
    final targetPage = pageNumber.clamp(1, pdfPages);
    if (targetPage - 1 != pdfCurrentPage) {
      isJumpingFromToc = true;
      _setPdfPage(targetPage - 1, null);
    }
    pdfController?.goToPage(pageNumber: targetPage, anchor: PdfPageAnchor.top);
    progress.recordInteraction();
    notify();
  }

  void jumpToPercent({
    required double percent,
    required Book book,
    required ProgressController progress,
    required ValueNotifier<double> scrollProgressNotifier,
  }) {
    if (book.filePath.toLowerCase().endsWith('.epub')) {
      if (chapters.isEmpty || epubTotalLength == 0) return;
      final double targetTotalProgress = percent * epubTotalLength;
      int chapterIndex = 0;
      double accumulatedLength = 0;
      for (int i = 0; i < epubChapterLengths.length; i++) {
        final length = epubChapterLengths[i];
        if (accumulatedLength + length >= targetTotalProgress) {
          chapterIndex = i;
          break;
        }
        accumulatedLength += length;
        if (i == epubChapterLengths.length - 1) chapterIndex = i;
      }
      final double remainingLength = targetTotalProgress - accumulatedLength;
      final double chapterLength = epubChapterLengths[chapterIndex].toDouble();
      final double chapterScrollProgress =
          (chapterLength > 0 ? remainingLength / chapterLength : 0.0).clamp(
            0.0,
            1.0,
          );

      shouldJumpToBottom = false;
      currentChapterIndex = chapterIndex;
      initialScrollProgress = chapterScrollProgress;
      currentChapter =
          chapters[chapterIndex].Title ?? 'Chapter ${chapterIndex + 1}';

      pageController?.jumpToPage(chapterIndex);
      progress.recordInteraction();
      notify();
    } else {
      if (!isPdfReady || pdfPages <= 0) return;
      final targetPage = (percent * (pdfPages - 1)).toInt() + 1;
      jumpToPdfPage(targetPage, progress);
    }
  }

  void _setPdfPage(int page, ValueNotifier<double>? scrollProgressNotifier) {
    pdfCurrentPage = page;
    if (pdfPages > 1) {
      if (scrollProgressNotifier != null) {
        scrollProgressNotifier.value = (page / (pdfPages - 1)).clamp(0.0, 1.0);
      }
    } else {
      if (scrollProgressNotifier != null) {
        scrollProgressNotifier.value = 1.0;
      }
    }
    _updatePdfCurrentChapter();
  }

  void updatePdfPage(int page, ValueNotifier<double>? scrollProgressNotifier) {
    _setPdfPage(page, scrollProgressNotifier);
    notify();
  }

  void initPdf(
    List<PdfOutlineNode> outline,
    int pages,
    int initialPage,
    ValueNotifier<double> scrollProgressNotifier,
  ) {
    pdfPages = pages;
    tocPdfOutline = outline;
    pdfOutline = _flattenPdfOutline(outline);
    isPdfReady = true;
    _setPdfPage(initialPage, scrollProgressNotifier);
    notify();
  }

  void _updatePdfCurrentChapter() {
    if (pdfOutline.isEmpty) {
      return;
    }
    PdfOutlineNode? current;
    for (final node in pdfOutline) {
      if (node.dest?.pageNumber != null) {
        if (node.dest!.pageNumber <= pdfCurrentPage + 1) {
          if (current == null ||
              (current.dest?.pageNumber ?? 0) <= node.dest!.pageNumber) {
            current = node;
          }
        }
      }
    }
    currentPdfNode = current;
    if (current != null) {
      currentChapter = current.title;
    } else {
      currentChapter = 'Page ${pdfCurrentPage + 1}';
    }
  }

  void initEpub({
    required Book book,
    required WidgetRef ref,
    required ProgressController progress,
  }) {
    if (epubController != null) return;
    final controller = EpubController(
      document: EpubDocument.openFile(io.File(book.filePath)),
      epubCfi: book.lastPosition,
    );
    epubController = controller;

    controller.document.then((document) {
      final flattenedChapters = _flattenChapters(document.Chapters ?? []);
      final lengths = flattenedChapters
          .map((c) => c.HtmlContent?.length ?? 0)
          .toList();
      final total = lengths.fold(0, (sum, len) => sum + len);

      epubBook = document;
      chapters = flattenedChapters;
      epubChapterLengths = lengths;
      epubTotalLength = total;

      if (total > 0) {
        final double targetTotalProgress = book.progress * total.toDouble();
        int chapterIndex = 0;
        double accumulatedLength = 0.0;
        for (int i = 0; i < lengths.length; i++) {
          final double runningLen = lengths[i].toDouble();
          if (accumulatedLength + runningLen >= targetTotalProgress) {
            chapterIndex = i;
            break;
          }
          accumulatedLength += runningLen;
          if (i == lengths.length - 1) chapterIndex = i;
        }
        final double remainingLength = targetTotalProgress - accumulatedLength;
        final double chapterLength = lengths[chapterIndex].toDouble();
        currentChapterIndex = chapterIndex;
        initialScrollProgress =
            (chapterLength > 0 ? remainingLength / chapterLength : 0.0).clamp(
              0.0,
              1.0,
            );
      } else {
        double totalProgress = book.progress * flattenedChapters.length;
        currentChapterIndex = totalProgress.floor().clamp(
          0,
          flattenedChapters.length - 1,
        );
        initialScrollProgress = totalProgress - currentChapterIndex;
      }

      pageController = PageController(initialPage: currentChapterIndex);
      currentChapter =
          flattenedChapters[currentChapterIndex].Title ??
          'Chapter ${currentChapterIndex + 1}';
      progress.onEpubChapterEntry();
      progress.initialized = true;
      notify();
    });

    progress.startHeartbeat(book, ref, () => currentProgress(book, 0.0));
  }

  void handleChapterPageChange({
    required int index,
    required Book book,
    required WidgetRef ref,
    required ProgressController progress,
    required ValueNotifier<double> scrollProgressNotifier,
  }) {
    if (index == currentChapterIndex) return;

    progress.recordEpubChapterIfRead(currentChapterIndex);
    progress.onEpubChapterEntry();

    shouldJumpToBottom = !isJumpingFromToc && index < currentChapterIndex;
    currentChapterIndex = index;
    currentChapter = chapters[index].Title ?? 'Chapter ${index + 1}';
    scrollProgressNotifier.value = 0.0;

    progress.recordInteraction();

    final runningProgress = currentProgress(book, scrollProgressNotifier.value);
    final int pagesRead = progress.totalEpubPagesRead(
      chapters,
      epubChapterLengths,
    );

    ref
        .read(libraryProvider.notifier)
        .updateBookProgress(
          book.id!,
          runningProgress,
          pagesRead: pagesRead > 0 ? pagesRead : 0,
          durationMinutes: 0,
          currentPage: currentChapterIndex,
          totalPages: chapters.length,
          estimateReadingTime: false,
        );

    if (pagesRead > 0) {
      progress.epubChaptersReadThisSession.clear();
    }
    notify();
  }

  void handlePdfPageChange({
    required int? page,
    required int? total,
    required Book book,
    required WidgetRef ref,
    required ProgressController progress,
    required ValueNotifier<double> scrollProgressNotifier,
  }) {
    if (page == null || total == null || total == 0) return;
    final int zeroIndexedPage = page;

    if (isJumpingFromToc) {
      if (zeroIndexedPage == pdfCurrentPage) {
        isJumpingFromToc = false;
      } else {
        return;
      }
    }

    if (zeroIndexedPage == pdfCurrentPage && total == pdfPages) return;

    if (!progress.initialized) {
      progress.lastSyncTime = DateTime.now();
      progress.onPdfPageEntry();
      progress.initialized = true;
      pdfPages = total;
      _setPdfPage(zeroIndexedPage, scrollProgressNotifier);
      ref
          .read(libraryProvider.notifier)
          .updateBookProgress(
            book.id!,
            book.progress,
            pagesRead: 0,
            durationMinutes: 0,
            currentPage: zeroIndexedPage,
            totalPages: total,
            estimateReadingTime: false,
          );
      notify();
      return;
    }

    progress.countAndMaybeClearPdfPages(
      previousPage: pdfCurrentPage,
      newPage: zeroIndexedPage,
      clearAfter: false,
    );
    progress.onPdfPageEntry();

    pdfPages = total;
    _setPdfPage(zeroIndexedPage, scrollProgressNotifier);

    final progressVal = currentProgress(book, scrollProgressNotifier.value);
    progress.schedulePdfProgressUpdate(
      book,
      zeroIndexedPage,
      total,
      progressVal,
      ref,
      clearSession: true,
    );
    notify();
  }

  Future<void> handleSearch(
    String query,
    Book book,
    ReaderSearchController search,
  ) async {
    if (query.trim().isEmpty) {
      searchResults = [];
      notify();
      return;
    }
    isSearchLoading = true;
    searchResults = [];
    notify();
    try {
      List<SearchResult> results;
      if (book.filePath.toLowerCase().endsWith('.pdf')) {
        results = await search.searchPdf(query, pdfController, pdfSearcher);
      } else {
        results = await search.searchEpub(query, chapters, _stripHtml);
      }
      searchResults = results;
    } catch (e) {
      debugPrint('Search error: $e');
    } finally {
      isSearchLoading = false;
      isSearchResultsCollapsed = false;
      notify();
    }
  }

  void startSearch(ReaderSearchController search) {
    isSearching = true;
    notify();
    search.focusNode.requestFocus();
  }

  void clearSearch(ReaderSearchController search) {
    isSearching = false;
    search.textController.clear();
    searchResults = [];
    activeSearchQuery = null;
    notify();
  }

  void toggleSearchResultsCollapse() {
    isSearchResultsCollapsed = !isSearchResultsCollapsed;
    notify();
  }

  String _stripHtml(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ').trim();
  }

  void goToSearchResult({required SearchResult result, required Book book}) {
    isJumpingFromToc = true;
    activeSearchQuery = result.query;
    isSearchResultsCollapsed = true;

    if (book.filePath.toLowerCase().endsWith('.pdf')) {
      if (result.pageIndex != pdfCurrentPage) {
        pdfCurrentPage = result.pageIndex;
        _updatePdfCurrentChapter();
      }
    } else {
      if (result.pageIndex != currentChapterIndex) {
        currentChapterIndex = result.pageIndex;
        currentChapter =
            chapters[result.pageIndex].Title ??
            'Chapter ${result.pageIndex + 1}';
      }
    }

    if (result.scrollProgress != null) {
      initialScrollProgress = result.scrollProgress!;
    }

    if (book.filePath.toLowerCase().endsWith('.pdf')) {
      if (result.metadata is PdfPageTextRange) {
        pdfSearcher?.goToMatch(result.metadata as PdfPageTextRange);
      } else {
        pdfController?.goToPage(
          pageNumber: result.pageIndex + 1,
          anchor: PdfPageAnchor.top,
        );
      }
    } else {
      pageController?.jumpToPage(result.pageIndex);
    }
    notify();
  }

  Future<void> lookupDictionary(WidgetRef ref, String word) async {
    final lookupWord = word.trim().split(RegExp(r'\s+')).first;
    final encoded = Uri.encodeComponent(lookupWord);

    final book = ref.read(currentlyReadingProvider);
    if (book != null) {
      await ref
          .read(libraryProvider.notifier)
          .recordDictionaryLookup(lookupWord, book.id!);
    }

    if (io.Platform.isAndroid) {
      try {
        final intent = AndroidIntent(
          action: 'android.intent.action.PROCESS_TEXT',
          type: 'text/plain',
          arguments: {
            'android.intent.extra.PROCESS_TEXT': lookupWord,
            'android.intent.extra.PROCESS_TEXT_READONLY': true,
          },
        );
        await intent.launch();
        return;
      } catch (e) {
        debugPrint('Dictionary intent failed: $e');
      }
    }
    if (io.Platform.isIOS || io.Platform.isMacOS) {
      final dictUri = Uri.parse('x-dictionary:r:$encoded');
      if (await canLaunchUrl(dictUri)) {
        await launchUrl(dictUri);
        return;
      }
    }
  }

  void showNavigationSheet({
    required BuildContext context,
    required WidgetRef ref,
    required Book book,
    required ReaderSettings settings,
    required BookmarkController bookmarks,
    required ProgressController progress,
    required ValueNotifier<double> scrollProgressNotifier,
    required VoidCallback onOpenSheet,
    required VoidCallback onCloseSheet,
  }) {
    if (!context.mounted) return;
    onOpenSheet();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return NavigationSheet(
          readerSettings: settings,
          book: book,
          chapters: chapters,
          tocChapters: epubBook?.Chapters ?? [],
          pdfOutline: pdfOutline,
          tocPdfOutline: tocPdfOutline,
          currentChapterIndex: currentChapterIndex,
          currentPdfNode: currentPdfNode,
          totalPages: pdfPages,
          focusJump: false,
          onExport: () => ExportHelper.exportToMarkdown(
            context,
            book,
            ref,
            bookmarks.highlights,
          ),
          getVocabulary: () =>
              ref.read(libraryProvider.notifier).getVocabularyForBook(book.id!),
          onUpdateHighlight: (h) async {
            await bookmarks.updateHighlight(h, ref);
          },
          onChapterTap: (index) {
            Navigator.pop(context);
            if (index != currentChapterIndex) {
              currentChapterIndex = index;
              currentChapter = chapters[index].Title ?? 'Chapter ${index + 1}';
              pageController?.jumpToPage(index);
              notify();
            }
          },
          onPdfOutlineTap: (node) {
            if (node.dest?.pageNumber != null) {
              Navigator.pop(context);
              final targetPage = node.dest!.pageNumber;
              if (targetPage - 1 != pdfCurrentPage) {
                jumpToPdfPage(targetPage, progress);
              }
            }
          },
          onJumpToPage: (page) {
            FocusManager.instance.primaryFocus?.unfocus();
            Navigator.pop(context);
            if (page - 1 != pdfCurrentPage) {
              jumpToPdfPage(page, progress);
            }
          },
          onJumpToPercent: (percent) {
            FocusManager.instance.primaryFocus?.unfocus();
            Navigator.pop(context);
            Future.delayed(const Duration(milliseconds: 300), () {
              jumpToPercent(
                percent: percent,
                book: book,
                progress: progress,
                scrollProgressNotifier: scrollProgressNotifier,
              );
            });
          },
          getBookmarks: () =>
              ref.read(libraryProvider.notifier).getBookmarks(book.id!),
          getHighlights: () => ref
              .read(databaseRepositoryProvider)
              .getHighlightsForBook(book.id!),
          highlights: bookmarks.highlights,
          onHighlightTap: (h) {
            Navigator.pop(context);
            if (book.filePath.toLowerCase().endsWith('.epub')) {
              if (h.position.contains(':')) {
                final parts = h.position.split(':');
                final index = int.tryParse(parts[0]) ?? h.chapterIndex;
                final progressVal = double.tryParse(parts.last) ?? 0.0;
                if (index >= 0 && index < chapters.length) {
                  final bool isSameChapter = index == currentChapterIndex;
                  currentChapterIndex = index;
                  initialScrollProgress = progressVal;
                  currentChapter =
                      chapters[index].Title ?? 'Chapter ${index + 1}';
                  pageController?.jumpToPage(index);
                  if (isSameChapter) {
                    progress.recordInteraction();
                  }
                  notify();
                }
              }
            } else {
              if (h.chapterIndex != pdfCurrentPage) {
                jumpToPdfPage(h.chapterIndex + 1, progress);
              }
            }
          },
          onLookup: (word) => lookupDictionary(ref, word),
          onDeleteHighlight: (id) async {
            await bookmarks.deleteHighlight(id, ref);
          },
          onDeleteHighlights: (ids) async {
            await bookmarks.deleteHighlights(ids, ref);
          },
          onDeleteBookmark: (bookmark) async {
            await ref
                .read(libraryProvider.notifier)
                .deleteBookmark(bookmark.id!);
            await bookmarks.load(book.id!, ref);
          },
          onDeleteBookmarks: (bookmarksList) async {
            await bookmarks.deleteBookmarks(bookmarksList, ref, book.id!);
          },
          onBookmarkTap: (bookmark) {
            Navigator.pop(context);
            if (book.filePath.toLowerCase().endsWith('.epub')) {
              if (bookmark.position.contains(':')) {
                final parts = bookmark.position.split(':');
                final index = int.tryParse(parts[0]) ?? 0;
                final progressVal = double.tryParse(parts[1]) ?? 0.0;
                if (index >= 0 && index < chapters.length) {
                  currentChapterIndex = index;
                  initialScrollProgress = progressVal;
                  currentChapter =
                      chapters[index].Title ?? 'Chapter ${index + 1}';
                  pageController?.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                  );
                  notify();
                }
              } else {
                final index = int.tryParse(bookmark.position);
                if (index != null && index >= 0 && index < chapters.length) {
                  currentChapterIndex = index;
                  initialScrollProgress = 0.0;
                  currentChapter =
                      chapters[index].Title ?? 'Chapter ${index + 1}';
                  pageController?.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                  );
                  notify();
                } else {
                  epubController?.gotoEpubCfi(bookmark.position);
                }
              }
            } else {
              final targetPage = int.tryParse(bookmark.position) ?? 1;
              if (targetPage - 1 != pdfCurrentPage) {
                jumpToPdfPage(targetPage, progress);
              }
            }
          },
          formatDate: ExportHelper.formatDate,
        );
      },
    ).then((_) {
      onCloseSheet();
    });
  }

  void syncFinalProgress({
    required Book book,
    required WidgetRef ref,
    required ProgressController progress,
    required double scrollProgress,
  }) {
    if (!progress.initialized) return;

    progress.syncFinalProgress(
      book: book,
      ref: ref,
      progress: currentProgress(book, scrollProgress),
      currentPage: book.filePath.toLowerCase().endsWith('.epub')
          ? currentChapterIndex
          : pdfCurrentPage,
      totalPages: book.filePath.toLowerCase().endsWith('.epub')
          ? chapters.length
          : pdfPages,
      chapters: chapters,
      epubChapterLengths: epubChapterLengths,
      currentChapterIndex: currentChapterIndex,
      pdfCurrentPage: pdfCurrentPage,
      pdfPages: pdfPages,
    );
  }
}
