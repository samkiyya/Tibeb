// features/reader/screens/reading_screen.dart
//
// Refactored ReadingScreen — the god class is gone.
// State is split across focused providers:
//   epubReaderNotifierProvider   — chapter/scroll position
//   pdfReaderNotifierProvider    — PDF page state
//   audioNotifierProvider        — playback (AudioNotifier)
//   searchNotifierProvider       — in-book search
//   annotationNotifierProvider   — highlights + bookmarks
//   readerSettingsProvider       — display preferences

import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tibeb/shared/models/book_model.dart';
import 'package:tibeb/shared/models/reader_settings_model.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../features/reader/providers/reader_provider.dart';
import '../../../features/reader/providers/audio_provider.dart';
import '../../../widgets/reading/epub_view.dart';
import '../../../widgets/reading/pdf_view.dart';
import '../../../widgets/reading/reading_header.dart';
import '../../../widgets/reading/reading_footer.dart';
import '../../../widgets/reading/reading_bottom_controls.dart';
import '../../../widgets/reading/play_pause_button.dart';
import '../../../components/display_settings_sheet.dart';
import '../../../utils/tutorial_helper.dart';
import '../controllers/reading_controller.dart';
import '../widgets/audio/reader_audio_adapter.dart';
import '../widgets/reader_nav_sheet.dart';

class ReadingScreen extends ConsumerStatefulWidget {
  final Book? book;
  const ReadingScreen({super.key, this.book});

