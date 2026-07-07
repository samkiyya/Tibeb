import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/library_provider.dart';
import '../providers/reader_settings_provider.dart';
import '../models/book_model.dart';

import 'package:tibeb/widgets/reading/reading.dart';
import 'package:tibeb/screens/reading/reading.dart';


class ReadingScreen extends ConsumerStatefulWidget {
  const ReadingScreen({super.key});

  @override
  ConsumerState<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends ConsumerState<ReadingScreen>
    with TickerProviderStateMixin {
  // ── Domain controllers ────────────────────────────────────────────────────
  final AudioController _audio = AudioController();
  late final AudioSyncController _audioSync = AudioSyncController(_audio);
  final ProgressController _progress = ProgressController();
  final ReaderSearchController _search = ReaderSearchController();
  final BookmarkController _bookmarks = BookmarkController();
  final BatteryController _battery = BatteryController();
  late final AutoScrollController _autoScroll = AutoScrollController();

  // ── Domain managers ───────────────────────────────────────────────────────
  final EpubReadingManager _epub = EpubReadingManager();
  final PdfReadingManager _pdf = PdfReadingManager();
  late final NavigationManager _nav = NavigationManager(epub: _epub, pdf: _pdf);

  // ── UI state ──────────────────────────────────────────────────────────────
  final ReadingUiState _ui = ReadingUiState();

  // ── Shared ValueNotifiers ─────────────────────────────────────────────────
  final ValueNotifier<double> _pullDistanceNotifier = ValueNotifier(0.0);
  final ValueNotifier<bool> _isPullingDownNotifier = ValueNotifier(false);
  final ValueNotifier<double> _scrollProgressNotifier = ValueNotifier(0.0);
  final ValueNotifier<bool> _showControlsNotifier = ValueNotifier(true);
  final ValueNotifier<String> _currentTimeNotifier = ValueNotifier('');

  // ── Layer keys ────────────────────────────────────────────────────────────
  final GlobalKey<EpubReaderLayerState> _epubLayerKey = GlobalKey();
  final GlobalKey<PdfReaderLayerState> _pdfLayerKey = GlobalKey();

  // ── Tutorial keys ─────────────────────────────────────────────────────────
  late final TutorialKeys _tutorialKeys = TutorialKeys(
    tocKey: GlobalKey(),
    searchKey: GlobalKey(),
    lockKey: GlobalKey(),
    audioKey: GlobalKey(),
    autoScrollKey: GlobalKey(),
    displaySettingsKey: GlobalKey(),
  );

  // ── Lifecycle manager ─────────────────────────────────────────────────────
  late final ReadingLifecycle _lifecycle;

  // ── Misc ──────────────────────────────────────────────────────────────────
  int? _lastBookId;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _lifecycle = ReadingLifecycle(
      audio: _audio,
      audioSync: _audioSync,
      autoScroll: _autoScroll,
      battery: _battery,
      bookmarks: _bookmarks,
      progress: _progress,
      search: _search,
      currentTimeNotifier: _currentTimeNotifier,
      pullDistanceNotifier: _pullDistanceNotifier,
      isPullingDownNotifier: _isPullingDownNotifier,
      scrollProgressNotifier: _scrollProgressNotifier,
      showControlsNotifier: _showControlsNotifier,
      onBatteryChanged: () { if (mounted) setState(() {}); },
      onIndexChanged: () { if (mounted) setState(() {}); },
      onBookmarkStateChanged: () { if (mounted) setState(() {}); },
      onTimeTick: _updateTime,
      tutorialKeys: _tutorialKeys,
      getPdfController: () => _pdfLayerKey.currentState?.pdfController,
      getIsEpub: () {
        final book = ref.read(currentlyReadingProvider);
        return book?.filePath.toLowerCase().endsWith('.epub') ?? false;
      },
    );
    _lifecycle.init(
      vsync: this,
      ref: ref,
      context: context,
      loadBookmarks: _loadBookmarks,
    );
  }

