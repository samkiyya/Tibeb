// widgets/navigation_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tibeb/core/theme/theme.dart';
import 'package:tibeb/providers/navigation_provider.dart';
import 'package:tibeb/widgets/glass_container.dart';

class CustomBottomNavigationBar extends ConsumerWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navState = ref.watch(navigationStateProvider);
    final selectedIndex = navState.current;

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
            children: [
              _buildNavItem(
                context,
                ref,
                index: 0,
                icon: Icons.dashboard_rounded,
                label: 'Home',
              ),
              _buildNavItem(
                context,
                ref,
                index: 1,
                icon: Icons.menu_book_rounded,
                label: 'Library',
              ),
              _buildNavItem(
                context,
                ref,
                index: 2,
                icon: Icons.bar_chart_rounded,
                label: 'Stats',
              ),
              _buildNavItem(
                context,
                ref,
                index: 3,
                icon: Icons.settings_rounded,
                label: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
     BuildContext context, 
    WidgetRef ref, {
    required int index,
    required IconData icon,
    required String label,
  }) {
    final navState = ref.watch(navigationStateProvider);
    final selectedIndex = navState.current;
    final isSelected = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (selectedIndex != index) {
            ref.read(navigationStateProvider.notifier).state = NavigationState(
              current: index,
              previous: selectedIndex,
            );
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? context.tibpiColors.primary
                  : context.tibpiColors.textTertiary,
              size: 28,
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: context.tibpiColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}