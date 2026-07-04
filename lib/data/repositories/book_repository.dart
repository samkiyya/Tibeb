import 'package:tibeb/shared/models/models.dart';


/// Abstract contract — swap SQLite for any backend without touching features.
abstract class BookRepository {
  Future<List<Book>> getBooks();
  Future<int> insertBook(Book book);
  Future<void> updateBook(Book book);
  Future<void> softDeleteBook(int id);
  Future<void> hardDeleteBook(int id);
  Future<void> restoreBook(int id);
}

abstract class AnnotationRepository {
  // Bookmarks
  Future<int> insertBookmark(Bookmark bookmark);
  Future<List<Bookmark>> getBookmarks(int bookId);
  Future<void> deleteBookmark(int id);

  // Highlights
  Future<int> insertHighlight(Highlight highlight);
  Future<List<Highlight>> getHighlightsForBook(int bookId);
  Future<void> updateHighlight(Highlight highlight);
  Future<void> deleteHighlight(int id);
  Future<void> deleteHighlightsForBook(int bookId);
}

abstract class VocabularyRepository {
  Future<void> insertLookup(String word, int bookId);
  Future<List<VocabularyLookup>> getLookupsForBook(int bookId);
  Future<int> getTotalCount();
}

abstract class SessionRepository {
  Future<void> insertSession(int bookId, int pages, int durationMinutes);
  Future<List<Map<String, dynamic>>> getSessions();
}

abstract class QuestRepository {
  Future<void> insertQuest(Map<String, dynamic> quest);
  Future<List<Map<String, dynamic>>> getQuestsForDate(String date);
  Future<void> updateQuestProgress(
      String id, int currentValue, bool isCompleted);
  Future<int> getTotalQuestXP();
}
