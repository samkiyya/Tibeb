import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';
import '../core/rank/tibeb_rank_extension.dart';
import '../core/rank/tibeb_rank_repository.dart';
import '../core/repositories/database_repository.dart';
import '../models/models.dart';
import '../services/book_service.dart';
import '../services/notification_service.dart';
import 'database_providers.dart';

// Extracted Modules
import 'library/library.dart';
export 'library/notification_manager.dart' show DeferredNotification;

export 'library/library_state.dart';

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

    if (wasReading && !active && state.deferredNotifications.isNotEmpty) {
      _processDeferredNotifications();
    }
  }

  void _processDeferredNotifications() async {
    final notifications = List<DeferredNotification>.from(
      state.deferredNotifications,
    );
    state = state.copyWith(deferredNotifications: []);
    await ReadingNotificationManager.processDeferredNotifications(notifications);
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

    double finalPageGoal = pageGoal ?? 100.0;
    String finalType = prefs.getString('weeklyGoalType') ?? 'pages';

    if (pageGoal == null) {
      final oldVal = prefs.getDouble('weeklyGoalValue');
      if (oldVal != null) {
        if (finalType == 'pages') {
          finalPageGoal = oldVal;
        }
        if (finalType == 'minutes' && minuteGoal == 0) {
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

      final streak = StatsCalculator.calculateStreak(sessions);
      final activity = StatsCalculator.calculateDetailedActivity(sessions, books);
      final stats = StatsCalculator.calculate(
        sessions: sessions,
        books: books,
        questWp: questWp,
        lookupCount: lookupCount,
      );
      final visibleBooks = books.where((b) => !b.isDeleted).toList();

      state = state.copyWith(
        allBooks: visibleBooks,
        filteredBooks: applyBookFilters(visibleBooks, state),
        isLoading: false,
        currentStreak: streak,
        isStreakActiveToday: StatsCalculator.isStreakActiveToday(sessions),
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

  Future<void> _loadQuests() async {
    final today = DateTime.now().toIso8601String().split('T')[0];
    final quests = await _db.getQuestsForDate(today);

    if (quests.isEmpty) {
      final newQuests = QuestEngine.generateDaily(today);
      for (var q in newQuests) {
        await _db.insertQuest(q);
      }
      state = state.copyWith(dailyQuests: newQuests);
    } else {
      state = state.copyWith(dailyQuests: quests);
    }
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

    int finalPages = pagesRead ?? 0;
    int finalMinutes = durationMinutes ?? 0;

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

    if (estimateReadingTime && finalMinutes == 0 && finalPages > 0) {
      finalMinutes = (finalPages * 1.2).ceil().clamp(1, 60);
    }

    if (finalPages > 0 || finalMinutes > 0) {
      await _db.insertReadingSession(bookId, finalPages, finalMinutes);
    }

    _updateStateAndSync(updatedBook);

    final sessions = await _db.getReadingSessions();
    final questWp = await _db.getTotalQuestWP();
    final lookupCount = await _db.getDictionaryLookupCount();

    final activity = StatsCalculator.calculateDetailedActivity(sessions, state.allBooks);
    final stats = StatsCalculator.calculate(
      sessions: sessions,
      books: state.allBooks,
      questWp: questWp,
      lookupCount: lookupCount,
    );

    final newAchievements = stats.achievements.difference(
      state.unlockedAchievements,
    );
    for (var achievement in newAchievements) {
      final title = achievementTitle(achievement);
      final newDeferred = ReadingNotificationManager.showOrDefer(
        isReading: state.isReading,
        existing: state.deferredNotifications,
        id: achievement.hashCode,
        title: 'Achievement Unlocked!',
        body: 'You earned the "$title" badge!',
      );
      state = state.copyWith(deferredNotifications: newDeferred);
    }

    state = state.copyWith(
      currentStreak: StatsCalculator.calculateStreak(sessions),
      dailyPages: activity.pages,
      dailyMinutes: activity.minutes,
      dailyWP: activity.wp,
      totalWP: stats.wp,
      level: stats.level,
      totalPagesRead: stats.totalPages,
      totalMinutesRead: stats.totalMinutes,
      unlockedAchievements: stats.achievements,
      sessionHistory: sessions,
      isStreakActiveToday: StatsCalculator.isStreakActiveToday(sessions),
      totalLookups: lookupCount,
    );

    await _updateQuests(finalPages, finalMinutes);
  }

  Future<void> _updateQuests(int pagesRead, int minutesRead) async {
    if (pagesRead <= 0 && minutesRead <= 0) return;

    final now = DateTime.now();
    final result = QuestEngine.applyProgress(
      currentQuests: state.dailyQuests,
      pagesRead: pagesRead,
      minutesRead: minutesRead,
      timestamp: now,
    );

    if (result.isChanged) {
      final oldQuests = state.dailyQuests;
      state = state.copyWith(dailyQuests: result.updatedQuests);

      for (var q in result.updatedQuests) {
        final oldQ = oldQuests.firstWhereOrNull((oq) => oq.id == q.id);
        if (oldQ == null || oldQ.currentValue != q.currentValue || oldQ.isCompleted != q.isCompleted) {
          await _db.updateQuestProgress(q.id, q.currentValue, q.isCompleted);
        }
      }

      for (var q in result.newlyCompletedQuests) {
        final newDeferred = ReadingNotificationManager.showOrDefer(
          isReading: state.isReading,
          existing: state.deferredNotifications,
          id: q.id.hashCode,
          title: 'Quest Completed!',
          body: 'You completed: ${q.title}. +${q.wpReward} WP earned!',
        );
        state = state.copyWith(deferredNotifications: newDeferred);
      }

      final sessions = await _db.getReadingSessions();
      final questWp = await _db.getTotalQuestWP();
      final lookupCount = await _db.getDictionaryLookupCount();
      final stats = StatsCalculator.calculate(
        sessions: sessions,
        books: state.allBooks,
        questWp: questWp,
        lookupCount: lookupCount,
      );

      if (stats.level > state.level) {
        final newRank = TibebRankRepository.instance.getCurrentRank(
          stats.level,
          stats.achievements.length,
        );
        final oldRank = TibebRankRepository.instance.getCurrentRank(
          state.level,
          state.unlockedAchievements.length,
        );

        if (newRank.name != oldRank.name) {
          final newDeferred = ReadingNotificationManager.showOrDefer(
            isReading: state.isReading,
            existing: state.deferredNotifications,
            id: 1001,
            title: 'Rank Up!',
            body: 'Congratulations! You are now a ${newRank.name}!',
          );
          state = state.copyWith(deferredNotifications: newDeferred);
        } else {
          final newDeferred = ReadingNotificationManager.showOrDefer(
            isReading: state.isReading,
            existing: state.deferredNotifications,
            id: 1002,
            title: 'Level Up!',
            body: 'You reached Level ${stats.level}!',
          );
          state = state.copyWith(deferredNotifications: newDeferred);
        }
      }

      state = state.copyWith(totalWP: stats.wp, level: stats.level);
    }
  }

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

    final sessions = await _db.getReadingSessions();
    final activity = StatsCalculator.calculateDetailedActivity(sessions, state.allBooks);

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
    state = state.copyWith(filteredBooks: applyBookFilters(state.allBooks, state));
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
    state = state.copyWith(
      allBooks: state.allBooks
          .map((b) => b.id == updatedBook.id ? updatedBook : b)
          .toList(),
      filteredBooks: state.filteredBooks
          .map((b) => b.id == updatedBook.id ? updatedBook : b)
          .toList(),
    );

    final currentBook = _ref.read(currentlyReadingProvider);
    if (currentBook?.id == updatedBook.id) {
      _ref.read(currentlyReadingProvider.notifier).state = updatedBook;
    }
  }

  Future<void> recordDictionaryLookup(String word, int bookId) async {
    await _db.insertDictionaryLookup(word, bookId);
    final count = await _db.getDictionaryLookupCount();

    state = state.copyWith(totalLookups: count);

    final result = QuestEngine.applyDictionaryLookup(
      currentQuests: state.dailyQuests,
    );

    if (result.isChanged) {
      state = state.copyWith(dailyQuests: result.updatedQuests);
      for (var q in result.updatedQuests) {
        if (q.type == QuestType.dictionaryLookup) {
          await _db.updateQuestProgress(q.id, q.currentValue, q.isCompleted);
        }
      }
    }

    await loadBooks();
  }

  Future<List<VocabularyLookup>> getVocabularyForBook(int bookId) async {
    return await _db.getDictionaryLookupsForBook(bookId);
  }

  Map<String, int> get dailyReadingValues {
    if (state.weeklyGoalType == 'pages') return state.dailyPages;
    if (state.weeklyGoalType == 'minutes') return state.dailyMinutes;
    return state.dailyWP;
  }

  // Filter setters delegation
  void setSearchQuery(String query) {
    final newState = state.copyWith(searchQuery: query);
    state = newState.copyWith(
      filteredBooks: applyBookFilters(state.allBooks, newState),
    );
  }

  void setSortBy(BookSortBy sortBy) {
    final newState = state.copyWith(sortBy: sortBy);
    state = newState.copyWith(
      filteredBooks: applyBookFilters(state.allBooks, newState),
    );
  }

  void toggleSortOrder() {
    final newState = state.copyWith(sortAscending: !state.sortAscending);
    state = newState.copyWith(
      filteredBooks: applyBookFilters(state.allBooks, newState),
    );
  }

  void setStatusFilter(BookStatusFilter filter) {
    final targetFilter = state.statusFilter == filter
        ? BookStatusFilter.all
        : filter;
    final newState = state.copyWith(statusFilter: targetFilter);
    state = newState.copyWith(
      filteredBooks: applyBookFilters(state.allBooks, newState),
    );
  }

  void toggleFavoriteOnly() {
    final newState = state.copyWith(onlyFavorites: !state.onlyFavorites);
    state = newState.copyWith(
      filteredBooks: applyBookFilters(state.allBooks, newState),
    );
  }

  void setAuthorFilter(String author) {
    final targetAuthor = state.selectedAuthor == author ? 'All' : author;
    final newState = state.copyWith(selectedAuthor: targetAuthor);
    state = newState.copyWith(
      filteredBooks: applyBookFilters(state.allBooks, newState),
    );
  }

  void setGenreFilter(String genre) {
    final targetGenre = state.selectedGenre == genre ? 'All' : genre;
    final newState = state.copyWith(selectedGenre: targetGenre);
    state = newState.copyWith(
      filteredBooks: applyBookFilters(state.allBooks, newState),
    );
  }

  void setFolderFilter(String folder) {
    final newState = state.copyWith(selectedFolder: folder);
    state = newState.copyWith(
      filteredBooks: applyBookFilters(state.allBooks, newState),
    );
  }

  void setSeriesFilter(String series) {
    final newState = state.copyWith(selectedSeries: series);
    state = newState.copyWith(
      filteredBooks: applyBookFilters(state.allBooks, newState),
    );
  }

  void setFileTypeFilter(String fileType) {
    final newState = state.copyWith(selectedFileType: fileType);
    state = newState.copyWith(
      filteredBooks: applyBookFilters(state.allBooks, newState),
    );
  }

  void setTagFilter(String tag) {
    final newState = state.copyWith(selectedTag: tag);
    state = newState.copyWith(
      filteredBooks: applyBookFilters(state.allBooks, newState),
    );
  }
}
