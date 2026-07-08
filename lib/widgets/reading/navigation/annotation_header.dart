import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

class AnnotationHeader extends StatelessWidget {
  final int count;
  final bool isSelectionMode;
  final int selectedCount;
  final VoidCallback onToggleSelection;
  final VoidCallback onDeleteSelected;
  final VoidCallback onCloseSelection;
  final VoidCallback onShareSelected;
  final VoidCallback onShareQuote;
  final VoidCallback? onExport;

  const AnnotationHeader({
    super.key,
    required this.count,
    required this.isSelectionMode,
    required this.selectedCount,
    required this.onToggleSelection,
    required this.onDeleteSelected,
    required this.onCloseSelection,
    required this.onShareSelected,
    required this.onShareQuote,
    this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        border: const Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isSelectionMode ? "$selectedCount SELECTED" : "ANNOTATIONS",
                  style: TextStyle(
                    color: context.tibpiColors.accent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                if (!isSelectionMode)
                  Text(
                    "$count items",
                    style: const TextStyle(color: Colors.white38, fontSize: 10),
                  ),
              ],
            ),
          ),
          if (isSelectionMode) ...[
            IconButton(
              icon: Icon(
                Icons.format_quote_rounded,
                color: context.tibpiColors.accent,
                size: 20,
              ),
              onPressed: selectedCount > 0 ? onShareQuote : null,
              tooltip: 'Share as Quote',
            ),
            IconButton(
              icon: Icon(
                Icons.ios_share_rounded,
                color: context.tibpiColors.accent,
                size: 20,
              ),
              onPressed: selectedCount > 0 ? onShareSelected : null,
              tooltip: 'Share Markdown',
            ),
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.redAccent,
                size: 20,
              ),
              onPressed: selectedCount > 0 ? onDeleteSelected : null,
              tooltip: 'Delete selected',
            ),
            IconButton(
              icon: const Icon(
                Icons.close_rounded,
                color: Colors.white54,
                size: 20,
              ),
              onPressed: onCloseSelection,
              tooltip: 'Cancel selection',
            ),
          ] else ...[
            if (onExport != null)
              IconButton(
                icon: Icon(
                  Icons.ios_share_rounded,
                  color: context.tibpiColors.accent,
                  size: 18,
                ),
                onPressed: onExport,
                tooltip: 'Export',
              ),
            TextButton(
              onPressed: onToggleSelection,
              child: Text(
                'SELECT',
                style: TextStyle(
                  color: context.tibpiColors.accent,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ColorFilterBar extends StatelessWidget {
  final String? selectedColor;
  final Function(String?) onColorTap;

  const ColorFilterBar({
    super.key,
    required this.selectedColor,
    required this.onColorTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.01),
        border: const Border(bottom: BorderSide(color: Colors.white10)),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: FilterChip(
              label: const Text(
                'ALL',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              selected: selectedColor == null,
              onSelected: (_) => onColorTap(null),
              backgroundColor: Colors.transparent,
              selectedColor: context.tibpiColors.accent.withValues(alpha: 0.2),
              checkmarkColor: context.tibpiColors.accent,
              side: BorderSide(
                color: selectedColor == null
                    ? context.tibpiColors.accent
                    : Colors.white10,
              ),
              visualDensity: VisualDensity.compact,
            ),
          ),
          const SizedBox(width: 8),
          ...context.tibpiColors.highlightColors.map((color) {
            final hexColor =
                '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
            final isSelected = selectedColor == hexColor;
            return Padding(
              padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
              child: FilterChip(
                label: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                selected: isSelected,
                onSelected: (_) => onColorTap(hexColor),
                backgroundColor: color.withValues(alpha: 0.1),
                selectedColor: color.withValues(alpha: 0.3),
                checkmarkColor: Colors.white,
                side: BorderSide(
                  color: isSelected ? color : Colors.transparent,
                ),
                visualDensity: VisualDensity.compact,
              ),
            );
          }),
        ],
      ),
    );
  }
}