  @override
  ConsumerState<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends ConsumerState<ReadingScreen>
    with TickerProviderStateMixin {
  late final ReadingController _ctrl;

  // Pure UI state
  final ValueNotifier<bool> _showControls = ValueNotifier(true);
  final ValueNotifier<String> _clock = ValueNotifier('');
  Timer? _clockTimer;
  int _battery = 100;
  final Battery _batteryPlugin = Battery();
  StreamSubscription<BatteryState>? _batterySub;
  bool _navOpen = false;
  bool _audioExpanded = false;
  bool _landscape = false;

  // Tutorial keys
  final _tocKey = GlobalKey();
  final _searchKey = GlobalKey();
  final _lockKey = GlobalKey();
  final _audioKey = GlobalKey();
  final _scrollKey = GlobalKey();
  final _displayKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _ctrl = ReadingController(ref: ref, vsync: this);

    final book = widget.book ?? ref.read(currentlyReadingProvider);
    if (book != null) _ctrl.initialize(book);

    _tickClock();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) => _tickClock());
    _initBattery();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(libraryNotifierProvider.notifier).setReadingActive(true);
      _checkTutorial();
    });
  }

  void _tickClock() {
    final n = DateTime.now();
    final s =
        '${n.hour.toString().padLeft(2, '0')}:${n.minute.toString().padLeft(2, '0')}';
    if (_clock.value != s) _clock.value = s;
  }

  Future<void> _initBattery() async {
    try {
      final lvl = await _batteryPlugin.batteryLevel;
      if (mounted) setState(() => _battery = lvl);
    } catch (_) {}
    _batterySub = _batteryPlugin.onBatteryStateChanged.listen((_) async {
      final lvl = await _batteryPlugin.batteryLevel;
      if (mounted) setState(() => _battery = lvl);
    });
  }

  @override
  void deactivate() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Future.microtask(() {
      if (mounted) {
        ref.read(libraryNotifierProvider.notifier).setReadingActive(false);
      }
    });
    super.deactivate();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _clockTimer?.cancel();
    _showControls.dispose();
    _clock.dispose();
    _batterySub?.cancel();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void _toggleControls() {
    _showControls.value = !_showControls.value;
    SystemChrome.setEnabledSystemUIMode(
      _showControls.value
          ? SystemUiMode.edgeToEdge
          : SystemUiMode.immersiveSticky,
    );
  }

  void _setOrientation(bool landscape) {
    setState(() => _landscape = landscape);
    SystemChrome.setPreferredOrientations(landscape
        ? [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]
        : [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  Future<void> _checkTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('is_first_launch') ?? true) return;
    if (prefs.getBool('is_first_launch_reading') ?? true) {
      Future.delayed(
        const Duration(milliseconds: 500),
        () { if (mounted) _showTutorial(); },
      );
    }
  }

  void _showTutorial() {
    final book = ref.read(currentlyReadingProvider);
    if (book == null) return;
    final isPdf = book.filePath.toLowerCase().endsWith('.pdf');
    TutorialHelper.showTutorial(
      context: context,
      targets: [
        TutorialHelper.createTarget(
            identify: 'toc', keyTarget: _tocKey,
            title: 'Navigation',
            description: 'TOC, bookmarks, and highlights.',
            contentAlign: ContentAlign.top),
        TutorialHelper.createTarget(
            identify: 'search', keyTarget: _searchKey,
            title: 'Search',
            description: 'Find any phrase in this book.',
            contentAlign: ContentAlign.bottom),
        if (isPdf)
          TutorialHelper.createTarget(
              identify: 'lock', keyTarget: _lockKey,
              title: 'Scroll Lock',
              description: 'Lock horizontal scrolling or zoom.',
              contentAlign: ContentAlign.bottom),
        TutorialHelper.createTarget(
            identify: 'audio', keyTarget: _audioKey,
            title: 'Audiobook',
            description: 'Attach audio files and listen while reading.',
            contentAlign: ContentAlign.top),
        TutorialHelper.createTarget(
            identify: 'scroll', keyTarget: _scrollKey,
            title: 'Auto-Scroll',
            description: 'Hands-free scrolling at adjustable speed.',
            contentAlign: ContentAlign.top),
        TutorialHelper.createTarget(
            identify: 'display', keyTarget: _displayKey,
            title: 'Display',
            description: 'Fonts, themes, margins.',
            contentAlign: ContentAlign.top),
      ],
      onFinish: () => SharedPreferences.getInstance()
          .then((p) => p.setBool('is_first_launch_reading', false)),
      onSkip: () {
        SharedPreferences.getInstance()
            .then((p) => p.setBool('is_first_launch_reading', false));
        return true;
      },
    );
  }

  // ─── Nav sheet ────────────────────────────────────────────────────────────

  void _openNavSheet(Book book, ReaderSettings settings) {
    if (_navOpen) { Navigator.pop(context); return; }
    setState(() => _navOpen = true);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ReaderNavSheet(
        book: book,
        controller: _ctrl,
        readerSettings: settings,
        onExport: () => _exportMarkdown(book),
      ),
    ).then((_) => setState(() => _navOpen = false));
  }

  // ─── Export ───────────────────────────────────────────────────────────────

  Future<void> _exportMarkdown(Book book) async {
    final ann = ref.read(annotationNotifierProvider);
    final vocab = await ref
        .read(libraryNotifierProvider.notifier)
        .getVocabularyForBook(book.id!);
    final buf = StringBuffer()
      ..writeln('# ${book.title}')
      ..writeln('*Exported with Tibeb — ${DateTime.now().year}*\n');
    if (book.author.isNotEmpty) buf.writeln('**Author:** ${book.author}\n');
    if (ann.bookmarks.isNotEmpty) {
      buf.writeln('## Bookmarks');
      for (final b in ann.bookmarks) {
        buf.writeln('- ${b.title} (${(b.progress * 100).toStringAsFixed(1)}%)');
      }
      buf.writeln();
    }
    buf.writeln('## Highlights & Notes');
    for (final h in ann.highlights) {
      buf.writeln('> ${h.text}\n');
      if (h.note?.isNotEmpty == true) buf.writeln('**Note:** ${h.note}\n');
      buf.writeln('---');
    }
    if (vocab.isNotEmpty) {
      buf.writeln('\n## Vocabulary');
      buf.writeln(vocab.map((v) => v.word).join(', '));
    }
    try {
      final dir = await getTemporaryDirectory();
      final fname =
          '${book.title.replaceAll(RegExp(r'[^\w\s-]'), '')}_annotations.md';
      final file = io.File(p.join(dir.path, fname));
      await file.writeAsString(buf.toString());
      await SharePlus.instance.share(ShareParams(
        files: [XFile(file.path)],
        subject: '${book.title} - Annotations',
      ));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Export failed: $e')));
      }
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final book = ref.watch(currentlyReadingProvider) ?? widget.book;
    final settings = ref.watch(readerSettingsProvider);
    final audioState = ref.watch(audioNotifierProvider);
    final annotations = ref.watch(annotationNotifierProvider);
    final searchState = ref.watch(searchNotifierProvider);
    final audioNotifier = ref.read(audioNotifierProvider.notifier);

    if (book == null) {
      return Scaffold(
        backgroundColor: settings.backgroundColor,
        body: Center(
          child: Text('No book selected',
              style: TextStyle(color: settings.secondaryTextColor)),
        ),
      );
    }

    final isEpub = book.filePath.toLowerCase().endsWith('.epub');
    final audioTracks = book.audioTracks.isEmpty && book.audioPath != null
        ? [AudioTrack(path: book.audioPath!, title: p.basename(book.audioPath!))]
        : book.audioTracks;
    final hasAudio = audioTracks.isNotEmpty;

    return Scaffold(
      backgroundColor: settings.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) _ctrl.syncFinalProgress(book);
        },
        child: Column(children: [
          Expanded(
            child: Stack(children: [
              // ── Book content ───────────────────────────────────────────
              if (isEpub)
                _EpubLayer(
                  ctrl: _ctrl,
                  showControls: _showControls,
                  onToggle: _toggleControls,
                  annotations: annotations,
                  searchQuery: searchState.isActive ? searchState.query : null,
                )
              else
                _PdfLayer(
                  ctrl: _ctrl,
                  showControls: _showControls,
                  onToggle: _toggleControls,
                  annotations: annotations,
                ),

              // ── Animated header ────────────────────────────────────────
              ValueListenableBuilder<bool>(
                valueListenable: _showControls,
                builder: (_, show, _) => AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  top: show ? 0 : -200,
                  left: 0, right: 0,
                  child: ValueListenableBuilder<String>(
                    valueListenable: _clock,
                    builder: (_, time, _) {
                      final epubState = ref.watch(epubReaderNotifierProvider);
                      final pdfState = ref.watch(pdfReaderNotifierProvider);
                      return ReadingHeader(
                        book: book,
                        settings: settings,
                        currentChapter: isEpub
                            ? (_ctrl.chapters.isNotEmpty &&
                                    epubState.currentChapterIndex <
                                        _ctrl.chapters.length
                                ? _ctrl.chapters[epubState.currentChapterIndex]
                                        .Title ??
                                    'Chapter ${epubState.currentChapterIndex + 1}'
                                : '')
                            : pdfState.currentChapterTitle,
                        pageInfo: isEpub
                            ? Text(
                                '${(_ctrl.epubState.overallProgress * 100).toStringAsFixed(0)}%',
                                style: TextStyle(
                                    color: settings.textColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500),
                              )
                            : Text(
                                '${pdfState.currentPage + 1} / ${pdfState.totalPages}',
                                style: TextStyle(
                                    color: settings.textColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500),
                              ),
                        isSearching: searchState.isActive,
                        isSearchLoading: searchState.isLoading,
                        isSearchResultsCollapsed: searchState.isCollapsed,
                        searchResultsCount: searchState.results.length,
                        searchController: _ctrl.searchTextController,
                        searchFocusNode: _ctrl.searchFocusNode,
                        onBackPressed: () {
                          _ctrl.syncFinalProgress(book);
                          Navigator.of(context).pop();
                        },
                        onToggleSearch: () {
                          ref.read(searchNotifierProvider.notifier).open();
                          _showControls.value = true;
                          _ctrl.searchFocusNode.requestFocus();
                        },
                        onClearSearch: () {
                          ref.read(searchNotifierProvider.notifier).clear();
                          _ctrl.searchTextController.clear();
                        },
                        onSearchSubmitted: (q) => _ctrl.search(q, book),
                        onToggleSearchResultsCollapse: () => ref
                            .read(searchNotifierProvider.notifier)
                            .toggleCollapse(),
                        onToggleLock: () => ref
                            .read(readerSettingsProvider.notifier)
                            .toggleLockState(),
                        searchKey: _searchKey,
                        lockKey: _lockKey,
                        searchResultsOverlay: searchState.results.isNotEmpty
                            ? _SearchResults(
                                results: searchState.results,
                                settings: settings,
                                ctrl: _ctrl,
                                book: book,
                              )
                            : null,
                      );
                    },
                  ),
                ),
              ),

              // ── Animated bottom controls ───────────────────────────────
              ValueListenableBuilder<bool>(
                valueListenable: _showControls,
                builder: (_, show, _) => AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  bottom: show ? 0 : -800,
                  left: 0, right: 0,
                  child: ReadingBottomControls(
                    book: book,
                    settings: settings,
                    isAudioControlsExpanded: _audioExpanded,
                    isNavigationSheetOpen: _navOpen,
                    isAutoScrolling: _ctrl.isAutoScrolling,
                    isBookmarked: _ctrl.isCurrentPositionBookmarked(
                        annotations.bookmarks),
                    playbackSpeed: audioState.playbackSpeed,
                    isOrientationLandscape: _landscape,
                    tocKey: _tocKey,
                    audioKey: _audioKey,
                    autoScrollKey: _scrollKey,
                    displaySettingsKey: _displayKey,
                    onToggleAudioControls: () =>
                        setState(() => _audioExpanded = !_audioExpanded),
                    onPickAudio: () => _ctrl.pickAudio(book),
                    onShowNavigationSheet: () =>
                        _openNavSheet(book, settings),
                    onToggleBookmark: () =>
                        _ctrl.toggleBookmark(book, context),
                    onToggleAutoScroll: () =>
                        _ctrl.toggleAutoScroll(settings.autoScrollSpeed),
                    onToggleOrientation: () =>
                        _setOrientation(!_landscape),
                    onShowDisplaySettings: () =>
                        showDisplaySettingsSheet(context),
                    onIncrementPlaybackSpeed:
                        audioNotifier.incrementSpeed,
                    onSkip: audioNotifier.skip,
                    onNextTrack: audioNotifier.hasNext
                        ? audioNotifier.nextTrack
                        : null,
                    onPrevTrack: audioNotifier.hasPrevious
                        ? audioNotifier.prevTrack
                        : null,
                    onShowTrackList: hasAudio
                        ? () => _ctrl.showTrackListSheet(context, book)
                        : null,
                    audioSection: hasAudio
                        ? ReaderAudioAdapter(
                            settings: settings,
                            audioState: audioState,
                            audioTracks: audioTracks,
                            onSeekEnd: audioNotifier.seekToPosition,
                            isOrientationLandscape: _landscape,
                          )
                        : null,
                    playPauseButton: PlayPauseButton(
                      isPlaying: audioState.isPlaying,
                      onTap: audioNotifier.togglePlayPause,
                    ),
                  ),
                ),
              ),
            ]),
          ),

          // ── Footer ────────────────────────────────────────────────────
          ValueListenableBuilder<String>(
            valueListenable: _clock,
            builder: (_, time, _) {
              final epubState = ref.watch(epubReaderNotifierProvider);
              final pdfState = ref.watch(pdfReaderNotifierProvider);
              return ReadingFooter(
                book: book,
                settings: settings,
                currentTime: time,
                currentChapter: isEpub
                    ? (_ctrl.chapters.isNotEmpty &&
                            epubState.currentChapterIndex <
                                _ctrl.chapters.length
                        ? _ctrl.chapters[epubState.currentChapterIndex]
                                .Title ??
                            'Chapter ${epubState.currentChapterIndex + 1}'
                        : '')
                    : pdfState.currentChapterTitle,
                batteryLevel: _battery,
                scrollProgressNotifier: _ctrl.scrollProgress,
                totalChapters: _ctrl.chapters.length,
                currentChapterIndex: epubState.currentChapterIndex,
                chapterLengths: _ctrl.chapterLengths,
              );
            },
          ),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Focused layer widgets — no business logic, only widget composition
