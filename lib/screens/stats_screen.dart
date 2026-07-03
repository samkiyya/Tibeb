import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../core/theme/semantics/color_scheme.dart';
import '../core/theme/tokens/spacing.dart';
import '../components/glass_container.dart';
import '../components/activity_graph.dart';
import '../components/stat_badge.dart';
import '../components/daily_activity_sheet.dart';
import '../providers/library_provider.dart';
import './stats/widgets/level_info_card.dart';
import './stats/widgets/weekly_goal_card.dart';
import './stats/widgets/achievements_grid.dart';
import './stats/widgets/goal_settings_sheet.dart';
import './stats/widgets/level_metadata_sheet.dart';
import '../components/daily_quests_card.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  String _selectedMonth = DateFormat('MMMM yyyy').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final libraryState = ref.watch(libraryProvider);
    final t = context.tibpiColors;

    return Scaffold(
      backgroundColor: t.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(TibebSpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reading Stats',
                style: context.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: t.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              LevelInfoCard(
                state: libraryState,
                onTap: () => _showLevelMetadata(context, libraryState),
              ),
              const SizedBox(height: 32),
              _buildQuickStats(context, t, libraryState),
              const SizedBox(height: 32),
              WeeklyGoalCard(
                state: libraryState,
                onEdit: () => _showGoalSettings(context),
              ),
              const SizedBox(height: 32),
              DailyQuestsCard(quests: libraryState.dailyQuests),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Reading Activity',
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: t.textPrimary,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _showMonthPicker(context, t),
                    icon: const Icon(Icons.calendar_month, size: 18),
                    label: Text(_selectedMonth),
                    style: TextButton.styleFrom(
                      foregroundColor: t.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ActivityGraph(
                dailyValues: libraryState.dailyReadingValues,
                selectedMonth: _selectedMonth,
                weeklyGoalType: libraryState.weeklyGoalType,
                weeklyGoalValue: libraryState.weeklyGoalValue,
                onDateTapped: (date, value) => _showDailyActivityDetail(
                  context,
                  libraryState,
                  date,
                  value,
                ),
              ),
              const SizedBox(height: 32),
              AchievementsGrid(state: libraryState),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  void _showLevelMetadata(BuildContext context, LibraryState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LevelMetadataSheet(state: state),
    );
  }

  Widget _buildQuickStats(BuildContext context, TibebThemeExtension t, LibraryState state) {
    final Color streakColor = state.isStreakActiveToday
        ? (state.currentStreak >= 30
            ? t.xpGold
            : (state.currentStreak >= 7 ? t.streakFire : t.primary))
        : t.textSecondary;

    return Row(
      children: [
        Expanded(
          child: StatBadge(
            label: 'Streak',
            value: '${state.currentStreak}',
            icon: Icons.local_fire_department,
            color: streakColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatBadge(
            label: 'Pages',
            value: '${state.totalPagesRead}',
            icon: Icons.auto_stories,
            color: t.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: StatBadge(
            label: 'Minutes',
            value: '${state.totalMinutesRead}',
            icon: Icons.timer,
            color: t.streakFire,
          ),
        ),
      ],
    );
  }

  void _showDailyActivityDetail(
    BuildContext context,
    LibraryState state,
    DateTime date,
    int totalValue,
  ) {
    if (totalValue == 0) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => DailyActivitySheet(
        date: date,
        totalValue: totalValue,
        goalType: state.weeklyGoalType,
        allBooks: state.allBooks,
        sessionHistory: state.sessionHistory,
      ),
    );
  }

  void _showGoalSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const GoalSettingsSheet(),
    );
  }

  void _showMonthPicker(BuildContext context, TibebThemeExtension t) {
    final state = ref.read(libraryProvider);
    final sessions = state.dailyReadingValues.keys.toList();

    final Set<String> availableMonthsSet = {};
    availableMonthsSet.add(DateFormat('MMMM yyyy').format(DateTime.now()));

    for (var dateStr in sessions) {
      try {
        final date = DateTime.parse(dateStr);
        availableMonthsSet.add(DateFormat('MMMM yyyy').format(date));
      } catch (_) {}
    }

    final availableMonths = availableMonthsSet.toList()
      ..sort((a, b) {
        final dateA = DateFormat('MMMM yyyy').parse(a);
        final dateB = DateFormat('MMMM yyyy').parse(b);
        return dateB.compareTo(dateA);
      });

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GlassContainer(
          borderRadius: 20,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: t.borderSubtle,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Select Month',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: t.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: availableMonths.length,
                  itemBuilder: (context, index) {
                    final m = availableMonths[index];
                    return ListTile(
                      title: Text(
                        m,
                        style: TextStyle(
                          color: _selectedMonth == m
                              ? t.primary
                              : t.textPrimary,
                          fontWeight: _selectedMonth == m
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      trailing: _selectedMonth == m
                          ? Icon(Icons.check, color: t.primary)
                          : null,
                      onTap: () {
                        setState(() => _selectedMonth = m);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }
}
