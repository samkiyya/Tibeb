// features/reader/controllers/reading_controller.dart
//
// ReadingController owns the lifecycle logic that was previously spread across
// _ReadingScreenState (2,515 LOC). It is NOT a Riverpod provider — it is a
// plain Dart class instantiated by ReadingScreen and disposed with it.
//
// It communicates with providers via the Ref it receives on construction.

import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:epub_view/epub_view.dart'
    show EpubController, EpubDocument, EpubBook, EpubChapter;
import 'package:pdfrx/pdfrx.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// WidgetRef is a subtype of Ref in Riverpod 3 — use WidgetRef directly
import 'package:path/path.dart' as p;
import 'package:android_intent_plus/android_intent.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:tibeb/shared/models/models.dart';

import '../../../features/reader/providers/reader_provider.dart';
import '../../../features/reader/providers/audio_provider.dart';
import '../widgets/reader_track_list_sheet.dart';

class ReadingController {
  final WidgetRef ref;
  final TickerProvider vsync;

  // ─── EPUB ─────────────────────────────────────────────────────────────────
  EpubController? epubController;
  EpubBook? epubBook;
  List<EpubChapter> chapters = [];
  List<int> chapterLengths = [];
  PageController? pageController;
  bool shouldJumpToBottom = false;
  double initialScrollProgress = 0.0;

  // ─── PDF ──────────────────────────────────────────────────────────────────
  PdfViewerController pdfController = PdfViewerController();
  PdfTextSearcher? pdfSearcher;
  List<PdfOutlineNode> pdfOutline = [];
  List<PdfOutlineNode> tocPdfOutline = [];

  // ─── Shared UI notifiers ──────────────────────────────────────────────────
  final ValueNotifier<double> scrollProgress = ValueNotifier(0.0);
  final ValueNotifier<double> pullDistance = ValueNotifier(0.0);
  final ValueNotifier<bool> isPullingDown = ValueNotifier(false);
  final ValueNotifier<double> autoScrollSpeed = ValueNotifier(0.0);

  // ─── Auto-scroll ──────────────────────────────────────────────────────────
  bool isAutoScrolling = false;
  Ticker? _pdfScrollTicker;
  Duration _lastPdfElapsed = Duration.zero;

  // ─── Progress tracking ────────────────────────────────────────────────────
  Timer? _heartbeat;
  Timer? _debounce;
  int _accumulatedSeconds = 0;
  DateTime _lastSync = DateTime.now();
  DateTime _lastInteraction = DateTime.now();
  DateTime? _pageEntryTime;
  DateTime? _epubPageEntryTime;
  final Set<int> _pagesRead = {};
  final Set<int> _chaptersRead = {};
  bool _initialized = false;
  static const _idleTimeout = Duration(minutes: 2);
  static const _readThreshold = Duration(seconds: 5);

  // ─── Pointer tracking (for tap detection) ─────────────────────────────────
  DateTime? _pointerDownTime;
  Offset? _pointerDownPos;

  ReadingController({required this.ref, required this.vsync}) {
    _pdfScrollTicker = Ticker((elapsed) {
      if (!isAutoScrolling) return;
      final speed = autoScrollSpeed.value;
      if (speed <= 0) return;
      final dt = (elapsed - _lastPdfElapsed).inMilliseconds / 1000.0;
      _lastPdfElapsed = elapsed;
      if (dt <= 0) return;
      final dy = speed * 30.0 * dt;
      pdfController.value =
          (pdfController.value..translateByDouble(0.0, -dy, 0.0, 1.0));
    });
    autoScrollSpeed.addListener(_onAutoScrollSpeedChanged);
  }

  void _onAutoScrollSpeedChanged() {
    if (autoScrollSpeed.value > 0) {
      if (!(_pdfScrollTicker?.isActive ?? false)) _pdfScrollTicker?.start();
    } else {
      _pdfScrollTicker?.stop();
    }
  }

  // ─── Initialisation ───────────────────────────────────────────────────────

