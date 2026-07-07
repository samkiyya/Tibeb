import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tibeb/widgets/reading/epub_reader_layer.dart';
import 'package:tibeb/widgets/reading/pdf_reader_layer.dart';

import '../providers/library_provider.dart';
import '../providers/reader_settings_provider.dart';
import '../models/book_model.dart';
import '../models/search_result_model.dart';
import '../widgets/reading/reading_footer.dart';
import '../widgets/reading/reading_content_area.dart';
import '../widgets/reading/reading_controls_overlay.dart';

import 'reading/audio_controller.dart';
import 'reading/audio_sync_controller.dart';
import 'reading/auto_scroll_controller.dart';
import 'reading/battery_controller.dart';
import 'reading/bookmark_controller.dart';
import 'reading/epub_reading_manager.dart';
import 'reading/navigation_manager.dart';
import 'reading/navigation_sheet_helper.dart';
import 'reading/pdf_reading_manager.dart';
import 'reading/progress_controller.dart';
import 'reading/reading_actions.dart';
import 'reading/reading_tutorial_helper.dart';
import 'reading/search_controller.dart';

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

  // ── Reading-state managers ────────────────────────────────────────────────
  final EpubReadingManager _epub = EpubReadingManager();
  final PdfReadingManager _pdf = PdfReadingManager();
  late final NavigationManager _nav =
      NavigationManager(epub: _epub, pdf: _pdf);

  // ── Shared ValueNotifiers ─────────────────────────────────────────────────
  final ValueNotifier<double> _pullDistanceNotifier = ValueNotifier(0.0);
  final ValueNotifier<bool> _isPullingDownNotifier = ValueNotifier(false);
  final ValueNotifier<double> _scrollProgressNotifier = ValueNotifier(0.0);
  final ValueNotifier<bool> _showControlsNotifier = ValueNotifier(true);
  final ValueNotifier<String> _currentTimeNotifier = ValueNotifier('');

  // ── UI flags ──────────────────────────────────────────────────────────────
  bool _isNavigationSheetOpen = false;
  bool _isOrientationLandscape = false;
  bool _isAudioControlsExpanded = false;
  bool _isJumpingFromToc = false;

  // ── Search state ──────────────────────────────────────────────────────────
  bool _isSearching = false;
  List<SearchResult> _searchResults = [];
  bool _isSearchLoading = false;
  String? _activeSearchQuery;
  bool _isSearchResultsCollapsed = false;

  // ── Layer keys ────────────────────────────────────────────────────────────
  final GlobalKey<EpubReaderLayerState> _epubLayerKey = GlobalKey();
  final GlobalKey<PdfReaderLayerState> _pdfLayerKey = GlobalKey();

  // ── Tutorial GlobalKeys ───────────────────────────────────────────────────
  final GlobalKey _audioKey = GlobalKey();
  final GlobalKey _searchKey = GlobalKey();
  final GlobalKey _lockKey = GlobalKey();
  final GlobalKey _tocKey = GlobalKey();
  final GlobalKey _autoScrollKey = GlobalKey();
  final GlobalKey _displaySettingsKey = GlobalKey();

  // ── Misc ──────────────────────────────────────────────────────────────────
  Timer? _currentTimeTimer;
  int? _lastBookId;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(libraryProvider.notifier).setReadingActive(true));

    _battery.init();
    _battery.onBatteryChanged = () {
      if (mounted) setState(() {});
    };

    _updateTime();
    _currentTimeTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => _updateTime());

    _audio.init();
    _audioSync.init(ref: ref, getContext: () => context);
    _audio.onIndexChanged = () {
      if (mounted) setState(() {});
    };

    _bookmarks.onStateChanged = () {
      if (mounted) setState(() {});
    };

    _autoScroll.init(this, () => _pdfLayerKey.currentState?.pdfController);
    _autoScroll.isEpubGetter = () {
      final book = ref.read(currentlyReadingProvider);
      return book?.filePath.toLowerCase().endsWith('.epub') ?? false;
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBookmarks();
      ref.read(libraryProvider.notifier).setReadingActive(true);
      final book = ref.read(currentlyReadingProvider);
      if (book != null) {
        ReadingTutorialHelper.checkAndShow(
          context: context,
          isPdf: book.filePath.toLowerCase().endsWith('.pdf'),
          tocKey: _tocKey,
          searchKey: _searchKey,
          lockKey: _lockKey,
          audioKey: _audioKey,
          autoScrollKey: _autoScrollKey,
          displaySettingsKey: _displaySettingsKey,
        );
      }
    });
  }

  @override
  void deactivate() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Future.microtask(
        () => ref.read(libraryProvider.notifier).setReadingActive(false));
    super.deactivate();
  }

  @override
  void dispose() {
    _audio.dispose();
    _progress.dispose();
    _search.dispose();
    _autoScroll.dispose();
    _currentTimeTimer?.cancel();
    _battery.dispose();
    _pullDistanceNotifier.dispose();
    _isPullingDownNotifier.dispose();
    _scrollProgressNotifier.dispose();
    _currentTimeNotifier.dispose();
    _showControlsNotifier.dispose();
    ReadingActions.resetOrientation();
    super.dispose();
  }

  // ── Reset on book switch ──────────────────────────────────────────────────

  void _resetReadingViewState() {
    final book = ref.read(currentlyReadingProvider);
    if (book != null) {
      ReadingActions.resetThemeForBook(
        book: book, ref: ref, settings: ref.read(readerSettingsProvider));
    }
    _epub.reset();
    _pdf.reset();
    _isJumpingFromToc = false;
    _isSearching = false;
    _searchResults = [];
    _isSearchLoading = false;
    _activeSearchQuery = null;
    _isSearchResultsCollapsed = false;
    _bookmarks.reset();
    _progress.initialized = false;
    _progress.pagesReadThisSession.clear();
    _progress.epubChaptersReadThisSession.clear();
  }

  Future<void> _loadBookmarks() async {
    final book = ref.read(currentlyReadingProvider);
    if (book != null) await _bookmarks.load(book.id!, ref);
  }

  void _updateTime() {
    final now = DateTime.now();
    final t = '${now.hour.toString().padLeft(2, '0')}:'
        '${now.minute.toString().padLeft(2, '0')}';
    if (_currentTimeNotifier.value != t) _currentTimeNotifier.value = t;
  }

  // ── Progress helpers ──────────────────────────────────────────────────────

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

  // ── Navigation actions ────────────────────────────────────────────────────

  void _jumpToPdfPage(int pageNumber) {
    if (!_pdf.isPdfReady || _pdf.pdfPages <= 0) return;
    final target = _nav.onJumpToPage(pageNumber);
    if (target == null) return;
    setState(() {
      _isJumpingFromToc = true;
      _pdf.setPage(target - 1);
      _scrollProgressNotifier.value =
          _pdf.pdfPages > 1 ? ((target - 1) / (_pdf.pdfPages - 1)).clamp(0.0, 1.0) : 1.0;
    });
    _pdfLayerKey.currentState?.jumpToPage(target);
    _progress.recordInteraction();
  }

  void _jumpToPercent(double percent, Book book) {
    if (book.filePath.toLowerCase().endsWith('.epub')) {
      if (_epub.chapters.isEmpty || _epub.totalLength == 0) return;
      final t = _nav.onJumpToPercentEpub(percent);
      if (t == null) return;
      setState(() {
        _epub.shouldJumpToBottom = false;
        _epub.currentChapterIndex = t.chapterIndex;
        _epub.initialScrollProgress = t.scrollFraction;
        _epub.currentChapter = t.chapterTitle;
      });
      _epubLayerKey.currentState?.jumpToChapter(t.chapterIndex);
      _progress.recordInteraction();
    } else {
      final page = _nav.onJumpToPercentPdf(percent);
      if (page != null) _jumpToPdfPage(page);
    }
  }

  // ── Search ────────────────────────────────────────────────────────────────

  Future<void> _handleSearch(String query, Book book) async {
    if (query.trim().isEmpty) { setState(() => _searchResults = []); return; }
    setState(() { _isSearchLoading = true; _searchResults = []; });
    try {
      List<SearchResult> results;
      if (book.filePath.toLowerCase().endsWith('.pdf')) {
        results = await _search.searchPdf(
          query,
          _pdfLayerKey.currentState?.pdfController,
          _pdfLayerKey.currentState?.pdfSearcher,
        );
      } else {
        results = await _search.searchEpub(
          query, _epub.chapters,
          (h) => h.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ').trim(),
        );
      }
      setState(() => _searchResults = results);
    } catch (e) {
      debugPrint('Search error: $e');
    } finally {
      setState(() { _isSearchLoading = false; _isSearchResultsCollapsed = false; });
    }
  }

  void _goToSearchResult(SearchResult result, Book book) {
    final nav = _nav.onSearchResult(result, book);
    setState(() {
      _isJumpingFromToc = true;
      _activeSearchQuery = nav.query;
      _isSearchResultsCollapsed = true;
      if (nav.isEpub) {
        final idx = nav.epubChapterIndex!;
        if (idx != _epub.currentChapterIndex) {
          _epub.currentChapterIndex = idx;
          _epub.currentChapter = _epub.chapters[idx].Title ?? 'Chapter ${idx + 1}';
        }
        if (nav.scrollFraction != null) {
          _epub.initialScrollProgress = nav.scrollFraction!;
        }
        _epubLayerKey.currentState?.jumpToChapter(idx);
      } else {
        final idx = nav.pdfPageIndex!;
        if (idx != _pdf.pdfCurrentPage) {
          _pdf.setPage(idx);
          _scrollProgressNotifier.value = _pdf.pdfPages > 1
              ? (idx / (_pdf.pdfPages - 1)).clamp(0.0, 1.0)
              : 1.0;
        }
        if (nav.pdfMatch != null) {
          _pdfLayerKey.currentState?.goToMatch(nav.pdfMatch!);
        } else {
          _pdfLayerKey.currentState?.jumpToPage(idx + 1);
        }
      }
    });
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final book = ref.watch(currentlyReadingProvider);
    final settings = ref.watch(readerSettingsProvider);

    if (book != null && _lastBookId != book.id) {
      _lastBookId = book.id;
      _resetReadingViewState();
    }

    // Keep auto-scroll speed in sync with settings
    if (_autoScroll.isScrolling &&
        _autoScroll.speedNotifier.value != settings.autoScrollSpeed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _autoScroll.syncSpeed(settings.autoScrollSpeed);
      });
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
                        book: book,
                        settings: settings,
                        isEpub: isEpub,
                        epubLayerKey: _epubLayerKey,
                        pdfLayerKey: _pdfLayerKey,
                        highlights: _bookmarks.highlights,
                        pullDistanceNotifier: _pullDistanceNotifier,
                        isPullingDownNotifier: _isPullingDownNotifier,
                        scrollProgressNotifier: _scrollProgressNotifier,
                        autoScrollSpeedNotifier: _autoScroll.speedNotifier,
                        showControlsNotifier: _showControlsNotifier,
                        activeSearchQuery: _activeSearchQuery,
                        epub: _epub,
                        pdf: _pdf,
                        onToggleControls: () => ReadingActions.toggleControls(
                          showControlsNotifier: _showControlsNotifier,
                          progress: _progress,
                        ),
                        onInteraction: _progress.recordInteraction,
                        onHighlight: (h) => _bookmarks.addHighlight(h, ref),
                        onDeleteHighlight: (id) =>
                            _bookmarks.deleteHighlight(id, ref),
                        onLookup: (w) => ReadingActions.lookupDictionary(
                            word: w, ref: ref),
                        onEpubLoaded: (chapters, epubBook, initialScroll) {
                          _epub.load(
                            loadedChapters: chapters,
                            loadedBook: epubBook,
                            savedScrollProgress: initialScroll,
                          );
                          setState(() {});
                          _progress.initialized = true;
                          _progress.startHeartbeat(
                              book, ref, () => _currentProgress(book));
                        },
                        onEpubPageChanged: (index) {
                          if (index == _epub.currentChapterIndex) return;
                          _epub.onPageChanged(
                            newIndex: index,
                            isJumpingFromToc: _isJumpingFromToc,
                            progress: _progress,
                          );
                          _scrollProgressNotifier.value = 0.0;
                          _progress.recordInteraction();
                          final prog = _currentProgress(book);
                          final pagesRead = _progress.totalEpubPagesRead(
                              _epub.chapters, _epub.chapterLengths);
                          ref
                              .read(libraryProvider.notifier)
                              .updateBookProgress(
                            book.id!, prog,
                            pagesRead: pagesRead > 0 ? pagesRead : 0,
                            durationMinutes: 0,
                            currentPage: _epub.currentChapterIndex,
                            totalPages: _epub.chapters.length,
                            estimateReadingTime: false,
                          );
                          if (pagesRead > 0) {
                            _progress.epubChaptersReadThisSession.clear();
                          }
                          setState(() {});
                        },
                        onPdfLoaded: (outline, totalPages, initialPage) {
                          _pdf.isPdfReady = true;
                          _pdf.pdfPages = totalPages;
                          _pdf.loadOutline(outline);
                          _pdf.setPage(initialPage, totalPages: totalPages);
                          _scrollProgressNotifier.value = totalPages > 1
                              ? (initialPage / (totalPages - 1)).clamp(0.0, 1.0)
                              : 1.0;
                          if (!_progress.initialized) {
                            _progress.onPdfPageEntry();
                            _progress.startHeartbeat(
                                book, ref, () => _currentProgress(book));
                            _progress.initialized = true;
                          }
                          setState(() {});
                        },
                        onPdfPageChanged: (page, total) {
                          if (_isJumpingFromToc) {
                            if (page == _pdf.pdfCurrentPage) {
                              setState(() => _isJumpingFromToc = false);
                            } else {
                              return;
                            }
                          }
                          if (page == _pdf.pdfCurrentPage &&
                              total == _pdf.pdfPages) {
                            return;
                          }
                          if (!_progress.initialized) {
                            _progress.lastSyncTime = DateTime.now();
                            _progress.onPdfPageEntry();
                            _progress.initialized = true;
                            _pdf.setPage(page, totalPages: total);
                            _scrollProgressNotifier.value = total > 1
                                ? (page / (total - 1)).clamp(0.0, 1.0)
                                : 1.0;
                            ref
                                .read(libraryProvider.notifier)
                                .updateBookProgress(
                              book.id!, book.progress,
                              pagesRead: 0, durationMinutes: 0,
                              currentPage: page, totalPages: total,
                              estimateReadingTime: false,
                            );
                            setState(() {});
                            return;
                          }
                          _progress.countAndMaybeClearPdfPages(
                              previousPage: _pdf.pdfCurrentPage,
                              newPage: page,
                              clearAfter: false);
                          _progress.onPdfPageEntry();
                          _pdf.setPage(page, totalPages: total);
                          _scrollProgressNotifier.value = total > 1
                              ? (page / (total - 1)).clamp(0.0, 1.0)
                              : 1.0;
                          final prog = _currentProgress(book);
                          _progress.schedulePdfProgressUpdate(
                              book, page, total, prog, ref,
                              clearSession: true);
                          setState(() {});
                        },
                        onJumpedToBottom: () =>
                            setState(() => _epub.shouldJumpToBottom = false),
                        onJumpedToPosition: () =>
                            setState(() => _epub.initialScrollProgress = 0.0),
                      ),
                      _buildControlsOverlay(book, settings),
                    ],
                  ),
                ),
              ),
              ValueListenableBuilder<String>(
                valueListenable: _currentTimeNotifier,
                builder: (context, time, _) => ReadingFooter(
                  book: book,
                  settings: settings,
                  currentTime: time,
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

  // ── Controls overlay ──────────────────────────────────────────────────────

  Widget _buildControlsOverlay(Book book, settings) {
    final isEpub = book.filePath.toLowerCase().endsWith('.epub');
    return ReadingControlsOverlay(
      book: book,
      settings: settings,
      audio: _audio,
      bookmarks: _bookmarks,
      search: _search,
      showControlsNotifier: _showControlsNotifier,
      currentTimeNotifier: _currentTimeNotifier,
      scrollProgressNotifier: _scrollProgressNotifier,
      autoScrollSpeedNotifier: _autoScroll.speedNotifier,
      isSearching: _isSearching,
      isSearchLoading: _isSearchLoading,
      isSearchResultsCollapsed: _isSearchResultsCollapsed,
      searchResults: _searchResults,
      currentChapter: isEpub ? _epub.currentChapter : _pdf.currentChapter,
      currentChapterIndex: _epub.currentChapterIndex,
      pdfCurrentPage: _pdf.pdfCurrentPage,
      pdfPages: _pdf.pdfPages,
      isPdfReady: _pdf.isPdfReady,
      isNavigationSheetOpen: _isNavigationSheetOpen,
      isAutoScrolling: _autoScroll.isScrolling,
      isOrientationLandscape: _isOrientationLandscape,
      isAudioControlsExpanded: _isAudioControlsExpanded,
      tocKey: _tocKey,
      audioKey: _audioKey,
      autoScrollKey: _autoScrollKey,
      displaySettingsKey: _displaySettingsKey,
      searchKey: _searchKey,
      lockKey: _lockKey,
      onBackPressed: () { _syncFinalProgress(book); Navigator.of(context).pop(); },
      onToggleSearch: () {
        setState(() { _isSearching = true; });
        ReadingActions.setControlsVisibility(
            visible: true, showControlsNotifier: _showControlsNotifier);
        _search.focusNode.requestFocus();
      },
      onClearSearch: () => setState(() {
        _isSearching = false;
        _search.textController.clear();
        _searchResults = [];
        _activeSearchQuery = null;
      }),
      onSearchSubmitted: (v) => _handleSearch(v, book),
      onToggleSearchResultsCollapse: () =>
          setState(() => _isSearchResultsCollapsed = !_isSearchResultsCollapsed),
      onToggleLock: () => ReadingActions.toggleLock(ref: ref, progress: _progress),
      onToggleAudioControls: () =>
          setState(() => _isAudioControlsExpanded = !_isAudioControlsExpanded),
      onPickAudio: () => _audio.pickAndAdd(context, book, ref),
      onShowNavigationSheet: () => _showNavigationSheet(book, settings),
      onToggleBookmark: () => _bookmarks.toggleBookmark(
        context: context, book: book, ref: ref,
        progress: _currentProgress(book),
        currentChapterIndex: _epub.currentChapterIndex,
        scrollProgress: _scrollProgressNotifier.value,
        isPdfReady: _pdf.isPdfReady,
        pdfCurrentPage: _pdf.pdfCurrentPage,
        chapters: _epub.chapters,
      ),
      onToggleAutoScroll: () => setState(() {
        _autoScroll.isScrolling = ReadingActions.toggleAutoScroll(
          isCurrentlyScrolling: _autoScroll.isScrolling,
          settingsSpeed: settings.autoScrollSpeed,
          speedNotifier: _autoScroll.speedNotifier,
        );
      }),
      onToggleOrientation: () => setState(() {
        _isOrientationLandscape =
            ReadingActions.toggleOrientation(isCurrentlyLandscape: _isOrientationLandscape);
      }),
      onShowDisplaySettings: () => ReadingActions.showDisplaySettings(context),
      onIncrementPlaybackSpeed: () => setState(() => _audio.incrementPlaybackSpeed()),
      onSkip: _audio.skip,
      onNextTrack: _audio.player.hasNext ? () => _audio.player.seekToNext() : null,
      onPrevTrack: _audio.player.hasPrevious ? () => _audio.player.seekToPrevious() : null,
      onShowTrackList: () => ReadingActions.showTrackList(
          context: context, settings: settings, audio: _audio, ref: ref),
      getDisplayProgress: () => _currentProgress(book),
      onResultTap: (r) => _goToSearchResult(r, book),
    );
  }

  // ── Navigation sheet ──────────────────────────────────────────────────────

  void _showNavigationSheet(Book book, settings) {
    NavigationSheetHelper.show(
      context: context,
      ref: ref,
      book: book,
      settings: settings,
      chapters: _epub.chapters,
      tocChapters: _epub.epubBook?.Chapters ?? [],
      pdfOutline: _pdf.pdfOutline,
      tocPdfOutline: _pdf.tocPdfOutline,
      currentChapterIndex: _epub.currentChapterIndex,
      currentPdfNode: _pdf.currentPdfNode,
      pdfPages: _pdf.pdfPages,
      pdfCurrentPage: _pdf.pdfCurrentPage,
      bookmarks: _bookmarks,
      scrollProgressNotifier: _scrollProgressNotifier,
      onOpenSheet: () => setState(() => _isNavigationSheetOpen = true),
      onCloseSheet: () => setState(() => _isNavigationSheetOpen = false),
      onChapterTap: (index) {
        final target = _nav.onEpubChapterTap(index);
        if (target == null) return;
        setState(() {
          _epub.currentChapterIndex = target;
          _epub.currentChapter =
              _epub.chapters[target].Title ?? 'Chapter ${target + 1}';
        });
        _epubLayerKey.currentState?.jumpToChapter(target);
      },
      onPdfOutlineTap: (node) {
        final page = _nav.onPdfOutlineTap(node);
        if (page != null) _jumpToPdfPage(page);
      },
      onJumpToPage: (page) {
        final target = _nav.onJumpToPage(page);
        if (target != null) _jumpToPdfPage(target);
      },
      onJumpToPercent: (percent) =>
          Future.delayed(const Duration(milliseconds: 300),
              () { if (mounted) _jumpToPercent(percent, book); }),
      onHighlightTap: (h) {
        if (book.filePath.toLowerCase().endsWith('.epub')) {
          final t = _nav.onEpubHighlightTap(h, _epub.chapters);
          if (t == null) return;
          setState(() {
            _epub.currentChapterIndex = t.chapterIndex;
            _epub.initialScrollProgress = t.scrollFraction;
            _epub.currentChapter = t.chapterTitle;
          });
          _epubLayerKey.currentState?.jumpToChapter(t.chapterIndex);
        } else {
          final page = _nav.onPdfHighlightTap(h);
          if (page != null) _jumpToPdfPage(page);
        }
      },
      onBookmarkTap: (bookmark) {
        if (book.filePath.toLowerCase().endsWith('.epub')) {
          final t = _nav.onEpubBookmarkTap(bookmark, _epub.chapters);
          if (t == null) return;
          if (t.isCfiJump) {
            _epubLayerKey.currentState?.jumpToCfi(t.cfi!);
          } else {
            setState(() {
              _epub.currentChapterIndex = t.chapterIndex;
              _epub.initialScrollProgress = t.scrollFraction;
              _epub.currentChapter = t.chapterTitle;
            });
            _epubLayerKey.currentState?.jumpToChapter(t.chapterIndex);
          }
        } else {
          final page = _nav.onPdfBookmarkTap(bookmark);
          if (page != null) _jumpToPdfPage(page);
        }
      },
      onLookup: (w) => ReadingActions.lookupDictionary(word: w, ref: ref),
    );
  }
}
