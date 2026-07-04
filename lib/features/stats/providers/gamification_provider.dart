// features/stats/providers/gamification_provider.dart
//
// Extracts XP / level / streak / achievements / quests from the library god-class
// into a focused modern Riverpod Notifier.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/rank/tibeb_rank_repository.dart';
import '../../../shared/models/quest_model.dart';
import '../../../shared/services/database_service.dart';
import '../../../shared/services/notification_service.dart';

// Re-export so features can import from one place
export '../../../core/rank/tibeb_rank_repository.dart';
export '../../../core/rank/tibeb_rank_extension.dart';
export '../../../shared/models/quest_model.dart';

// ─── State ───────────────────────────────────────────────────────────────────

class GamificationState {
  final int totalXP;
  final int level;
  final int currentStreak;
  final bool isStreakActiveToday;
  final int totalPagesRead;
  final int totalMinutesRead;
  final int totalLookups;
  final Set<String> unlockedAchievements;
  final List<DailyQuest> dailyQuests;
  final Map<String, int> dailyPages;
  final Map<String, int> dailyMinutes;
  final Map<String, int> dailyXP;
  final double weeklyPageGoal;
  final double weeklyMinuteGoal;
  final double weeklyXPGoal;
  final String weeklyGoalType;
  final int lastCelebratedLevel;

  const GamificationState({
    this.totalXP = 0,
    this.level = 1,
    this.currentStreak = 0,
    this.isStreakActiveToday = false,
    this.totalPagesRead = 0,
    this.totalMinutesRead = 0,
    this.totalLookups = 0,
    this.unlockedAchievements = const {},
    this.dailyQuests = const [],
    this.dailyPages = const {},
    this.dailyMinutes = const {},
    this.dailyXP = const {},
    this.weeklyPageGoal = 100,
    this.weeklyMinuteGoal = 0,
    this.weeklyXPGoal = 0,
    this.weeklyGoalType = 'pages',
    this.lastCelebratedLevel = 1,
  });

  String get rankName => TibebRankRepository.instance
      .getCurrentRank(level, unlockedAchievements.length).id;

  int get weeklyPagesRead => _sumCurrentWeek(dailyPages);
  int get weeklyMinutesRead => _sumCurrentWeek(dailyMinutes);
  int get weeklyXPRead => _sumCurrentWeek(dailyXP);

  double get weeklyGoalValue {
    if (weeklyGoalType == 'pages') return weeklyPageGoal;
    if (weeklyGoalType == 'minutes') return weeklyMinuteGoal;
    return weeklyXPGoal;
  }

  Map<String, int> get dailyReadingValues {
    if (weeklyGoalType == 'pages') return dailyPages;
    if (weeklyGoalType == 'minutes') return dailyMinutes;
    return dailyXP;
  }

  List<int> get activityData {
    final values = dailyReadingValues;
    final activity = List<int>.filled(31, 0);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    for (final e in values.entries) {
      final d = DateTime.parse(e.key);
      final diff = today.difference(d).inDays;
      if (diff >= 0 && diff < 31) {
        final val = e.value;
        final goal = weeklyGoalValue / 7.0;
        int lvl = 0;
        if (val >= goal * 2.0) {
          lvl = 4;
        } else if (val >= goal) {lvl = 3;}
        else if (val >= goal * 0.5) {lvl = 2;}
        else if (val > 0) {lvl = 1;}
        activity[30 - diff] = lvl;
      }
    }
    return activity;
  }

  int _sumCurrentWeek(Map<String, int> values) {
    final now = DateTime.now();
    final monday = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
    int sum = 0;
    values.forEach((dateStr, val) {
      final date = DateTime.parse(dateStr);
      if (!date.isBefore(monday)) sum += val;
    });
    return sum;
  }

