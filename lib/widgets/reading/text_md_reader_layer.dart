import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import '../../models/book_model.dart';
import '../../models/markdown_outline_node.dart';
import '../../models/reader_settings_model.dart';
import 'markdown/md_reader_layer.dart';
import 'txt/txt_reader_layer.dart';

/// Slim router — delegates to [TxtReaderLayer] for .txt files
/// or [MdReaderLayer] for .md files.
/// Contains NO rendering logic of its own.
class TextMdReaderLayer extends StatefulWidget {
  final Book book;
  final ReaderSettings settings;
  final ValueNotifier<double> scrollProgressNotifier;
  final ValueNotifier<double> autoScrollSpeedNotifier;
  final VoidCallback onToggleControls;
  final VoidCallback onInteraction;
  final Function(
    List<MarkdownOutlineNode> flat,
    List<MarkdownOutlineNode> tree,
  )?
  onLoaded;
  final Function(MarkdownOutlineNode node)? onActiveHeadingChanged;

  const TextMdReaderLayer({
    super.key,
    required this.book,
    required this.settings,
    required this.scrollProgressNotifier,
    required this.autoScrollSpeedNotifier,
    required this.onToggleControls,
    required this.onInteraction,
    this.onLoaded,
    this.onActiveHeadingChanged,
  });

  @override
  State<TextMdReaderLayer> createState() => TextMdReaderLayerState();
}

class TextMdReaderLayerState extends State<TextMdReaderLayer> {
  final GlobalKey<MdReaderLayerState> _mdKey = GlobalKey<MdReaderLayerState>();
  final GlobalKey<TxtReaderLayerState> _txtKey =
      GlobalKey<TxtReaderLayerState>();

  bool get _isMarkdown =>
      p.extension(widget.book.filePath).toLowerCase() == '.md';

  // ── Public facade API ──────────────────────────────────────────────────────

  void jumpToHeading(String elementId) {
    _mdKey.currentState?.jumpToHeading(elementId);
  }

  void searchInDocument(
    String query, {
    bool caseSensitive = false,
    bool regex = false,
  }) {
    _mdKey.currentState?.searchInDocument(
      query,
      caseSensitive: caseSensitive,
      regex: regex,
    );
  }

  void navigateSearchMatch(int direction) {
    _mdKey.currentState?.navigateSearchMatch(direction);
  }

  void clearSearch() {
    _mdKey.currentState?.clearSearch();
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (_isMarkdown) {
      return MdReaderLayer(
        key: _mdKey,
        book: widget.book,
        settings: widget.settings,
        scrollProgressNotifier: widget.scrollProgressNotifier,
        autoScrollSpeedNotifier: widget.autoScrollSpeedNotifier,
        onToggleControls: widget.onToggleControls,
        onInteraction: widget.onInteraction,
        onLoaded: widget.onLoaded,
        onActiveHeadingChanged: widget.onActiveHeadingChanged,
      );
    }

    return TxtReaderLayer(
      key: _txtKey,
      book: widget.book,
      settings: widget.settings,
      scrollProgressNotifier: widget.scrollProgressNotifier,
      autoScrollSpeedNotifier: widget.autoScrollSpeedNotifier,
      onToggleControls: widget.onToggleControls,
      onInteraction: widget.onInteraction,
    );
  }
}
