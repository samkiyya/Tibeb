import 'package:flutter/material.dart';
import 'package:epub_view/epub_view.dart' show EpubChapter;
import 'package:pdfrx/pdfrx.dart' show PdfOutlineNode;
import '../../../models/book_model.dart';
import '../../../models/markdown_outline_node.dart';
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

  // Markdown outline
  final List<MarkdownOutlineNode> mdOutline;
  final MarkdownOutlineNode? currentMdNode;
  final void Function(MarkdownOutlineNode)? onMdOutlineTap;

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
    this.mdOutline = const [],
    this.currentMdNode,
    this.onMdOutlineTap,
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
    final lowerPath = widget.book.filePath.toLowerCase();
    final isTxtMd = lowerPath.endsWith('.txt') || lowerPath.endsWith('.md');
    return Column(
      children: [
        if (!isTxtMd) _buildJumpToSection(),
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
    final lowerPath = widget.book.filePath.toLowerCase();

    if (lowerPath.endsWith('.txt') || lowerPath.endsWith('.md')) {
      if (widget.mdOutline.isEmpty) {
        final l10n = AppLocalizations.of(context)!;
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.subject_rounded, size: 48, color: Colors.white24),
                const SizedBox(height: 12),
                Text(
                  l10n.noOutlineAvailable,
                  style: const TextStyle(color: Colors.white38, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widget.mdOutline.map((node) {
            return MdTreeItem(
              node: node,
              depth: 0,
              currentNode: widget.currentMdNode,
              onTap: widget.onMdOutlineTap,
            );
          }).toList(),
        ),
      );
    } else if (lowerPath.endsWith('.epub')) {
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

// ── Markdown heading tree item ───────────────────────────────────────────────

class MdTreeItem extends StatelessWidget {
  final MarkdownOutlineNode node;
  final int depth;
  final MarkdownOutlineNode? currentNode;
  final void Function(MarkdownOutlineNode)? onTap;

  const MdTreeItem({
    super.key,
    required this.node,
    required this.depth,
    this.currentNode,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCurrent = currentNode == node;
    // H1 = bold large, H2 = slightly inset, H3+ = smaller and more inset
    final fontSize = switch (node.level) {
      1 => 16.0,
      2 => 15.0,
      _ => 14.0,
    };
    final fontWeight = node.level == 1 ? FontWeight.bold : FontWeight.normal;
    final leftPad = 16.0 + (node.level - 1) * 14.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onTap?.call(node),
            child: Container(
              decoration: isCurrent
                  ? BoxDecoration(
                      color: context.tibpiColors.accent.withValues(alpha: 0.12),
                      border: Border(
                        left: BorderSide(
                          color: context.tibpiColors.accent,
                          width: 3,
                        ),
                      ),
                    )
                  : null,
              padding: EdgeInsets.only(
                left: leftPad,
                top: 10,
                bottom: 10,
                right: 12,
              ),
              child: Row(
                children: [
                  // Level indicator badge
                  Container(
                    width: 20,
                    height: 20,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? context.tibpiColors.accent
                          : Colors.white12,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'H${node.level}',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: isCurrent ? Colors.white : Colors.white54,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      node.title,
                      style: TextStyle(
                        color: isCurrent
                            ? context.tibpiColors.accent
                            : Colors.white,
                        fontWeight: fontWeight,
                        fontSize: fontSize,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Render children recursively
        ...node.children.map((child) {
          return MdTreeItem(
            node: child,
            depth: depth + 1,
            currentNode: currentNode,
            onTap: onTap,
          );
        }),
      ],
    );
  }
}