  GamificationState copyWith({
    int? totalXP,
    int? level,
    int? currentStreak,
    bool? isStreakActiveToday,
    int? totalPagesRead,
    int? totalMinutesRead,
    int? totalLookups,
    Set<String>? unlockedAchievements,
    List<DailyQuest>? dailyQuests,
    Map<String, int>? dailyPages,
    Map<String, int>? dailyMinutes,
    Map<String, int>? dailyXP,
    double? weeklyPageGoal,
    double? weeklyMinuteGoal,
    double? weeklyXPGoal,
    String? weeklyGoalType,
    int? lastCelebratedLevel,
  }) =>
      GamificationState(
        totalXP: totalXP ?? this.totalXP,
        level: level ?? this.level,
        currentStreak: currentStreak ?? this.currentStreak,
        isStreakActiveToday: isStreakActiveToday ?? this.isStreakActiveToday,
        totalPagesRead: totalPagesRead ?? this.totalPagesRead,
        totalMinutesRead: totalMinutesRead ?? this.totalMinutesRead,
        totalLookups: totalLookups ?? this.totalLookups,
        unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
        dailyQuests: dailyQuests ?? this.dailyQuests,
        dailyPages: dailyPages ?? this.dailyPages,
        dailyMinutes: dailyMinutes ?? this.dailyMinutes,
        dailyXP: dailyXP ?? this.dailyXP,
        weeklyPageGoal: weeklyPageGoal ?? this.weeklyPageGoal,
        weeklyMinuteGoal: weeklyMinuteGoal ?? this.weeklyMinuteGoal,
        weeklyXPGoal: weeklyXPGoal ?? this.weeklyXPGoal,
        weeklyGoalType: weeklyGoalType ?? this.weeklyGoalType,
        lastCelebratedLevel: lastCelebratedLevel ?? this.lastCelebratedLevel,
      );
}

// ─── Provider ────────────────────────────────────────────────────────────────

final gamificationProvider =
    NotifierProvider<GamificationNotifier, GamificationState>(
        GamificationNotifier.new);

class GamificationNotifier extends Notifier<GamificationState> {
  final _db = DatabaseService();

  @override
  GamificationState build() {
    _init();
    return const GamificationState();
  }

  Future<void> _init() async {
    await _loadGoals();
    await refresh();
  }

