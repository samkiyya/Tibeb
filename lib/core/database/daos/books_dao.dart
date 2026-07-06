import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'books_dao.g.dart';

@DriftAccessor(tables: [Books])
class BooksDao extends DatabaseAccessor<AppDatabase> with _$BooksDaoMixin {
  BooksDao(super.db);

  Stream<List<BookEntity>> watchAllBooks() {
    return (select(books)..orderBy([
          (t) => OrderingTerm(expression: t.addedAt, mode: OrderingMode.desc),
        ]))
        .watch();
  }

  Future<List<BookEntity>> getAllBooks() {
    return (select(books)..orderBy([
          (t) => OrderingTerm(expression: t.addedAt, mode: OrderingMode.desc),
        ]))
        .get();
  }

  Future<int> insertBook(BooksCompanion book) {
    return into(books).insert(book);
  }

  Future<bool> updateBook(BookEntity book) {
    return update(books).replace(book);
  }

  Future<int> softDeleteBook(int id) {
    return (update(books)..where((t) => t.id.equals(id))).write(
      const BooksCompanion(isDeleted: Value(true)),
    );
  }

  Future<int> restoreBook(int id) {
    return (update(books)..where((t) => t.id.equals(id))).write(
      const BooksCompanion(isDeleted: Value(false)),
    );
  }

  Future<int> hardDeleteBook(int id) {
    return (delete(books)..where((t) => t.id.equals(id))).go();
  }
}
