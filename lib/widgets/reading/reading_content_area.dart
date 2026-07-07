import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../models/book_model.dart';
import '../../models/highlight_model.dart';
import '../../models/reader_settings_model.dart';
import '../../screens/reading/epub_reading_manager.dart';
import '../../screens/reading/pdf_reading_manager.dart';
import 'epub_reader_layer.dart';
import 'pdf_reader_layer.dart';

/// Encapsulates the EPUB and PDF content-area layers, keeping
/// reading_screen.dart free from verbose onLoaded/onPageChanged wiring.
class ReadingContentArea extends StatelessWidget {
  const ReadingContentArea({
    super.key,
    required this.book,
    required this.settings,
    required this.isEpub,
    required this.epubLayerKey,
    required this.pdfLayerKey,
    required this.highlights,
    required this.pullDistanceNotifier,
    required this.isPullingDownNotifier,
    required this.scrollProgressNotifier,
    required this.autoScrollSpeedNotifier,
    required this.showControlsNotifier,
    required this.activeSearchQuery,
    required this.epub,
    required this.pdf,
    required this.onToggleControls,
    required this.onInteraction,
    required this.onHighlight,
    required this.onDeleteHighlight,
    required this.onLookup,
    required this.onEpubLoaded,
    required this.onEpubPageChanged,
    required this.onPdfLoaded,
    required this.onPdfPageChanged,
    required this.onJumpedToBottom,
    required this.onJumpedToPosition,
  });

  final Book book;
  final ReaderSettings settings;
  final bool isEpub;
  final GlobalKey<EpubReaderLayerState> epubLayerKey;
  final GlobalKey<PdfReaderLayerState> pdfLayerKey;
  final List<Highlight> highlights;

  final ValueNotifier<double> pullDistanceNotifier;
  final ValueNotifier<bool> isPullingDownNotifier;
  final ValueNotifier<double> scrollProgressNotifier;
  final ValueNotifier<double> autoScrollSpeedNotifier;
  final ValueNotifier<bool> showControlsNotifier;
  final String? activeSearchQuery;

  final EpubReadingManager epub;
  final PdfReadingManager pdf;

  final VoidCallback onToggleControls;
  final VoidCallback onInteraction;
  final Function(Highlight) onHighlight;
  final Function(int) onDeleteHighlight;
  final Function(String) onLookup;

  final Function(
    List<EpubChapter> chapters,
    EpubBook epubBook,
    double initialScrollProgress,
  ) onEpubLoaded;
  final Function(int index) onEpubPageChanged;

  final Function(
    List<PdfOutlineNode> outline,
    int totalPages,
    int initialPage,
  ) onPdfLoaded;
  final Function(int page, int total) onPdfPageChanged;

  final VoidCallback onJumpedToBottom;
  final VoidCallback onJumpedToPosition;

  @override
  Widget build(BuildContext context) {
    if (isEpub) {
      return EpubReaderLayer(
        key: epubLayerKey,
        book: book,
        settings: settings,
        highlights: highlights,
        pullDistanceNotifier: pullDistanceNotifier,
        isPullingDownNotifier: isPullingDownNotifier,
        scrollProgressNotifier: scrollProgressNotifier,
        autoScrollSpeedNotifier: autoScrollSpeedNotifier,
        showControlsNotifier: showControlsNotifier,
        activeSearchQuery: activeSearchQuery,
        onToggleControls: onToggleControls,
        onInteraction: onInteraction,
        onHighlight: onHighlight,
        onDeleteHighlight: onDeleteHighlight,
        onLookup: onLookup,
        onLoaded: onEpubLoaded,
        onPageChanged: onEpubPageChanged,
        shouldJumpToBottom: epub.shouldJumpToBottom,
        initialScrollProgress: epub.initialScrollProgress,
        onJumpedToBottom: onJumpedToBottom,
        onJumpedToPosition: onJumpedToPosition,
      );
    }

    return PdfReaderLayer(
      key: pdfLayerKey,
      book: book,
      settings: settings,
      highlights: highlights,
      scrollProgressNotifier: scrollProgressNotifier,
      showControls: showControlsNotifier.value,
      onToggleControls: onToggleControls,
      onInteraction: onInteraction,
      onHighlight: onHighlight,
      onDeleteHighlight: onDeleteHighlight,
      onLoaded: onPdfLoaded,
      onPageChanged: onPdfPageChanged,
    );
  }
}
