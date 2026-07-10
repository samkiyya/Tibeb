import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/book_model.dart';
import '../../models/reader_settings_model.dart';
import '../../models/search_result_model.dart';
import '../../models/markdown_outline_node.dart';
import '../../widgets/reading/epub_reader_layer.dart';
import 'audio_controller.dart';
import 'audio_sync_controller.dart';
import 'auto_scroll_controller.dart';
import 'bookmark_controller.dart';
import 'epub_reading_manager.dart';
import 'navigation_manager.dart';
import 'navigation_sheet_helper.dart';
import 'pdf_reading_manager.dart';
import 'progress_controller.dart';
import 'reading_actions.dart';
import 'reading_search_manager.dart';
import 'reading_ui_state.dart';
import 'search_controller.dart';

/// Wires every action callback that [ReadingControlsOverlay] and
/// [_showNavigationSheet] require. [ReadingScreen] instantiates one of these
/// and delegates all overlay callbacks to it.
class ReadingControlsCoordinator {
  ReadingControlsCoordinator({
    required this.context,
    required this.ref,
    required this.book,
    required this.settings,
    required this.audio,
    required this.audioSync,
    required this.autoScroll,
    required this.bookmarks,
    required this.progress,
    required this.searchManager,
    required this.nav,
    required this.epub,
    required this.pdf,
    required this.ui,
    required this.search,
    required this.showControlsNotifier,
    required this.scrollProgressNotifier,
    required this.epubLayerKey,
    required this.onStateChanged,
    required this.getCurrentProgress,
    required this.jumpToPdfPage,
    required this.jumpToPercent,
    required this.syncFinalProgress,
    required this.mdOutline,
    required this.currentMdNode,
    required this.onMdOutlineTap,
  });

  final BuildContext context;
  final WidgetRef ref;
  final Book book;
  final ReaderSettings settings;

  // Controllers
  final AudioController audio;
  final AudioSyncController audioSync;
  final AutoScrollController autoScroll;
  final BookmarkController bookmarks;
  final ProgressController progress;
  final ReadingSearchManager searchManager;
  final NavigationManager nav;
  final EpubReadingManager epub;
  final PdfReadingManager pdf;
  final ReadingUiState ui;
  final ReaderSearchController search;

  // Notifiers
  final ValueNotifier<bool> showControlsNotifier;
  final ValueNotifier<double> scrollProgressNotifier;

  // Layer keys (only EPUB needed for animated chapter jumps)
  final GlobalKey<EpubReaderLayerState> epubLayerKey;

  // Screen callbacks
  final VoidCallback onStateChanged;
  final double Function() getCurrentProgress;
  final void Function(int page) jumpToPdfPage;
  final void Function(double percent, Book book) jumpToPercent;
  final void Function(Book book) syncFinalProgress;

  // Markdown outline state (owned by ReadingScreen, passed here for NavigationSheet)
  final List<MarkdownOutlineNode> mdOutline;
  final MarkdownOutlineNode? currentMdNode;
  final void Function(MarkdownOutlineNode) onMdOutlineTap;

  // ── Search ────────────────────────────────────────────────────────────────

  void onToggleSearch() {
    ui.isSearching = true;
    ReadingActions.setControlsVisibility(
      visible: true,
      showControlsNotifier: showControlsNotifier,
    );
    onStateChanged();
    search.focusNode.requestFocus();
  }

  void onClearSearch() {
    search.textController.clear();
    ui.resetSearch();
    onStateChanged();
  }

  Future<void> onSearchSubmitted(String query) async {
    if (query.trim().isEmpty) {
      ui.searchResults = [];
      onStateChanged();
      return;
    }
    ui.isSearchLoading = true;
    ui.searchResults = [];
    onStateChanged();
    try {
      ui.searchResults = await searchManager.runSearch(query, book);
    } catch (e) {
      debugPrint('Search error: $e');
    } finally {
      ui.isSearchLoading = false;
      ui.isSearchResultsCollapsed = false;
      onStateChanged();
    }
  }

  void onToggleSearchResultsCollapse() {
    ui.isSearchResultsCollapsed = !ui.isSearchResultsCollapsed;
    onStateChanged();
  }

  void onResultTap(SearchResult searchResult) {
    searchManager.goToResult(searchResult, book, onStateChanged);
  }

  // ── Bookmarks ─────────────────────────────────────────────────────────────

  void onToggleBookmark() {
    bookmarks.toggleBookmark(
      context: context,
      book: book,
      ref: ref,
      progress: getCurrentProgress(),
      currentChapterIndex: epub.currentChapterIndex,
      scrollProgress: scrollProgressNotifier.value,
      isPdfReady: pdf.isPdfReady,
      pdfCurrentPage: pdf.pdfCurrentPage,
      chapters: epub.chapters,
    );
  }

  // ── Lock / orientation / auto-scroll ─────────────────────────────────────

  void onToggleLock() =>
      ReadingActions.toggleLock(ref: ref, progress: progress);

  void onToggleOrientation() {
    ui.isOrientationLandscape = ReadingActions.toggleOrientation(
      isCurrentlyLandscape: ui.isOrientationLandscape,
    );
    onStateChanged();
  }

