import 'package:flutter/material.dart';
import '../../core/theme/theme.dart';
import '../glass_container.dart';
import '../../l10n/app_localizations.dart';

class StreakWidget extends StatelessWidget {
  final int streak;
  final bool isActive;

  const StreakWidget({super.key, required this.streak, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    final l10n = AppLocalizations.of(context)!;
    final Color fireColor = isActive
        ? (streak >= 30 ? t.wpGold : (streak >= 7 ? t.streakFire : t.error))
        : t.textTertiary;

    return GlassContainer(
      padding: const EdgeInsets.all(TibebSpacing.md),
      child: Column(
        children: [
          Icon(Icons.local_fire_department, color: fireColor, size: 24),
          const SizedBox(height: TibebSpacing.sm),
          Text(
            '$streak',
            style: context.textTheme.titleLarge?.copyWith(
              fontSize: 18,
              color: t.textSecondary,
            ),
          ),
          Text(
            l10n.streak,
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
