import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfrx/pdfrx.dart';

import '../widgets/display_settings_sheet.dart';
import '../providers/library_provider.dart';
import '../providers/reader_settings_provider.dart';
import '../models/book_model.dart';
import '../models/reader_settings_model.dart';
import '../widgets/reading/epub_view.dart';
import '../widgets/reading/pdf_view.dart';
import '../widgets/reading/reading_footer.dart';
import '../widgets/reading/track_list_sheet.dart';

import 'reading/audio_controller.dart';
import 'reading/progress_controller.dart';
import 'reading/search_controller.dart';
import 'reading/bookmark_controller.dart';
import 'reading/battery_controller.dart';
import 'reading/reading_tutorial_helper.dart';
import 'reading/document_controller.dart';
import '../widgets/reading/reading_controls_overlay.dart';

class ReadingScreen extends ConsumerStatefulWidget {
  const ReadingScreen({super.key});

  @override
  ConsumerState<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends ConsumerState<ReadingScreen>
    with TickerProviderStateMixin {
  // ── Controllers ─────────────────────────────────────────────────────────
  final AudioController _audio = AudioController();
  final ProgressController _progress = ProgressController();
  final ReaderSearchController _search = ReaderSearchController();
  final BookmarkController _bookmarks = BookmarkController();
  final BatteryController _battery = BatteryController();
  final DocumentController _document = DocumentController();

  // ── ValueNotifiers (shared with child widgets) ──────────────────────────
  final ValueNotifier<double> _pullDistanceNotifier = ValueNotifier(0.0);
  final ValueNotifier<bool> _isPullingDownNotifier = ValueNotifier(false);
  final ValueNotifier<double> _scrollProgressNotifier = ValueNotifier(0.0);
  final ValueNotifier<bool> _showControlsNotifier = ValueNotifier(true);
  final ValueNotifier<String> _currentTimeNotifier = ValueNotifier('');
  final ValueNotifier<double> _autoScrollSpeedNotifier = ValueNotifier(0.0);

  // ── UI state ────────────────────────────────────────────────────────────
  bool _isAutoScrolling = false;
  bool _isNavigationSheetOpen = false;
  bool _isOrientationLandscape = false;

  // ── Auto-scroll ─────────────────────────────────────────────────────────
  Ticker? _pdfAutoScrollTicker;
  Duration _lastPdfElapsed = Duration.zero;

  // ── Tutorial keys ───────────────────────────────────────────────────────
  final GlobalKey _audioKey = GlobalKey();
  final GlobalKey _searchKey = GlobalKey();
  final GlobalKey _lockKey = GlobalKey();
  final GlobalKey _tocKey = GlobalKey();
  final GlobalKey _autoScrollKey = GlobalKey();
  final GlobalKey _displaySettingsKey = GlobalKey();

  // ── Misc ────────────────────────────────────────────────────────────────
  Timer? _currentTimeTimer;
  int? _lastBookId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) ref.read(libraryProvider.notifier).setReadingActive(true);
    });

    // Battery
    _battery.init();
    _battery.onBatteryChanged = () {
      if (mounted) setState(() {});
    };

    // Clock
    _updateTime();
    _currentTimeTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateTime();
    });

    // Audio controller
    _audio.init();
    _audio.onSavePosition = (ms, index) {
      final book = ref.read(currentlyReadingProvider);
      if (book != null && book.id.toString() == _audio.loadedBookId) {
        ref
            .read(libraryProvider.notifier)
            .updateBookAudio(
              book.id!,
              audioLastPosition: ms,
              audioLastIndex: index,
            );
      }
    };
    _audio.onIndexChanged = () {
      if (mounted) setState(() {});
    };

    // Bookmark controller
    _bookmarks.onStateChanged = () {
      if (mounted) setState(() {});
    };

    // Document controller
    _document.onStateChanged = () {
      if (mounted) setState(() {});
    };

    // Progress controller
    _progress.onHeartbeatMinute = () {
      final book = ref.read(currentlyReadingProvider);
      if (book != null && _audio.loadedBookId == book.id.toString()) {
        _audio.saveNow();
      }
    };

    // PDF auto-scroll ticker
    _pdfAutoScrollTicker = createTicker((elapsed) {
      if (_isAutoScrolling && _document.pdfController != null) {
        final speed = _autoScrollSpeedNotifier.value;
        if (speed <= 0) return;
        final deltaTime = (elapsed - _lastPdfElapsed).inMilliseconds / 1000.0;
        _lastPdfElapsed = elapsed;
        if (deltaTime <= 0) return;
        final currentMatrix = _document.pdfController!.value;
        final dy = speed * 30.0 * deltaTime;
        final nextMatrix = currentMatrix.clone()
          ..translateByDouble(0.0, -dy, 0.0, 1.0);
        _document.pdfController!.value = nextMatrix;
      } else {
        _lastPdfElapsed = elapsed;
      }
    });
    _autoScrollSpeedNotifier.addListener(_handleGlobalSpeedChange);

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
    Future.microtask(() {
      if (mounted) ref.read(libraryProvider.notifier).setReadingActive(false);
    });
    super.deactivate();
  }

  @override
  void dispose() {
    _audio.dispose();
    _progress.dispose();
    _search.dispose();
    _document.reset(_bookmarks, _progress);
    _currentTimeTimer?.cancel();
    _battery.dispose();
    _pullDistanceNotifier.dispose();
    _isPullingDownNotifier.dispose();
    _scrollProgressNotifier.dispose();
    _currentTimeNotifier.dispose();
    _autoScrollSpeedNotifier.removeListener(_handleGlobalSpeedChange);
    _pdfAutoScrollTicker?.dispose();
    _showControlsNotifier.dispose();
    _autoScrollSpeedNotifier.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void _resetReadingViewState() {
    final book = ref.read(currentlyReadingProvider);
    if (book != null) {
      final isPdf = book.filePath.toLowerCase().endsWith('.pdf');
      Future.microtask(() {
        if (mounted) {
          final settings = ref.read(readerSettingsProvider);
          if (isPdf) {
            if (settings.pdfTheme != null) {
              ref
                  .read(readerSettingsProvider.notifier)
                  .setTheme(settings.pdfTheme!);
            } else {
              ref
                  .read(readerSettingsProvider.notifier)
                  .setTheme(ReaderTheme.white);
            }
          } else if (settings.epubTheme != null) {
            ref
                .read(readerSettingsProvider.notifier)
                .setTheme(settings.epubTheme!);
          }
        }
      });
    }
    _document.reset(_bookmarks, _progress);
  }

  Future<void> _loadBookmarks() async {
    final book = ref.read(currentlyReadingProvider);
    if (book != null) {
      await _bookmarks.load(book.id!, ref);
    }
  }

  void _updateTime() {
    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    if (_currentTimeNotifier.value != timeStr) {
      _currentTimeNotifier.value = timeStr;
    }
  }

  void _setControlsVisibility(bool visible) {
    if (_showControlsNotifier.value == visible) return;
    _showControlsNotifier.value = visible;
    SystemChrome.setEnabledSystemUIMode(
      visible ? SystemUiMode.edgeToEdge : SystemUiMode.immersiveSticky,
    );
  }

  void _toggleControls() {
    _progress.recordInteraction();
    _setControlsVisibility(!_showControlsNotifier.value);
  }

  void _toggleOrientation() {
    setState(() {
      _isOrientationLandscape = !_isOrientationLandscape;
      if (_isOrientationLandscape) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    });
  }

  void _toggleLock() {
    ref.read(readerSettingsProvider.notifier).toggleLockState();
    _progress.recordInteraction();
  }

  void _handleGlobalSpeedChange() {
    final book = ref.read(currentlyReadingProvider);
    if (book != null && !book.filePath.toLowerCase().endsWith('.epub')) {
      if (_autoScrollSpeedNotifier.value > 0) {
        if (!(_pdfAutoScrollTicker?.isActive ?? false)) {
          _pdfAutoScrollTicker?.start();
        }
      } else {
        _pdfAutoScrollTicker?.stop();
      }
    }
  }

  void _toggleBookmark(Book book) async {
    await _bookmarks.toggleBookmark(
      context: context,
      book: book,
      ref: ref,
      progress: _document.currentProgress(book, _scrollProgressNotifier.value),
      currentChapterIndex: _document.currentChapterIndex,
      scrollProgress: _scrollProgressNotifier.value,
      isPdfReady: _document.isPdfReady,
      pdfCurrentPage: _document.pdfCurrentPage,
      chapters: _document.chapters,
    );
  }

  void _syncAudioForBook(Book book) {
    final currentTracks = _audio.effectiveTracks(book);
    final hasAudio = currentTracks.isNotEmpty;

    bool tracksChanged = false;
    if (hasAudio && _audio.loadedBookId == book.id.toString()) {
      final sequence = _audio.player.sequence;
      if (sequence.length != currentTracks.length) {
        tracksChanged = true;
      }
    }

    if (hasAudio &&
        (_audio.loadedBookId != book.id.toString() || tracksChanged)) {
      _audio
          .load(
            currentTracks,
            bookId: book.id.toString(),
            initialIndex: book.audioLastIndex ?? 0,
            initialPositionMs: book.audioLastPosition ?? 0,
          )
          .catchError((e) {
            if (mounted) {
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(
                  SnackBar(content: Text('Error loading audio: $e')),
                );
            }
          });
    } else if (!hasAudio && _audio.loadedBookId != null) {
      _audio.load([], bookId: null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final book = ref.watch(currentlyReadingProvider);
    final settings = ref.watch(readerSettingsProvider);

    if (book != null && _lastBookId != book.id) {
      _lastBookId = book.id;
      _resetReadingViewState();
    }

    if (_isAutoScrolling &&
        _autoScrollSpeedNotifier.value != settings.autoScrollSpeed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _autoScrollSpeedNotifier.value = settings.autoScrollSpeed;
        }
      });
    }

    if (book == null) {
      return Scaffold(
        backgroundColor: settings.backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.menu_book_rounded,
                size: 64,
                color: settings.textColor.withValues(alpha: 0.1),
              ),
              const SizedBox(height: 16),
              Text(
                'Select a book from your library to start reading',
                style: TextStyle(color: settings.secondaryTextColor),
              ),
            ],
          ),
        ),
      );
    }

    final isEpub = book.filePath.toLowerCase().endsWith('.epub');
    if (isEpub) _document.initEpub(book: book, ref: ref, progress: _progress);
    _syncAudioForBook(book);

    return Scaffold(
      backgroundColor: settings.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            _document.syncFinalProgress(
              book: book,
              ref: ref,
              progress: _progress,
              scrollProgress: _scrollProgressNotifier.value,
            );
          }
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
                      if (isEpub)
                        _buildEpubLayer(book, settings)
                      else
                        _buildPdfLayer(book, settings),
                      _buildAnimatedControlsOverlay(context, book, settings),
                    ],
                  ),
                ),
              ),
              ValueListenableBuilder<String>(
                valueListenable: _currentTimeNotifier,
                builder: (context, currentTime, _) {
                  return ReadingFooter(
                    book: book,
                    settings: settings,
                    currentTime: currentTime,
                    currentChapter: _document.currentChapter,
                    batteryLevel: _battery.batteryLevel,
                    scrollProgressNotifier: _scrollProgressNotifier,
                    totalChapters: _document.chapters.length,
                    currentChapterIndex: _document.currentChapterIndex,
                    chapterLengths: _document.epubChapterLengths,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEpubLayer(Book book, ReaderSettings settings) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (event) {
        _document.epubPointerDownTime = DateTime.now();
        _document.epubPointerDownPosition = event.position;
      },
      onPointerUp: (event) {
        if (_document.epubPointerDownTime == null ||
            _document.epubPointerDownPosition == null) {
          return;
        }
        final elapsed = DateTime.now().difference(_document.epubPointerDownTime!);
        final distance =
            (event.position - _document.epubPointerDownPosition!).distance;
        if (elapsed < const Duration(milliseconds: 300) && distance < 20) {
          _toggleControls();
        }
        _document.epubPointerDownTime = null;
        _document.epubPointerDownPosition = null;
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: _showControlsNotifier,
        builder: (context, showControls, _) {
          return ReadingEpubView(
            book: book,
            settings: settings,
            chapters: _document.chapters,
            pageController: _document.pageController,
            currentChapterIndex: _document.currentChapterIndex,
            shouldJumpToBottom: _document.shouldJumpToBottom,
            initialScrollProgress: _document.initialScrollProgress,
            onJumpedToBottom: () =>
                setState(() => _document.shouldJumpToBottom = false),
            onJumpedToPosition: () =>
                setState(() => _document.initialScrollProgress = 0.0),
            pullDistanceNotifier: _pullDistanceNotifier,
            isPullingDownNotifier: _isPullingDownNotifier,
            scrollProgressNotifier: _scrollProgressNotifier,
            autoScrollSpeedNotifier: _autoScrollSpeedNotifier,
            showControls: showControls,
            onPageChanged: (index) => _document.handleChapterPageChange(
              index: index,
              book: book,
              ref: ref,
              progress: _progress,
              scrollProgressNotifier: _scrollProgressNotifier,
            ),
            onHideControls: () {
              if (_showControlsNotifier.value) {
                _setControlsVisibility(false);
              }
            },
            onToggleControls: _toggleControls,
            onInteraction: _progress.recordInteraction,
            highlights: _bookmarks.highlights,
            onHighlight: (h) => _bookmarks.addHighlight(h, ref),
            onDeleteHighlight: (id) => _bookmarks.deleteHighlight(id, ref),
            onLookup: (word) => _document.lookupDictionary(ref, word),
            searchQuery: _document.activeSearchQuery,
            epubBook: _document.epubBook,
          );
        },
      ),
    );
  }

  Widget _buildPdfLayer(Book book, ReaderSettings settings) {
    return ReadingPdfView(
      key: ValueKey('pdf_${book.id}'),
      book: book,
      settings: settings,
      controller: _document.pdfController ??= PdfViewerController(),
      searcher: _document.pdfSearcher,
      highlights: _bookmarks.highlights,
      onHighlight: (h) => _bookmarks.addHighlight(h, ref),
      onDeleteHighlight: (id) => _bookmarks.deleteHighlight(id, ref),
      onViewerReady: (document, controller) async {
        _document.pdfSearcher = PdfTextSearcher(controller);
        _document.pdfSearcher!.addListener(() => setState(() {}));
        final outline = await document.loadOutline();
        if (mounted) {
          final initialPage = (book.progress * (document.pages.length - 1)).toInt();
          _document.initPdf(outline, document.pages.length, initialPage, _scrollProgressNotifier);
          controller.goToPage(
            pageNumber: initialPage + 1,
            anchor: PdfPageAnchor.top,
          );
        }
        if (!_progress.initialized) {
          _progress.onPdfPageEntry();
          _progress.startHeartbeat(
            book,
            ref,
            () => _document.currentProgress(book, _scrollProgressNotifier.value),
          );
          _progress.initialized = true;
        }
      },
      onPageChanged: (pageNumber) {
        _progress.recordInteraction();
        if (pageNumber != null) {
          _document.handlePdfPageChange(
            page: pageNumber - 1,
            total: _document.pdfPages,
            book: book,
            ref: ref,
            progress: _progress,
            scrollProgressNotifier: _scrollProgressNotifier,
          );
        }
      },
      onInteraction: () {
        _progress.recordInteraction();
      },
      onHideControls: _toggleControls,
      showControls: _showControlsNotifier.value,
      scrollProgressNotifier: _scrollProgressNotifier,
    );
  }

  Widget _buildAnimatedControlsOverlay(
    BuildContext context,
    Book book,
    ReaderSettings settings,
  ) {
    return ReadingControlsOverlay(
      book: book,
      settings: settings,
      audio: _audio,
      bookmarks: _bookmarks,
      search: _search,
      showControlsNotifier: _showControlsNotifier,
      currentTimeNotifier: _currentTimeNotifier,
      scrollProgressNotifier: _scrollProgressNotifier,
      autoScrollSpeedNotifier: _autoScrollSpeedNotifier,
      isSearching: _document.isSearching,
      isSearchLoading: _document.isSearchLoading,
      isSearchResultsCollapsed: _document.isSearchResultsCollapsed,
      searchResults: _document.searchResults,
      currentChapter: _document.currentChapter,
      currentChapterIndex: _document.currentChapterIndex,
      pdfCurrentPage: _document.pdfCurrentPage,
      pdfPages: _document.pdfPages,
      isPdfReady: _document.isPdfReady,
      isNavigationSheetOpen: _isNavigationSheetOpen,
      isAutoScrolling: _isAutoScrolling,
      isOrientationLandscape: _isOrientationLandscape,
      tocKey: _tocKey,
      audioKey: _audioKey,
      autoScrollKey: _autoScrollKey,
      displaySettingsKey: _displaySettingsKey,
      searchKey: _searchKey,
      lockKey: _lockKey,
      onBackPressed: () {
        _document.syncFinalProgress(
          book: book,
          ref: ref,
          progress: _progress,
          scrollProgress: _scrollProgressNotifier.value,
        );
        Navigator.of(context).pop();
      },
      onToggleSearch: () {
        _document.startSearch(_search);
        _setControlsVisibility(true);
      },
      onClearSearch: () {
        _document.clearSearch(_search);
      },
      onSearchSubmitted: (value) => _document.handleSearch(value, book, _search),
      onToggleSearchResultsCollapse: _document.toggleSearchResultsCollapse,
      onToggleLock: _toggleLock,
      onToggleAudioControls: () => setState(() {}),
      onPickAudio: () => _audio.pickAndAdd(context, book, ref),
      onShowNavigationSheet: () => _document.showNavigationSheet(
        context: context,
        ref: ref,
        book: book,
        settings: settings,
        bookmarks: _bookmarks,
        progress: _progress,
        scrollProgressNotifier: _scrollProgressNotifier,
        onOpenSheet: () => setState(() => _isNavigationSheetOpen = true),
        onCloseSheet: () => setState(() => _isNavigationSheetOpen = false),
      ),
      onToggleBookmark: () => _toggleBookmark(book),
      onToggleAutoScroll: () {
        setState(() {
          _isAutoScrolling = !_isAutoScrolling;
          final activeSpeed = settings.autoScrollSpeed < 0.5
              ? 2.0
              : settings.autoScrollSpeed;
          _autoScrollSpeedNotifier.value = _isAutoScrolling ? activeSpeed : 0.0;
        });
      },
      onToggleOrientation: _toggleOrientation,
      onShowDisplaySettings: () => showDisplaySettingsSheet(context),
      onIncrementPlaybackSpeed: () {
        setState(() => _audio.incrementPlaybackSpeed());
      },
      onSkip: _audio.skip,
      onNextTrack: _audio.player.hasNext
          ? () => _audio.player.seekToNext()
          : null,
      onPrevTrack: _audio.player.hasPrevious
          ? () => _audio.player.seekToPrevious()
          : null,
      onShowTrackList: () => showTrackListSheet(
        context: context,
        settings: settings,
        audio: _audio,
        ref: ref,
      ),
      getDisplayProgress: () =>
          _document.currentProgress(book, _scrollProgressNotifier.value),
      onResultTap: (result) => _document.goToSearchResult(result: result, book: book),
    );
  }
}
