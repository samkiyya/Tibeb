import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:tibeb/models/achievement.dart';
import 'package:tibeb/models/achievements_data.dart';
import '../../core/database/database.dart' show ReadingSessionEntity;
import '../../core/rank/tibeb_rank_repository.dart';
import '../../core/rank/tibeb_rank_extension.dart';
import '../../models/models.dart';
import 'notification_manager.dart' show DeferredNotification;

enum BookSortBy { title, author, recent }

enum BookStatusFilter { all, unread, reading, finished }

final currentlyReadingProvider = StateProvider<Book?>((ref) => null);

class LibraryState {
  final List<Book> allBooks;
  final List<Book> filteredBooks;
  final String searchQuery;
  final bool isLoading;
  final String selectedAuthor;
  final String selectedGenre;
  final String selectedFolder;
  final BookStatusFilter statusFilter;
  final bool onlyFavorites;
  final String? selectedSeries;
  final String? selectedTag;
  final String selectedFileType;
  final BookSortBy sortBy;
  final bool sortAscending;
  final int currentStreak;
  final int totalWP;
  final int level;
  final int totalPagesRead;
  final int totalMinutesRead;
  final double weeklyPageGoal;
  final double weeklyMinuteGoal;
  final double weeklyWPGoal;
  final String weeklyGoalType;
  final Map<String, int> dailyPages;
  final Map<String, int> dailyMinutes;
  final Map<String, int> dailyWP;
  final Set<String> unlockedAchievements;
  final List<ReadingSessionEntity> sessionHistory;
  final List<DailyQuest> dailyQuests;
  final bool isStreakActiveToday;
  final bool notificationsEnabled;
  final int reminderHour;
  final int reminderMinute;

  final int lastCelebratedLevel;
  final bool isReading;
  final int totalLookups;
  final List<DeferredNotification> deferredNotifications;

  LibraryState({
    required this.allBooks,
    required this.filteredBooks,
    this.searchQuery = '',
    this.isLoading = false,
    this.selectedAuthor = 'All',
    this.selectedGenre = 'All',
    this.selectedFolder = 'All',
    this.statusFilter = BookStatusFilter.all,
    this.onlyFavorites = false,
    this.selectedSeries = 'All',
    this.selectedTag = 'All',
    this.selectedFileType = 'All',
    this.sortBy = BookSortBy.recent,
    this.sortAscending = false,
    this.currentStreak = 0,
    this.totalWP = 0,
    this.level = 1,
    this.lastCelebratedLevel = 1,
    this.totalPagesRead = 0,
    this.totalMinutesRead = 0,
    this.weeklyPageGoal = 100,
    this.weeklyMinuteGoal = 0,
    this.weeklyWPGoal = 0,
    this.weeklyGoalType = 'pages',
    this.dailyPages = const {},
    this.dailyMinutes = const {},
    this.dailyWP = const {},
    this.unlockedAchievements = const {},
    this.sessionHistory = const <ReadingSessionEntity>[],
    this.dailyQuests = const [],
    this.isStreakActiveToday = false,
    this.notificationsEnabled = true,
    this.reminderHour = 20,
    this.reminderMinute = 0,
    this.isReading = false,
    this.totalLookups = 0,
    this.deferredNotifications = const [],
  });

  double get weeklyGoalValue {
    if (weeklyGoalType == 'pages') return weeklyPageGoal;
    if (weeklyGoalType == 'minutes') return weeklyMinuteGoal;
    return weeklyWPGoal;
  }

  Map<String, int> get dailyReadingValues {
    if (weeklyGoalType == 'pages') return dailyPages;
    if (weeklyGoalType == 'minutes') return dailyMinutes;
    return dailyWP;
  }

  List<int> get activityData {
    final values = dailyReadingValues;
    final activity = List<int>.filled(31, 0);
    final now = DateTime.now();
    final todayNormalized = DateTime(now.year, now.month, now.day);

    for (var entry in values.entries) {
      final sessionDate = DateTime.parse(entry.key);
      final difference = todayNormalized.difference(sessionDate).inDays;
      if (difference >= 0 && difference < 31) {
        final val = entry.value;
        int level = 0;
        final double goal = weeklyGoalValue / 7.0;
        if (val >= goal * 2.0) {
          level = 4;
        } else if (val >= goal) {
          level = 3;
        } else if (val >= goal * 0.5) {
          level = 2;
        } else if (val > 0) {
          level = 1;
        }
        activity[30 - difference] = level;
      }
    }
    return activity;
  }

  String get rankName => TibebRankRepository.instance
      .getCurrentRank(level, unlockedAchievements.length)
      .id;