  @override
  void deactivate() {
    ReadingLifecycle.onDeactivate(ref);
    super.deactivate();
  }

  @override
  void dispose() {
    _lifecycle.teardown();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  void _updateTime() {
    final now = DateTime.now();
    final t = '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}';
    if (_currentTimeNotifier.value != t) _currentTimeNotifier.value = t;
  }

  Future<void> _loadBookmarks() async {
    final book = ref.read(currentlyReadingProvider);
    if (book != null) await _bookmarks.load(book.id!, ref);
  }

  double _currentProgress(Book book) {
    return ProgressController.calculateCurrentProgress(
      book: book,
      epubChapterLengths: _epub.chapterLengths,
      epubTotalLength: _epub.totalLength,
      currentChapterIndex: _epub.currentChapterIndex,
      scrollProgress: _scrollProgressNotifier.value,
      chaptersLength: _epub.chapters.length,
      pdfPages: _pdf.pdfPages,
      pdfCurrentPage: _pdf.pdfCurrentPage,
    );
  }

  void _syncFinalProgress(Book book) {
    _audioSync.flushOnExit();
    if (!_progress.initialized) return;
    _progress.syncFinalProgress(
      book: book,
      ref: ref,
      progress: _currentProgress(book),
      currentPage: book.filePath.toLowerCase().endsWith('.epub')
          ? _epub.currentChapterIndex
          : _pdf.pdfCurrentPage,
      totalPages: book.filePath.toLowerCase().endsWith('.epub')
          ? _epub.chapters.length
          : _pdf.pdfPages,
      chapters: _epub.chapters,
      epubChapterLengths: _epub.chapterLengths,
      currentChapterIndex: _epub.currentChapterIndex,
      pdfCurrentPage: _pdf.pdfCurrentPage,
      pdfPages: _pdf.pdfPages,
    );
  }

  void _resetReadingViewState(Book book) {
    ReadingActions.resetThemeForBook(
        book: book, ref: ref, settings: ref.read(readerSettingsProvider));
    _epub.reset();
    _pdf.reset();
    _ui.reset();
    _bookmarks.reset();
    _progress.initialized = false;
    _progress.pagesReadThisSession.clear();
    _progress.epubChaptersReadThisSession.clear();
  }

  void _jumpToPdfPage(int pageNumber) {
    if (!_pdf.isPdfReady || _pdf.pdfPages <= 0) return;
    final target = _nav.onJumpToPage(pageNumber);
    if (target == null) return;
    _ui.isJumpingFromToc = true;
    _pdf.setPage(target - 1);
    _scrollProgressNotifier.value = _pdf.pdfPages > 1
        ? ((target - 1) / (_pdf.pdfPages - 1)).clamp(0.0, 1.0)
        : 1.0;
    setState(() {});
    _pdfLayerKey.currentState?.jumpToPage(target);
    _progress.recordInteraction();
  }

  void _jumpToPercent(double percent, Book book) {
    if (book.filePath.toLowerCase().endsWith('.epub')) {
      if (_epub.chapters.isEmpty || _epub.totalLength == 0) return;
      final t = _nav.onJumpToPercentEpub(percent);
      if (t == null) return;
      _epub.shouldJumpToBottom = false;
      _epub.currentChapterIndex = t.chapterIndex;
      _epub.initialScrollProgress = t.scrollFraction;
      _epub.currentChapter = t.chapterTitle;
      setState(() {});
      _epubLayerKey.currentState?.jumpToChapter(t.chapterIndex);
      _progress.recordInteraction();
    } else {
      final page = _nav.onJumpToPercentPdf(percent);
      if (page != null) _jumpToPdfPage(page);
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final book = ref.watch(currentlyReadingProvider);
    final settings = ref.watch(readerSettingsProvider);

    if (book != null && _lastBookId != book.id) {
      _lastBookId = book.id;
      _resetReadingViewState(book);
    }

    if (_autoScroll.isScrolling &&
        _autoScroll.speedNotifier.value != settings.autoScrollSpeed) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) { if (mounted) _autoScroll.syncSpeed(settings.autoScrollSpeed); });
    }

