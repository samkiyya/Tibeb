import 'package:flutter/material.dart';
import 'package:tibeb/shared/models/quest_model.dart';
import '../core/theme/theme.dart';


import 'glass_container.dart';

class DailyQuestsCard extends StatelessWidget {
  final List<DailyQuest> quests;

  const DailyQuestsCard({super.key, required this.quests});

  @override
  Widget build(BuildContext context) {
    if (quests.isEmpty) return const SizedBox.shrink();

    final t = context.tibpiColors;
    final now = DateTime.now();
    final isWeekend =
        now.weekday == DateTime.saturday || now.weekday == DateTime.sunday;

    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Daily Quests',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: t.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isWeekend) ...[
                    const SizedBox(width: TibebSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: t.xpGold.withValues(alpha: 0.2),
                        borderRadius: TibebRadius.borderXs,
                        border: Border.all(
                          color: t.xpGold.withValues(alpha: 0.5),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '2X XP',
                        style: TextStyle(
                          color: t.xpGold,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              Icon(
                isWeekend
                    ? Icons.celebration
                    : Icons.assignment_turned_in_outlined,
                color: isWeekend ? t.xpGold : t.textSecondary,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: TibebSpacing.base),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: quests.length,
            separatorBuilder: (context, index) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              final quest = quests[index];
              return _QuestItem(quest: quest, isWeekend: isWeekend);
            },
          ),
        ],
      ),
    );
  }
}

class _QuestItem extends StatelessWidget {
  final DailyQuest quest;
  final bool isWeekend;

  const _QuestItem({required this.quest, this.isWeekend = false});

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    final bool isCompleted = quest.isCompleted;
    final double progress = quest.progress.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quest.title,
                    style: TextStyle(
                      color: isCompleted ? t.textDisabled : t.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  if (!isCompleted)
                    Text(
                      quest.description,
                      style: TextStyle(
                        color: t.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              isCompleted ? 'Done' : '${(progress * 100).toInt()}%',
              style: TextStyle(
                color: isCompleted ? t.primary : t.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: TibebSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: t.borderSubtle,
            valueColor: AlwaysStoppedAnimation<Color>(
              isCompleted ? t.success : t.primary,
            ),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Reward: ${quest.xpReward} XP',
                  style: TextStyle(
                    color: isWeekend ? t.xpGold : t.textSecondary,
                    fontSize: 11,
                    fontWeight: isWeekend ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (isWeekend) ...[
                  const SizedBox(width: 4),
                  Icon(Icons.flash_on, color: t.xpGold, size: 10),
                ],
              ],
            ),
            if (isCompleted)
              Icon(
                Icons.check_circle,
                color: t.success,
                size: 14,
              ),
          ],
        ),
      ],
    );
  }
}
