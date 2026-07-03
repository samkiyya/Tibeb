import 'package:flutter/material.dart';
import '../../../core/rank/tibeb_rank_extension.dart';
import '../../../core/rank/tibeb_rank_repository.dart';
import '../../../core/theme/theme.dart';
import '../../../components/glass_container.dart';
import '../../../providers/library_provider.dart';

class LevelInfoCard extends StatelessWidget {
  final LibraryState state;
  final VoidCallback onTap;

  const LevelInfoCard({super.key, required this.state, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    final currentTitle = TibebRankRepository.instance
        .getCurrentRank(state.level, state.unlockedAchievements.length)
        .name;

    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: t.primary.withValues(alpha: 0.1),
                border: Border.all(color: t.primary, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: t.primary.withValues(alpha: 0.3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '${state.level}',
                  style: TextStyle(
                    color: t.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        currentTitle,
                        style: TextStyle(
                          color: t.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.info_outline,
                        size: 14,
                        color: t.textSecondary,
                      ),
                    ],
                  ),
                  Text(
                    'Current Level',
                    style: TextStyle(color: t.textSecondary, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (state.totalXP % 1000) / 1000,
                      backgroundColor: t.borderSubtle,
                      valueColor: AlwaysStoppedAnimation<Color>(t.primary),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${state.totalXP % 1000} / 1000 XP',
                        style: TextStyle(
                          color: t.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${1000 - (state.totalXP % 1000)} XP to level up',
                        style: TextStyle(
                          color: t.primary.withValues(alpha: 0.6),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