// ─────────────────────────────────────────────────────────────────────────────

class _EpubLayer extends ConsumerWidget {
  final ReadingController ctrl;
  final ValueNotifier<bool> showControls;
  final VoidCallback onToggle;
  final AnnotationState annotations;
  final String? searchQuery;

  const _EpubLayer({
    required this.ctrl,
    required this.showControls,
    required this.onToggle,
    required this.annotations,
    this.searchQuery,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final book = ref.watch(currentlyReadingProvider);
    final settings = ref.watch(readerSettingsProvider);
    if (book == null) return const SizedBox.shrink();

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (e) => ctrl.recordPointerDown(e.position),
      onPointerUp: (e) {
        if (ctrl.isTap(e.position)) onToggle();
        ctrl.clearPointerDown();
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: showControls,
        builder: (_, show, _) => ReadingEpubView(
          book: book,
          settings: settings,
          chapters: ctrl.chapters,
          epubBook: ctrl.epubBook,
          pageController: ctrl.pageController,
          currentChapterIndex: ctrl.epubState.currentChapterIndex,
          shouldJumpToBottom: ctrl.shouldJumpToBottom,
          initialScrollProgress: ctrl.initialScrollProgress,
          onJumpedToBottom: ctrl.onJumpedToBottom,
          onJumpedToPosition: ctrl.onJumpedToPosition,
          pullDistanceNotifier: ctrl.pullDistance,
          isPullingDownNotifier: ctrl.isPullingDown,
          scrollProgressNotifier: ctrl.scrollProgress,
          autoScrollSpeedNotifier: ctrl.autoScrollSpeed,
          showControls: show,
          onPageChanged: (i) => ctrl.handleEpubPageChange(i, book),
          onHideControls: () { if (showControls.value) onToggle(); },
          onToggleControls: onToggle,
          onInteraction: ctrl.recordInteraction,
          highlights: annotations.highlights,
          onHighlight: (h) =>
              ref.read(annotationNotifierProvider.notifier).addHighlight(h),
          onDeleteHighlight: (id) =>
              ref.read(annotationNotifierProvider.notifier).deleteHighlight(id),
          onLookup: (w) => ctrl.lookupWord(w, book),
          searchQuery: searchQuery,
        ),
      ),
    );
  }
}

