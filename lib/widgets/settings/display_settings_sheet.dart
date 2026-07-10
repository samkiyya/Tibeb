import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/reader_settings_provider.dart';
import '../../models/reader_settings_model.dart';

class DisplaySettingsSheet extends ConsumerWidget {
  const DisplaySettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tibpiColors;
    final l10n = AppLocalizations.of(context)!;
    final readerSettings = ref.watch(readerSettingsProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.displayMode,
            style: TextStyle(
              color: t.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Reading Theme
          Text(
            l10n.readingTheme,
            style: TextStyle(
              color: t.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildThemeChip(
                  l10n.themeLight,
                  readerSettings.theme == ReaderTheme.white,
                  t,
                  () => ref
                      .read(readerSettingsProvider.notifier)
                      .setTheme(ReaderTheme.white),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildThemeChip(
                  l10n.themeSepia,
                  readerSettings.theme == ReaderTheme.cream,
                  t,
                  () => ref
                      .read(readerSettingsProvider.notifier)
                      .setTheme(ReaderTheme.cream),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildThemeChip(
                  l10n.themeDark,
                  readerSettings.theme == ReaderTheme.black,
                  t,
                  () => ref
                      .read(readerSettingsProvider.notifier)
                      .setTheme(ReaderTheme.black),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Text Alignment
          Text(
            l10n.textAlignment,
            style: TextStyle(
              color: t.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildAlignmentChip(
                  l10n.alignLeft,
                  readerSettings.alignment == ReaderAlignment.left,
                  t,
                  () => ref
                      .read(readerSettingsProvider.notifier)
                      .setAlignment(ReaderAlignment.left),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildAlignmentChip(
                  l10n.alignCenter,
                  readerSettings.alignment == ReaderAlignment.center,
                  t,
                  () => ref
                      .read(readerSettingsProvider.notifier)
                      .setAlignment(ReaderAlignment.center),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildAlignmentChip(
                  l10n.alignJustified,
                  readerSettings.alignment == ReaderAlignment.justified,
                  t,
                  () => ref
                      .read(readerSettingsProvider.notifier)
                      .setAlignment(ReaderAlignment.justified),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildThemeChip(
    String label,
    bool isSelected,
    TibebThemeExtension t,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? t.primary.withValues(alpha: 0.1)
              : t.surface.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? t.primary : t.borderSubtle,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? t.primary : t.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildAlignmentChip(
    String label,
    bool isSelected,
    TibebThemeExtension t,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? t.primary.withValues(alpha: 0.1)
              : t.surface.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? t.primary : t.borderSubtle,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? t.primary : t.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}