  Future<void> _loadGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final celebrated = prefs.getInt('lastCelebratedLevel') ?? 1;
    state = state.copyWith(
      weeklyPageGoal: prefs.getDouble('weeklyPageGoal') ?? 100.0,
      weeklyMinuteGoal: prefs.getDouble('weeklyMinuteGoal') ?? 0.0,
      weeklyXPGoal: prefs.getDouble('weeklyXPGoal') ?? 0.0,
      weeklyGoalType: prefs.getString('weeklyGoalType') ?? 'pages',
      lastCelebratedLevel: celebrated,
      totalLookups: prefs.getInt('totalLookups') ?? 0,
    );
  }

  Future<void> refresh() async {
    final sessions = await _db.getReadingSessions();
    final questXp = await _db.getTotalQuestXP();
    final lookupCount = await _db.getDictionaryLookupCount();
    final books = await _db.getBooks();

    final streak = _calculateStreak(sessions);
    final stats = _calculateStats(sessions, books, questXp, lookupCount);
    final activity = _calculateActivity(sessions, books);
    final isActiveToday = _isStreakActiveToday(sessions);

    state = state.copyWith(
      totalXP: stats.xp,
      level: stats.level,
      currentStreak: streak,
      isStreakActiveToday: isActiveToday,
      totalPagesRead: stats.totalPages,
      totalMinutesRead: stats.totalMinutes,
      totalLookups: lookupCount,
      unlockedAchievements: stats.achievements,
      dailyPages: activity.pages,
      dailyMinutes: activity.minutes,
      dailyXP: activity.xp,
    );

    await _loadOrCreateQuests(sessions);
  }

  Future<void> recordProgress(
    int bookId, {
    required int pagesRead,
    required int minutesRead,
  }) async {
    if (pagesRead <= 0 && minutesRead <= 0) return;
    await refresh();
    await _updateQuests(pagesRead, minutesRead);
  }

  Future<void> recordLookup() async {
    await refresh();
    await _updateDictionaryQuests();
  }

  Future<void> updateWeeklyGoals({
    double? pages,
    double? minutes,
    double? xp,
    String? activeType,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (pages != null) await prefs.setDouble('weeklyPageGoal', pages);
    if (minutes != null) await prefs.setDouble('weeklyMinuteGoal', minutes);
    if (xp != null) await prefs.setDouble('weeklyXPGoal', xp);
    if (activeType != null) await prefs.setString('weeklyGoalType', activeType);
    state = state.copyWith(
      weeklyPageGoal: pages ?? state.weeklyPageGoal,
      weeklyMinuteGoal: minutes ?? state.weeklyMinuteGoal,
      weeklyXPGoal: xp ?? state.weeklyXPGoal,
      weeklyGoalType: activeType ?? state.weeklyGoalType,
    );
    await refresh();
  }

  Future<void> markLevelCelebrated(int level) async {
    state = state.copyWith(lastCelebratedLevel: level);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastCelebratedLevel', level);
  }

  // ─── Quest logic ───────────────────────────────────────────────────────

  Future<void> _loadOrCreateQuests(List<Map<String, dynamic>> sessions) async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final questMaps = await _db.getQuestsForDate(today);
    if (questMaps.isEmpty) {
      final newQuests = _generateDailyQuests(today);
      for (final q in newQuests) {
        await _db.insertQuest(q.toMap());
      }
      state = state.copyWith(dailyQuests: newQuests);
    } else {
      state = state.copyWith(
        dailyQuests: questMaps.map(DailyQuest.fromMap).toList(),
      );
    }
  }

  List<DailyQuest> _generateDailyQuests(String dateStr) {
    final date = DateTime.parse(dateStr);
    final isWeekend =
        date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
    final multiplier = isWeekend ? 2 : 1;
    return [
      DailyQuest(
        id: 'pages_$dateStr',
        title: 'Daily Reader',
        description: 'Read 5 pages today.',
        type: QuestType.pages,
        targetValue: 5,
        xpReward: 100 * multiplier,
        date: date,
      ),
      DailyQuest(
        id: 'minutes_$dateStr',
        title: 'Deep Focus',
        description: 'Read for 15 minutes.',
        type: QuestType.minutes,
        targetValue: 15,
        xpReward: 150 * multiplier,
        date: date,
      ),
      DailyQuest(
        id: 'early_$dateStr',
        title: 'Early Bird',
        description: 'Read before 9:00 AM.',
        type: QuestType.earlyBird,
        targetValue: 1,
        xpReward: 200 * multiplier,
        date: date,
      ),
    ];
  }

  Future<void> _updateQuests(int pages, int minutes) async {
    final now = DateTime.now();
    final updated = <DailyQuest>[];
    bool changed = false;

    for (final quest in state.dailyQuests) {
      if (quest.isCompleted) { updated.add(quest); continue; }
      int newVal = quest.currentValue;
      switch (quest.type) {
        case QuestType.pages: newVal += pages; break;
        case QuestType.minutes: newVal += minutes; break;
        case QuestType.earlyBird:
          if (now.hour < 9) newVal = 1;
          break;
        case QuestType.nightOwl:
          if (now.hour >= 22 || now.hour < 1) newVal = 1;
          break;
        default: break;
      }
      final completed = newVal >= quest.targetValue;
      if (newVal != quest.currentValue) {
        final q = quest.copyWith(
          currentValue: completed ? quest.targetValue : newVal,
          isCompleted: completed,
        );
        updated.add(q);
        await _db.updateQuestProgress(q.id, q.currentValue, q.isCompleted);
        if (completed) {
          NotificationService().showNotification(
            id: q.id.hashCode,
            title: 'Quest Completed!',
            body: 'You completed: ${q.title}. +${q.xpReward} XP earned!',
          );
        }
        changed = true;
      } else {
        updated.add(quest);
      }
    }
    if (changed) {
      state = state.copyWith(dailyQuests: updated);
      await refresh();
    }
  }

  Future<void> _updateDictionaryQuests() async {
    final updated = <DailyQuest>[];
    bool changed = false;
    for (final quest in state.dailyQuests) {
      if (quest.type == QuestType.dictionaryLookup && !quest.isCompleted) {
        final newVal = quest.currentValue + 1;
        final completed = newVal >= quest.targetValue;
        final q = quest.copyWith(
          currentValue: completed ? quest.targetValue : newVal,
          isCompleted: completed,
        );
        updated.add(q);
        await _db.updateQuestProgress(q.id, q.currentValue, q.isCompleted);
        changed = true;
      } else {
        updated.add(quest);
      }
    }
    if (changed) state = state.copyWith(dailyQuests: updated);
  }

  // ─── Stats / XP calculation ────────────────────────────────────────────

  _Stats _calculateStats(
    List<Map<String, dynamic>> sessions,
    List books,
    int questXp,
    int lookupCount,
  ) {
    int totalPages = 0, totalMinutes = 0, xp = 0;
    for (final s in sessions) {
      final p = (s['pagesRead'] as int? ?? 0);
      final m = (s['durationMinutes'] as int? ?? 0);
      totalPages += p;
      totalMinutes += m;

      double mult = 1.0;
      final ts = s['timestamp'] != null
          ? DateTime.tryParse(s['timestamp']) ?? DateTime.parse(s['date'])
          : DateTime.parse(s['date']);
      if (ts.weekday == DateTime.saturday || ts.weekday == DateTime.sunday) {
        mult = 2.0;
      } else if ((ts.hour >= 6 && ts.hour < 9) ||
          ts.hour >= 22 || ts.hour < 1) {
        mult = 1.5;
      }
      xp += ((p * 10 + m * 5) * mult).round();
    }
    xp += questXp;
    int level = (xp ~/ 1000) + 1;
    if (level > 99) level = 99;

    final finishedBooks = books.where((b) => b.progress >= 0.99).length;
    final streak = _calculateStreak(sessions);
    final achievements = _computeAchievements(
      sessions: sessions,
      books: books,
      totalPages: totalPages,
      streak: streak,
      finishedBooks: finishedBooks,
      lookupCount: lookupCount,
    );
    return _Stats(xp: xp, level: level, totalPages: totalPages,
        totalMinutes: totalMinutes, achievements: achievements);
  }

  Set<String> _computeAchievements({
    required List<Map<String, dynamic>> sessions,
    required List books,
    required int totalPages,
    required int streak,
    required int finishedBooks,
    required int lookupCount,
  }) {
    final a = <String>{};
    if (finishedBooks >= 1) a.add('the_first_page');
    if (streak >= 3) a.add('habit_builder');
    if (streak >= 7) a.add('seven_day_streak');
    if (streak >= 30) a.add('unstoppable');
    if (totalPages >= 1000) a.add('bookworm');
    if (totalPages >= 5000) a.add('scholar');
    if (finishedBooks >= 10) a.add('yomibito');
    if (finishedBooks >= 50) a.add('sensei');
    if (books.where((b) => !b.isDeleted).length >= 10) a.add('bibliophile');
    if (books.where((b) => !b.isDeleted).length >= 100) a.add('collector');
    for (final s in sessions) {
      final p = (s['pagesRead'] as int? ?? 0);
      final m = (s['durationMinutes'] as int? ?? 0);
      final ts = s['timestamp'] != null
          ? DateTime.tryParse(s['timestamp']) ?? DateTime.parse(s['date'])
          : DateTime.parse(s['date']);
      if (p >= 100) a.add('century_club');
      if (m >= 120) a.add('marathoner');
      if (ts.hour >= 6 && ts.hour < 9) a.add('early_bird');
      if (ts.hour >= 22 || ts.hour < 1) a.add('night_owl');
      if (ts.weekday == DateTime.saturday) a.add('_readSat');
      if (ts.weekday == DateTime.sunday) a.add('_readSun');
    }
    if (a.contains('_readSat') && a.contains('_readSun')) {
      a.add('weekend_warrior');
    }
    a.remove('_readSat');
    a.remove('_readSun');
    if (lookupCount >= 1) a.add('the_translator');
    if (lookupCount >= 20) a.add('vocabulary_builder');
    if (lookupCount >= 100) a.add('polyglot');
    return a;
  }

  int _calculateStreak(List<Map<String, dynamic>> sessions) {
    if (sessions.isEmpty) return 0;
    final dates = sessions
        .map((s) => DateTime.parse(s['date'] as String))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));
    final today = DateTime.now();
    final todayN = DateTime(today.year, today.month, today.day);
    final yestN = todayN.subtract(const Duration(days: 1));
    if (!dates.contains(todayN) && !dates.contains(yestN)) return 0;
    int streak = 0;
    DateTime check = dates.contains(todayN) ? todayN : yestN;
    while (dates.contains(check)) {
      streak++;
      check = check.subtract(const Duration(days: 1));
    }
    return streak;
  }

  bool _isStreakActiveToday(List<Map<String, dynamic>> sessions) {
    final today = DateTime.now().toIso8601String().split('T')[0];
    return sessions.any((s) => s['date'] == today);
  }

  _Activity _calculateActivity(
    List<Map<String, dynamic>> sessions,
    List books,
  ) {
    final pages = <String, int>{};
    final minutes = <String, int>{};
    final xpMap = <String, int>{};
    for (final s in sessions) {
      final date = s['date'] as String;
      final p = (s['pagesRead'] as int? ?? 0);
      final m = (s['durationMinutes'] as int? ?? 0);
      pages[date] = (pages[date] ?? 0) + p;
      minutes[date] = (minutes[date] ?? 0) + m;
      xpMap[date] = (xpMap[date] ?? 0) + p * 10 + m * 5;
    }
    return _Activity(pages: pages, minutes: minutes, xp: xpMap);
  }
}

class _Stats {
  final int xp, level, totalPages, totalMinutes;
  final Set<String> achievements;
  _Stats({required this.xp, required this.level, required this.totalPages,
      required this.totalMinutes, required this.achievements});
}

class _Activity {
  final Map<String, int> pages, minutes, xp;
  _Activity({required this.pages, required this.minutes, required this.xp});
}
