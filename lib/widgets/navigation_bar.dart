import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tibeb/core/theme/theme.dart';
import 'package:tibeb/providers/navigation_provider.dart';
import 'package:tibeb/widgets/glass_container.dart';

/// The floating glass bottom navigation bar.
///
/// [itemKeys] can optionally wire up GlobalKeys for the tutorial coach marks.
/// Pass them in order: [homeKey, libraryKey, statsKey, settingsKey].
class CustomBottomNavigationBar extends ConsumerWidget {
  final List<GlobalKey?> itemKeys;

  const CustomBottomNavigationBar({
    super.key,
    this.itemKeys = const [null, null, null, null],
  });

  static const _items = [
    (icon: Icons.dashboard_rounded, label: 'Home'),
    (icon: Icons.menu_book_rounded, label: 'Library'),
    (icon: Icons.bar_chart_rounded, label: 'Stats'),
    (icon: Icons.settings_rounded, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationStateProvider).current;

    return SafeArea(
      bottom: true,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GlassContainer(
          height: 70,
          blur: 20,
          opacity: 0.1,
          borderRadius: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              _items.length,
              (index) => _NavItem(
                index: index,
                icon: _items[index].icon,
                label: _items[index].label,
                isSelected: selectedIndex == index,
                itemKey: index < itemKeys.length ? itemKeys[index] : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends ConsumerWidget {
  final int index;
  final IconData icon;
  final String label;
  final bool isSelected;
  final GlobalKey? itemKey;

  const _NavItem({
    required this.index,
    required this.icon,
    required this.label,
    required this.isSelected,
    this.itemKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tibpiColors;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          final current = ref.read(navigationStateProvider).current;
          if (current != index) {
            ref.read(navigationStateProvider.notifier).changeTab(index);
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          key: itemKey,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              icon,
              color: isSelected ? t.primary : t.textTertiary,
              size: 28,
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: t.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
