import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/reader_settings_provider.dart';

class ReadingSpeedSheet extends ConsumerWidget {
  const ReadingSpeedSheet({super.key});

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
            l10n.readingSpeed,
            style: TextStyle(
              color: t.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          
          // Auto Scroll Speed
          Text(
            'Auto Scroll Speed',
            style: TextStyle(
              color: t.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Speed: ${readerSettings.autoScrollSpeed.toStringAsFixed(1)}x',
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
            value: readerSettings.autoScrollSpeed,
            min: 0.5,
            max: 10.0,
            divisions: 19,
            activeColor: t.primary,
            onChanged: (value) {
              ref.read(readerSettingsProvider.notifier).setAutoScrollSpeed(value);
            },
          ),
          
          const SizedBox(height: 8),
          Text(
            'Adjust the speed for auto-scrolling while reading. Higher values scroll faster.',
            style: TextStyle(
              color: t.textTertiary,
              fontSize: 12,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Quick Speed Presets
          Text(
            'Quick Presets',
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
              _buildSpeedPreset('0.5x', 0.5, readerSettings.autoScrollSpeed, t, ref),
              _buildSpeedPreset('1.0x', 1.0, readerSettings.autoScrollSpeed, t, ref),
              _buildSpeedPreset('1.5x', 1.5, readerSettings.autoScrollSpeed, t, ref),
              _buildSpeedPreset('2.0x', 2.0, readerSettings.autoScrollSpeed, t, ref),
              _buildSpeedPreset('3.0x', 3.0, readerSettings.autoScrollSpeed, t, ref),
              _buildSpeedPreset('5.0x', 5.0, readerSettings.autoScrollSpeed, t, ref),
            ],
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSpeedPreset(
    String label,
    double speed,
    double currentSpeed,
    TibebThemeExtension t,
    WidgetRef ref,
  ) {
    final isSelected = currentSpeed == speed;
    
    return GestureDetector(
      onTap: () {
        ref.read(readerSettingsProvider.notifier).setAutoScrollSpeed(speed);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? t.primary.withValues(alpha: 0.1)
              : t.surface.withValues(alpha: 0.35),
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