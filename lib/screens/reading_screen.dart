import 'dart:io' as io;
import 'dart:async';
import 'package:tibeb/widgets/reading/track_list_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:epub_view/epub_view.dart';
import 'package:pdfrx/pdfrx.dart';
import '../widgets/display_settings_sheet.dart';
import '../providers/library_provider.dart';
import '../providers/reader_settings_provider.dart';
import '../models/book_model.dart';
import '../models/reader_settings_model.dart';
import '../models/search_result_model.dart';
import '../widgets/reading/navigation_sheet.dart';
import '../widgets/reading/epub_view.dart';
import '../widgets/reading/pdf_view.dart';
import '../widgets/reading/reading_footer.dart';
import '../providers/database_providers.dart';

import 'reading/audio_controller.dart';
import 'reading/progress_controller.dart';
import 'reading/search_controller.dart';
import 'reading/bookmark_controller.dart';
import 'reading/export_helper.dart';
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

  // ── Document controllers ────────────────────────────────────────────────
  EpubController? _epubController;
  EpubBook? _epubBook;
  PdfViewerController? _pdfController;
  PdfTextSearcher? _pdfSearcher;
  PageController? _pageController;

  // ── EPUB state ──────────────────────────────────────────────────────────
  List<EpubChapter> _chapters = [];
  List<int> _epubChapterLengths = [];
  int _epubTotalLength = 0;
  String _currentChapter = 'Chapter 1';
  int _currentChapterIndex = 0;

  // ── PDF state ───────────────────────────────────────────────────────────
  int _pdfPages = 0;
  int _pdfCurrentPage = 0;
  bool _isPdfReady = false;
  final String _pdfErrorMessage = '';
  List<PdfOutlineNode> _pdfOutline = [];
  List<PdfOutlineNode> _tocPdfOutline = [];
  PdfOutlineNode? _currentPdfNode;

  // ── ValueNotifiers (shared with child widgets) ──────────────────────────
  final ValueNotifier<double> _pullDistanceNotifier = ValueNotifier(0.0);
  final ValueNotifier<bool> _isPullingDownNotifier = ValueNotifier(false);
  final ValueNotifier<double> _scrollProgressNotifier = ValueNotifier(0.0);
  final ValueNotifier<bool> _showControlsNotifier = ValueNotifier(true);
  final ValueNotifier<String> _currentTimeNotifier = ValueNotifier('');
  final ValueNotifier<double> _autoScrollSpeedNotifier = ValueNotifier(0.0);

  // ── UI state ────────────────────────────────────────────────────────────
  bool _shouldJumpToBottom = false;
  double _initialScrollProgress = 0.0;
  bool _isAutoScrolling = false;
  bool _isNavigationSheetOpen = false;
  bool _isOrientationLandscape = false;
  bool _isJumpingFromToc = false;

  // ── Search UI state ─────────────────────────────────────────────────────
  bool _isSearching = false;
  List<SearchResult> _searchResults = [];
  bool _isSearchLoading = false;
  String? _activeSearchQuery;
  bool _isSearchResultsCollapsed = false;

  // ── Auto-scroll ─────────────────────────────────────────────────────────
  Ticker? _pdfAutoScrollTicker;
  Duration _lastPdfElapsed = Duration.zero;

  // ── Battery ─────────────────────────────────────────────────────────────
  final BatteryController _battery = BatteryController();

  // ── Tutorial keys ───────────────────────────────────────────────────────
  final GlobalKey _audioKey = GlobalKey();
  final GlobalKey _searchKey = GlobalKey();
  final GlobalKey _lockKey = GlobalKey();
  final GlobalKey _tocKey = GlobalKey();
  final GlobalKey _autoScrollKey = GlobalKey();
  final GlobalKey _displaySettingsKey = GlobalKey();

  // ── Misc ────────────────────────────────────────────────────────────────
  Timer? _currentTimeTimer;
  DateTime? _epubPointerDownTime;
  Offset? _epubPointerDownPosition;
  int? _lastBookId;

  // ═══════════════════════════════════════════════════════════════════════
  // LIFECYCLE
  // ═══════════════════════════════════════════════════════════════════════

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

    // Progress controller
    _progress.onHeartbeatMinute = () {
      final book = ref.read(currentlyReadingProvider);
      if (book != null && _audio.loadedBookId == book.id.toString()) {
        _audio.saveNow();
      }
    };

    // PDF auto-scroll ticker
    _pdfAutoScrollTicker = createTicker((elapsed) {
      if (_isAutoScrolling && _pdfController != null) {
        final speed = _autoScrollSpeedNotifier.value;
        if (speed <= 0) return;
        final deltaTime = (elapsed - _lastPdfElapsed).inMilliseconds / 1000.0;
        _lastPdfElapsed = elapsed;
        if (deltaTime <= 0) return;
        final currentMatrix = _pdfController!.value;
        final dy = speed * 30.0 * deltaTime;
        final nextMatrix = currentMatrix.clone()
          ..translateByDouble(0.0, -dy, 0.0, 1.0);
        _pdfController!.value = nextMatrix;
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
    _epubController?.dispose();
    _pageController?.dispose();
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

  // ═══════════════════════════════════════════════════════════════════════
  // STATE RESET (book switch)
  // ═══════════════════════════════════════════════════════════════════════

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

    _epubController?.dispose();
    _epubController = null;
    _epubBook = null;
    _pdfController = null;
    _pdfPages = 0;
    _pdfCurrentPage = 0;
    _isPdfReady = false;
    _progress.initialized = false;
    _pdfOutline = [];
    _tocPdfOutline = [];
    _currentPdfNode = null;
    _currentChapter = 'Chapter 1';
    _currentChapterIndex = 0;
    _pageController?.dispose();
    _pageController = null;
    _progress.pagesReadThisSession.clear();
    _progress.epubChaptersReadThisSession.clear();
    _isAutoScrolling = false;
    _pdfAutoScrollTicker?.stop();
    _pdfSearcher?.dispose();
    _pdfSearcher = null;
    _searchResults = [];
    _isSearching = false;
    _activeSearchQuery = null;
    _isSearchLoading = false;
    _search.textController.clear();
    _bookmarks.reset();
    _epubChapterLengths = [];
    _epubTotalLength = 0;
    _loadBookmarks();
  }

  // ═══════════════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════════════

  Future<void> _loadBookmarks() async {
    final book = ref.read(currentlyReadingProvider);
    if (book != null) {
      await _bookmarks.load(book.id!, ref);
    }
  }

  double _currentProgress(Book book) {
    return ProgressController.calculateCurrentProgress(
      book: book,
      epubChapterLengths: _epubChapterLengths,
      epubTotalLength: _epubTotalLength,
      currentChapterIndex: _currentChapterIndex,
      scrollProgress: _scrollProgressNotifier.value,
      chaptersLength: _chapters.length,
      pdfPages: _pdfPages,
      pdfCurrentPage: _pdfCurrentPage,
    );
  }

  void _updateTime() {
    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    if (_currentTimeNotifier.value != timeStr) {
      _currentTimeNotifier.value = timeStr;
    }
  }

  String _stripHtml(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ').trim();
  }

  List<EpubChapter> _flattenChapters(List<EpubChapter> chapters) {
    final List<EpubChapter> flattened = [];
    for (final chapter in chapters) {
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





  // ═══════════════════════════════════════════════════════════════════════
  // UI CONTROLS
  // ═══════════════════════════════════════════════════════════════════════

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

  // ═══════════════════════════════════════════════════════════════════════
  // NAVIGATION
  // ═══════════════════════════════════════════════════════════════════════

  void _jumpToPdfPage(int pageNumber) {
    if (_pdfController == null || !_isPdfReady || _pdfPages <= 0) return;
    final targetPage = pageNumber.clamp(1, _pdfPages);
    if (targetPage - 1 != _pdfCurrentPage) {
      setState(() {
        _isJumpingFromToc = true;
        _setPdfPage(targetPage - 1);
      });
    }
    _pdfController?.goToPage(pageNumber: targetPage, anchor: PdfPageAnchor.top);
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
        _currentChapterIndex = chapterIndex;
        _initialScrollProgress = chapterScrollProgress;
        _currentChapter =
            _chapters[chapterIndex].Title ?? 'Chapter ${chapterIndex + 1}';
        _pageController?.jumpToPage(chapterIndex);
      });
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
      final book = ref.read(currentlyReadingProvider);
      if (book != null && !book.filePath.toLowerCase().endsWith('.epub')) {
        _currentChapter = 'Page ${_pdfCurrentPage + 1}';
      }
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

  // ═══════════════════════════════════════════════════════════════════════
  // EPUB INIT
  // ═══════════════════════════════════════════════════════════════════════

  void _initEpub(Book book) {
    if (_epubController != null) return;
    final controller = EpubController(
      document: EpubDocument.openFile(io.File(book.filePath)),
      epubCfi: book.lastPosition,
    );
    _epubController = controller;

    controller.document.then((document) {
      final flattenedChapters = _flattenChapters(document.Chapters ?? []);
      final lengths = flattenedChapters
          .map((c) => c.HtmlContent?.length ?? 0)
          .toList();
      final total = lengths.fold(0, (sum, len) => sum + len);

      setState(() {
        _epubBook = document;
        _chapters = flattenedChapters;
        _epubChapterLengths = lengths;
        _epubTotalLength = total;

        if (total > 0) {
          final double targetTotalProgress = book.progress * total.toDouble();
          int chapterIndex = 0;
          double accumulatedLength = 0.0;
          for (int i = 0; i < lengths.length; i++) {
            final double length = lengths[i].toDouble();
            if (accumulatedLength + length >= targetTotalProgress) {
              chapterIndex = i;
              break;
            }
            accumulatedLength += length;
            if (i == lengths.length - 1) chapterIndex = i;
          }
          final double remainingLength =
              targetTotalProgress - accumulatedLength;
          final double chapterLength = lengths[chapterIndex].toDouble();
          _currentChapterIndex = chapterIndex;
          _initialScrollProgress =
              (chapterLength > 0 ? remainingLength / chapterLength : 0.0).clamp(
                0.0,
                1.0,
              );
        } else {
          double totalProgress = book.progress * flattenedChapters.length;
          _currentChapterIndex = totalProgress.floor().clamp(
            0,
            flattenedChapters.length - 1,
          );
          _initialScrollProgress = totalProgress - _currentChapterIndex;
        }

        _pageController = PageController(initialPage: _currentChapterIndex);
        _currentChapter =
            flattenedChapters[_currentChapterIndex].Title ??
            'Chapter ${_currentChapterIndex + 1}';
        _progress.onEpubChapterEntry();
        _progress.initialized = true;
      });
    });

    _progress.startHeartbeat(book, ref, () => _currentProgress(book));
  }

  // ═══════════════════════════════════════════════════════════════════════
  // PAGE / CHAPTER CHANGE HANDLERS
  // ═══════════════════════════════════════════════════════════════════════

  void _handleChapterPageChange(int index, Book book) {
    if (index == _currentChapterIndex) return;

    // Record the chapter we are LEAVING
    _progress.recordEpubChapterIfRead(_currentChapterIndex);
    _progress.onEpubChapterEntry();

    setState(() {
      _shouldJumpToBottom = !_isJumpingFromToc && index < _currentChapterIndex;
      _currentChapterIndex = index;
      _currentChapter = _chapters[index].Title ?? 'Chapter ${index + 1}';
      _scrollProgressNotifier.value = 0.0;
    });

    _progress.recordInteraction();

    final progress = _currentProgress(book);
    final int pagesRead = _progress.totalEpubPagesRead(
      _chapters,
      _epubChapterLengths,
    );

    ref
        .read(libraryProvider.notifier)
        .updateBookProgress(
          book.id!,
          progress,
          pagesRead: pagesRead > 0 ? pagesRead : 0,
          durationMinutes: 0,
          currentPage: _currentChapterIndex,
          totalPages: _chapters.length,
          estimateReadingTime: false,
        );

    if (pagesRead > 0) {
      _progress.epubChaptersReadThisSession.clear();
    }
  }

  void _handlePdfPageChange(int? page, int? total, Book book) {
    if (page == null || total == null || total == 0) return;
    final int zeroIndexedPage = page;

    if (_isJumpingFromToc) {
      if (zeroIndexedPage == _pdfCurrentPage) {
        setState(() => _isJumpingFromToc = false);
      } else {
        return;
      }
    }

    if (zeroIndexedPage == _pdfCurrentPage && total == _pdfPages) return;

    if (!_progress.initialized) {
      _progress.lastSyncTime = DateTime.now();
      _progress.onPdfPageEntry();
      _progress.initialized = true;
      setState(() {
        _pdfPages = total;
        _setPdfPage(zeroIndexedPage);
      });
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
      return;
    }

    // Record the page we are LEAVING
    _progress.countAndMaybeClearPdfPages(
      previousPage: _pdfCurrentPage,
      newPage: zeroIndexedPage,
      clearAfter: false,
    );
    _progress.onPdfPageEntry();

    setState(() {
      _pdfPages = total;
      _setPdfPage(zeroIndexedPage);
    });

    final progress = _currentProgress(book);
    _progress.schedulePdfProgressUpdate(
      book,
      zeroIndexedPage,
      total,
      progress,
      ref,
      clearSession: true,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // SYNC FINAL PROGRESS (on pop)
  // ═══════════════════════════════════════════════════════════════════════

  void _syncFinalProgress(Book book) {
    // Save audio position early
    if (book.audioPath != null) {
      ref
          .read(libraryProvider.notifier)
          .updateBookAudio(
            book.id!,
            audioLastPosition: _audio.player.position.inMilliseconds,
          );
    }

    if (!_progress.initialized) return;

    _progress.syncFinalProgress(
      book: book,
      ref: ref,
      progress: _currentProgress(book),
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

  // ═══════════════════════════════════════════════════════════════════════
  // SEARCH
  // ═══════════════════════════════════════════════════════════════════════

  Future<void> _handleSearch(String query, Book book) async {
    if (query.trim().isEmpty) {
      setState(() => _searchResults = []);
      return;
    }
    setState(() {
      _isSearchLoading = true;
      _searchResults = [];
    });
    try {
      List<SearchResult> results;
      if (book.filePath.toLowerCase().endsWith('.pdf')) {
        results = await _search.searchPdf(query, _pdfController, _pdfSearcher);
      } else {
        results = await _search.searchEpub(query, _chapters, _stripHtml);
      }
      setState(() => _searchResults = results);
    } catch (e) {
      debugPrint('Search error: $e');
    } finally {
      setState(() {
        _isSearchLoading = false;
        _isSearchResultsCollapsed = false;
      });
    }
  }

  void _goToSearchResult(SearchResult result, Book book) {
    setState(() {
      _activeSearchQuery = result.query;
      _isSearchResultsCollapsed = true;

      if (book.filePath.toLowerCase().endsWith('.pdf')) {
        if (result.pageIndex != _pdfCurrentPage) {
          _isJumpingFromToc = true;
          _setPdfPage(result.pageIndex);
        }
      } else {
        if (result.pageIndex != _currentChapterIndex) {
          _isJumpingFromToc = true;
          _currentChapterIndex = result.pageIndex;
          _currentChapter =
              _chapters[result.pageIndex].Title ??
              'Chapter ${result.pageIndex + 1}';
        }
      }

      if (result.scrollProgress != null) {
        _initialScrollProgress = result.scrollProgress!;
      }
    });

    if (book.filePath.toLowerCase().endsWith('.pdf')) {
      if (result.metadata is PdfPageTextRange) {
        _pdfSearcher?.goToMatch(result.metadata as PdfPageTextRange);
      } else {
        _jumpToPdfPage(result.pageIndex + 1);
      }
    } else {
      _pageController?.jumpToPage(result.pageIndex);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // BOOKMARK / HIGHLIGHT (delegates to controller)
  // ═══════════════════════════════════════════════════════════════════════

  void _toggleBookmark(Book book) async {
    await _bookmarks.toggleBookmark(
      context: context,
      book: book,
      ref: ref,
      progress: _currentProgress(book),
      currentChapterIndex: _currentChapterIndex,
      scrollProgress: _scrollProgressNotifier.value,
      isPdfReady: _isPdfReady,
      pdfCurrentPage: _pdfCurrentPage,
      chapters: _chapters,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // DICTIONARY
  // ═══════════════════════════════════════════════════════════════════════

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





  // ═══════════════════════════════════════════════════════════════════════
  // NAVIGATION SHEET
  // ═══════════════════════════════════════════════════════════════════════

  void _showNavigationSheet({
    required Book book,
    required ReaderSettings settings,
    bool focusJump = false,
  }) {
    if (!mounted) return;
    if (_isNavigationSheetOpen) {
      Navigator.pop(context);
      return;
    }
    setState(() => _isNavigationSheetOpen = true);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return NavigationSheet(
          readerSettings: settings,
          book: book,
          chapters: _chapters,
          tocChapters: _epubBook?.Chapters ?? [],
          pdfOutline: _pdfOutline,
          tocPdfOutline: _tocPdfOutline,
          currentChapterIndex: _currentChapterIndex,
          currentPdfNode: _currentPdfNode,
          totalPages: _pdfPages,
          focusJump: focusJump,
          onExport: () => ExportHelper.exportToMarkdown(
            context,
            book,
            ref,
            _bookmarks.highlights,
          ),
          getVocabulary: () =>
              ref.read(libraryProvider.notifier).getVocabularyForBook(book.id!),
          onUpdateHighlight: (h) async {
            await _bookmarks.updateHighlight(h, ref);
          },
          onChapterTap: (index) {
            Navigator.pop(context);
            if (index != _currentChapterIndex) {
              setState(() {
                _currentChapterIndex = index;
                _currentChapter =
                    _chapters[index].Title ?? 'Chapter ${index + 1}';
              });
              _pageController?.jumpToPage(index);
            }
          },
          onPdfOutlineTap: (node) {
            if (node.dest?.pageNumber != null) {
              Navigator.pop(context);
              final targetPage = node.dest!.pageNumber;
              if (targetPage - 1 != _pdfCurrentPage) {
                _jumpToPdfPage(targetPage);
              }
            }
          },
          onJumpToPage: (page) {
            FocusManager.instance.primaryFocus?.unfocus();
            Navigator.pop(context);
            if (page - 1 != _pdfCurrentPage) {
              _jumpToPdfPage(page);
            }
          },
          onJumpToPercent: (percent) {
            FocusManager.instance.primaryFocus?.unfocus();
            Navigator.pop(context);
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) _jumpToPercent(percent, book);
            });
          },
          getBookmarks: () =>
              ref.read(libraryProvider.notifier).getBookmarks(book.id!),
          getHighlights: () => ref
              .read(databaseRepositoryProvider)
              .getHighlightsForBook(book.id!),
          highlights: _bookmarks.highlights,
          onHighlightTap: (h) {
            Navigator.pop(context);
            if (book.filePath.toLowerCase().endsWith('.epub')) {
              if (h.position.contains(':')) {
                final parts = h.position.split(':');
                final index = int.tryParse(parts[0]) ?? h.chapterIndex;
                final progress = double.tryParse(parts.last) ?? 0.0;
                if (index >= 0 && index < _chapters.length) {
                  final bool isSameChapter = index == _currentChapterIndex;
                  setState(() {
                    _currentChapterIndex = index;
                    _initialScrollProgress = progress;
                    _currentChapter =
                        _chapters[index].Title ?? 'Chapter ${index + 1}';
                  });
                  _pageController?.jumpToPage(index);
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
          onLookup: _lookupDictionary,
          onDeleteHighlight: (id) async {
            await _bookmarks.deleteHighlight(id, ref);
          },
          onDeleteHighlights: (ids) async {
            await _bookmarks.deleteHighlights(ids, ref);
          },
          onDeleteBookmark: (bookmark) async {
            await ref
                .read(libraryProvider.notifier)
                .deleteBookmark(bookmark.id!);
            await _loadBookmarks();
          },
          onDeleteBookmarks: (bookmarksList) async {
            await _bookmarks.deleteBookmarks(bookmarksList, ref, book.id!);
          },
          onBookmarkTap: (bookmark) {
            Navigator.pop(context);
            if (book.filePath.toLowerCase().endsWith('.epub')) {
              if (bookmark.position.contains(':')) {
                final parts = bookmark.position.split(':');
                final index = int.tryParse(parts[0]) ?? 0;
                final progress = double.tryParse(parts[1]) ?? 0.0;
                if (index >= 0 && index < _chapters.length) {
                  setState(() {
                    _currentChapterIndex = index;
                    _initialScrollProgress = progress;
                    _currentChapter =
                        _chapters[index].Title ?? 'Chapter ${index + 1}';
                  });
                  _pageController?.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                  );
                }
              } else {
                final index = int.tryParse(bookmark.position);
                if (index != null && index >= 0 && index < _chapters.length) {
                  setState(() {
                    _currentChapterIndex = index;
                    _initialScrollProgress = 0.0;
                    _currentChapter =
                        _chapters[index].Title ?? 'Chapter ${index + 1}';
                  });
                  _pageController?.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                  );
                } else {
                  _epubController?.gotoEpubCfi(bookmark.position);
                }
              }
            } else {
              final targetPage = int.tryParse(bookmark.position) ?? 1;
              if (targetPage - 1 != _pdfCurrentPage) {
                _jumpToPdfPage(targetPage);
              }
            }
          },
          formatDate: ExportHelper.formatDate,
        );
      },
    ).then((_) {
      if (mounted) setState(() => _isNavigationSheetOpen = false);
    });
  }

  // ═══════════════════════════════════════════════════════════════════════
  // AUDIO LOADING (build-time sync)
  // ═══════════════════════════════════════════════════════════════════════

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

  // ═══════════════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════════════

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
    if (isEpub) _initEpub(book);
    _syncAudioForBook(book);

    return Scaffold(
      backgroundColor: settings.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
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
                      if (isEpub)
                        _buildEpubLayer(book, settings)
                      else
                        _buildPdfLayer(book, settings),
                      _buildAnimatedControlsOverlay(context, book, settings),
                      if (_pdfErrorMessage.isNotEmpty)
                        Center(
                          child: Text(
                            _pdfErrorMessage,
                            style: TextStyle(color: settings.textColor),
                          ),
                        )
                      else if (!isEpub && !_isPdfReady)
                        const Center(child: CircularProgressIndicator()),
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

  // ── Build helpers ─────────────────────────────────────────────────────

  Widget _buildEpubLayer(Book book, ReaderSettings settings) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (event) {
        _epubPointerDownTime = DateTime.now();
        _epubPointerDownPosition = event.position;
      },
      onPointerUp: (event) {
        if (_epubPointerDownTime == null || _epubPointerDownPosition == null) {
          return;
        }
        final elapsed = DateTime.now().difference(_epubPointerDownTime!);
        final distance = (event.position - _epubPointerDownPosition!).distance;
        if (elapsed < const Duration(milliseconds: 300) && distance < 20) {
          _toggleControls();
        }
        _epubPointerDownTime = null;
        _epubPointerDownPosition = null;
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: _showControlsNotifier,
        builder: (context, showControls, _) {
          return ReadingEpubView(
            book: book,
            settings: settings,
            chapters: _chapters,
            pageController: _pageController,
            currentChapterIndex: _currentChapterIndex,
            shouldJumpToBottom: _shouldJumpToBottom,
            initialScrollProgress: _initialScrollProgress,
            onJumpedToBottom: () => setState(() => _shouldJumpToBottom = false),
            onJumpedToPosition: () =>
                setState(() => _initialScrollProgress = 0.0),
            pullDistanceNotifier: _pullDistanceNotifier,
            isPullingDownNotifier: _isPullingDownNotifier,
            scrollProgressNotifier: _scrollProgressNotifier,
            autoScrollSpeedNotifier: _autoScrollSpeedNotifier,
            showControls: showControls,
            onPageChanged: (index) => _handleChapterPageChange(index, book),
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
            onLookup: _lookupDictionary,
            searchQuery: _activeSearchQuery,
            epubBook: _epubBook,
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
      controller: _pdfController ??= PdfViewerController(),
      searcher: _pdfSearcher,
      highlights: _bookmarks.highlights,
      onHighlight: (h) => _bookmarks.addHighlight(h, ref),
      onDeleteHighlight: (id) => _bookmarks.deleteHighlight(id, ref),
      onViewerReady: (document, controller) async {
        _pdfSearcher = PdfTextSearcher(controller);
        _pdfSearcher!.addListener(() => setState(() {}));
        final outline = await document.loadOutline();
        if (mounted) {
          setState(() {
            _pdfPages = document.pages.length;
            _tocPdfOutline = outline;
            _pdfOutline = _flattenPdfOutline(outline);
            _isPdfReady = true;
            _updatePdfCurrentChapter();
          });
        }
        if (!_progress.initialized) {
          _progress.onPdfPageEntry();
          final initialPage = (book.progress * (_pdfPages - 1)).toInt();
          _pdfCurrentPage = initialPage;
          _scrollProgressNotifier.value = book.progress;
          if (mounted) {
            setState(() {
              _updatePdfCurrentChapter();
            });
          }
          controller.goToPage(
            pageNumber: initialPage + 1,
            anchor: PdfPageAnchor.top,
          );
          _progress.startHeartbeat(book, ref, () => _currentProgress(book));
          _progress.initialized = true;
        }
      },
      onPageChanged: (pageNumber) {
        _progress.recordInteraction();
        if (pageNumber != null) {
          _handlePdfPageChange(pageNumber - 1, _pdfPages, book);
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
        _isSearching = true;
        _setControlsVisibility(true);
        setState(() {});
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
      onToggleSearchResultsCollapse: () => setState(
        () => _isSearchResultsCollapsed = !_isSearchResultsCollapsed,
      ),
      onToggleLock: _toggleLock,
      onToggleAudioControls: () => setState(() {}),
      onPickAudio: () => _audio.pickAndAdd(context, book, ref),
      onShowNavigationSheet: () =>
          _showNavigationSheet(book: book, settings: settings),
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
      getDisplayProgress: () => _currentProgress(book),
      onResultTap: (result) => _goToSearchResult(result, book),
    );
  }
}
