import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../../../models/reader_settings_model.dart';
import '../note_view.dart';

class AnnotationCard extends StatelessWidget {
  final String? title;
  final String text;
  final String? note;
  final String date;
  final bool isHighlight;
  final bool isSelectionMode;
  final bool isSelected;
  final ValueChanged<bool?>? onSelectedChanged;
  final VoidCallback? onDelete;
  final VoidCallback onTap;
  final VoidCallback? onNoteTap;
  final VoidCallback onLongPress;
  final ReaderSettings readerSettings;

  const AnnotationCard({
    super.key,
    this.title,
    required this.text,
    this.note,
    required this.date,
    required this.isHighlight,
    required this.isSelectionMode,
    required this.isSelected,
    this.onSelectedChanged,
    this.onDelete,
    required this.onTap,
    this.onNoteTap,
    required this.onLongPress,
    required this.readerSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Material(
        color: isSelected
            ? context.tibpiColors.accent.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isSelectionMode) ...[
                  Checkbox(
                    value: isSelected,
                    activeColor: context.tibpiColors.accent,
                    onChanged: onSelectedChanged,
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isHighlight) ...[
                        Container(
                          padding: const EdgeInsets.only(left: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: context.tibpiColors.accent,
                                width: 3,
                              ),
                            ),
                          ),
                          child: Text(
                            text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              height: 1.5,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ] else ...[
                        Text(
                          title ?? 'Bookmark',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (text.isNotEmpty && text != title)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              text,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      if (note != null && note!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.notes_rounded,
                                    color: context.tibpiColors.accent
                                        .withValues(alpha: 0.7),
                                    size: 14,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'NOTE',
                                    style: TextStyle(
                                      color: context.tibpiColors.accent
                                          .withValues(alpha: 0.7),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              NoteView(
                                markdown: note!,
                                settings: readerSettings,
                                fontSize: 13,
                                textColor: Colors.white70,
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            date,
                            style: const TextStyle(
                              color: Colors.white24,
                              fontSize: 11,
                            ),
                          ),
                          Row(
                            children: [
                              if (!isSelectionMode &&
                                  onNoteTap != null &&
                                  isHighlight)
                                IconButton(
                                  icon: Icon(
                                    (note != null && note!.isNotEmpty)
                                        ? Icons.sticky_note_2_outlined
                                        : Icons.add_comment_outlined,
                                    color: context.tibpiColors.accent,
                                    size: 20,
                                  ),
                                  onPressed: onNoteTap,
                                  padding: const EdgeInsets.only(right: 8),
                                  constraints: const BoxConstraints(),
                                  style: const ButtonStyle(
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  tooltip: 'View/Edit Note',
                                ),
                              if (!isSelectionMode && onDelete != null)
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.white24,
                                    size: 20,
                                  ),
                                  onPressed: onDelete,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  style: const ButtonStyle(
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
