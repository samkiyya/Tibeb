class MarkdownOutlineNode {
  final String title;
  final double scrollProgress;
  final int lineNumber;
  final int level;
  final String elementId;
  final List<MarkdownOutlineNode> children;

  MarkdownOutlineNode({
    required this.title,
    required this.scrollProgress,
    required this.lineNumber,
    required this.level,
    required this.elementId,
    List<MarkdownOutlineNode>? children,
  }) : children = children ?? [];
}
