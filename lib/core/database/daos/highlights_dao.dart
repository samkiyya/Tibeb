import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'highlights_dao.g.dart';

@DriftAccessor(tables: [Highlights])
class HighlightsDao extends DatabaseAccessor<AppDatabase>
    with _$HighlightsDaoMixin {
  HighlightsDao(super.db);

  Stream<List<HighlightEntity>> watchHighlightsForBook(int bookId) {
    return (select(highlights)
          ..where((t) => t.bookId.equals(bookId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  Future<List<HighlightEntity>> getHighlightsForBook(int bookId) {
    return (select(highlights)
          ..where((t) => t.bookId.equals(bookId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
          ]))
        .get();
  }

  Future<int> insertHighlight(HighlightsCompanion highlight) {
    return into(highlights).insert(highlight);
  }

  Future<bool> updateHighlight(HighlightEntity highlight) {
    return update(highlights).replace(highlight);
  }

  Future<int> deleteHighlight(int id) {
    return (delete(highlights)..where((t) => t.id.equals(id))).go();
  }

  Future<int> deleteHighlightsForBook(int bookId) {
    return (delete(highlights)..where((t) => t.bookId.equals(bookId))).go();
  }
}
