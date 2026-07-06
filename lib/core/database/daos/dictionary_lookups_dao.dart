import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'dictionary_lookups_dao.g.dart';

@DriftAccessor(tables: [DictionaryLookups])
class DictionaryLookupsDao extends DatabaseAccessor<AppDatabase>
    with _$DictionaryLookupsDaoMixin {
  DictionaryLookupsDao(super.db);

  Future<DictionaryLookupEntity?> findLookup(String word, int bookId) {
    return (select(dictionaryLookups)
          ..where((t) => t.word.equals(word) & t.bookId.equals(bookId)))
        .getSingleOrNull();
  }

  Future<int> insertDictionaryLookup(DictionaryLookupsCompanion lookup) {
    return into(dictionaryLookups).insert(lookup);
  }

  Future<int> updateLookupTimestamp(int id, DateTime timestamp) {
    return (update(dictionaryLookups)..where((t) => t.id.equals(id))).write(
      DictionaryLookupsCompanion(timestamp: Value(timestamp)),
    );
  }

  Future<List<DictionaryLookupEntity>> getDictionaryLookupsForBook(int bookId) {
    return (select(dictionaryLookups)
          ..where((t) => t.bookId.equals(bookId))
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc),
          ]))
        .get();
  }

  Future<int> getDictionaryLookupCount() async {
    final query = selectOnly(dictionaryLookups)
      ..addColumns([dictionaryLookups.id.count()]);
    final result = await query
        .map((row) => row.read(dictionaryLookups.id.count()))
        .getSingleOrNull();
    return result ?? 0;
  }
}
