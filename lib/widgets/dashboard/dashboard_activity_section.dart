import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tibeb/core/theme/theme.dart';
import 'package:tibeb/providers/library_provider.dart';
import 'package:tibeb/widgets/activity_graph.dart';
import 'package:tibeb/widgets/daily_activity_sheet.dart';
import 'package:tibeb/l10n/app_localizations.dart';

/// "Reading Activity" heading + monthly heatmap graph.
class DashboardActivitySection extends StatelessWidget {
  final LibraryState state;

  const DashboardActivitySection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.readingActivity,
          style: context.textTheme.titleLarge?.copyWith(
            color: t.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.currentMonth,
          style: TextStyle(color: t.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 12),
        ActivityGraph(
          dailyValues: state.dailyReadingValues,
          selectedMonth: DateFormat('MMMM yyyy').format(DateTime.now()),
          weeklyGoalType: state.weeklyGoalType,
          weeklyGoalValue: state.weeklyGoalValue,
          onDateTapped: (date, value) {
            if (value == 0) return;
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (_) => DailyActivitySheet(
                date: date,
                totalValue: value,
                goalType: state.weeklyGoalType,
                allBooks: state.allBooks,
                sessionHistory: state.sessionHistory,
              ),
            );
          },
        ),
      ],
    );
  }
}
