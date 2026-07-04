// features/stats/screens/stats_screen.dart
//
// Clean replacement — reads from libraryNotifierProvider.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/theme.dart';
import '../../../features/library/providers/library_provider.dart';
import '../../../components/activity_graph.dart';
import '../../../components/daily_activity_sheet.dart';
import '../../../components/daily_quests_card.dart';
import '../../../components/glass_container.dart';
import '../../../components/stat_badge.dart';
import '../../../widgets/stats/achievements_grid.dart';
import '../../../widgets/stats/goal_settings_sheet.dart';
import '../../../widgets/stats/level_info_card.dart';
import '../../../widgets/stats/level_metadata_sheet.dart';
import '../../../widgets/stats/weekly_goal_card.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  String _selectedMonth =
      DateFormat('MMMM yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(libraryNotifierProvider);
    final t = context.tibpiColors;

    return Scaffold(
      backgroundColor: t.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(TibebSpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Reading Stats',
                  style: context.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold, color: t.textPrimary)),
              const SizedBox(height: 24),
              LevelInfoCard(
                  state: state,
                  onTap: () => _showLevelMetadata(context, state)),
              const SizedBox(height: 32),
              _buildQuickStats(t, state),
              const SizedBox(height: 32),
              WeeklyGoalCard(
                  state: state,
                  onEdit: () => _showGoalSettings(context)),
              const SizedBox(height: 32),
              DailyQuestsCard(quests: state.dailyQuests),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Reading Activity',
                      style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: t.textPrimary)),
                  TextButton.icon(
                    onPressed: () => _showMonthPicker(context, t, state),
                    icon: const Icon(Icons.calendar_month, size: 18),
                    label: Text(_selectedMonth),
                    style:
                        TextButton.styleFrom(foregroundColor: t.primary),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ActivityGraph(
                dailyValues: state.dailyReadingValues,
                selectedMonth: _selectedMonth,
                weeklyGoalType: state.weeklyGoalType,
                weeklyGoalValue: state.weeklyGoalValue,
                onDateTapped: (date, value) =>
                    _showDailyDetail(context, state, date, value),
              ),
              const SizedBox(height: 32),
              AchievementsGrid(state: state),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats(TibebThemeExtension t, LibraryState state) {
    final streakColor = state.isStreakActiveToday
        ? (state.currentStreak >= 30
            ? t.xpGold
            : state.currentStreak >= 7
                ? t.streakFire
                : t.primary)
        : t.textSecondary;
    return Row(children: [
      Expanded(
          child: StatBadge(
              label: 'Streak',
              value: '${state.currentStreak}',
              icon: Icons.local_fire_department,
              color: streakColor)),
      const SizedBox(width: 12),
      Expanded(
          child: StatBadge(
              label: 'Pages',
              value: '${state.totalPagesRead}',
              icon: Icons.auto_stories,
              color: t.success)),
      const SizedBox(width: 12),
      Expanded(
          child: StatBadge(
              label: 'Minutes',
              value: '${state.totalMinutesRead}',
              icon: Icons.timer,
              color: t.streakFire)),
    ]);
  }

  void _showLevelMetadata(BuildContext context, LibraryState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LevelMetadataSheet(state: state),
    );
  }

  void _showGoalSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const GoalSettingsSheet(),
    );
  }

  void _showDailyDetail(
      BuildContext context, LibraryState state, DateTime date, int value) {
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
  }

  void _showMonthPicker(
      BuildContext context, TibebThemeExtension t, LibraryState state) {
    final sessions = state.dailyReadingValues.keys.toList();
    final monthsSet = <String>{DateFormat('MMMM yyyy').format(DateTime.now())};
    for (final d in sessions) {
      try {
        monthsSet.add(DateFormat('MMMM yyyy').format(DateTime.parse(d)));
      } catch (_) {}
    }
    final months = monthsSet.toList()
      ..sort((a, b) => DateFormat('MMMM yyyy')
          .parse(b)
          .compareTo(DateFormat('MMMM yyyy').parse(a)));

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => GlassContainer(
        borderRadius: 20,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const SizedBox(height: 12),
          Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: t.borderSubtle,
                  borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          Text('Select Month',
              style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold, color: t.textPrimary)),
          const SizedBox(height: 12),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: months.length,
              itemBuilder: (ctx, i) {
                final m = months[i];
                final selected = _selectedMonth == m;
                return ListTile(
                  title: Text(m,
                      style: TextStyle(
                          color: selected ? t.primary : t.textPrimary,
                          fontWeight: selected
                              ? FontWeight.bold
                              : FontWeight.normal)),
                  trailing: selected
                      ? Icon(Icons.check, color: t.primary)
                      : null,
                  onTap: () {
                    setState(() => _selectedMonth = m);
                    Navigator.pop(ctx);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 30),
        ]),
      ),
    );
  }
}
