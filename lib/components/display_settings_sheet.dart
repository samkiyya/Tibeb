import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/reader_settings_model.dart';
import '../providers/reader_settings_provider.dart';
import '../core/theme/semantics/color_scheme.dart';
import '../core/theme/tokens/radius.dart';

class DisplaySettingsSheet extends ConsumerStatefulWidget {
  const DisplaySettingsSheet({super.key});

  @override
  ConsumerState<DisplaySettingsSheet> createState() =>
      _DisplaySettingsSheetState();
}

class _DisplaySettingsSheetState extends ConsumerState<DisplaySettingsSheet> {
  late double _localTextSize;
  late double _localAutoScrollSpeed;
  late double _localLineHeight;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(readerSettingsProvider);
    _localTextSize = settings.textSize;
    _localAutoScrollSpeed = settings.autoScrollSpeed;
    _localLineHeight = settings.lineHeight;
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _debounceUpdate(VoidCallback update) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 100), update);
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(readerSettingsProvider);
    final notifier = ref.read(readerSettingsProvider.notifier);
    final t = context.tibpiColors;

    return Container(
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: t.textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Display Settings',
                  style: TextStyle(
                    color: t.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: t.textSecondary),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Theme Section
            _buildSectionLabel(t, 'THEME'),
            const SizedBox(height: 12),
            _buildThemeSelector(t, settings, notifier),
            const SizedBox(height: 28),

            // Typeface Section
            _buildSectionLabel(t, 'TYPEFACE'),
            const SizedBox(height: 12),
            _buildTypefaceDropdown(t, settings, notifier),
            const SizedBox(height: 28),

            // Size & Layout Section
            _buildSectionLabel(t, 'SIZE & LAYOUT'),
            const SizedBox(height: 16),

            // Text Size Slider
            _buildSliderRow(
              t,
              label: 'Text Size',
              value: _localTextSize,
              min: 12,
              max: 32,
              divisions: 20,
              displayValue: '${_localTextSize.round()}px',
              onChanged: (value) {
                setState(() => _localTextSize = value);
                _debounceUpdate(() => notifier.setTextSize(value));
              },
            ),
            // Auto Scroll Speed Slider
            _buildSliderRow(
              t,
              label: 'Auto Scroll Speed',
              value: _localAutoScrollSpeed,
              min: 0.5,
              max: 10.0,
              divisions: 19,
              displayValue: '${_localAutoScrollSpeed.toStringAsFixed(1)}x',
              onChanged: (value) {
                setState(() => _localAutoScrollSpeed = value);
                _debounceUpdate(() => notifier.setAutoScrollSpeed(value));
              },
            ),
            const SizedBox(height: 16),

            // Line Height Slider
            _buildSliderRow(
              t,
              label: 'Line Height',
              value: _localLineHeight,
              min: 1.0,
              max: 2.5,
              divisions: 15,
              displayValue: _localLineHeight.toStringAsFixed(1),
              onChanged: (value) {
                setState(() => _localLineHeight = value);
                _debounceUpdate(() => notifier.setLineHeight(value));
              },
            ),
            const SizedBox(height: 20),

            // Alignment Buttons
            _buildAlignmentSelector(t, settings, notifier),
            const SizedBox(height: 28),

            // Publisher Defaults Toggle
            _buildPublisherDefaultsToggle(t, settings, notifier),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(TibebThemeExtension t, String label) {
    return Text(
      label,
      style: TextStyle(
        color: t.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildThemeSelector(
    TibebThemeExtension t,
    ReaderSettings settings,
    ReaderSettingsNotifier notifier,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: ReaderTheme.values.map((theme) {
        final isSelected = settings.theme == theme;
        final color = ReaderSettings.themePreviewColors[theme]!;

        return GestureDetector(
          onTap: () => notifier.setTheme(theme),
          child: Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? t.primary : Colors.transparent,
                width: 2,
              ),
            ),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: t.borderSubtle,
                  width: 1,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTypefaceDropdown(
    TibebThemeExtension t,
    ReaderSettings settings,
    ReaderSettingsNotifier notifier,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: t.textSecondary.withValues(alpha: 0.05),
        borderRadius: TibebRadius.borderMd,
        border: Border.all(color: t.borderSubtle),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: settings.typeface,
          isExpanded: true,
          dropdownColor: t.surface,
          style: TextStyle(color: t.textPrimary, fontSize: 16),
          icon: Icon(Icons.keyboard_arrow_down, color: t.textSecondary),
          items: ReaderSettings.availableTypefaces.map((typeface) {
            return DropdownMenuItem(
              value: typeface,
              child: Text(
                typeface,
                style: TextStyle(
                  fontFamily: typeface == 'System' ? null : typeface,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              notifier.setTypeface(value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildSliderRow(
    TibebThemeExtension t, {
    required String label,
    required double value,
    required double min,
    required double max,
    required String displayValue,
    required ValueChanged<double> onChanged,
    int? divisions,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(color: t.textSecondary, fontSize: 14),
            ),
            Text(
              displayValue,
              style: TextStyle(
                color: t.primary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: t.primary,
            inactiveTrackColor: t.borderSubtle,
            thumbColor: t.primary,
            overlayColor: t.primary.withValues(alpha: 0.2),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildAlignmentSelector(
    TibebThemeExtension t,
    ReaderSettings settings,
    ReaderSettingsNotifier notifier,
  ) {
    return Row(
      children: [
        _buildAlignmentButton(
          t: t,
          icon: Icons.format_align_left,
          isSelected: settings.alignment == ReaderAlignment.left,
          onTap: () => notifier.setAlignment(ReaderAlignment.left),
        ),
        const SizedBox(width: 8),
        _buildAlignmentButton(
          t: t,
          icon: Icons.format_align_center,
          isSelected: settings.alignment == ReaderAlignment.center,
          onTap: () => notifier.setAlignment(ReaderAlignment.center),
        ),
        const SizedBox(width: 8),
        _buildAlignmentButton(
          t: t,
          icon: Icons.format_align_justify,
          isSelected: settings.alignment == ReaderAlignment.justified,
          onTap: () => notifier.setAlignment(ReaderAlignment.justified),
        ),
      ],
    );
  }

  Widget _buildAlignmentButton({
    required TibebThemeExtension t,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? t.primary.withValues(alpha: 0.2)
                : t.textSecondary.withValues(alpha: 0.05),
            borderRadius: TibebRadius.borderMd,
            border: Border.all(
              color: isSelected
                  ? t.primary
                  : t.borderSubtle,
            ),
          ),
          child: Icon(
            icon,
            color: isSelected ? t.primary : t.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildPublisherDefaultsToggle(
    TibebThemeExtension t,
    ReaderSettings settings,
    ReaderSettingsNotifier notifier,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: t.textSecondary.withValues(alpha: 0.05),
        borderRadius: TibebRadius.borderMd,
        border: Border.all(color: t.borderSubtle),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Defaults',
            style: TextStyle(color: t.textPrimary, fontSize: 16),
          ),
          Switch(
            value: settings.usePublisherDefaults,
            onChanged: (value) => notifier.togglePublisherDefaults(value),
            activeTrackColor: t.primary.withValues(alpha: 0.5),
            activeColor: t.primary,
            inactiveTrackColor: t.borderSubtle,
          ),
        ],
      ),
    );
  }
}

/// Show the display settings as a bottom sheet
void showDisplaySettingsSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => const DisplaySettingsSheet(),
  );
}