  void initialize(Book book) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isEpub = book.filePath.toLowerCase().endsWith('.epub');
      if (isEpub) {
        _initEpub(book);
      } else {
        _startHeartbeat(book);
      }
      ref
          .read(annotationNotifierProvider.notifier)
          .loadForBook(book.id!);
      ref
          .read(audioNotifierProvider.notifier)
          .loadBook(book);
    });
  }

  void _initEpub(Book book) {
    if (epubController != null) return;
    epubController = EpubController(
      document: EpubDocument.openFile(io.File(book.filePath)),
      epubCfi: book.lastPosition,
    );
    epubController!.document.then((doc) {
      final flat = _flattenChapters(doc.Chapters ?? []);
      final lengths = flat.map((c) => c.HtmlContent?.length ?? 0).toList();
      final total = lengths.fold(0, (s, l) => s + l);

      int initChapter = 0;
      double initScroll = 0.0;
      if (total > 0) {
        final target = book.progress * total;
        double acc = 0.0;
        for (int i = 0; i < lengths.length; i++) {
          if (acc + lengths[i] >= target) {
            initChapter = i;
            initScroll = lengths[i] > 0
                ? ((target - acc) / lengths[i]).clamp(0.0, 1.0)
                : 0.0;
            break;
          }
          acc += lengths[i];
          if (i == lengths.length - 1) initChapter = i;
        }
      }

      chapters = flat;
      chapterLengths = lengths;
      epubBook = doc;
      initialScrollProgress = initScroll;
      pageController = PageController(initialPage: initChapter);

      ref.read(epubReaderNotifierProvider.notifier).initialize(
        chapterLengths: lengths,
        initialChapterIndex: initChapter,
        initialScrollProgress: initScroll,
      );

      _epubPageEntryTime = DateTime.now();
      _initialized = true;
      _startHeartbeat(book);
    });
  }

  EpubReaderState get epubState =>
      ref.read(epubReaderNotifierProvider);

  List<EpubChapter> _flattenChapters(List<EpubChapter> list) {
    final result = <EpubChapter>[];
    for (final c in list) {
      result.add(c);
      if (c.SubChapters?.isNotEmpty == true) {
        result.addAll(_flattenChapters(c.SubChapters!));
      }
    }
    return result;
  }

  // ─── Progress handlers ────────────────────────────────────────────────────

  void handleEpubPageChange(int index, Book book) {
    final now = DateTime.now();
    final prev = epubState.currentChapterIndex;
    if (_epubPageEntryTime != null &&
        now.difference(_epubPageEntryTime!) >= _readThreshold &&
        !_chaptersRead.contains(prev)) {
      _chaptersRead.add(prev);
    }
    _epubPageEntryTime = now;
    shouldJumpToBottom = !_isJumping && index < prev;
    ref.read(epubReaderNotifierProvider.notifier).updateChapterIndex(index);
    recordInteraction();
    _saveProgress(book);
  }

  void onJumpedToBottom() => shouldJumpToBottom = false;
  void onJumpedToPosition() => initialScrollProgress = 0.0;

  bool _isJumping = false;

  void jumpToChapter(int index, Book book) {
    _isJumping = true;
    ref.read(epubReaderNotifierProvider.notifier).updateChapterIndex(index);
    pageController?.jumpToPage(index);
    Future.delayed(const Duration(milliseconds: 500),
        () => _isJumping = false);
  }

  void onPdfViewerReady(
      PdfDocument doc, PdfViewerController ctrl, Book book) {
    pdfSearcher = PdfTextSearcher(ctrl);
    final outline = doc.loadOutline();
    outline.then((nodes) {
      tocPdfOutline = nodes;
      pdfOutline = _flattenPdfOutline(nodes);
      ref.read(pdfReaderNotifierProvider.notifier).setReady(doc.pages.length);
      final initPage = (book.progress * (doc.pages.length - 1)).toInt();
      pdfController.goToPage(pageNumber: initPage + 1, anchor: PdfPageAnchor.top);
      _pageEntryTime = DateTime.now();
      _initialized = true;
      _startHeartbeat(book);
    });
  }

  void handlePdfPageChange(int? page, Book book) {
    if (page == null) return;
    final now = DateTime.now();
    final pdfState = ref.read(pdfReaderNotifierProvider);
    final prev = pdfState.currentPage;
    if (_pageEntryTime != null &&
        now.difference(_pageEntryTime!) >= _readThreshold &&
        !_pagesRead.contains(prev)) {
      _pagesRead.add(prev);
    }
    _pageEntryTime = now;
    ref.read(pdfReaderNotifierProvider.notifier)
        .updatePage(page - 1, pdfState.totalPages);
    final total = pdfState.totalPages;
    if (total > 1) {
      scrollProgress.value = ((page - 1) / (total - 1)).clamp(0.0, 1.0);
    }
    recordInteraction();
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () => _saveProgress(book));
  }

  // ─── Bookmark ─────────────────────────────────────────────────────────────

  bool isCurrentPositionBookmarked(List<Bookmark> bookmarks) {
    final book = ref.read(currentlyReadingProvider);
    if (book == null || bookmarks.isEmpty) return false;
    final isEpub = book.filePath.toLowerCase().endsWith('.epub');
    if (isEpub) {
      final idx = epubState.currentChapterIndex;
      return bookmarks.any((b) => b.position.startsWith('$idx:'));
    } else {
      final page = ref.read(pdfReaderNotifierProvider).currentPage + 1;
      return bookmarks.any((b) => b.position == '$page');
    }
  }

  void toggleBookmark(Book book, BuildContext context) async {
    final annotations = ref.read(annotationNotifierProvider);
    final isEpub = book.filePath.toLowerCase().endsWith('.epub');

    String position;
    double progress;
    String title;

    if (isEpub) {
      final idx = epubState.currentChapterIndex;
      position = '$idx:${scrollProgress.value}';
      progress = _calculateProgress(book);
      title = chapters.isNotEmpty && idx < chapters.length
          ? chapters[idx].Title ?? 'Bookmark'
          : 'Bookmark';
    } else {
      final pdfState = ref.read(pdfReaderNotifierProvider);
      final page = pdfState.currentPage + 1;
      position = '$page';
      progress = _calculateProgress(book);
      title = 'Page $page';
    }

    final existing = annotations.bookmarks
        .where((b) => b.position == position)
        .firstOrNull;

    if (existing != null) {
      await ref
          .read(annotationNotifierProvider.notifier)
          .deleteBookmark(existing.id!);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Bookmark removed'),
            behavior: SnackBarBehavior.floating,
            width: 200));
      }
    } else {
      await ref.read(annotationNotifierProvider.notifier).addBookmark(
        Bookmark(
          bookId: book.id!,
          title: title,
          progress: progress,
          createdAt: DateTime.now(),
          position: position,
        ),
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Position bookmarked'),
            behavior: SnackBarBehavior.floating,
            width: 200));
      }
    }
  }

  // ─── Search ───────────────────────────────────────────────────────────────

  Future<void> search(String query, Book book) async {
    if (query.trim().isEmpty) {
      ref.read(searchNotifierProvider.notifier).clear();
      return;
    }
    ref.read(searchNotifierProvider.notifier).setLoading(true);
    final results = <SearchResult>[];
    final isEpub = book.filePath.toLowerCase().endsWith('.epub');

    if (!isEpub) {
      if (pdfSearcher != null) {
        pdfSearcher!.startTextSearch(query, goToFirstMatch: false);
        await pdfController.useDocument((doc) async {
          for (int i = 0; i < doc.pages.length; i++) {
            final page = doc.pages[i];
            final txt = await page.loadText();
            final plain = txt?.fullText ?? '';
            final lower = plain.toLowerCase();
            final lq = query.toLowerCase();
            int start = 0;
            while (true) {
              final idx = lower.indexOf(lq, start);
              if (idx == -1 || results.length >= 30) break;
              final snip = plain
                  .substring((idx - 40).clamp(0, plain.length),
                      (idx + query.length + 60).clamp(0, plain.length))
                  .replaceAll('\n', ' ')
                  .trim();
              results.add(SearchResult(
                pageIndex: i,
                title: 'Page ${i + 1}',
                snippet: '...$snip...',
                query: query,
              ));
              start = idx + query.length;
            }
            if (results.length >= 30) break;
          }
        });
      }
    } else {
      for (int i = 0; i < chapters.length && results.length <= 30; i++) {
        final plain = _stripHtml(chapters[i].HtmlContent ?? '');
        int start = 0;
        while (true) {
          final idx = plain.toLowerCase().indexOf(query.toLowerCase(), start);
          if (idx == -1 || results.length > 30) break;
          final snip = plain
              .substring((idx - 40).clamp(0, plain.length),
                  (idx + query.length + 60).clamp(0, plain.length))
              .replaceAll('\n', ' ')
              .trim();
          results.add(SearchResult(
            pageIndex: i,
            title: chapters[i].Title ?? 'Chapter ${i + 1}',
            snippet: '...$snip...',
            query: query,
            scrollProgress: idx / plain.length,
          ));
          start = idx + query.length;
        }
      }
    }
    ref.read(searchNotifierProvider.notifier).setResults(query, results);
  }

  String _stripHtml(String html) =>
      html.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ').trim();

  // ─── Auto-scroll ──────────────────────────────────────────────────────────

  void toggleAutoScroll(double settingsSpeed) {
    isAutoScrolling = !isAutoScrolling;
    autoScrollSpeed.value =
        isAutoScrolling ? (settingsSpeed < 0.5 ? 2.0 : settingsSpeed) : 0.0;
  }

  // ─── Audio: pick files ────────────────────────────────────────────────────

  Future<void> pickAudio(Book book) async {
    final result =
        await FilePicker.pickFiles(type: FileType.audio, allowMultiple: true);
    if (result == null || result.paths.isEmpty) return;
    final existing = book.audioTracks;
    final newTracks = List<AudioTrack>.from(existing);
    for (final path in result.paths) {
      if (path != null && !newTracks.any((t) => t.path == path)) {
        newTracks.add(AudioTrack(path: path, title: p.basename(path)));
      }
    }
    if (newTracks.length == existing.length) return;
    final updated = book.copyWith(
        audioTracks: newTracks,
        audioPath: newTracks.isNotEmpty ? newTracks.first.path : null);
    await ref.read(libraryNotifierProvider.notifier).updateBook(updated);
    await ref.read(audioNotifierProvider.notifier).loadBook(updated);
  }

  void showTrackListSheet(BuildContext context, Book book) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ReaderTrackListSheet(
        book: book,
        audioNotifier: ref.read(audioNotifierProvider.notifier),
        libraryNotifier: ref.read(libraryNotifierProvider.notifier),
      ),
    );
  }

  // ─── Dictionary ───────────────────────────────────────────────────────────

  Future<void> lookupWord(String word, Book book) async {
    final w = word.trim().split(RegExp(r'\s+')).first;
    await ref
        .read(libraryNotifierProvider.notifier)
        .recordDictionaryLookup(w, book.id!);

    final encoded = Uri.encodeComponent(w);
    if (io.Platform.isAndroid) {
      try {
        await AndroidIntent(
          action: 'android.intent.action.PROCESS_TEXT',
          type: 'text/plain',
          arguments: {
            'android.intent.extra.PROCESS_TEXT': w,
            'android.intent.extra.PROCESS_TEXT_READONLY': true,
          },
        ).launch();
        return;
      } catch (_) {}
    }
    final uri = Uri.parse(
        'https://www.google.com/search?q=define+$encoded');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // ─── Progress sync ────────────────────────────────────────────────────────

  void recordInteraction() => _lastInteraction = DateTime.now();

  void recordPointerDown(Offset pos) {
    _pointerDownTime = DateTime.now();
    _pointerDownPos = pos;
  }

  bool isTap(Offset pos) {
    if (_pointerDownTime == null || _pointerDownPos == null) return false;
    final elapsed = DateTime.now().difference(_pointerDownTime!);
    final dist = (pos - _pointerDownPos!).distance;
    return elapsed < const Duration(milliseconds: 300) && dist < 20;
  }

  void clearPointerDown() {
    _pointerDownTime = null;
    _pointerDownPos = null;
  }

  bool _isIdle() =>
      DateTime.now().difference(_lastInteraction) > _idleTimeout;

  void _startHeartbeat(Book book) {
    _heartbeat?.cancel();
    _heartbeat = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_isIdle()) return;
      _accumulatedSeconds++;
      if (_accumulatedSeconds >= 60) {
        _accumulatedSeconds = 0;
        _lastSync = DateTime.now();
        final progress = _calculateProgress(book);
        ref.read(libraryNotifierProvider.notifier).updateBookProgress(
          book.id!, progress,
          pagesRead: 0, durationMinutes: 1,
        );
        final audioId = ref.read(audioNotifierProvider).loadedBookId;
        if (audioId == book.id.toString()) {
          ref.read(audioNotifierProvider.notifier).savePositionNow();
        }
      }
    });
  }

  double _calculateProgress(Book book) {
    final isEpub = book.filePath.toLowerCase().endsWith('.epub');
    if (isEpub) {
      final total = chapterLengths.fold(0, (s, l) => s + l);
      if (total == 0) return book.progress;
      final idx = epubState.currentChapterIndex;
      double acc = 0;
      for (int i = 0; i < idx; i++){ acc += chapterLengths[i];}
      return ((acc + chapterLengths[idx] * scrollProgress.value) / total)
          .clamp(0.0, 1.0);
    } else {
      final pdfState = ref.read(pdfReaderNotifierProvider);
      if (pdfState.totalPages <= 0) return book.progress;
      if (pdfState.totalPages == 1) return 1.0;
      return (pdfState.currentPage / (pdfState.totalPages - 1)).clamp(0.0, 1.0);
    }
  }

  void _saveProgress(Book book) {
    if (!_initialized) return;
    final progress = _calculateProgress(book);
    final isEpub = book.filePath.toLowerCase().endsWith('.epub');
    int pages = 0, currentPage = 0, total = 0;
    if (isEpub) {
      pages = _chaptersRead.fold(
          0, (s, idx) => s + (_getChapterWeight(idx)));
      currentPage = epubState.currentChapterIndex;
      total = chapters.length;
    } else {
      pages = _pagesRead.length;
      final pdfState = ref.read(pdfReaderNotifierProvider);
      currentPage = pdfState.currentPage;
      total = pdfState.totalPages;
    }
    ref.read(libraryNotifierProvider.notifier).updateBookProgress(
      book.id!, progress,
      pagesRead: pages,
      durationMinutes: 0,
      currentPage: currentPage,
      totalPages: total,
      estimateReadingTime: false,
    );
  }

  void syncFinalProgress(Book book) {
    if (!_initialized) return;
    _debounce?.cancel();
    _heartbeat?.cancel();
    final now = DateTime.now();
    int duration = now.difference(_lastSync).inMinutes;
    if (_accumulatedSeconds >= 30) duration++;

    if (_pageEntryTime != null) {
      final elapsed = now.difference(_pageEntryTime!);
      final pdfState = ref.read(pdfReaderNotifierProvider);
      if (elapsed >= _readThreshold &&
          !_pagesRead.contains(pdfState.currentPage)) {
        _pagesRead.add(pdfState.currentPage);
      }
    }
    if (_epubPageEntryTime != null) {
      final elapsed = now.difference(_epubPageEntryTime!);
      final idx = epubState.currentChapterIndex;
      if (elapsed >= _readThreshold && !_chaptersRead.contains(idx)) {
        _chaptersRead.add(idx);
      }
    }

    final progress = _calculateProgress(book);
    final isEpub = book.filePath.toLowerCase().endsWith('.epub');
    int pages = 0, currentPage = 0, total = 0;
    if (isEpub) {
      pages = _chaptersRead.fold(0, (s, i) => s + _getChapterWeight(i));
      currentPage = epubState.currentChapterIndex;
      total = chapters.length;
    } else {
      pages = _pagesRead.length;
      final pdfState = ref.read(pdfReaderNotifierProvider);
      currentPage = pdfState.currentPage;
      total = pdfState.totalPages;
    }
    if (pages > 0 || duration > 0) {
      ref.read(libraryNotifierProvider.notifier).updateBookProgress(
        book.id!, progress,
        pagesRead: pages, durationMinutes: duration,
        currentPage: currentPage, totalPages: total,
        estimateReadingTime: false,
      );
    }
    ref.read(audioNotifierProvider.notifier).savePositionNow();
  }

  int _getChapterWeight(int idx) {
    if (idx < 0 || idx >= chapterLengths.length) return 0;
    return (chapterLengths[idx] / 1000).ceil();
  }

  List<PdfOutlineNode> _flattenPdfOutline(List<PdfOutlineNode> nodes) {
    final result = <PdfOutlineNode>[];
    for (final n in nodes) {
      result.add(n);
      if (n.children.isNotEmpty) {
        result.addAll(_flattenPdfOutline(n.children));
      }
    }
    return result;
  }

  // ─── Cleanup ──────────────────────────────────────────────────────────────

  void dispose() {
    _heartbeat?.cancel();
    _debounce?.cancel();
    epubController?.dispose();
    pageController?.dispose();
    pdfSearcher?.dispose();
    _pdfScrollTicker?.dispose();
    autoScrollSpeed.removeListener(_onAutoScrollSpeedChanged);
    scrollProgress.dispose();
    pullDistance.dispose();
    isPullingDown.dispose();
    autoScrollSpeed.dispose();
  }
}

