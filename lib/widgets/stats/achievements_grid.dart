import 'package:flutter/material.dart';
import 'package:tibeb/core/theme/theme.dart';
import 'package:tibeb/providers/library_provider.dart';
import 'package:tibeb/widgets/stats/achievement_badge.dart';
import 'package:tibeb/widgets/stats/achievement_detail_dialog.dart';
import 'package:tibeb/l10n/app_localizations.dart';

class AchievementsGrid extends StatelessWidget {
  final LibraryState state;

  const AchievementsGrid({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    final l10n = AppLocalizations.of(context)!;
    final achievements = state.sortedAchievements; // uses the getter

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.achievements,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: t.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            final ach = achievements[index];
            return GestureDetector(
              onTap: () => showDialog(
                context: context,
                builder: (_) => AchievementDetailDialog(achievement: ach),
              ),
              child: AchievementBadge(
                title: ach.getTitle(context),
                desc: ach.getDescription(context),
                icon: ach.icon,
                isUnlocked: ach.isUnlocked,
              ),
            );
          },
        ),
      ],
    );
  }
}