  void onToggleAutoScroll() {
    autoScroll.isScrolling = ReadingActions.toggleAutoScroll(
      isCurrentlyScrolling: autoScroll.isScrolling,
      settingsSpeed: settings.autoScrollSpeed,
      speedNotifier: autoScroll.speedNotifier,
    );
    onStateChanged();
  }

  // ── Audio ─────────────────────────────────────────────────────────────────

  void onToggleAudioControls() {
    ui.isAudioControlsExpanded = !ui.isAudioControlsExpanded;
    onStateChanged();
  }

  void onPickAudio() => audio.pickAndAdd(context, book, ref);

  void onIncrementPlaybackSpeed() {
    audio.incrementPlaybackSpeed();
    onStateChanged();
  }

  // ── Display settings ──────────────────────────────────────────────────────

  void onShowDisplaySettings() => ReadingActions.showDisplaySettings(context);

  void onShowTrackList() => ReadingActions.showTrackList(
    context: context,
    settings: settings,
    audio: audio,
    ref: ref,
  );

  // ── Back ──────────────────────────────────────────────────────────────────

  void onBackPressed() {
    syncFinalProgress(book);
    Navigator.of(context).pop();
  }

  // ── Navigation sheet ──────────────────────────────────────────────────────

  void onShowNavigationSheet() {
    NavigationSheetHelper.show(
      context: context,
      ref: ref,
      book: book,
      settings: settings,
      chapters: epub.chapters,
      tocChapters: epub.epubBook?.Chapters ?? [],
      pdfOutline: pdf.pdfOutline,
      tocPdfOutline: pdf.tocPdfOutline,
      currentChapterIndex: epub.currentChapterIndex,
      currentPdfNode: pdf.currentPdfNode,
      pdfPages: pdf.pdfPages,
      pdfCurrentPage: pdf.pdfCurrentPage,
      bookmarks: bookmarks,
      scrollProgressNotifier: scrollProgressNotifier,
      mdOutline: mdOutline,
      currentMdNode: currentMdNode,
      onMdOutlineTap: onMdOutlineTap,
      onOpenSheet: () {
        ui.isNavigationSheetOpen = true;
        onStateChanged();
      },
      onCloseSheet: () {
        ui.isNavigationSheetOpen = false;
        onStateChanged();
      },
      onChapterTap: (index) {
        final target = nav.onEpubChapterTap(index);
        if (target == null) return;
        epub.currentChapterIndex = target;
        epub.currentChapter =
            epub.chapters[target].Title ?? 'Chapter ${target + 1}';
        onStateChanged();
        epubLayerKey.currentState?.jumpToChapter(target);
      },
      onPdfOutlineTap: (node) {
        final page = nav.onPdfOutlineTap(node);
        if (page != null) jumpToPdfPage(page);
      },
      onJumpToPage: (page) {
        final target = nav.onJumpToPage(page);
        if (target != null) jumpToPdfPage(target);
      },
      onJumpToPercent: (percent) =>
          Future.delayed(const Duration(milliseconds: 300), () {
            if (context.mounted) jumpToPercent(percent, book);
          }),
      onHighlightTap: (h) {
        if (book.filePath.toLowerCase().endsWith('.epub')) {
          final t = nav.onEpubHighlightTap(h, epub.chapters);
          if (t == null) return;
          final isSameChapter = t.chapterIndex == epub.currentChapterIndex;
          epub.currentChapterIndex = t.chapterIndex;
          epub.initialScrollProgress = t.scrollFraction;
          epub.currentChapter = t.chapterTitle;
          onStateChanged();
          epubLayerKey.currentState?.jumpToChapter(t.chapterIndex);
          if (isSameChapter) progress.recordInteraction();
        } else {
          final page = nav.onPdfHighlightTap(h);
          if (page != null) jumpToPdfPage(page);
        }
      },
      onBookmarkTap: (bookmark) {
        if (book.filePath.toLowerCase().endsWith('.epub')) {
          final t = nav.onEpubBookmarkTap(bookmark, epub.chapters);
          if (t == null) return;
          if (t.isCfiJump) {
            epubLayerKey.currentState?.jumpToCfi(t.cfi!);
          } else if (bookmark.position.contains(':')) {
            epub.currentChapterIndex = t.chapterIndex;
            epub.initialScrollProgress = t.scrollFraction;
            epub.currentChapter = t.chapterTitle;
            onStateChanged();
            epubLayerKey.currentState?.jumpToChapter(t.chapterIndex);
          } else {
            epub.currentChapterIndex = t.chapterIndex;
            epub.initialScrollProgress = t.scrollFraction;
            epub.currentChapter = t.chapterTitle;
            onStateChanged();
            epubLayerKey.currentState?.animateToChapter(t.chapterIndex);
          }
        } else {
          final page = nav.onPdfBookmarkTap(bookmark);
          if (page != null) jumpToPdfPage(page);
        }
      },
      onLookup: (w) => ReadingActions.lookupDictionary(word: w, ref: ref),
    );
  }
}
