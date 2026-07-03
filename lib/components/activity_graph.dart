import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/theme/semantics/color_scheme.dart';
import '../core/theme/tokens/radius.dart';

class ActivityGraph extends StatelessWidget {
  final Map<String, int> dailyValues;
  final String selectedMonth;
  final String weeklyGoalType;
  final double weeklyGoalValue;
  final Function(DateTime, int)? onDateTapped;

  const ActivityGraph({
    super.key,
    required this.dailyValues,
    required this.selectedMonth,
    required this.weeklyGoalType,
    required this.weeklyGoalValue,
    this.onDateTapped,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;

    // Parse selected month and year
    final DateFormat formatter = DateFormat('MMMM yyyy');
    final DateTime targetDate = formatter.parse(selectedMonth);
    final int year = targetDate.year;
    final int month = targetDate.month;

    final DateTime firstDayOfMonth = DateTime(year, month, 1);
    final DateTime lastDayOfMonth = DateTime(year, month + 1, 0);
    final int daysInMonth = lastDayOfMonth.day;
    final int leadingEmptyDays =
        firstDayOfMonth.weekday % 7; // 0 = Sun, 1 = Mon, etc.

    // GitHub/Finance style: 7 columns (Mon-Sun)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].map((d) {
            return Expanded(
              child: Center(
                child: Text(
                  d,
                  style: TextStyle(color: t.textTertiary, fontSize: 10),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.85,
          ),
          itemCount: daysInMonth + leadingEmptyDays,
          itemBuilder: (context, index) {
            final int dayIndex = index - leadingEmptyDays;
            if (dayIndex < 0) return const SizedBox.shrink();

            final DateTime date = DateTime(year, month, dayIndex + 1);
            final String dateStr = date.toIso8601String().split('T')[0];
            final int value = dailyValues[dateStr] ?? 0;

            return GestureDetector(
              onTap: () => onDateTapped?.call(date, value),
              child: _buildDayCell(context, date.day, value),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDayCell(BuildContext context, int day, int value) {
    final t = context.tibpiColors;

    int level = 0;
    if (value > 0) {
      final double dailyGoal = weeklyGoalValue / 7.0;
      if (value >= dailyGoal * 2.0) {
        level = 4;
      } else if (value >= dailyGoal) {
        level = 3;
      } else if (value >= dailyGoal * 0.5) {
        level = 2;
      } else {
        level = 1;
      }
    }

    final Color bgColor = t.graphLevels[level];
    final bool hasActivity = value > 0;
    final String label = value >= 1000
        ? '${(value / 1000).toStringAsFixed(1)}k'
        : '$value';

    return Container(
      decoration: BoxDecoration(
        color: hasActivity
            ? bgColor.withValues(alpha: 0.8)
            : t.glass,
        borderRadius: TibebRadius.borderSm,
        border: Border.all(
          color: hasActivity ? bgColor : t.borderSubtle,
          width: 0.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$day',
            style: TextStyle(
              color: hasActivity ? t.textOnPrimary : t.textTertiary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (hasActivity)
            Text(
              '$label${weeklyGoalType == 'pages' ? 'p' : (weeklyGoalType == 'minutes' ? 'm' : 'x')}',
              style: TextStyle(
                color: hasActivity ? t.textOnPrimary.withValues(alpha: 0.87) : t.textTertiary,
                fontSize: 8,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}
