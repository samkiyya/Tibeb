import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:epub_view/epub_view.dart';
import '../../models/book_model.dart';
import '../../models/reader_settings_model.dart';
import '../../models/highlight_model.dart';
import 'epub_view.dart';

/// Encapsulates all EPUB controller lifecycles, gesture listenings, and layout compositions.
class EpubReaderLayer extends StatefulWidget {
  final Book book;
  final ReaderSettings settings;
  final List<Highlight> highlights;
  final ValueNotifier<double> pullDistanceNotifier;
  final ValueNotifier<bool> isPullingDownNotifier;
  final ValueNotifier<double> scrollProgressNotifier;
  final ValueNotifier<double> autoScrollSpeedNotifier;
  final ValueNotifier<bool> showControlsNotifier;
  final String? activeSearchQuery;

  final VoidCallback onToggleControls;
  final VoidCallback onInteraction;
  final Function(Highlight) onHighlight;
  final Function(int) onDeleteHighlight;
  final Function(String) onLookup;

  final Function(List<EpubChapter> chapters, EpubBook epubBook,
      double initialScrollProgress) onLoaded;
  final Function(int index) onPageChanged;

  final bool shouldJumpToBottom;
  final double initialScrollProgress;
  final VoidCallback onJumpedToBottom;
  final VoidCallback onJumpedToPosition;

  const EpubReaderLayer({
    super.key,
    required this.book,
    required this.settings,
    required this.highlights,
    required this.pullDistanceNotifier,
    required this.isPullingDownNotifier,
    required this.scrollProgressNotifier,
    required this.autoScrollSpeedNotifier,
    required this.showControlsNotifier,
    required this.activeSearchQuery,
    required this.onToggleControls,
    required this.onInteraction,
    required this.onHighlight,
    required this.onDeleteHighlight,
    required this.onLookup,
    required this.onLoaded,
    required this.onPageChanged,
    required this.shouldJumpToBottom,
    required this.initialScrollProgress,
    required this.onJumpedToBottom,
    required this.onJumpedToPosition,
  });

  @override
  State<EpubReaderLayer> createState() => EpubReaderLayerState();
}

class EpubReaderLayerState extends State<EpubReaderLayer> {
  EpubController? _epubController;
  EpubBook? _epubBook;
  PageController? _pageController;

  List<EpubChapter> _chapters = [];
  int _currentChapterIndex = 0;

  DateTime? _epubPointerDownTime;
  Offset? _epubPointerDownPosition;

  @override
  void initState() {
    super.initState();
    _initEpub();
  }

  @override
  void dispose() {
    _epubController?.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  void jumpToChapter(int index) {
    _pageController?.jumpToPage(index);
  }

  void jumpToCfi(String cfi) {
    _epubController?.gotoEpubCfi(cfi);
  }

  void _initEpub() {
    final controller = EpubController(
      document: EpubDocument.openFile(io.File(widget.book.filePath)),
      epubCfi: widget.book.lastPosition,
    );
    _epubController = controller;

    controller.document.then((document) {
      if (!mounted) return;
      final flattened = _flattenChapters(document.Chapters ?? []);
      final lengths = flattened.map((c) => c.HtmlContent?.length ?? 0).toList();
      final total = lengths.fold(0, (sum, len) => sum + len);

      int initialPage = 0;
      if (total > 0) {
        final double targetTotalProgress =
            widget.book.progress * total.toDouble();
        double accumulatedLength = 0.0;
        for (int i = 0; i < lengths.length; i++) {
          final double runningLen = lengths[i].toDouble();
          if (accumulatedLength + runningLen >= targetTotalProgress) {
            initialPage = i;
            break;
          }
          accumulatedLength += runningLen;
          if (i == lengths.length - 1) initialPage = i;
        }
      } else {
        double totalProgress = widget.book.progress * flattened.length;
        initialPage = totalProgress.floor().clamp(0, flattened.length - 1);
      }

      // Compute the intra-chapter scroll fraction so the screen can restore
      // the user's exact saved position within the starting chapter (Bug B fix).
      double initialScrollProgress = 0.0;
      if (total > 0) {
        final double targetTotalProgress =
            widget.book.progress * total.toDouble();
        double accumulatedLength = 0.0;
        for (int i = 0; i < initialPage; i++) {
          accumulatedLength += lengths[i].toDouble();
        }
        final double remaining = targetTotalProgress - accumulatedLength;
        final double chapterLen = lengths[initialPage].toDouble();
        initialScrollProgress =
            (chapterLen > 0 ? remaining / chapterLen : 0.0).clamp(0.0, 1.0);
      }

      setState(() {
        _epubBook = document;
        _chapters = flattened;
        _currentChapterIndex = initialPage;
        _pageController = PageController(initialPage: initialPage);
      });

      widget.onLoaded(_chapters, _epubBook!, initialScrollProgress);
    });
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

  @override
  Widget build(BuildContext context) {
    if (_epubBook == null || _pageController == null) {
      return const Center(child: CircularProgressIndicator());
    }

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
          widget.onToggleControls();
        }
        _epubPointerDownTime = null;
        _epubPointerDownPosition = null;
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: widget.showControlsNotifier,
        builder: (context, showControls, _) {
          return ReadingEpubView(
            book: widget.book,
            settings: widget.settings,
            chapters: _chapters,
            pageController: _pageController,
            currentChapterIndex: _currentChapterIndex,
            shouldJumpToBottom: widget.shouldJumpToBottom,
            initialScrollProgress: widget.initialScrollProgress,
            onJumpedToBottom: widget.onJumpedToBottom,
            onJumpedToPosition: widget.onJumpedToPosition,
            pullDistanceNotifier: widget.pullDistanceNotifier,
            isPullingDownNotifier: widget.isPullingDownNotifier,
            scrollProgressNotifier: widget.scrollProgressNotifier,
            autoScrollSpeedNotifier: widget.autoScrollSpeedNotifier,
            showControls: showControls,
            onPageChanged: (index) {
              setState(() => _currentChapterIndex = index);
              widget.onPageChanged(index);
            },
            onHideControls: () {
              if (widget.showControlsNotifier.value) {
                widget.onToggleControls();
              }
            },
            onToggleControls: widget.onToggleControls,
            onInteraction: widget.onInteraction,
            highlights: widget.highlights,
            onHighlight: widget.onHighlight,
            onDeleteHighlight: widget.onDeleteHighlight,
            onLookup: widget.onLookup,
            searchQuery: widget.activeSearchQuery,
            epubBook: _epubBook,
          );
        },
      ),
    );
  }
}
