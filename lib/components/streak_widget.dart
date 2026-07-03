import 'package:flutter/material.dart';
import '../core/theme/semantics/color_scheme.dart';
import '../core/theme/tokens/spacing.dart';
import './glass_container.dart';

class StreakWidget extends StatelessWidget {
  final int streak;
  final bool isActive;

  const StreakWidget({super.key, required this.streak, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    final Color fireColor = isActive
        ? (streak >= 30
              ? t.xpGold
              : (streak >= 7 ? t.streakFire : t.error))
        : t.textTertiary;

    return GlassContainer(
      padding: const EdgeInsets.all(TibebSpacing.md),
      child: Column(
        children: [
          Icon(Icons.local_fire_department, color: fireColor, size: 24),
          const SizedBox(height: TibebSpacing.sm),
          Text(
            '$streak',
            style: context.textTheme.titleLarge?.copyWith(fontSize: 18),
          ),
          Text(
            'Streak',
            style: context.textTheme.bodySmall?.copyWith(
              fontSize: 10,
              color: t.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
