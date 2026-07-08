import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tibeb/core/theme/theme.dart';
import 'package:tibeb/providers/navigation_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CustomBottomNavigationBar (TibebNavBar)
//
// Design language:
//   • Custom shaped notched bar integrated directly with Scaffold
//   • Centered notch margin allowing the Floating Action Button (FAB) to fit
//   • Semi-translucent glassmorphic dark surface styling
//   • Symmetric layouts with Home/Library on left, Stats/Settings on right
//   • Golden-amber active indicators reflecting Ethiopian wisdom gold
//   • Dynamic scaling & haptic feedback on tab select
// ─────────────────────────────────────────────────────────────────────────────

class CustomBottomNavigationBar extends ConsumerWidget {
  final List<GlobalKey?> itemKeys;

  const CustomBottomNavigationBar({
    super.key,
    this.itemKeys = const [],
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationStateProvider).current;
    final t = context.tibpiColors;

    Widget buildNavItem(int index, IconData activeIcon, IconData inactiveIcon, String label, GlobalKey? key) {
      final isSelected = selectedIndex == index;
      return Expanded(
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            key: key,
            onTap: () {
              if (selectedIndex != index) {
                HapticFeedback.mediumImpact();
                ref.read(navigationStateProvider.notifier).changeTab(index);
              }
            },
            highlightColor: t.primary.withValues(alpha: 0.1),
            splashColor: t.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: isSelected ? 1.15 : 1.0,
                  duration: const Duration(milliseconds: 150),
                  child: Icon(
                    isSelected ? activeIcon : inactiveIcon,
                    color: isSelected ? t.primary : t.textTertiary,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? t.primary : t.textTertiary,
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return BottomAppBar(
      color: t.surface.withValues(alpha: 0.95),
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      elevation: 20,
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.zero,
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: t.borderSubtle.withValues(alpha: 0.15),
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildNavItem(0, Icons.dashboard_rounded, Icons.dashboard_outlined, 'Home', itemKeys.isNotEmpty ? itemKeys[0] : null),
            buildNavItem(1, Icons.menu_book_rounded, Icons.menu_book_outlined, 'Library', itemKeys.length > 1 ? itemKeys[1] : null),
            const SizedBox(width: 60), // Center spacing for the notched FAB
            buildNavItem(2, Icons.bar_chart_rounded, Icons.bar_chart_rounded, 'Stats', itemKeys.length > 2 ? itemKeys[2] : null),
            buildNavItem(3, Icons.settings_rounded, Icons.settings_outlined, 'Settings', itemKeys.length > 3 ? itemKeys[3] : null),
          ],
        ),
      ),
    );
  }
}

typedef TibebNavBar = CustomBottomNavigationBar;
