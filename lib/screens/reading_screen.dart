import 'dart:io' as io;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:epub_view/epub_view.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';

import '../widgets/display_settings_sheet.dart';
import '../providers/library_provider.dart';
import '../providers/reader_settings_provider.dart';
import '../models/book_model.dart';
import '../models/reader_settings_model.dart';
import '../models/search_result_model.dart';
import '../widgets/reading/reading_footer.dart';
import '../widgets/reading/track_list_sheet.dart';
import '../widgets/reading/epub_reader_layer.dart';
import '../widgets/reading/pdf_reader_layer.dart';
import 'reading/navigation_sheet_helper.dart';

import 'reading/audio_controller.dart';
import 'reading/progress_controller.dart';
import 'reading/search_controller.dart';
import 'reading/bookmark_controller.dart';
import 'reading/battery_controller.dart';
import 'reading/reading_tutorial_helper.dart';
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
  bool _isAudioControlsExpanded = false;

  // ── Layer keys ──────────────────────────────────────────────────────────
  final GlobalKey<EpubReaderLayerState> _epubLayerKey = GlobalKey();
  final GlobalKey<PdfReaderLayerState> _pdfLayerKey = GlobalKey();

  // ── State variables ─────────────────────────────────────────────────────
  List<EpubChapter> _chapters = [];
  EpubBook? _epubBook;
  List<PdfOutlineNode> _pdfOutline = [];
  List<PdfOutlineNode> _tocPdfOutline = [];
  PdfOutlineNode? _currentPdfNode;
  int _pdfPages = 0;
  int _pdfCurrentPage = 0;
  bool _isPdfReady = false;
  String _currentChapter = 'Chapter 1';
  int _currentChapterIndex = 0;
  List<int> _epubChapterLengths = [];
  int _epubTotalLength = 0;

  bool _shouldJumpToBottom = false;
  double _initialScrollProgress = 0.0;
  bool _isJumpingFromToc = false;

  // ── Search State ────────────────────────────────────────────────────────
  bool _isSearching = false;
  List<SearchResult> _searchResults = [];
  bool _isSearchLoading = false;
  String? _activeSearchQuery;
  bool _isSearchResultsCollapsed = false;

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

    // PDF auto-scroll ticker
    _pdfAutoScrollTicker = createTicker((elapsed) {
      final pdfCtl = _pdfLayerKey.currentState?.pdfController;
      if (_isAutoScrolling && pdfCtl != null) {
        final speed = _autoScrollSpeedNotifier.value;
        if (speed <= 0) return;
        final deltaTime = (elapsed - _lastPdfElapsed).inMilliseconds / 1000.0;
        _lastPdfElapsed = elapsed;
        if (deltaTime <= 0) return;
        final currentMatrix = pdfCtl.value;
        final dy = speed * 30.0 * deltaTime;
        final nextMatrix = currentMatrix.clone()
          ..translateByDouble(0.0, -dy, 0.0, 1.0);
        pdfCtl.value = nextMatrix;
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

    _chapters = [];
    _epubBook = null;
    _pdfOutline = [];
    _tocPdfOutline = [];
    _currentPdfNode = null;
    _pdfPages = 0;
    _pdfCurrentPage = 0;
    _isPdfReady = false;
    _currentChapter = 'Chapter 1';
    _currentChapterIndex = 0;
    _epubChapterLengths = [];
    _epubTotalLength = 0;
    _shouldJumpToBottom = false;
    _initialScrollProgress = 0.0;
    _isJumpingFromToc = false;

    // Reset search
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
      progress: _currentProgress(book, _scrollProgressNotifier.value),
      currentChapterIndex: _currentChapterIndex,
      scrollProgress: _scrollProgressNotifier.value,
      isPdfReady: _isPdfReady,
      pdfCurrentPage: _pdfCurrentPage,
      chapters: _chapters,
    );
  }

  double _currentProgress(Book book, double scrollProgress) {
    return ProgressController.calculateCurrentProgress(
      book: book,
      epubChapterLengths: _epubChapterLengths,
      epubTotalLength: _epubTotalLength,
      currentChapterIndex: _currentChapterIndex,
      scrollProgress: scrollProgress,
      chaptersLength: _chapters.length,
      pdfPages: _pdfPages,
      pdfCurrentPage: _pdfCurrentPage,
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

  void _jumpToPdfPage(int pageNumber) {
    if (!_isPdfReady || _pdfPages <= 0) return;
    final targetPage = pageNumber.clamp(1, _pdfPages);
    if (targetPage - 1 != _pdfCurrentPage) {
      setState(() {
        _isJumpingFromToc = true;
        _setPdfPage(targetPage - 1);
      });
    }
    _pdfLayerKey.currentState?.jumpToPage(targetPage);
    _progress.recordInteraction();
  }

  void _jumpToPercent(double percent, Book book) {
    if (book.filePath.toLowerCase().endsWith('.epub')) {
      if (_chapters.isEmpty || _epubTotalLength == 0) return;
      final double targetTotalProgress = percent * _epubTotalLength;
      int chapterIndex = 0;
      double accumulatedLength = 0;
      for (int i = 0; i < _epubChapterLengths.length; i++) {
        final length = _epubChapterLengths[i];
        if (accumulatedLength + length >= targetTotalProgress) {
          chapterIndex = i;
          break;
        }
        accumulatedLength += length;
        if (i == _epubChapterLengths.length - 1) chapterIndex = i;
      }
      final double remainingLength = targetTotalProgress - accumulatedLength;
      final double chapterLength = _epubChapterLengths[chapterIndex].toDouble();
      final double chapterScrollProgress =
          (chapterLength > 0 ? remainingLength / chapterLength : 0.0).clamp(
            0.0,
            1.0,
          );
      setState(() {
        _shouldJumpToBottom = false;
        _currentChapterIndex = chapterIndex;
        _initialScrollProgress = chapterScrollProgress;
        _currentChapter =
            _chapters[chapterIndex].Title ?? 'Chapter ${chapterIndex + 1}';
      });
      _epubLayerKey.currentState?.jumpToChapter(chapterIndex);
      _progress.recordInteraction();
    } else {
      if (!_isPdfReady || _pdfPages <= 0) return;
      final targetPage = (percent * (_pdfPages - 1)).toInt() + 1;
      _jumpToPdfPage(targetPage);
    }
  }

  void _setPdfPage(int page) {
    _pdfCurrentPage = page;
    if (_pdfPages > 1) {
      _scrollProgressNotifier.value = (page / (_pdfPages - 1)).clamp(0.0, 1.0);
    } else {
      _scrollProgressNotifier.value = 1.0;
    }
    _updatePdfCurrentChapter();
  }

  void _updatePdfCurrentChapter() {
    if (_pdfOutline.isEmpty) {
      // Fallback: show page number when there's no outline (Bug I fix)
      _currentChapter = 'Page ${_pdfCurrentPage + 1}';
      return;
    }
    PdfOutlineNode? current;
    for (final node in _pdfOutline) {
      if (node.dest?.pageNumber != null) {
        if (node.dest!.pageNumber <= _pdfCurrentPage + 1) {
          if (current == null ||
              (current.dest?.pageNumber ?? 0) <= node.dest!.pageNumber) {
            current = node;
          }
        }
      }
    }
    _currentPdfNode = current;
    if (current != null) {
      _currentChapter = current.title;
    } else {
      _currentChapter = 'Page ${_pdfCurrentPage + 1}';
    }
  }

  void _syncFinalProgress(Book book) {
    // Guaranteed final flush of audio position before leaving (Bug D fix)
    if (_audio.isLoaded) {
      _audio.saveNow();
    }

    if (!_progress.initialized) return;

    _progress.syncFinalProgress(
      book: book,
      ref: ref,
      progress: _currentProgress(book, _scrollProgressNotifier.value),
      currentPage: book.filePath.toLowerCase().endsWith('.epub')
          ? _currentChapterIndex
          : _pdfCurrentPage,
      totalPages: book.filePath.toLowerCase().endsWith('.epub')
          ? _chapters.length
          : _pdfPages,
      chapters: _chapters,
      epubChapterLengths: _epubChapterLengths,
      currentChapterIndex: _currentChapterIndex,
      pdfCurrentPage: _pdfCurrentPage,
      pdfPages: _pdfPages,
    );
  }

  Future<void> _handleSearch(String query, Book book) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }
    setState(() {
      _isSearchLoading = true;
      _searchResults = [];
    });
    try {
      List<SearchResult> results;
      if (book.filePath.toLowerCase().endsWith('.pdf')) {
        results = await _search.searchPdf(
          query,
          _pdfLayerKey.currentState?.pdfController,
          _pdfLayerKey.currentState?.pdfSearcher,
        );
      } else {
        results = await _search.searchEpub(query, _chapters, _stripHtml);
      }
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      debugPrint('Search error: $e');
    } finally {
      setState(() {
        _isSearchLoading = false;
        _isSearchResultsCollapsed = false;
      });
    }
  }

  String _stripHtml(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ').trim();
  }

  void _goToSearchResult(SearchResult result, Book book) {
    setState(() {
      _isJumpingFromToc = true;
      _activeSearchQuery = result.query;
      _isSearchResultsCollapsed = true;

      if (book.filePath.toLowerCase().endsWith('.pdf')) {
        if (result.pageIndex != _pdfCurrentPage) {
          _pdfCurrentPage = result.pageIndex;
          _updatePdfCurrentChapter();
        }
      } else {
        if (result.pageIndex != _currentChapterIndex) {
          _currentChapterIndex = result.pageIndex;
          _currentChapter =
              _chapters[result.pageIndex].Title ??
              'Chapter ${result.pageIndex + 1}';
        }
      }

      if (result.scrollProgress != null) {
        _initialScrollProgress = result.scrollProgress!;
      }

      if (book.filePath.toLowerCase().endsWith('.pdf')) {
        if (result.metadata is PdfPageTextRange) {
          _pdfLayerKey.currentState?.goToMatch(result.metadata as PdfPageTextRange);
        } else {
          _pdfLayerKey.currentState?.jumpToPage(result.pageIndex + 1);
        }
      } else {
        _epubLayerKey.currentState?.jumpToChapter(result.pageIndex);
      }
    });
  }

  Future<void> _lookupDictionary(String word) async {
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
    _syncAudioForBook(book);

    return Scaffold(
      backgroundColor: settings.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            _syncFinalProgress(book);
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
                        EpubReaderLayer(
                          key: _epubLayerKey,
                          book: book,
                          settings: settings,
                          highlights: _bookmarks.highlights,
                          pullDistanceNotifier: _pullDistanceNotifier,
                          isPullingDownNotifier: _isPullingDownNotifier,
                          scrollProgressNotifier: _scrollProgressNotifier,
                          autoScrollSpeedNotifier: _autoScrollSpeedNotifier,
                          showControlsNotifier: _showControlsNotifier,
                          activeSearchQuery: _activeSearchQuery,
                          onToggleControls: _toggleControls,
                          onInteraction: _progress.recordInteraction,
                          onHighlight: (h) => _bookmarks.addHighlight(h, ref),
                          onDeleteHighlight: (id) => _bookmarks.deleteHighlight(id, ref),
                          onLookup: _lookupDictionary,
                          onLoaded: (chapters, epubBook, initialScrollProgress) {
                            final lengths = chapters.map((c) => c.HtmlContent?.length ?? 0).toList();
                            final total = lengths.fold(0, (sum, len) => sum + len);
                            setState(() {
                              _chapters = chapters;
                              _epubBook = epubBook;
                              _epubChapterLengths = lengths;
                              _epubTotalLength = total;
                              _progress.initialized = true;
                              _currentChapter = chapters[0].Title ?? 'Chapter 1';
                              // Restore intra-chapter scroll position from saved progress (Bug B fix)
                              _initialScrollProgress = initialScrollProgress;
                            });
                            _progress.startHeartbeat(
                              book,
                              ref,
                              () => _currentProgress(book, _scrollProgressNotifier.value),
                            );
                          },
                          onPageChanged: (index) {
                            if (index == _currentChapterIndex) return;

                            // Only count the chapter as read if we weren't
                            // jumping via TOC/search (Bug H fix)
                            if (!_isJumpingFromToc) {
                              _progress.recordEpubChapterIfRead(_currentChapterIndex);
                            }
                            _progress.onEpubChapterEntry();

                            _shouldJumpToBottom = !_isJumpingFromToc && index < _currentChapterIndex;
                            _currentChapterIndex = index;
                            _currentChapter = _chapters[index].Title ?? 'Chapter ${index + 1}';
                            _scrollProgressNotifier.value = 0.0;

                            _progress.recordInteraction();

                            final runningProgress = _currentProgress(book, _scrollProgressNotifier.value);
                            final int pagesRead = _progress.totalEpubPagesRead(
                              _chapters,
                              _epubChapterLengths,
                            );

                            ref.read(libraryProvider.notifier).updateBookProgress(
                                  book.id!,
                                  runningProgress,
                                  pagesRead: pagesRead > 0 ? pagesRead : 0,
                                  durationMinutes: 0,
                                  currentPage: _currentChapterIndex,
                                  totalPages: _chapters.length,
                                  estimateReadingTime: false,
                                );

                            if (pagesRead > 0) {
                              _progress.epubChaptersReadThisSession.clear();
                            }
                            setState(() {});
                          },
                          shouldJumpToBottom: _shouldJumpToBottom,
                          initialScrollProgress: _initialScrollProgress,
                          onJumpedToBottom: () => setState(() => _shouldJumpToBottom = false),
                          onJumpedToPosition: () => setState(() => _initialScrollProgress = 0.0),
                        )
                      else
                        PdfReaderLayer(
                          key: _pdfLayerKey,
                          book: book,
                          settings: settings,
                          highlights: _bookmarks.highlights,
                          scrollProgressNotifier: _scrollProgressNotifier,
                          showControls: _showControlsNotifier.value,
                          onToggleControls: _toggleControls,
                          onInteraction: _progress.recordInteraction,
                          onHighlight: (h) => _bookmarks.addHighlight(h, ref),
                          onDeleteHighlight: (id) => _bookmarks.deleteHighlight(id, ref),
                          onLoaded: (outline, totalPages, initialPage) {
                            setState(() {
                              _pdfPages = totalPages;
                              _tocPdfOutline = outline;
                              _pdfOutline = _flattenPdfOutline(outline);
                              _isPdfReady = true;
                              _setPdfPage(initialPage);
                            });
                            if (!_progress.initialized) {
                              _progress.onPdfPageEntry();
                              _progress.startHeartbeat(
                                book,
                                ref,
                                () => _currentProgress(book, _scrollProgressNotifier.value),
                              );
                              _progress.initialized = true;
                            }
                          },
                          onPageChanged: (page, total) {
                            if (_isJumpingFromToc) {
                              if (page == _pdfCurrentPage) {
                                _isJumpingFromToc = false;
                              } else {
                                return;
                              }
                            }

                            if (page == _pdfCurrentPage && total == _pdfPages) return;

                            if (!_progress.initialized) {
                              _progress.lastSyncTime = DateTime.now();
                              _progress.onPdfPageEntry();
                              _progress.initialized = true;
                              _pdfPages = total;
                              _setPdfPage(page);
                              ref.read(libraryProvider.notifier).updateBookProgress(
                                    book.id!,
                                    book.progress,
                                    pagesRead: 0,
                                    durationMinutes: 0,
                                    currentPage: page,
                                    totalPages: total,
                                    estimateReadingTime: false,
                                  );
                              setState(() {});
                              return;
                            }

                            _progress.countAndMaybeClearPdfPages(
                              previousPage: _pdfCurrentPage,
                              newPage: page,
                              clearAfter: false,
                            );
                            _progress.onPdfPageEntry();

                            _pdfPages = total;
                            _setPdfPage(page);

                            final progressVal = _currentProgress(book, _scrollProgressNotifier.value);
                            _progress.schedulePdfProgressUpdate(
                              book,
                              page,
                              total,
                              progressVal,
                              ref,
                              clearSession: true,
                            );
                            setState(() {});
                          },
                        ),
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
                    currentChapter: _currentChapter,
                    batteryLevel: _battery.batteryLevel,
                    scrollProgressNotifier: _scrollProgressNotifier,
                    totalChapters: _chapters.length,
                    currentChapterIndex: _currentChapterIndex,
                    chapterLengths: _epubChapterLengths,
                  );
                },
              ),
            ],
          ),
        ),
      ),
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
      isSearching: _isSearching,
      isSearchLoading: _isSearchLoading,
      isSearchResultsCollapsed: _isSearchResultsCollapsed,
      searchResults: _searchResults,
      currentChapter: _currentChapter,
      currentChapterIndex: _currentChapterIndex,
      pdfCurrentPage: _pdfCurrentPage,
      pdfPages: _pdfPages,
      isPdfReady: _isPdfReady,
      isNavigationSheetOpen: _isNavigationSheetOpen,
      isAutoScrolling: _isAutoScrolling,
      isOrientationLandscape: _isOrientationLandscape,
      isAudioControlsExpanded: _isAudioControlsExpanded,
      tocKey: _tocKey,
      audioKey: _audioKey,
      autoScrollKey: _autoScrollKey,
      displaySettingsKey: _displaySettingsKey,
      searchKey: _searchKey,
      lockKey: _lockKey,
      onBackPressed: () {
        _syncFinalProgress(book);
        Navigator.of(context).pop();
      },
      onToggleSearch: () {
        setState(() {
          _isSearching = true;
          _setControlsVisibility(true);
        });
        _search.focusNode.requestFocus();
      },
      onClearSearch: () {
        setState(() {
          _isSearching = false;
          _search.textController.clear();
          _searchResults = [];
          _activeSearchQuery = null;
        });
      },
      onSearchSubmitted: (value) => _handleSearch(value, book),
      onToggleSearchResultsCollapse: () => setState(() {
        _isSearchResultsCollapsed = !_isSearchResultsCollapsed;
      }),
      onToggleLock: _toggleLock,
      onToggleAudioControls: () => setState(() => _isAudioControlsExpanded = !_isAudioControlsExpanded),
      onPickAudio: () => _audio.pickAndAdd(context, book, ref),
      onShowNavigationSheet: () {
        NavigationSheetHelper.show(
          context: context,
          ref: ref,
          book: book,
          settings: settings,
          chapters: _chapters,
          tocChapters: _epubBook?.Chapters ?? [],
          pdfOutline: _pdfOutline,
          tocPdfOutline: _tocPdfOutline,
          currentChapterIndex: _currentChapterIndex,
          currentPdfNode: _currentPdfNode,
          pdfPages: _pdfPages,
          pdfCurrentPage: _pdfCurrentPage,
          bookmarks: _bookmarks,
          scrollProgressNotifier: _scrollProgressNotifier,
          onOpenSheet: () => setState(() => _isNavigationSheetOpen = true),
          onCloseSheet: () => setState(() => _isNavigationSheetOpen = false),
          onChapterTap: (index) {
            if (index != _currentChapterIndex) {
              setState(() {
                _currentChapterIndex = index;
                _currentChapter = _chapters[index].Title ?? 'Chapter ${index + 1}';
              });
              _epubLayerKey.currentState?.jumpToChapter(index);
            }
          },
          onPdfOutlineTap: (node) {
            if (node.dest?.pageNumber != null) {
              final targetPage = node.dest!.pageNumber;
              if (targetPage - 1 != _pdfCurrentPage) {
                _jumpToPdfPage(targetPage);
              }
            }
          },
          onJumpToPage: (page) {
            if (page - 1 != _pdfCurrentPage) {
              _jumpToPdfPage(page);
            }
          },
          onJumpToPercent: (percent) {
            Future.delayed(const Duration(milliseconds: 300), () {
              _jumpToPercent(percent, book);
            });
          },
          onHighlightTap: (h) {
            if (book.filePath.toLowerCase().endsWith('.epub')) {
              if (h.position.contains(':')) {
                final parts = h.position.split(':');
                final index = int.tryParse(parts[0]) ?? h.chapterIndex;
                final progressVal = double.tryParse(parts.last) ?? 0.0;
                if (index >= 0 && index < _chapters.length) {
                  final bool isSameChapter = index == _currentChapterIndex;
                  setState(() {
                    _currentChapterIndex = index;
                    _initialScrollProgress = progressVal;
                    _currentChapter = _chapters[index].Title ?? 'Chapter ${index + 1}';
                  });
                  _epubLayerKey.currentState?.jumpToChapter(index);
                  if (isSameChapter) {
                    _progress.recordInteraction();
                  }
                }
              }
            } else {
              if (h.chapterIndex != _pdfCurrentPage) {
                _jumpToPdfPage(h.chapterIndex + 1);
              }
            }
          },
          onBookmarkTap: (bookmark) {
            if (book.filePath.toLowerCase().endsWith('.epub')) {
              if (bookmark.position.contains(':')) {
                final parts = bookmark.position.split(':');
                final index = int.tryParse(parts[0]) ?? 0;
                final progressVal = double.tryParse(parts[1]) ?? 0.0;
                if (index >= 0 && index < _chapters.length) {
                  setState(() {
                    _currentChapterIndex = index;
                    _initialScrollProgress = progressVal;
                    _currentChapter = _chapters[index].Title ?? 'Chapter ${index + 1}';
                  });
                  _epubLayerKey.currentState?.jumpToChapter(index);
                }
              } else {
                final index = int.tryParse(bookmark.position);
                if (index != null && index >= 0 && index < _chapters.length) {
                  setState(() {
                    _currentChapterIndex = index;
                    _initialScrollProgress = 0.0;
                    _currentChapter = _chapters[index].Title ?? 'Chapter ${index + 1}';
                  });
                  _epubLayerKey.currentState?.jumpToChapter(index);
                } else {
                  _epubLayerKey.currentState?.jumpToCfi(bookmark.position);
                }
              }
            } else {
              final targetPage = int.tryParse(bookmark.position) ?? 1;
              if (targetPage - 1 != _pdfCurrentPage) {
                _jumpToPdfPage(targetPage);
              }
            }
          },
          onLookup: _lookupDictionary,
        );
      },
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
          _currentProgress(book, _scrollProgressNotifier.value),
      onResultTap: (result) => _goToSearchResult(result, book),
    );
  }
}
