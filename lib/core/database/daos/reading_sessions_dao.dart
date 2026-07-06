import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'reading_sessions_dao.g.dart';

@DriftAccessor(tables: [ReadingSessions])
class ReadingSessionsDao extends DatabaseAccessor<AppDatabase>
    with _$ReadingSessionsDaoMixin {
  ReadingSessionsDao(super.db);

  Stream<List<ReadingSessionEntity>> watchAllReadingSessions() {
    return (select(readingSessions)..orderBy([
          (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
        ]))
        .watch();
  }

  Future<List<ReadingSessionEntity>> getAllReadingSessions() {
    return (select(readingSessions)..orderBy([
          (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
        ]))
        .get();
  }

  Future<int> insertReadingSession(ReadingSessionsCompanion session) {
    return into(readingSessions).insert(session);
  }

  Future<int> deleteReadingSessionsForBook(int bookId) {
    return (delete(
      readingSessions,
    )..where((t) => t.bookId.equals(bookId))).go();
  }
}
