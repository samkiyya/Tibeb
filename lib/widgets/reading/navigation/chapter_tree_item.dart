import 'package:flutter/material.dart';
import 'package:epub_view/epub_view.dart' show EpubChapter;
import 'package:pdfrx/pdfrx.dart' show PdfOutlineNode;
import 'package:tibeb/core/theme/theme.dart';

class ChapterTreeItem extends StatefulWidget {
  final EpubChapter chapter;
  final int depth;
  final int currentChapterIndex;
  final List<EpubChapter> flattenedChapters;
  final Function(int) onTap;

  const ChapterTreeItem({
    super.key,
    required this.chapter,
    required this.depth,
    required this.currentChapterIndex,
    required this.flattenedChapters,
    required this.onTap,
  });

  @override
  State<ChapterTreeItem> createState() => _ChapterTreeItemState();
}

class _ChapterTreeItemState extends State<ChapterTreeItem> {
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final index = widget.flattenedChapters.indexOf(widget.chapter);
        if (index == widget.currentChapterIndex) {
          Scrollable.ensureVisible(
            context,
            alignment: 0.5,
            duration: const Duration(milliseconds: 300),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasSubChapters =
        widget.chapter.SubChapters != null &&
        widget.chapter.SubChapters!.isNotEmpty;
    final index = widget.flattenedChapters.indexOf(widget.chapter);
    final isCurrent = widget.currentChapterIndex == index;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (index != -1) {
                widget.onTap(index);
              }
            },
            child: Padding(
              padding: EdgeInsets.only(
                left: 16.0 + (widget.depth * 16.0),
                top: 12,
                bottom: 12,
                right: 8,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.chapter.Title?.trim() ?? 'Chapter',
                      style: TextStyle(
                        color: isCurrent
                            ? context.tibpiColors.accent
                            : Colors.white,
                        fontWeight: isCurrent
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  if (hasSubChapters)
                    IconButton(
                      icon: Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: Colors.white54,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      style: const ButtonStyle(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (_isExpanded && hasSubChapters)
          Column(
            children: widget.chapter.SubChapters!.map((subChapter) {
              return ChapterTreeItem(
                chapter: subChapter,
                depth: widget.depth + 1,
                currentChapterIndex: widget.currentChapterIndex,
                flattenedChapters: widget.flattenedChapters,
                onTap: widget.onTap,
              );
            }).toList(),
          ),
      ],
    );
  }
}

class PdfTreeItem extends StatefulWidget {
  final PdfOutlineNode node;
  final int depth;
  final Function(PdfOutlineNode) onTap;
  final PdfOutlineNode? currentPdfNode;
  final List<PdfOutlineNode> flattenedOutline;

  const PdfTreeItem({
    super.key,
    required this.node,
    required this.depth,
    required this.onTap,
    this.currentPdfNode,
    this.flattenedOutline = const [],
  });

  @override
  State<PdfTreeItem> createState() => _PdfTreeItemState();
}

class _PdfTreeItemState extends State<PdfTreeItem> {
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.node == widget.currentPdfNode) {
        Scrollable.ensureVisible(
          context,
          alignment: 0.5,
          duration: const Duration(milliseconds: 300),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasChildren = widget.node.children.isNotEmpty;
    final isCurrent = widget.currentPdfNode == widget.node;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => widget.onTap(widget.node),
            child: Padding(
              padding: EdgeInsets.only(
                left: 16.0 + (widget.depth * 16.0),
                top: 12,
                bottom: 12,
                right: 8,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.node.title,
                      style: TextStyle(
                        color: isCurrent
                            ? context.tibpiColors.accent
                            : Colors.white,
                        fontWeight: isCurrent
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (hasChildren)
                    IconButton(
                      icon: Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: Colors.white54,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      style: const ButtonStyle(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (_isExpanded && hasChildren)
          Column(
            children: widget.node.children.map((child) {
              return PdfTreeItem(
                node: child,
                depth: widget.depth + 1,
                onTap: widget.onTap,
                currentPdfNode: widget.currentPdfNode,
                flattenedOutline: widget.flattenedOutline,
              );
            }).toList(),
          ),
      ],
    );
  }
}
