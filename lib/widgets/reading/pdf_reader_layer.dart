import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import '../../models/book_model.dart';
import '../../models/reader_settings_model.dart';
import '../../models/highlight_model.dart';
import 'pdf_view.dart';

/// Encapsulates all PDF viewer controller lifecycles, outline parsings, and layout compositions.
class PdfReaderLayer extends StatefulWidget {
  final Book book;
  final ReaderSettings settings;
  final List<Highlight> highlights;
  final ValueNotifier<double> scrollProgressNotifier;
  final bool showControls;

  final VoidCallback onToggleControls;
  final VoidCallback onInteraction;
  final Function(Highlight) onHighlight;
  final Function(int) onDeleteHighlight;

  final Function(List<PdfOutlineNode> outline, int totalPages, int initialPage)
  onLoaded;
  final Function(int page, int total) onPageChanged;

  const PdfReaderLayer({
    super.key,
    required this.book,
    required this.settings,
    required this.highlights,
    required this.scrollProgressNotifier,
    required this.showControls,
    required this.onToggleControls,
    required this.onInteraction,
    required this.onHighlight,
    required this.onDeleteHighlight,
    required this.onLoaded,
    required this.onPageChanged,
  });

  @override
  State<PdfReaderLayer> createState() => PdfReaderLayerState();
}

class PdfReaderLayerState extends State<PdfReaderLayer> {
  PdfViewerController? _pdfController;
  PdfTextSearcher? _pdfSearcher;

  int _pdfPages = 0;
  bool _isPdfReady = false;

  PdfViewerController get pdfController => _pdfController!;
  PdfTextSearcher? get pdfSearcher => _pdfSearcher;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfViewerController();
  }

  @override
  void dispose() {
    _pdfSearcher?.dispose();
    super.dispose();
  }

  void jumpToPage(int page) {
    if (!_isPdfReady || _pdfPages <= 0) return;
    _pdfController?.goToPage(pageNumber: page, anchor: PdfPageAnchor.top);
  }

  void goToMatch(PdfPageTextRange match) {
    _pdfSearcher?.goToMatch(match);
  }

  @override
  Widget build(BuildContext context) {
    if (_pdfController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ReadingPdfView(
      key: ValueKey('pdf_${widget.book.id}'),
      book: widget.book,
      settings: widget.settings,
      controller: _pdfController!,
      searcher: _pdfSearcher,
      highlights: widget.highlights,
      onHighlight: widget.onHighlight,
      onDeleteHighlight: widget.onDeleteHighlight,
      onViewerReady: (document, controller) async {
        _pdfSearcher = PdfTextSearcher(controller);
        _pdfSearcher!.addListener(() => setState(() {}));
        final outline = await document.loadOutline();

        if (mounted) {
          setState(() {
            _pdfPages = document.pages.length;
            _isPdfReady = true;
          });

          final initialPage =
              (widget.book.progress * (document.pages.length - 1)).toInt();
          widget.onLoaded(outline, document.pages.length, initialPage);

          // Scroll the viewer to the saved page on first open (Bug C fix)
          if (initialPage > 0) {
            _pdfController?.goToPage(
              pageNumber: initialPage + 1,
              anchor: PdfPageAnchor.top,
            );
          }
        }
      },
      onPageChanged: (pageNumber) {
        widget.onInteraction();
        if (pageNumber != null && _isPdfReady) {
          widget.onPageChanged(pageNumber - 1, _pdfPages);
        }
      },
      onInteraction: widget.onInteraction,
      onHideControls: widget.onToggleControls,
      showControls: widget.showControls,
      scrollProgressNotifier: widget.scrollProgressNotifier,
    );
  }
}
