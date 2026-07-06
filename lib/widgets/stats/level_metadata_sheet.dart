import 'package:flutter/material.dart';
import '../../../core/rank/tibeb_rank.dart';
import '../../../core/rank/tibeb_rank_extension.dart';
import '../../../core/rank/tibeb_rank_repository.dart';
import '../../../core/theme/theme.dart';
import '../glass_container.dart';
import '../../../providers/library_provider.dart';

class LevelMetadataSheet extends StatelessWidget {
  final LibraryState state;

  const LevelMetadataSheet({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    final List<TibebRank> ranks = TibebRankRepository.instance.getAllRanks();

    return GlassContainer(
      borderRadius: 24,
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reading Ranks',
              style: context.textTheme.titleMedium?.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: t.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: t.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: t.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.bolt, color: t.primary, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Earn XP: PDF (10/page), EPUB (40/chapter) + 5 XP/min. Every 1000 XP = 1 Level!',
                      style: TextStyle(
                        color: t.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ...ranks.map((rank) {
              final bool isReached =
                  state.level >= rank.level &&
                  state.unlockedAchievements.length >=
                      rank.achievementsRequired;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isReached
                            ? t.primary.withValues(alpha: 0.1)
                            : t.glass,
                        border: Border.all(
                          color: isReached ? t.primary : t.borderSubtle,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${rank.level}',
                          style: TextStyle(
                            color: isReached ? t.textPrimary : t.textSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rank.name,
                            style: TextStyle(
                              color: isReached
                                  ? t.textPrimary
                                  : t.textSecondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            'Level ${rank.level}+ • ${rank.achievementsRequired} Achievements\n${rank.description}',
                            style: TextStyle(
                              color: isReached
                                  ? t.textSecondary
                                  : t.textSecondary.withValues(alpha: 0.5),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isReached)
                      Icon(Icons.check_circle, color: t.success, size: 18),
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
