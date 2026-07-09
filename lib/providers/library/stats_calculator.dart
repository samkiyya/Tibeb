import '../../core/database/database.dart' show ReadingSessionEntity;
import '../../models/book_model.dart';

class UserStats {
  final int wp;
  final int level;
  final int totalPages;
  final int totalMinutes;
  final Set<String> achievements;

  UserStats({
    required this.wp,
    required this.level,
    required this.totalPages,
    required this.totalMinutes,
    required this.achievements,
  });
}

class DetailedActivityData {
  final Map<String, int> pages;
  final Map<String, int> minutes;
  final Map<String, int> wp;

  DetailedActivityData({
    required this.pages,
    required this.minutes,
    required this.wp,
  });
}

class StatsCalculator {
  static UserStats calculate({
    required List<ReadingSessionEntity> sessions,
    required List<Book> books,
    required int questWp,
    required int lookupCount,
    int annotationCount = 0,
  }) {
    int totalPages = 0;
    int totalMinutes = 0;
    for (var s in sessions) {
      totalPages += s.pagesRead;
      totalMinutes += s.durationMinutes;
    }

    final finishedBooks = books.where((b) => b.progress >= 0.99).length;
    final streak = calculateStreak(sessions);

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

    wp += questWp;

    int level = (wp ~/ 1000) + 1;
    if (level > 99) level = 99;

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

    if (lookupCount >= 1)   achievements.add('the_translator');
    if (lookupCount >= 20)  achievements.add('vocabulary_builder');
    if (lookupCount >= 100) achievements.add('polyglot');

    // ── Pages milestones ──────────────────────────────────────────────────
    if (totalPages >= 500)   achievements.add('gondar_keep');
    if (totalPages >= 2000)  achievements.add('sheba_wisdom');
    if (totalPages >= 10000) achievements.add('axum_legacy');

    // ── Books finished ────────────────────────────────────────────────────
    if (finishedBooks >= 5)   achievements.add('fasil_crown');
    if (finishedBooks >= 20)  achievements.add('yohannes_torch');
    if (finishedBooks >= 100) achievements.add('menelik_library');

    // ── Total reading hours ───────────────────────────────────────────────
    if (totalMinutes >= 6000) achievements.add('lalibela_vigil'); // 100 h

    // ── Long streaks ──────────────────────────────────────────────────────
    if (streak >= 49)  achievements.add('adwa_spirit');    // 7 weeks
    if (streak >= 100) achievements.add('selassie_endurance');

    // ── Vocabulary milestones ─────────────────────────────────────────────
    if (lookupCount >= 500)  achievements.add('geez_mastery');
    if (lookupCount >= 1000) achievements.add('qene_poet');

    // ── Audiobooks ────────────────────────────────────────────────────────
    final audiobookCount = books.where((b) => b.isAudioOnly).length;
    if (audiobookCount >= 1) achievements.add('oral_tradition');
    if (audiobookCount >= 5) achievements.add('azmari_listener');

    // ── Annotations (highlights + bookmarks combined) ─────────────────────
    if (annotationCount >= 20) achievements.add('annotations_scholar');

    // ── Fast reader: finish any book within 3 days of adding it ──────────
    for (final book in books) {
      if (book.progress >= 0.99 &&
          book.lastReadAt != null &&
          book.lastReadAt!.difference(book.addedAt).inDays <= 3) {
        achievements.add('fast_reader');
        break;
      }
    }

    // ── Meskel Flame: finish 3+ books in the current calendar month ───────
    final now = DateTime.now();
    final booksFinishedThisMonth = books.where((b) =>
        b.progress >= 0.99 &&
        b.lastReadAt != null &&
        b.lastReadAt!.year == now.year &&
        b.lastReadAt!.month == now.month).length;
    if (booksFinishedThisMonth >= 3) achievements.add('meskel_flame');

    // ── Seasonal: reading on specific Ethiopian feast days ────────────────
    // Only award seasonal achievements if the user has at least one session
    // on that date so they're actually reading (not just opening the app).
    final todayStr = '${now.year}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')}';
    final readToday = sessions.any((s) => s.date == todayStr);

    if (readToday) {
      // Timkat (Ethiopian Epiphany) — Gregorian Jan 19 (most years)
      if (now.month == 1 && (now.day == 19 || now.day == 20)) {
        achievements.add('timkat_reader');
      }
      // Enkutatash (Ethiopian New Year) — Gregorian Sep 11
      if (now.month == 9 && (now.day == 11 || now.day == 12)) {
        achievements.add('enkutatash_start');
      }
    }

    return UserStats(
      wp: wp,
      level: level,
      totalPages: totalPages,
      totalMinutes: totalMinutes,
      achievements: achievements,
    );
  }

  static int calculateStreak(List<ReadingSessionEntity> sessions) {
    if (sessions.isEmpty) return 0;

    final readDates = sessions
        .map((s) => s.date)
        .toSet()
        .map((d) => DateTime.parse(d))
        .toList();

    if (readDates.isEmpty) return 0;

    readDates.sort((a, b) => b.compareTo(a));

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

  static DetailedActivityData calculateDetailedActivity(
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

    return DetailedActivityData(pages: pages, minutes: minutes, wp: wpMap);
  }

  static bool isStreakActiveToday(List<ReadingSessionEntity> sessions) {
    if (sessions.isEmpty) return false;
    final today = DateTime.now().toIso8601String().split('T')[0];
    return sessions.any((s) => s.date == today);
  }
}
