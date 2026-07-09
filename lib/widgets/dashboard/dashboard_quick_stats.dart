import 'package:flutter/material.dart';
import 'package:tibeb/core/theme/theme.dart';
import 'package:tibeb/providers/library_provider.dart';
import 'package:tibeb/widgets/stat_badge.dart';
import 'package:tibeb/widgets/dashboard/streak_widget.dart';
import 'package:tibeb/l10n/app_localizations.dart';

/// Four-badge row: streak, total pages, total minutes, current level.
class DashboardQuickStats extends StatelessWidget {
  final LibraryState state;

  const DashboardQuickStats({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    final l10n = AppLocalizations.of(context)!;
  
    return Row(
      children: [
        Expanded(
          child: StreakWidget(
            streak: state.currentStreak,
            isActive: state.isStreakActiveToday,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: StatBadge(
            label: l10n.pages,
            value: '${state.totalPagesRead}',
            icon: Icons.auto_stories,
            color: t.success,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: StatBadge(
            label: l10n.minutes,
            value: '${state.totalMinutesRead}',
            icon: Icons.timer,
            color: t.streakFire,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: StatBadge(
            label: l10n.level,
            value: '${state.level}',
            icon: Icons.stars_rounded,
            color: t.primary,
          ),
        ),
      ],
    );
  }
}
