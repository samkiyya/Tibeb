import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'bookmarks_dao.g.dart';

@DriftAccessor(tables: [Bookmarks])
class BookmarksDao extends DatabaseAccessor<AppDatabase>
    with _$BookmarksDaoMixin {
  BookmarksDao(super.db);

  Stream<List<BookmarkEntity>> watchBookmarksForBook(int bookId) {
    return (select(bookmarks)
          ..where((t) => t.bookId.equals(bookId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  Future<List<BookmarkEntity>> getBookmarksForBook(int bookId) {
    return (select(bookmarks)
          ..where((t) => t.bookId.equals(bookId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  Future<int> insertBookmark(BookmarksCompanion bookmark) {
    return into(bookmarks).insert(bookmark);
  }

  Future<int> deleteBookmark(int id) {
    return (delete(bookmarks)..where((t) => t.id.equals(id))).go();
  }
}
