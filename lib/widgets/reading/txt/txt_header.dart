import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

import '../../../core/theme/theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/book_model.dart';
import '../../../models/reader_settings_model.dart';

class TxtHeader extends StatelessWidget {
  final Book book;
  final ReaderSettings settings;
  final bool hasUnsavedChanges;
  final int wordCount;
  final int lineCount;
  final VoidCallback onSave;
  final VoidCallback onCopyAll;

  const TxtHeader({
    super.key,
    required this.book,
    required this.settings,
    required this.hasUnsavedChanges,
    required this.wordCount,
    required this.lineCount,
    required this.onSave,
    required this.onCopyAll,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      color: settings.backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 8, 6),
            child: Row(
              children: [
                Icon(
                  Icons.text_fields_outlined,
                  size: 17,
                  color: settings.secondaryTextColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        p.basename(book.filePath),
                        style: TextStyle(
                          color: settings.textColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '$wordCount words · $lineCount lines',
                        style: TextStyle(
                          color: settings.secondaryTextColor,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                if (hasUnsavedChanges)
                  _ActionButton(
                    icon: Icons.save_rounded,
                    label: l10n.saveChanges,
                    color: t.primary,
                    onTap: onSave,
                  ),
                _ActionButton(
                  icon: Icons.copy_all_rounded,
                  label: '',
                  color: settings.secondaryTextColor,
                  onTap: onCopyAll,
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: t.borderSubtle),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: color),
            if (label.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
