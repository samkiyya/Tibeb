import 'package:flutter/material.dart';
import '../core/constants.dart';

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
    final ranks = TibebConstants.ranks;
    final currentRank = TibebConstants.getRankForLevel(
      currentLevel,
      achievementCount,
    );

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: TibebConstants.horizontalPadding,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: TibebConstants.surface,
        borderRadius: BorderRadius.circular(TibebConstants.borderRadius),
        border: Border.all(color: TibebConstants.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mastery Path',
            style: TextStyle(
              color: TibebConstants.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Current Rank: ${currentRank.name}',
            style: const TextStyle(
              color: TibebConstants.accentGreen,
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
                        ? TibebConstants.accentGreen
                        : (isNext ? Colors.blueAccent : TibebConstants.glassy),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isReached
                          ? Colors.transparent
                          : TibebConstants.textSecondary,
                      width: 2,
                    ),
                  ),
                  child: isReached
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    color: isReached
                        ? TibebConstants.accentGreen
                        : TibebConstants.glassy,
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
                          ? TibebConstants.textPrimary
                          : (isNext
                                ? Colors.blueAccent
                                : TibebConstants.textSecondary),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Level ${rank.level}+ • ${rank.achievementsRequired} Achievements • ${rank.description}',
                    style: const TextStyle(
                      color: TibebConstants.textSecondary,
                      fontSize: 12,
                    ),
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
