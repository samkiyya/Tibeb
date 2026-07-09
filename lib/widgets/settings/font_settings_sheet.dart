import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/reader_settings_provider.dart';

class FontSettingsSheet extends ConsumerWidget {
  const FontSettingsSheet({super.key});

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
            l10n.fontSettings,
            style: TextStyle(
              color: t.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          
          // Font Family
          Text(
            'Font Family',
            style: TextStyle(
              color: t.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFontChip('Merriweather', readerSettings.typeface == 'Merriweather', t, () {
                ref.read(readerSettingsProvider.notifier).setFontFamily('Merriweather');
              }),
              _buildFontChip('Georgia', readerSettings.typeface == 'Georgia', t, () {
                ref.read(readerSettingsProvider.notifier).setFontFamily('Georgia');
              }),
              _buildFontChip('Lexend', readerSettings.typeface == 'Lexend', t, () {
                ref.read(readerSettingsProvider.notifier).setFontFamily('Lexend');
              }),
              _buildFontChip('System', readerSettings.typeface == 'System', t, () {
                ref.read(readerSettingsProvider.notifier).setFontFamily('System');
              }),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Font Size
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Font Size',
                style: TextStyle(
                  color: t.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                readerSettings.textSize.toStringAsFixed(0),
                style: TextStyle(
                  color: t.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            value: readerSettings.textSize,
            min: 12,
            max: 32,
            divisions: 20,
            activeColor: t.primary,
            onChanged: (value) {
              ref.read(readerSettingsProvider.notifier).setFontSize(value);
            },
          ),
          
          const SizedBox(height: 24),
          
          // Line Height
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Line Height',
                style: TextStyle(
                  color: t.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                readerSettings.lineHeight.toStringAsFixed(1),
                style: TextStyle(
                  color: t.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Slider(
            value: readerSettings.lineHeight,
            min: 1.0,
            max: 2.5,
            divisions: 15,
            activeColor: t.primary,
            onChanged: (value) {
              ref.read(readerSettingsProvider.notifier).setLineHeight(value);
            },
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildFontChip(String label, bool isSelected, TibebThemeExtension t, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? t.primary.withValues(alpha: 0.1) : t.surface.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? t.primary : t.borderSubtle,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? t.primary : t.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}