// ─── Search UI controllers (owned here to survive screen rebuilds) ─────────
extension ReadingControllerSearch on ReadingController {
  // These are lazy-initialised via late fields; add them as class members
  // by patching the class. Dart doesn't allow extension fields, so we use
  // a separate storage map pattern.
}

// Add to ReadingController class directly — patch via top-level storage
final _textControllers = Expando<TextEditingController>();
final _focusNodes = Expando<FocusNode>();

extension ReadingControllerUI on ReadingController {
  TextEditingController get searchTextController {
    return _textControllers[this] ??= TextEditingController();
  }

  FocusNode get searchFocusNode {
    return _focusNodes[this] ??= FocusNode();
  }

  void goToSearchResult(dynamic result, Book book) {
    final isEpub = book.filePath.toLowerCase().endsWith('.epub');
    if (isEpub) {
      final idx = result.pageIndex as int;
      if (idx != epubState.currentChapterIndex) {
        ref.read(epubReaderNotifierProvider.notifier).updateChapterIndex(idx);
        pageController?.jumpToPage(idx);
      }
      if (result.scrollProgress != null) {
        initialScrollProgress = result.scrollProgress as double;
      }
    } else {
      final page = (result.pageIndex as int) + 1;
      pdfController.goToPage(pageNumber: page, anchor: PdfPageAnchor.top);
    }
    ref.read(searchNotifierProvider.notifier).toggleCollapse();
  }
}

