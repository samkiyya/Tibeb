import 'package:drift/drift.dart';
import '../database/database.dart';
import '../../models/book_model.dart';
import '../../models/bookmark_model.dart';
import '../../models/highlight_model.dart';
import '../../models/quest_model.dart';
import '../../models/vocabulary_model.dart';
import 'mappers.dart';

abstract class DatabaseRepository {
  // Books operations
  Stream<List<Book>> watchAllBooks();
  Future<List<Book>> getBooks();
  Future<int> insertBook(Book book);
  Future<bool> updateBook(Book book);
  Future<int> softDeleteBook(int id);
  Future<int> restoreBook(int id);
  Future<int> hardDeleteBook(int id);

  // Bookmarks operations
  Stream<List<Bookmark>> watchBookmarksForBook(int bookId);
  Future<List<Bookmark>> getBookmarksForBook(int bookId);
  Future<int> insertBookmark(Bookmark bookmark);
  Future<int> deleteBookmark(int id);

  // Reading Sessions operations
  Stream<List<ReadingSessionEntity>> watchAllReadingSessions();
  Future<List<ReadingSessionEntity>> getReadingSessions();
  Future<int> insertReadingSession(
    int bookId,
    int pagesRead,
    int durationMinutes,
  );

  // Quests operations
  Future<List<DailyQuest>> getQuestsForDate(String date);
  Future<int> insertQuest(DailyQuest quest);
  Future<int> updateQuestProgress(
    String id,
    int currentValue,
    bool isCompleted,
  );
  Future<int> getTotalQuestXP();

  // Highlights operations
  Stream<List<Highlight>> watchHighlightsForBook(int bookId);
  Future<List<Highlight>> getHighlightsForBook(int bookId);
  Future<int> insertHighlight(Highlight highlight);
  Future<bool> updateHighlight(Highlight highlight);
  Future<int> deleteHighlight(int id);
  Future<int> deleteHighlightsForBook(int bookId);

  // Dictionary Lookup operations
  Future<int> insertDictionaryLookup(String word, int bookId);
  Future<List<VocabularyLookup>> getDictionaryLookupsForBook(int bookId);
  Future<int> getDictionaryLookupCount();
}

class DatabaseRepositoryImpl implements DatabaseRepository {
  final AppDatabase _db;

  DatabaseRepositoryImpl(this._db);

  // Books
  @override
  Stream<List<Book>> watchAllBooks() {
    return _db.booksDao.watchAllBooks().map(
      (entities) => entities.map((e) => e.toDomain()).toList(),
    );
  }

  @override
  Future<List<Book>> getBooks() async {
    final entities = await _db.booksDao.getAllBooks();
    return entities.map((e) => e.toDomain()).toList();
  }

  @override
  Future<int> insertBook(Book book) {
    return _db.booksDao.insertBook(book.toCompanion());
  }

  @override
  Future<bool> updateBook(Book book) {
    return _db.booksDao.updateBook(book.toEntity());
  }

  @override
  Future<int> softDeleteBook(int id) {
    return _db.booksDao.softDeleteBook(id);
  }

  @override
  Future<int> restoreBook(int id) {
    return _db.booksDao.restoreBook(id);
  }

  @override
  Future<int> hardDeleteBook(int id) {
    return _db.booksDao.hardDeleteBook(id);
  }

  // Bookmarks
  @override
  Stream<List<Bookmark>> watchBookmarksForBook(int bookId) {
    return _db.bookmarksDao
        .watchBookmarksForBook(bookId)
        .map((entities) => entities.map((e) => e.toDomain()).toList());
  }

  @override
  Future<List<Bookmark>> getBookmarksForBook(int bookId) async {
    final entities = await _db.bookmarksDao.getBookmarksForBook(bookId);
    return entities.map((e) => e.toDomain()).toList();
  }

  @override
  Future<int> insertBookmark(Bookmark bookmark) {
    return _db.bookmarksDao.insertBookmark(bookmark.toCompanion());
  }

  @override
  Future<int> deleteBookmark(int id) {
    return _db.bookmarksDao.deleteBookmark(id);
  }

  // Reading Sessions
  @override
  Stream<List<ReadingSessionEntity>> watchAllReadingSessions() {
    return _db.readingSessionsDao.watchAllReadingSessions();
  }

  @override
  Future<List<ReadingSessionEntity>> getReadingSessions() {
    return _db.readingSessionsDao.getAllReadingSessions();
  }

  @override
  Future<int> insertReadingSession(
    int bookId,
    int pagesRead,
    int durationMinutes,
  ) {
    return _db.readingSessionsDao.insertReadingSession(
      ReadingSessionsCompanion(
        bookId: Value(bookId),
        pagesRead: Value(pagesRead),
        durationMinutes: Value(durationMinutes),
        date: Value(DateTime.now().toIso8601String().split('T')[0]),
        timestamp: Value(DateTime.now()),
      ),
    );
  }

  // Quests
  @override
  Future<List<DailyQuest>> getQuestsForDate(String date) async {
    final entities = await _db.questsDao.getQuestsForDate(date);
    return entities.map((e) => e.toDomain()).toList();
  }

  @override
  Future<int> insertQuest(DailyQuest quest) {
    return _db.questsDao.insertQuest(quest.toCompanion());
  }

  @override
  Future<int> updateQuestProgress(
    String id,
    int currentValue,
    bool isCompleted,
  ) {
    return _db.questsDao.updateQuestProgress(id, currentValue, isCompleted);
  }

  @override
  Future<int> getTotalQuestXP() {
    return _db.questsDao.getTotalQuestXP();
  }

  // Highlights
  @override
  Stream<List<Highlight>> watchHighlightsForBook(int bookId) {
    return _db.highlightsDao
        .watchHighlightsForBook(bookId)
        .map((entities) => entities.map((e) => e.toDomain()).toList());
  }

  @override
  Future<List<Highlight>> getHighlightsForBook(int bookId) async {
    final entities = await _db.highlightsDao.getHighlightsForBook(bookId);
    return entities.map((e) => e.toDomain()).toList();
  }

  @override
  Future<int> insertHighlight(Highlight highlight) {
    return _db.highlightsDao.insertHighlight(highlight.toCompanion());
  }

  @override
  Future<bool> updateHighlight(Highlight highlight) {
    return _db.highlightsDao.updateHighlight(highlight.toEntity());
  }

  @override
  Future<int> deleteHighlight(int id) {
    return _db.highlightsDao.deleteHighlight(id);
  }

  @override
  Future<int> deleteHighlightsForBook(int bookId) {
    return _db.highlightsDao.deleteHighlightsForBook(bookId);
  }

  // Dictionary Lookup
  @override
  Future<int> insertDictionaryLookup(String word, int bookId) {
    return _db.dictionaryLookupsDao.insertDictionaryLookup(
      DictionaryLookupsCompanion(
        bookId: Value(bookId),
        word: Value(word),
        timestamp: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<List<VocabularyLookup>> getDictionaryLookupsForBook(int bookId) async {
    final entities = await _db.dictionaryLookupsDao.getDictionaryLookupsForBook(
      bookId,
    );
    return entities.map((e) => e.toDomain()).toList();
  }

  @override
  Future<int> getDictionaryLookupCount() {
    return _db.dictionaryLookupsDao.getDictionaryLookupCount();
  }
}
