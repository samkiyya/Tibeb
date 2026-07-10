import 'package:flutter/material.dart';
import 'package:epub_view/epub_view.dart' show EpubChapter;
import 'package:pdfrx/pdfrx.dart' show PdfOutlineNode;
import '../../../models/book_model.dart';
import '../../../core/theme/theme.dart';
import '../../../l10n/app_localizations.dart';
import 'chapter_tree_item.dart';

class ChaptersTab extends StatefulWidget {
  final Book book;
  final List<EpubChapter> chapters;
  final List<EpubChapter> tocChapters;
  final List<PdfOutlineNode> pdfOutline;
  final List<PdfOutlineNode> tocPdfOutline;
  final int currentChapterIndex;
  final PdfOutlineNode? currentPdfNode;
  final Function(int) onChapterTap;
  final Function(PdfOutlineNode) onPdfOutlineTap;
  final void Function(int)? onJumpToPage;
  final void Function(double)? onJumpToPercent;
  final int totalPages;
  final bool focusJump;

  const ChaptersTab({
    super.key,
    required this.book,
    required this.chapters,
    required this.tocChapters,
    required this.pdfOutline,
    required this.tocPdfOutline,
    required this.currentChapterIndex,
    this.currentPdfNode,
    required this.onChapterTap,
    required this.onPdfOutlineTap,
    this.onJumpToPage,
    this.onJumpToPercent,
    required this.totalPages,
    this.focusJump = false,
  });

  @override
  State<ChaptersTab> createState() => _ChaptersTabState();
}

class _ChaptersTabState extends State<ChaptersTab> {
  final TextEditingController _jumpController = TextEditingController();
  final FocusNode _jumpFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.focusJump) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _jumpFocusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _jumpController.dispose();
    _jumpFocusNode.dispose();
    super.dispose();
  }

  void _handleJump() {
    final value = _jumpController.text;
    final numValue = double.tryParse(value);
    if (numValue != null) {
      final isEpub = widget.book.filePath.toLowerCase().endsWith('.epub');
      if (isEpub) {
        if (widget.onJumpToPercent != null) {
          widget.onJumpToPercent!(numValue / 100.0);
        }
      } else {
        if (widget.onJumpToPage != null) {
          widget.onJumpToPage!(numValue.toInt());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildJumpToSection(),
        Expanded(child: _buildChaptersList()),
      ],
    );
  }

  Widget _buildJumpToSection() {
    final isEpub = widget.book.filePath.toLowerCase().endsWith('.epub');
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _jumpController,
              focusNode: _jumpFocusNode,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                hintText: isEpub
                    ? l10n.jumpToPercent
                    : '${l10n.jumpToPage}${widget.totalPages > 0 ? " (1 - ${widget.totalPages})" : ""}',
                hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                suffixText: isEpub
                    ? '%'
                    : (widget.totalPages > 0 ? "/ ${widget.totalPages}" : null),
                suffixStyle: const TextStyle(color: Colors.white38),
              ),
              onSubmitted: (value) => _handleJump(),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: context.tibpiColors.accent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: _handleJump,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: context.tibpiColors.accent,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChaptersList() {
    if (widget.book.filePath.toLowerCase().endsWith('.epub')) {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widget.tocChapters.map((chapter) {
            return ChapterTreeItem(
              chapter: chapter,
              depth: 0,
              currentChapterIndex: widget.currentChapterIndex,
              flattenedChapters: widget.chapters,
              onTap: widget.onChapterTap,
            );
          }).toList(),
        ),
      );
    } else {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widget.tocPdfOutline.map((node) {
            return PdfTreeItem(
              node: node,
              depth: 0,
              onTap: widget.onPdfOutlineTap,
              currentPdfNode: widget.currentPdfNode,
              flattenedOutline: widget.pdfOutline,
            );
          }).toList(),
        ),
      );
    }
  }
}