class _PdfLayer extends ConsumerWidget {
  final ReadingController ctrl;
  final ValueNotifier<bool> showControls;
  final VoidCallback onToggle;
  final AnnotationState annotations;

  const _PdfLayer({
    required this.ctrl,
    required this.showControls,
    required this.onToggle,
    required this.annotations,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final book = ref.watch(currentlyReadingProvider);
    final settings = ref.watch(readerSettingsProvider);
    if (book == null) return const SizedBox.shrink();

    return ReadingPdfView(
      key: ValueKey('pdf_${book.id}'),
      book: book,
      settings: settings,
      controller: ctrl.pdfController,
      searcher: ctrl.pdfSearcher,
      highlights: annotations.highlights,
      onHighlight: (h) =>
          ref.read(annotationNotifierProvider.notifier).addHighlight(h),
      onDeleteHighlight: (id) =>
          ref.read(annotationNotifierProvider.notifier).deleteHighlight(id),
      onViewerReady: (doc, c) =>
          ctrl.onPdfViewerReady(doc, c, book),
      onPageChanged: (page) => ctrl.handlePdfPageChange(page, book),
      onInteraction: ctrl.recordInteraction,
      onHideControls: onToggle,
      showControls: showControls.value,
      scrollProgressNotifier: ctrl.scrollProgress,
    );
  }
}

class _SearchResults extends StatelessWidget {
  final List results;
  final ReaderSettings settings;
  final ReadingController ctrl;
  final Book book;

  const _SearchResults({
    required this.results,
    required this.settings,
    required this.ctrl,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 240),
      color: settings.backgroundColor,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: results.length,
        itemBuilder: (_, i) {
          final r = results[i] as dynamic;
          return ListTile(
            dense: true,
            title: Text(r.title ?? '',
                style: TextStyle(
                    color: settings.textColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
            subtitle: Text(r.snippet ?? '',
                style: TextStyle(
                    color: settings.secondaryTextColor, fontSize: 11),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            onTap: () => ctrl.goToSearchResult(r, book),
          );
        },
      ),
    );
  }
}
