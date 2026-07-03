import 'package:flutter/material.dart';
import '../core/rank/tibeb_rank.dart';
import '../core/rank/tibeb_rank_extension.dart';
import '../core/rank/tibeb_rank_repository.dart';
import '../core/theme/semantics/color_scheme.dart';
import '../core/theme/tokens/radius.dart';
import '../core/theme/tokens/spacing.dart';

class RankPathWidget extends StatelessWidget {
  final int currentLevel;
  final int achievementCount;

  const RankPathWidget({
    super.key,
    required this.currentLevel,
    required this.achievementCount,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    final List<TibebRank> ranks = TibebRankRepository.instance.getAllRanks();
    final TibebRank currentRank = TibebRankRepository.instance.getCurrentRank(
      currentLevel,
      achievementCount,
    );

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: TibebSpacing.screenPadding,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: TibebRadius.borderLg,
        border: Border.all(color: t.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mastery Path',
            style: context.textTheme.titleLarge?.copyWith(
              color: t.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Current Rank: ${currentRank.name}',
            style: TextStyle(
              color: t.success,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          _buildPath(context, ranks),
        ],
      ),
    );
  }

  Widget _buildPath(BuildContext context, List<TibebRank> ranks) {
    final t = context.tibpiColors;
    return Column(
      children: List.generate(ranks.length, (index) {
        final rank = ranks[index];
        final isReached = currentLevel >= rank.level;
        final isNext =
            !isReached &&
            (index == 0 || currentLevel >= ranks[index - 1].level);
        final isLast = index == ranks.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isReached
                        ? t.success
                        : (isNext ? t.accent : t.glass),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isReached ? Colors.transparent : t.textSecondary,
                      width: 2,
                    ),
                  ),
                  child: isReached
                      ? Icon(Icons.check, size: 14, color: t.textOnPrimary)
                      : null,
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    color: isReached ? t.success : t.glass,
                  ),
              ],
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
                          : (isNext ? t.accent : t.textSecondary),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Level ${rank.level}+ • ${rank.achievementsRequired} Achievements • ${rank.description}',
                    style: TextStyle(color: t.textSecondary, fontSize: 12),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