// ─── Navigation helpers ───────────────────────────────────────────────────
extension ReadingControllerNav on ReadingController {
  void jumpToPercent(double percent, Book book) {
    final isEpub = book.filePath.toLowerCase().endsWith('.epub');
    if (isEpub) {
      if (chapters.isEmpty || chapterLengths.isEmpty) return;
      final total = chapterLengths.fold(0, (s, l) => s + l);
      final target = percent * total;
      double acc = 0;
      int chIdx = 0;
      for (int i = 0; i < chapterLengths.length; i++) {
        if (acc + chapterLengths[i] >= target) { chIdx = i; break; }
        acc += chapterLengths[i];
        if (i == chapterLengths.length - 1) chIdx = i;
      }
      final remaining = target - acc;
      final chLen = chapterLengths[chIdx].toDouble();
      initialScrollProgress =
          chLen > 0 ? (remaining / chLen).clamp(0.0, 1.0) : 0.0;
      ref.read(epubReaderNotifierProvider.notifier)
          .updateChapterIndex(chIdx);
      pageController?.jumpToPage(chIdx);
    } else {
      final pdfState = ref.read(pdfReaderNotifierProvider);
      if (pdfState.totalPages <= 0) return;
      final page = (percent * (pdfState.totalPages - 1)).toInt() + 1;
      pdfController.goToPage(pageNumber: page, anchor: PdfPageAnchor.top);
    }
  }