  String getRankName(BuildContext context) {
    final rank = TibebRankRepository.instance
        .getCurrentRank(level, unlockedAchievements.length);
    return rank.getName(context);
  }

  int get weeklyPagesRead => _sumForCurrentWeek(dailyPages);
  int get weeklyMinutesRead => _sumForCurrentWeek(dailyMinutes);
  int get weeklyWPRead => _sumForCurrentWeek(dailyWP);

  bool get dailyGoalReached {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final progress = dailyReadingValues[today] ?? 0;
    return progress >= (weeklyGoalValue / 7.0);
  }

List<Achievement> get sortedAchievements {
  // Map each base achievement to a copy with isUnlocked set
  final list = allAchievements.map((ach) {
    return ach.copyWith(isUnlocked: unlockedAchievements.contains(ach.id));
  }).toList();

  // Sort: unlocked first, then locked
  list.sort((a, b) {
    if (a.isUnlocked == b.isUnlocked) return 0;
    return a.isUnlocked ? -1 : 1;
  });
  return list;
}

  int _sumForCurrentWeek(Map<String, int> values) {
    final now = DateTime.now();
    final monday = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));

    int sum = 0;
    values.forEach((dateStr, val) {
      final date = DateTime.parse(dateStr);
      if (!date.isBefore(monday)) {
        sum += val;
      }
    });
    return sum;
  }

  LibraryState copyWith({
    List<Book>? allBooks,
    List<Book>? filteredBooks,
    String? searchQuery,
    bool? isLoading,
    String? selectedAuthor,
    String? selectedGenre,
    String? selectedFolder,
    BookStatusFilter? statusFilter,
    bool? onlyFavorites,
    String? selectedSeries,
    String? selectedTag,
    String? selectedFileType,
    BookSortBy? sortBy,
    bool? sortAscending,
    int? currentStreak,
    int? totalWP,
    int? level,
    int? lastCelebratedLevel,
    int? totalPagesRead,
    int? totalMinutesRead,
    double? weeklyPageGoal,
    double? weeklyMinuteGoal,
    double? weeklyWPGoal,
    String? weeklyGoalType,
    Map<String, int>? dailyPages,
    Map<String, int>? dailyMinutes,
    Map<String, int>? dailyWP,
    Set<String>? unlockedAchievements,
    List<ReadingSessionEntity>? sessionHistory,
    List<DailyQuest>? dailyQuests,
    bool? isStreakActiveToday,
    bool? notificationsEnabled,
    int? reminderHour,
    int? reminderMinute,
    bool? isReading,
    int? totalLookups,
    List<DeferredNotification>? deferredNotifications,
  }) {
    return LibraryState(
      allBooks: allBooks ?? this.allBooks,
      filteredBooks: filteredBooks ?? this.filteredBooks,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      selectedAuthor: selectedAuthor ?? this.selectedAuthor,
      selectedGenre: selectedGenre ?? this.selectedGenre,
      selectedFolder: selectedFolder ?? this.selectedFolder,
      statusFilter: statusFilter ?? this.statusFilter,
      onlyFavorites: onlyFavorites ?? this.onlyFavorites,
      selectedSeries: selectedSeries ?? this.selectedSeries,
      selectedTag: selectedTag ?? this.selectedTag,
      selectedFileType: selectedFileType ?? this.selectedFileType,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
      currentStreak: currentStreak ?? this.currentStreak,
      totalWP: totalWP ?? this.totalWP,
      level: level ?? this.level,
      lastCelebratedLevel: lastCelebratedLevel ?? this.lastCelebratedLevel,
      totalPagesRead: totalPagesRead ?? this.totalPagesRead,
      totalMinutesRead: totalMinutesRead ?? this.totalMinutesRead,
      weeklyPageGoal: weeklyPageGoal ?? this.weeklyPageGoal,
      weeklyMinuteGoal: weeklyMinuteGoal ?? this.weeklyMinuteGoal,
      weeklyWPGoal: weeklyWPGoal ?? this.weeklyWPGoal,
      weeklyGoalType: weeklyGoalType ?? this.weeklyGoalType,
      dailyPages: dailyPages ?? this.dailyPages,
      dailyMinutes: dailyMinutes ?? this.dailyMinutes,
      dailyWP: dailyWP ?? this.dailyWP,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
      sessionHistory: sessionHistory ?? this.sessionHistory,
      dailyQuests: dailyQuests ?? this.dailyQuests,
      isStreakActiveToday: isStreakActiveToday ?? this.isStreakActiveToday,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      isReading: isReading ?? this.isReading,
      totalLookups: totalLookups ?? this.totalLookups,
      deferredNotifications:
          deferredNotifications ?? this.deferredNotifications,
    );
  }
}
