import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import '../glass_container.dart';
import '../../../providers/library_provider.dart';

class WeeklyGoalCard extends StatelessWidget {
  final LibraryState state;
  final VoidCallback onEdit;

  const WeeklyGoalCard({super.key, required this.state, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    return GlassContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekly Goals',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: t.textPrimary,
                ),
              ),
              IconButton(
                icon: Icon(Icons.edit, size: 18, color: t.textSecondary),
                onPressed: onEdit,
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (state.weeklyPageGoal > 0)
            _buildGoalProgress(
              context: context,
              t: t,
              title: 'Pages',
              current: state.weeklyPagesRead.toDouble(),
              goal: state.weeklyPageGoal,
              unit: 'pages',
            ),
          if (state.weeklyMinuteGoal > 0) ...[
            if (state.weeklyPageGoal > 0) const SizedBox(height: 20),
            _buildGoalProgress(
              context: context,
              t: t,
              title: 'Minutes',
              current: state.weeklyMinutesRead.toDouble(),
              goal: state.weeklyMinuteGoal,
              unit: 'minutes',
            ),
          ],
          if (state.weeklyXPGoal > 0) ...[
            if (state.weeklyPageGoal > 0 || state.weeklyMinuteGoal > 0)
              const SizedBox(height: 20),
            _buildGoalProgress(
              context: context,
              t: t,
              title: 'Experience',
              current: state.weeklyXPRead.toDouble(),
              goal: state.weeklyXPGoal,
              unit: 'XP',
            ),
          ],
          if (state.weeklyPageGoal == 0 &&
              state.weeklyMinuteGoal == 0 &&
              state.weeklyXPGoal == 0)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'No goals set for this week',
                  style: TextStyle(color: t.textSecondary),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGoalProgress({
    required BuildContext context,
    required TibebThemeExtension t,
    required String title,
    required double current,
    required double goal,
    required String unit,
  }) {
    final double progress = (current / goal).clamp(0.0, 1.0);
    final bool isGoalMet = progress >= 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: t.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                color: isGoalMet ? t.success : t.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: t.borderSubtle,
            valueColor: AlwaysStoppedAnimation<Color>(
              isGoalMet ? t.success : t.primary,
            ),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${current.toInt()} / ${goal.toInt()} $unit',
          style: TextStyle(color: t.textSecondary, fontSize: 11),
        ),
      ],
    );
  }
}