  void jumpToHighlight(dynamic h, Book book) {
    final isEpub = book.filePath.toLowerCase().endsWith('.epub');
    if (isEpub) {
      final pos = h.position as String;
      if (pos.contains(':')) {
        final parts = pos.split(':');
        final idx = int.tryParse(parts[0]) ?? h.chapterIndex;
        final progress = double.tryParse(parts.last) ?? 0.0;
        initialScrollProgress = progress;
        ref.read(epubReaderNotifierProvider.notifier)
            .updateChapterIndex(idx);
        pageController?.jumpToPage(idx);
      }
    } else {
      pdfController.goToPage(
          pageNumber: h.chapterIndex + 1, anchor: PdfPageAnchor.top);
    }
  }

  void jumpToBookmark(Bookmark bm, Book book) {
    final isEpub = book.filePath.toLowerCase().endsWith('.epub');
    if (isEpub) {
      if (bm.position.contains(':')) {
        final parts = bm.position.split(':');
        final idx = int.tryParse(parts[0]) ?? 0;
        final progress = double.tryParse(parts[1]) ?? 0.0;
        initialScrollProgress = progress;
        ref.read(epubReaderNotifierProvider.notifier)
            .updateChapterIndex(idx);
        pageController?.animateToPage(idx,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic);
      } else {
        final idx = int.tryParse(bm.position) ?? 0;
        ref.read(epubReaderNotifierProvider.notifier)
            .updateChapterIndex(idx);
        pageController?.animateToPage(idx,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic);
      }
    } else {
      final page = int.tryParse(bm.position) ?? 1;
      pdfController.goToPage(pageNumber: page, anchor: PdfPageAnchor.top);
    }
  }
}