    if (book == null) {
      return Scaffold(
        backgroundColor: settings.backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.menu_book_rounded, size: 64,
                  color: settings.textColor.withValues(alpha: 0.1)),
              const SizedBox(height: 16),
              Text('Select a book from your library to start reading',
                  style: TextStyle(color: settings.secondaryTextColor)),
            ],
          ),
        ),
      );
    }

    final isEpub = book.filePath.toLowerCase().endsWith('.epub');

    _audioSync.syncForBook(book, onError: (msg) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(content: Text(msg)));
      }
    });

    // Build per-frame coordinators (cheap — no allocation of controllers)
    final contentCoord = ReadingContentCoordinator(
      epub: _epub, pdf: _pdf, progress: _progress,
      ui: _ui, scrollProgressNotifier: _scrollProgressNotifier,
      ref: ref, book: book, onStateChanged: () => setState(() {}),
    );

    final controlsCoord = ReadingControlsCoordinator(
      context: context, ref: ref, book: book, settings: settings,
      audio: _audio, audioSync: _audioSync, autoScroll: _autoScroll,
      bookmarks: _bookmarks, progress: _progress,
      searchManager: ReadingSearchManager(
        search: _search, nav: _nav, epub: _epub, pdf: _pdf, ui: _ui,
        epubLayerKey: _epubLayerKey, pdfLayerKey: _pdfLayerKey,
        scrollProgressNotifier: _scrollProgressNotifier,
      ),
      nav: _nav, epub: _epub, pdf: _pdf, ui: _ui, search: _search,
      showControlsNotifier: _showControlsNotifier,
      scrollProgressNotifier: _scrollProgressNotifier,
      epubLayerKey: _epubLayerKey,
      onStateChanged: () => setState(() {}),
      getCurrentProgress: () => _currentProgress(book),
      jumpToPdfPage: _jumpToPdfPage,
      jumpToPercent: _jumpToPercent,
      syncFinalProgress: _syncFinalProgress,
    );

    return Scaffold(
      backgroundColor: settings.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) _syncFinalProgress(book);
        },
        child: Container(
          color: settings.backgroundColor,
          child: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Stack(
                    children: [
                      ReadingContentArea(
                        book: book, settings: settings, isEpub: isEpub,
                        epubLayerKey: _epubLayerKey,
                        pdfLayerKey: _pdfLayerKey,
                        highlights: _bookmarks.highlights,
                        pullDistanceNotifier: _pullDistanceNotifier,
                        isPullingDownNotifier: _isPullingDownNotifier,
                        scrollProgressNotifier: _scrollProgressNotifier,
                        autoScrollSpeedNotifier: _autoScroll.speedNotifier,
                        showControlsNotifier: _showControlsNotifier,
                        activeSearchQuery: _ui.activeSearchQuery,
                        epub: _epub, pdf: _pdf,
                        onToggleControls: () => ReadingActions.toggleControls(
                          showControlsNotifier: _showControlsNotifier,
                          progress: _progress,
                        ),
                        onInteraction: _progress.recordInteraction,
                        onHighlight: (h) => _bookmarks.addHighlight(h, ref),
                        onDeleteHighlight: (id) =>
                            _bookmarks.deleteHighlight(id, ref),
                        onLookup: (w) =>
                            ReadingActions.lookupDictionary(word: w, ref: ref),
                        onEpubLoaded: contentCoord.onEpubLoaded,
                        onEpubPageChanged: contentCoord.onEpubPageChanged,
                        onPdfLoaded: contentCoord.onPdfLoaded,
                        onPdfPageChanged: contentCoord.onPdfPageChanged,
                        onJumpedToBottom: () =>
                            setState(() => _epub.shouldJumpToBottom = false),
                        onJumpedToPosition: () =>
                            setState(() => _epub.initialScrollProgress = 0.0),
                      ),
                      _buildControlsOverlay(book, settings, controlsCoord),
                    ],
                  ),
                ),
              ),
              ValueListenableBuilder<String>(
                valueListenable: _currentTimeNotifier,
                builder: (context, time, _) => ReadingFooter(
                  book: book, settings: settings, currentTime: time,
                  currentChapter: isEpub
                      ? _epub.currentChapter
                      : _pdf.currentChapter,
                  batteryLevel: _battery.batteryLevel,
                  scrollProgressNotifier: _scrollProgressNotifier,
                  totalChapters: _epub.chapters.length,
                  currentChapterIndex: _epub.currentChapterIndex,
                  chapterLengths: _epub.chapterLengths,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControlsOverlay(
    Book book,
    settings,
    ReadingControlsCoordinator coord,
  ) {
    final isEpub = book.filePath.toLowerCase().endsWith('.epub');
    return ReadingControlsOverlay(
      book: book, settings: settings,
      audio: _audio, bookmarks: _bookmarks, search: _search,
      showControlsNotifier: _showControlsNotifier,
      currentTimeNotifier: _currentTimeNotifier,
      scrollProgressNotifier: _scrollProgressNotifier,
      autoScrollSpeedNotifier: _autoScroll.speedNotifier,
      isSearching: _ui.isSearching,
      isSearchLoading: _ui.isSearchLoading,
      isSearchResultsCollapsed: _ui.isSearchResultsCollapsed,
      searchResults: _ui.searchResults,
      currentChapter: isEpub ? _epub.currentChapter : _pdf.currentChapter,
      currentChapterIndex: _epub.currentChapterIndex,
      pdfCurrentPage: _pdf.pdfCurrentPage,
      pdfPages: _pdf.pdfPages,
      isPdfReady: _pdf.isPdfReady,
      isNavigationSheetOpen: _ui.isNavigationSheetOpen,
      isAutoScrolling: _autoScroll.isScrolling,
      isOrientationLandscape: _ui.isOrientationLandscape,
      isAudioControlsExpanded: _ui.isAudioControlsExpanded,
      tocKey: _tutorialKeys.tocKey,
      audioKey: _tutorialKeys.audioKey,
      autoScrollKey: _tutorialKeys.autoScrollKey,
      displaySettingsKey: _tutorialKeys.displaySettingsKey,
      searchKey: _tutorialKeys.searchKey,
      lockKey: _tutorialKeys.lockKey,
      onBackPressed: coord.onBackPressed,
      onToggleSearch: coord.onToggleSearch,
      onClearSearch: coord.onClearSearch,
      onSearchSubmitted: coord.onSearchSubmitted,
      onToggleSearchResultsCollapse: coord.onToggleSearchResultsCollapse,
      onToggleLock: coord.onToggleLock,
      onToggleAudioControls: coord.onToggleAudioControls,
      onPickAudio: coord.onPickAudio,
      onShowNavigationSheet: coord.onShowNavigationSheet,
      onToggleBookmark: coord.onToggleBookmark,
      onToggleAutoScroll: coord.onToggleAutoScroll,
      onToggleOrientation: coord.onToggleOrientation,
      onShowDisplaySettings: coord.onShowDisplaySettings,
      onIncrementPlaybackSpeed: coord.onIncrementPlaybackSpeed,
      onSkip: _audio.skip,
      onNextTrack: _audio.player.hasNext
          ? () => _audio.player.seekToNext()
          : null,
      onPrevTrack: _audio.player.hasPrevious
          ? () => _audio.player.seekToPrevious()
          : null,
      onShowTrackList: coord.onShowTrackList,
      getDisplayProgress: () => _currentProgress(book),
      onResultTap: coord.onResultTap,
    );
  }
}
