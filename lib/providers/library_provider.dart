import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';
import '../core/database/database.dart' show ReadingSessionEntity;
import '../core/rank/tibeb_rank_extension.dart';
import '../core/rank/tibeb_rank_repository.dart';
import '../core/repositories/database_repository.dart';
import '../models/book_model.dart';
import '../models/bookmark_model.dart';
import '../models/quest_model.dart';
import '../models/vocabulary_model.dart';
import '../services/book_service.dart';
import '../services/notification_service.dart';
import 'database_providers.dart';

enum BookSortBy { title, author, recent }

enum BookStatusFilter { all, unread, reading, finished }

final currentlyReadingProvider = StateProvider<Book?>((ref) => null);

class DeferredNotification {
  final String title;
  final String body;
  final int id;

  DeferredNotification({
    required this.title,
    required this.body,
    required this.id,
  });
}

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
      .name;

  int get weeklyPagesRead => _sumForCurrentWeek(dailyPages);
  int get weeklyMinutesRead => _sumForCurrentWeek(dailyMinutes);
  int get weeklyWPRead => _sumForCurrentWeek(dailyWP);

  bool get dailyGoalReached {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final progress = dailyReadingValues[today] ?? 0;
    return progress >= (weeklyGoalValue / 7.0);
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

final libraryProvider = StateNotifierProvider<LibraryNotifier, LibraryState>((
  ref,
) {
  return LibraryNotifier(ref);
});

class LibraryNotifier extends StateNotifier<LibraryState> {
  final Ref _ref;
  late final DatabaseRepository _db;
  final BookService _bookService = BookService();

  LibraryNotifier(this._ref)
    : super(
        LibraryState(
          allBooks: [],
          filteredBooks: [],
          searchQuery: '',
          isLoading: true,
          selectedAuthor: 'All',
          selectedGenre: 'All',
          selectedFolder: 'All',
          statusFilter: BookStatusFilter.all,
          onlyFavorites: false,
          selectedSeries: 'All',
          selectedTag: 'All',
          selectedFileType: 'All',
          sortBy: BookSortBy.recent,
          sortAscending: false,
        ),
      ) {
    _db = _ref.read(databaseRepositoryProvider);
    _init();
  }

  void setReadingActive(bool active) {
    bool wasReading = state.isReading;
    state = state.copyWith(isReading: active);

    // If we just stopped reading, process deferred notifications
    if (wasReading && !active && state.deferredNotifications.isNotEmpty) {
      _processDeferredNotifications();
    }
  }

  void _processDeferredNotifications() async {
    final notifications = List<DeferredNotification>.from(
      state.deferredNotifications,
    );
    state = state.copyWith(deferredNotifications: []);

    for (var i = 0; i < notifications.length; i++) {
      final dn = notifications[i];
      // Show with a slight stagger if there are multiple
      await Future.delayed(Duration(milliseconds: i * 1500));
      NotificationService().showNotification(
        id: dn.id,
        title: dn.title,
        body: dn.body,
      );
    }
  }

  Future<void> _init() async {
    try {
      await _loadGoal();
      await loadBooks();
      await _loadQuests();

      if (state.notificationsEnabled) {
        await NotificationService().scheduleDailyReminder(
          id: 999,
          title: 'Time to read!',
          body: 'Keep your streak alive and dive back into your books.',
          hour: state.reminderHour,
          minute: state.reminderMinute,
        );
        await NotificationService().scheduleWeekendBoostNotifications();
      }
    } catch (e) {
      debugPrint('Error during LibraryNotifier init: $e');
      // Ensure loading is stopped even on init error
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> _loadGoal() async {
    final prefs = await SharedPreferences.getInstance();
    final pageGoal = prefs.getDouble('weeklyPageGoal');
    final minuteGoal = prefs.getDouble('weeklyMinuteGoal') ?? 0.0;
    final wpGoal = prefs.getDouble('weeklyWPGoal') ?? 0.0;

    final notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    final reminderHour = prefs.getInt('reminderHour') ?? 20;
    final reminderMinute = prefs.getInt('reminderMinute') ?? 0;

    // Migration
    double finalPageGoal = pageGoal ?? 100.0;
    String finalType = prefs.getString('weeklyGoalType') ?? 'pages';

    if (pageGoal == null) {
      // Check for old value
      final oldVal = prefs.getDouble('weeklyGoalValue');
      if (oldVal != null) {
        if (finalType == 'pages') {
          finalPageGoal = oldVal;
        }
        // If it was minutes, we migrate that too if minuteGoal is still 0
        if (finalType == 'minutes' && minuteGoal == 0) {
          // Temporarily set it, though we now have dedicated fields
          await prefs.setDouble('weeklyMinuteGoal', oldVal);
        }
      }
    }

    final celebrated = prefs.getInt('lastCelebratedLevel') ?? 1;
    state = state.copyWith(
      weeklyPageGoal: finalPageGoal,
      weeklyMinuteGoal: minuteGoal,
      weeklyWPGoal: wpGoal,
      weeklyGoalType: finalType,
      lastCelebratedLevel: celebrated,
      notificationsEnabled: notificationsEnabled,
      reminderHour: reminderHour,
      reminderMinute: reminderMinute,
      totalLookups: prefs.getInt('totalLookups') ?? 0,
    );
  }

  Future<void> updateNotificationSettings({
    bool? enabled,
    int? hour,
    int? minute,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (enabled != null) {
      await prefs.setBool('notificationsEnabled', enabled);
    }
    if (hour != null) {
      await prefs.setInt('reminderHour', hour);
    }
    if (minute != null) {
      await prefs.setInt('reminderMinute', minute);
    }

    state = state.copyWith(
      notificationsEnabled: enabled ?? state.notificationsEnabled,
      reminderHour: hour ?? state.reminderHour,
      reminderMinute: minute ?? state.reminderMinute,
    );

    if (state.notificationsEnabled) {
      await NotificationService().scheduleDailyReminder(
        id: 999,
        title: 'Time to read!',
        body: 'Keep your streak alive and dive back into your books.',
        hour: state.reminderHour,
        minute: state.reminderMinute,
      );
      await NotificationService().scheduleWeekendBoostNotifications();
    } else {
      await NotificationService().cancel(id: 999);
      await NotificationService().cancel(id: 1000);
      await NotificationService().cancel(id: 1001);
    }
  }

  Future<void> markLevelCelebrated(int level) async {
    state = state.copyWith(lastCelebratedLevel: level);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastCelebratedLevel', level);
  }

  Future<void> loadBooks() async {
    state = state.copyWith(isLoading: true);
    try {
      final books = await _db.getBooks();
      final sessions = await _db.getReadingSessions();
      final questWp = await _db.getTotalQuestWP();
      final lookupCount = await _db.getDictionaryLookupCount();

      final streak = _calculateStreak(sessions);
      final activity = _calculateDetailedActivity(sessions, books);
      final stats = _calculateStats(sessions, books, questWp, lookupCount);
      final visibleBooks = books.where((b) => !b.isDeleted).toList();

      state = state.copyWith(
        allBooks: visibleBooks,
        filteredBooks: _applyFilters(visibleBooks, state),
        isLoading: false,
        currentStreak: streak,
        isStreakActiveToday: _isStreakActiveToday(sessions),
        dailyPages: activity.pages,
        dailyMinutes: activity.minutes,
        dailyWP: activity.wp,
        totalWP: stats.wp,
        level: stats.level,
        totalPagesRead: stats.totalPages,
        totalMinutesRead: stats.totalMinutes,
        unlockedAchievements: stats.achievements,
        sessionHistory: sessions,
        totalLookups: lookupCount,
      );

      await _loadQuests();
    } catch (e) {
      debugPrint('Error loading books: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  bool _isStreakActiveToday(List<ReadingSessionEntity> sessions) {
    if (sessions.isEmpty) return false;
    final today = DateTime.now().toIso8601String().split('T')[0];
    return sessions.any((s) => s.date == today);
  }

  Future<void> _loadQuests() async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final quests = await _db.getQuestsForDate(today);

    if (quests.isEmpty) {
      final newQuests = _generateDailyQuests(today);
      for (var q in newQuests) {
        await _db.insertQuest(q);
      }
      state = state.copyWith(dailyQuests: newQuests);
    } else {
      state = state.copyWith(dailyQuests: quests);
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
        wpReward: 100 * multiplier,
        date: date,
      ),
      DailyQuest(
        id: 'minutes_$dateStr',
        title: 'Deep Focus',
        description: 'Read for 15 minutes.',
        type: QuestType.minutes,
        targetValue: 15,
        wpReward: 150 * multiplier,
        date: date,
      ),
      DailyQuest(
        id: 'early_$dateStr',
        title: 'Early Bird',
        description: 'Read before 9:00 AM.',
        type: QuestType.earlyBird,
        targetValue: 1,
        wpReward: 200 * multiplier,
        date: date,
      ),
    ];
  }

  _UserStats _calculateStats(
    List<ReadingSessionEntity> sessions,
    List<Book> books,
    int questWp,
    int lookupCount,
  ) {
    int totalPages = 0;
    int totalMinutes = 0;
    for (var s in sessions) {
      totalPages += s.pagesRead;
      totalMinutes += s.durationMinutes;
    }

    final finishedBooks = books.where((b) => b.progress >= 0.99).length;
    final streak = _calculateStreak(sessions);

    // WP calculation:
    // PDF: 10 per page, 5 per minute
    // EPUB: 40 per chapter (since epubs "pages" are chapters), 5 per minute
    int wp = 0;
    for (var s in sessions) {
      final pg = s.pagesRead;
      final m = s.durationMinutes;
      final sessionTimestamp = s.timestamp;

      double multiplier = 1.0;
      if (sessionTimestamp.hour >= 6 && sessionTimestamp.hour < 9) {
        multiplier = 1.5;
      } else if (sessionTimestamp.hour >= 22 || sessionTimestamp.hour < 1) {
        multiplier = 1.5;
      }
      if (sessionTimestamp.weekday == DateTime.saturday ||
          sessionTimestamp.weekday == DateTime.sunday) {
        multiplier = 2.0;
      }
      wp += ((pg * 10 + m * 5) * multiplier).round();
    }

    // Add Quest WP from historical database
    wp += questWp;

    // Level calculation: 1 level per 1000 WP
    int level = (wp ~/ 1000) + 1;
    if (level > 99) level = 99;

    // Achievements check
    // Achievements check
    final achievements = <String>{};
    if (finishedBooks >= 1) achievements.add('the_first_page');
    if (streak >= 3) achievements.add('habit_builder');
    if (streak >= 7) achievements.add('seven_day_streak');
    if (streak >= 30) achievements.add('unstoppable');
    if (totalPages >= 1000) achievements.add('bookworm');
    if (totalPages >= 5000) achievements.add('scholar');
    if (finishedBooks >= 10) achievements.add('yomibito');
    if (finishedBooks >= 50) achievements.add('sensei');
    if (books.where((b) => !b.isDeleted).length >= 10) {
      achievements.add('bibliophile');
    }
    if (books.where((b) => !b.isDeleted).length >= 100) {
      achievements.add('collector');
    }

    // Time & Session based achievements
    final readOnSat = sessions.any(
      (s) => s.timestamp.weekday == DateTime.saturday,
    );
    final readOnSun = sessions.any(
      (s) => s.timestamp.weekday == DateTime.sunday,
    );
    if (readOnSat && readOnSun) achievements.add('weekend_warrior');

    for (var s in sessions) {
      final pages = s.pagesRead;
      final minutes = s.durationMinutes;
      final ts = s.timestamp;

      if (pages >= 100) achievements.add('century_club');
      if (minutes >= 120) achievements.add('marathoner');
      if (ts.hour >= 6 && ts.hour < 9) achievements.add('early_bird');
      if (ts.hour >= 22 || ts.hour < 1) achievements.add('night_owl');
    }

    if (lookupCount >= 1) achievements.add('the_translator');
    if (lookupCount >= 20) achievements.add('vocabulary_builder');
    if (lookupCount >= 100) achievements.add('polyglot');

    return _UserStats(
      wp: wp,
      level: level,
      totalPages: totalPages,
      totalMinutes: totalMinutes,
      achievements: achievements,
    );
  }

  int _calculateStreak(List<ReadingSessionEntity> sessions) {
    if (sessions.isEmpty) return 0;

    final readDates = sessions
        .map((s) => s.date)
        .toSet()
        .map((d) => DateTime.parse(d))
        .toList();

    if (readDates.isEmpty) return 0;

    readDates.sort((a, b) => b.compareTo(a)); // Newest first

    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);
    final yesterdayNormalized = todayNormalized.subtract(
      const Duration(days: 1),
    );

    if (!readDates.contains(todayNormalized) &&
        !readDates.contains(yesterdayNormalized)) {
      return 0;
    }

    int streak = 0;
    DateTime currentCheck = readDates.contains(todayNormalized)
        ? todayNormalized
        : yesterdayNormalized;

    while (readDates.contains(currentCheck)) {
      streak++;
      currentCheck = currentCheck.subtract(const Duration(days: 1));
    }

    return streak;
  }

  _DetailedActivityData _calculateDetailedActivity(
    List<ReadingSessionEntity> sessions,
    List<Book> books,
  ) {
    final pages = <String, int>{};
    final minutes = <String, int>{};
    final wpMap = <String, int>{};

    for (var session in sessions) {
      final date = session.date;
      final bookId = session.bookId;
      final book = books.firstWhere(
        (b) => b.id == bookId,
        orElse: () => books.isNotEmpty
            ? books[0]
            : Book(
                title: 'Unknown',
                author: 'Unknown',
                coverPath: '',
                filePath: '',
                addedAt: DateTime.now(),
              ),
      );
      final isEpub = book.filePath.toLowerCase().endsWith('.epub');

      final pg = session.pagesRead;
      final m = session.durationMinutes;

      final wp = isEpub ? (pg * 40) + (m * 5) : (pg * 10) + (m * 5);

      pages[date] = (pages[date] ?? 0) + pg;
      minutes[date] = (minutes[date] ?? 0) + m;
      wpMap[date] = (wpMap[date] ?? 0) + wp;
    }

    return _DetailedActivityData(pages: pages, minutes: minutes, wp: wpMap);
  }

  // Helper getters for backward compat on graph if needed
  Map<String, int> get dailyReadingValues {
    if (state.weeklyGoalType == 'pages') return state.dailyPages;
    if (state.weeklyGoalType == 'minutes') return state.dailyMinutes;
    return state.dailyWP;
  }

  void setSearchQuery(String query) {
    final newState = state.copyWith(searchQuery: query);
    state = newState.copyWith(
      filteredBooks: _applyFilters(state.allBooks, newState),
    );
  }

  void setSortBy(BookSortBy sortBy) {
    final newState = state.copyWith(sortBy: sortBy);
    state = newState.copyWith(
      filteredBooks: _applyFilters(state.allBooks, newState),
    );
  }

  void toggleSortOrder() {
    final newState = state.copyWith(sortAscending: !state.sortAscending);
    state = newState.copyWith(
      filteredBooks: _applyFilters(state.allBooks, newState),
    );
  }

  void setStatusFilter(BookStatusFilter filter) {
    // Toggle: if clicking already selected tab, clear it
    final targetFilter = state.statusFilter == filter
        ? BookStatusFilter.all
        : filter;
    final newState = state.copyWith(statusFilter: targetFilter);
    state = newState.copyWith(
      filteredBooks: _applyFilters(state.allBooks, newState),
    );
  }

  void toggleFavoriteOnly() {
    final newState = state.copyWith(onlyFavorites: !state.onlyFavorites);
    state = newState.copyWith(
      filteredBooks: _applyFilters(state.allBooks, newState),
    );
  }

  void setAuthorFilter(String author) {
    // Toggle: if clicking already selected author, set to 'All'
    final targetAuthor = state.selectedAuthor == author ? 'All' : author;
    final newState = state.copyWith(selectedAuthor: targetAuthor);
    state = newState.copyWith(
      filteredBooks: _applyFilters(state.allBooks, newState),
    );
  }

  void setGenreFilter(String genre) {
    // Toggle: if clicking already selected genre, set to 'All'
    final targetGenre = state.selectedGenre == genre ? 'All' : genre;
    final newState = state.copyWith(selectedGenre: targetGenre);
    state = newState.copyWith(
      filteredBooks: _applyFilters(state.allBooks, newState),
    );
  }

  void setFolderFilter(String folder) {
    final newState = state.copyWith(selectedFolder: folder);
    state = newState.copyWith(
      filteredBooks: _applyFilters(state.allBooks, newState),
    );
  }

  void setSeriesFilter(String series) {
    final newState = state.copyWith(selectedSeries: series);
    state = newState.copyWith(
      filteredBooks: _applyFilters(state.allBooks, newState),
    );
  }

  void setFileTypeFilter(String fileType) {
    final newState = state.copyWith(selectedFileType: fileType);
    state = newState.copyWith(
      filteredBooks: _applyFilters(state.allBooks, newState),
    );
  }

  void setTagFilter(String tag) {
    final newState = state.copyWith(selectedTag: tag);
    state = newState.copyWith(
      filteredBooks: _applyFilters(state.allBooks, newState),
    );
  }

  List<Book> _applyFilters(List<Book> books, LibraryState currentState) {
    List<Book> filtered = List.from(books);

    // 1. Search filter
    if (currentState.searchQuery.isNotEmpty) {
      final query = currentState.searchQuery.toLowerCase();
      filtered = filtered
          .where(
            (b) =>
                b.title.toLowerCase().contains(query) ||
                b.author.toLowerCase().contains(query),
          )
          .toList();
    }

    // 2. Author filter
    if (currentState.selectedAuthor != 'All') {
      filtered = filtered
          .where((b) => b.author == currentState.selectedAuthor)
          .toList();
    }

    // 2.1 Genre filter
    if (currentState.selectedGenre != 'All') {
      filtered = filtered
          .where((b) => b.genre == currentState.selectedGenre)
          .toList();
    }

    // 3. Status filter
    if (currentState.statusFilter != BookStatusFilter.all) {
      filtered = filtered.where((b) {
        switch (currentState.statusFilter) {
          case BookStatusFilter.unread:
            return b.progress == 0;
          case BookStatusFilter.reading:
            return b.progress > 0 && b.progress < 0.95;
          case BookStatusFilter.finished:
            return b.progress >= 0.95;
          default:
            return true;
        }
      }).toList();
    }

    // 4. Favorites filter
    if (currentState.onlyFavorites) {
      filtered = filtered.where((b) => b.isFavorite).toList();
    }

    // 5. Folder filter
    if (currentState.selectedFolder != 'All') {
      filtered = filtered
          .where((b) => b.folderPath == currentState.selectedFolder)
          .toList();
    }

    // 6. Series filter
    if (currentState.selectedSeries != 'All') {
      filtered = filtered
          .where((b) => b.series == currentState.selectedSeries)
          .toList();
    }

    // 7. Tags filter
    if (currentState.selectedTag != 'All') {
      filtered = filtered
          .where(
            (b) =>
                b.tags != null &&
                b.tags!
                    .split(',')
                    .map((e) => e.trim())
                    .contains(currentState.selectedTag),
          )
          .toList();
    }

    // 7.5 FileType filter
    if (currentState.selectedFileType != 'All') {
      filtered = filtered.where((b) {
        if (currentState.selectedFileType == 'EPUB') {
          return b.filePath.toLowerCase().endsWith('.epub');
        } else if (currentState.selectedFileType == 'PDF') {
          return b.filePath.toLowerCase().endsWith('.pdf');
        }
        return true;
      }).toList();
    }

    // 8. Sorting
    filtered.sort((a, b) {
      int cmp;
      switch (currentState.sortBy) {
        case BookSortBy.title:
          cmp = a.title.toLowerCase().compareTo(b.title.toLowerCase());
          break;
        case BookSortBy.author:
          cmp = a.author.toLowerCase().compareTo(b.author.toLowerCase());
          break;
        case BookSortBy.recent:
          cmp = a.addedAt.compareTo(b.addedAt);
          break;
      }
      return currentState.sortAscending ? cmp : -cmp;
    });

    return filtered;
  }

  Future<List<Book>> importFiles(List<String> paths) async {
    state = state.copyWith(isLoading: true);
    final List<Book> result = [];
    final existing = await _db.getBooks();

    for (var path in paths) {
      final file = io.File(path);
      final book = await _bookService.processFile(file);
      if (book != null) {
        final duplicate = existing.firstWhereOrNull(
          (b) =>
              b.filePath == book.filePath ||
              (book.contentHash != null && b.contentHash == book.contentHash),
        );

        if (duplicate == null) {
          final bookToInsert = book.copyWith(folderPath: p.dirname(path));
          final id = await _db.insertBook(bookToInsert);
          result.add(bookToInsert.copyWith(id: id));
        } else if (duplicate.isDeleted) {
          debugPrint('Restoring soft-deleted book: ${duplicate.title}');
          final bookToUpdate = duplicate.copyWith(
            isDeleted: false,
            folderPath: p.dirname(path),
            filePath: path,
          );
          await _db.updateBook(bookToUpdate);
          await _db.restoreBook(duplicate.id!);
          result.add(bookToUpdate);
        } else {
          debugPrint('Duplicate book found, skipping: ${book.title}');
          result.add(duplicate);
        }
      }
    }
    await loadBooks();
    return result;
  }

  Future<void> updateBookProgress(
    int bookId,
    double progress, {
    int? pagesRead,
    int? durationMinutes,
    int? currentPage,
    int? totalPages,
    String? lastPosition,
    bool estimateReadingTime = true,
  }) async {
    final book = state.allBooks.firstWhereOrNull((b) => b.id == bookId);
    if (book == null) return;
    final oldProgress = book.progress;

    // Calculate estimated reading time if we have total pages
    int estimatedMinutes = 0;
    if (totalPages != null && currentPage != null && totalPages > 0) {
      final pagesRemaining = totalPages - currentPage;
      if (pagesRemaining > 0) {
        final readingSpeed = await _getReadingSpeed();
        estimatedMinutes = (pagesRemaining / readingSpeed).ceil();
      }
    }

    final updatedBook = book.copyWith(
      progress: progress,
      lastReadAt: DateTime.now(),
      currentPage: currentPage ?? book.currentPage,
      totalPages: totalPages ?? book.totalPages,
      estimatedReadingMinutes: estimatedMinutes > 0
          ? estimatedMinutes
          : book.estimatedReadingMinutes,
      lastPosition: lastPosition ?? book.lastPosition,
    );
    await _db.updateBook(updatedBook);

    // Record session
    int finalPages = pagesRead ?? 0;
    int finalMinutes = durationMinutes ?? 0;

    // 1. Estimate Pages if null, based on progress
    // We only want to track pages read if progress moved and pagesRead wasn't provided.
    if (finalPages == 0 &&
        pagesRead == null &&
        durationMinutes != null &&
        durationMinutes > 0 &&
        progress > oldProgress + 0.001) {
      final effectiveTotalPages = book.totalPages > 0 ? book.totalPages : 300;
      finalPages = ((progress - oldProgress) * effectiveTotalPages)
          .round()
          .clamp(1, 100);
    }

    // 2. Estimate Minutes ONLY if allowed and not provided
    if (estimateReadingTime && finalMinutes == 0 && finalPages > 0) {
      finalMinutes = (finalPages * 1.2).ceil().clamp(1, 60);
    }

    if (finalPages > 0 || finalMinutes > 0) {
      await _db.insertReadingSession(bookId, finalPages, finalMinutes);
    }

    _updateStateAndSync(updatedBook);

    // Refresh stats
    final sessions = await _db.getReadingSessions();
    final questWp = await _db.getTotalQuestWP();
    final lookupCount = await _db.getDictionaryLookupCount();

    final activity = _calculateDetailedActivity(sessions, state.allBooks);
    final stats = _calculateStats(
      sessions,
      state.allBooks,
      questWp,
      lookupCount,
    );

    // Check for new achievements
    final newAchievements = stats.achievements.difference(
      state.unlockedAchievements,
    );
    for (var achievement in newAchievements) {
      final title = _getAchievementTitle(achievement);
      if (!state.isReading) {
        NotificationService().showNotification(
          id: achievement.hashCode,
          title: 'Achievement Unlocked!',
          body: 'You earned the "$title" badge!',
        );
      } else {
        _queueNotification(
          id: achievement.hashCode,
          title: 'Achievement Unlocked!',
          body: 'You earned the "$title" badge!',
        );
      }
    }

    state = state.copyWith(
      currentStreak: _calculateStreak(sessions),
      dailyPages: activity.pages,
      dailyMinutes: activity.minutes,
      dailyWP: activity.wp,
      totalWP: stats.wp,
      level: stats.level,
      totalPagesRead: stats.totalPages,
      totalMinutesRead: stats.totalMinutes,
      unlockedAchievements: stats.achievements,
      sessionHistory: sessions,
      isStreakActiveToday: _isStreakActiveToday(sessions),
      totalLookups: lookupCount,
    );

    await _updateQuests(finalPages, finalMinutes);
  }

  String _getAchievementTitle(String key) {
    switch (key) {
      case 'the_first_page':
        return 'The First Page';
      case 'habit_builder':
        return 'Habit Builder';
      case 'seven_day_streak':
        return '7-Day Streak';
      case 'unstoppable':
        return 'Unstoppable';
      case 'bookworm':
        return 'Bookworm';
      case 'scholar':
        return 'Scholar';
      case 'yomibito':
        return 'Yomibito';
      case 'sensei':
        return 'Sensei';
      case 'century_club':
        return 'Century Club';
      case 'marathoner':
        return 'Marathoner';
      case 'early_bird':
        return 'Early Bird';
      case 'night_owl':
        return 'Night Owl';
      case 'bibliophile':
        return 'Bibliophile';
      case 'collector':
        return 'Collector';
      case 'weekend_warrior':
        return 'Weekend Warrior';
      case 'the_translator':
        return 'Word Seeker';
      case 'vocabulary_builder':
        return 'Vocab Builder';
      case 'polyglot':
        return 'Lexicoguru';
      default:
        return 'New Achievement';
    }
  }

  Future<void> _updateQuests(int pagesRead, int minutesRead) async {
    if (pagesRead <= 0 && minutesRead <= 0) return;

    final now = DateTime.now();
    final updatedQuests = <DailyQuest>[];
    bool changed = false;

    for (var quest in state.dailyQuests) {
      if (quest.isCompleted) {
        updatedQuests.add(quest);
        continue;
      }

      int newVal = quest.currentValue;
      bool newlyCompleted = false;

      switch (quest.type) {
        case QuestType.pages:
          newVal += pagesRead;
          break;
        case QuestType.minutes:
          newVal += minutesRead;
          break;
        case QuestType.earlyBird:
          if (now.hour < 9) {
            newVal = 1;
          }
          break;
        case QuestType.nightOwl:
          if (now.hour >= 22 || now.hour < 1) {
            newVal = 1;
          }
          break;
        case QuestType.bookFinished:
          break;
        case QuestType.dictionaryLookup:
          newVal += 1;
          break;
      }

      if (newVal >= quest.targetValue) {
        newVal = quest.targetValue;
        newlyCompleted = true;
      }

      if (newVal != quest.currentValue || newlyCompleted) {
        final updated = quest.copyWith(
          currentValue: newVal,
          isCompleted: newlyCompleted,
        );
        updatedQuests.add(updated);
        await _db.updateQuestProgress(
          updated.id,
          updated.currentValue,
          updated.isCompleted,
        );
        changed = true;
      } else {
        updatedQuests.add(quest);
      }
    }

    if (changed) {
      final oldQuests = state.dailyQuests;
      state = state.copyWith(dailyQuests: updatedQuests);

      // Notify for newly completed quests
      for (var q in updatedQuests) {
        final wasCompleted = oldQuests.any(
          (oq) => oq.id == q.id && oq.isCompleted,
        );
        if (q.isCompleted && !wasCompleted) {
          if (!state.isReading) {
            NotificationService().showNotification(
              id: q.id.hashCode,
              title: 'Quest Completed!',
              body: 'You completed: ${q.title}. +${q.wpReward} WP earned!',
            );
          } else {
            _queueNotification(
              id: q.id.hashCode,
              title: 'Quest Completed!',
              body: 'You completed: ${q.title}. +${q.wpReward} WP earned!',
            );
          }
        }
      }

      final sessions = await _db.getReadingSessions();
      final questWp = await _db.getTotalQuestWP();
      final lookupCount = await _db.getDictionaryLookupCount();
      final stats = _calculateStats(
        sessions,
        state.allBooks,
        questWp,
        lookupCount,
      );

      // Check for level up notification
      if (stats.level > state.level) {
        final newRank = TibebRankRepository.instance.getCurrentRank(
          stats.level,
          stats.achievements.length,
        );
        final oldRank = TibebRankRepository.instance.getCurrentRank(
          state.level,
          state.unlockedAchievements.length,
        );

        if (!state.isReading) {
          if (newRank.name != oldRank.name) {
            NotificationService().showNotification(
              id: 1001,
              title: 'Rank Up!',
              body: 'Congratulations! You are now a ${newRank.name}!',
            );
          } else {
            NotificationService().showNotification(
              id: 1002,
              title: 'Level Up!',
              body: 'You reached Level ${stats.level}!',
            );
          }
        } else {
          if (newRank.name != oldRank.name) {
            _queueNotification(
              id: 1001,
              title: 'Rank Up!',
              body: 'Congratulations! You are now a ${newRank.name}!',
            );
          } else {
            _queueNotification(
              id: 1002,
              title: 'Level Up!',
              body: 'You reached Level ${stats.level}!',
            );
          }
        }
      }

      state = state.copyWith(totalWP: stats.wp, level: stats.level);
    }
  }

  /// Calculate user's average reading speed in pages per minute
  Future<double> _getReadingSpeed() async {
    final sessions = await _db.getReadingSessions();

    if (sessions.isEmpty) return 1.0;

    int totalPages = 0;
    int totalMinutes = 0;

    for (var session in sessions) {
      totalPages += session.pagesRead;
      totalMinutes += session.durationMinutes;
    }

    if (totalMinutes == 0) return 1.0;

    return (totalPages / totalMinutes).clamp(0.1, 100.0);
  }

  Future<void> markBookAsOpened(Book book) async {
    if (book.lastReadAt == null) {
      final updatedBook = book.copyWith(lastReadAt: DateTime.now());
      await _db.updateBook(updatedBook);

      state = state.copyWith(
        allBooks: state.allBooks
            .map((b) => b.id == updatedBook.id ? updatedBook : b)
            .toList(),
        filteredBooks: state.filteredBooks
            .map((b) => b.id == updatedBook.id ? updatedBook : b)
            .toList(),
      );
    }
  }

  Future<void> updateWeeklyGoals({
    double? pages,
    double? minutes,
    double? wp,
    String? activeType,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final newPages = pages ?? state.weeklyPageGoal;
    final newMinutes = minutes ?? state.weeklyMinuteGoal;
    final newWP = wp ?? state.weeklyWPGoal;
    final newType = activeType ?? state.weeklyGoalType;

    if (pages != null) await prefs.setDouble('weeklyPageGoal', pages);
    if (minutes != null) await prefs.setDouble('weeklyMinuteGoal', minutes);
    if (wp != null) await prefs.setDouble('weeklyWPGoal', wp);
    if (activeType != null) await prefs.setString('weeklyGoalType', activeType);

    state = state.copyWith(
      weeklyPageGoal: newPages,
      weeklyMinuteGoal: newMinutes,
      weeklyWPGoal: newWP,
      weeklyGoalType: newType,
    );

    // Re-calculate activity data
    final sessions = await _db.getReadingSessions();
    final activity = _calculateDetailedActivity(sessions, state.allBooks);

    state = state.copyWith(
      dailyPages: activity.pages,
      dailyMinutes: activity.minutes,
      dailyWP: activity.wp,
    );
  }

  Future<void> deleteBook(int id, {bool deleteHistory = false}) async {
    if (deleteHistory) {
      await _db.hardDeleteBook(id);
    } else {
      await _db.softDeleteBook(id);
    }
    await loadBooks();
  }

  Future<void> toggleBookFavorite(Book book) async {
    final updatedBook = book.copyWith(isFavorite: !book.isFavorite);
    await _db.updateBook(updatedBook);
    await loadBooks();
  }

  void clearFilters() {
    state = state.copyWith(
      searchQuery: '',
      selectedAuthor: 'All',
      selectedGenre: 'All',
      selectedFolder: 'All',
      statusFilter: BookStatusFilter.all,
      onlyFavorites: false,
      selectedSeries: 'All',
      selectedTag: 'All',
      selectedFileType: 'All',
      sortBy: BookSortBy.recent,
      sortAscending: false,
    );
    state = state.copyWith(filteredBooks: _applyFilters(state.allBooks, state));
  }

  Future<void> batchAddTag(List<int> bookIds, String newTag) async {
    final cleanTag = newTag.trim();
    if (cleanTag.isEmpty) return;

    for (int id in bookIds) {
      final book = state.allBooks.firstWhereOrNull((b) => b.id == id);
      if (book != null) {
        String updatedTags = book.tags ?? '';
        final currentTags = updatedTags
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

        if (!currentTags.contains(cleanTag)) {
          currentTags.add(cleanTag);
          final finalTags = currentTags.join(', ');
          final updatedBook = book.copyWith(tags: finalTags);
          await _db.updateBook(updatedBook);
          _updateStateAndSync(updatedBook);
        }
      }
    }
  }

  Future<void> updateBook(Book updatedBook) async {
    await _db.updateBook(updatedBook);
    _updateStateAndSync(updatedBook);
  }

  Future<void> updateBookAudio(
    int bookId, {
    Object? audioPath = Book.sentinel,
    Object? audioLastPosition = Book.sentinel,
    Object? audioLastIndex = Book.sentinel,
    List<AudioTrack>? audioTracks,
  }) async {
    final book = state.allBooks.firstWhereOrNull((b) => b.id == bookId);
    if (book == null) return;

    final updatedBook = book.copyWith(
      audioTracks: audioTracks ?? book.audioTracks,
      audioPath: audioPath,
      audioLastPosition: audioLastPosition,
      audioLastIndex: audioLastIndex,
    );
    await updateBook(updatedBook);
  }

  // Bookmark specialized methods
  Future<void> addBookmark(Bookmark bookmark) async {
    await _db.insertBookmark(bookmark);
  }

  Future<List<Bookmark>> getBookmarks(int bookId) async {
    return await _db.getBookmarksForBook(bookId);
  }

  Future<void> deleteBookmark(int bookmarkId) async {
    await _db.deleteBookmark(bookmarkId);
  }

  void _updateStateAndSync(Book updatedBook) {
    // Update state
    state = state.copyWith(
      allBooks: state.allBooks
          .map((b) => b.id == updatedBook.id ? updatedBook : b)
          .toList(),
      filteredBooks: state.filteredBooks
          .map((b) => b.id == updatedBook.id ? updatedBook : b)
          .toList(),
    );

    // Sync current reader
    final currentBook = _ref.read(currentlyReadingProvider);
    if (currentBook?.id == updatedBook.id) {
      _ref.read(currentlyReadingProvider.notifier).state = updatedBook;
    }
  }

  Future<void> recordDictionaryLookup(String word, int bookId) async {
    await _db.insertDictionaryLookup(word, bookId);
    final count = await _db.getDictionaryLookupCount();

    state = state.copyWith(totalLookups: count);

    // Update dictionary-related quests
    final updatedQuests = <DailyQuest>[];
    bool changed = false;

    for (var quest in state.dailyQuests) {
      if (quest.type == QuestType.dictionaryLookup && !quest.isCompleted) {
        int newVal = quest.currentValue + 1;
        bool newlyCompleted = newVal >= quest.targetValue;
        updatedQuests.add(
          quest.copyWith(
            currentValue: newlyCompleted ? quest.targetValue : newVal,
            isCompleted: newlyCompleted,
          ),
        );
        await _db.updateQuestProgress(quest.id, newVal, newlyCompleted);
        changed = true;
      } else {
        updatedQuests.add(quest);
      }
    }

    if (changed) {
      state = state.copyWith(dailyQuests: updatedQuests);
    }

    // Refresh achievements and level
    await loadBooks();
  }

  Future<List<VocabularyLookup>> getVocabularyForBook(int bookId) async {
    return await _db.getDictionaryLookupsForBook(bookId);
  }

  void _queueNotification({
    required int id,
    required String title,
    required String body,
  }) {
    state = state.copyWith(
      deferredNotifications: [
        ...state.deferredNotifications,
        DeferredNotification(id: id, title: title, body: body),
      ],
    );
  }
}

class _UserStats {
  final int wp;
  final int level;
  final int totalPages;
  final int totalMinutes;
  final Set<String> achievements;

  _UserStats({
    required this.wp,
    required this.level,
    required this.totalPages,
    required this.totalMinutes,
    required this.achievements,
  });
}

class _DetailedActivityData {
  final Map<String, int> pages;
  final Map<String, int> minutes;
  final Map<String, int> wp;

  _DetailedActivityData({
    required this.pages,
    required this.minutes,
    required this.wp,
  });
}
