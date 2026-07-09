import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme.dart';

class ThemeSelector extends ConsumerWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tibpiColors;
    final currentThemeMode = ref.watch(themeModeProvider);

    return Row(
      children: [
        Expanded(
          child: _ThemeTile(
            title: 'Light',
            icon: Icons.light_mode_rounded,
            themeMode: ThemeMode.light,
            isSelected: currentThemeMode == ThemeMode.light,
            previewWidget: Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFFDFBF7),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.black.withValues(alpha: 0.08),
                ),
              ),
              child: Center(
                child: Container(
                  width: 30,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.brown.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
            t: t,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ThemeTile(
            title: 'Dark',
            icon: Icons.dark_mode_rounded,
            themeMode: ThemeMode.dark,
            isSelected: currentThemeMode == ThemeMode.dark,
            previewWidget: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.12),
                ),
              ),
              child: Center(
                child: Container(
                  width: 30,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
            t: t,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ThemeTile(
            title: 'System',
            icon: Icons.settings_suggest_rounded,
            themeMode: ThemeMode.system,
            isSelected: currentThemeMode == ThemeMode.system,
            previewWidget: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: t.border.withValues(alpha: 0.2)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(color: const Color(0xFFFDFBF7)),
                    ),
                    Expanded(child: Container(color: Colors.black)),
                  ],
                ),
              ),
            ),
            t: t,
          ),
        ),
      ],
    );
  }
}

class _ThemeTile extends ConsumerWidget {
  final String title;
  final IconData icon;
  final ThemeMode themeMode;
  final bool isSelected;
  final Widget previewWidget;
  final TibebThemeExtension t;

  const _ThemeTile({
    required this.title,
    required this.icon,
    required this.themeMode,
    required this.isSelected,
    required this.previewWidget,
    required this.t,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(themeModeProvider.notifier).setThemeMode(themeMode);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? t.primary.withValues(alpha: 0.08)
              : t.surface.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? t.primary : t.borderSubtle,
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: t.primary.withValues(alpha: 0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            previewWidget,
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 15,
                  color: isSelected ? t.primary : t.textSecondary,
                ),
                const SizedBox(width: 5),
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? t.textPrimary : t.textSecondary,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}