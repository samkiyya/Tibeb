import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../models/book_model.dart' show AudioTrack;
import '../../models/quest_model.dart' show QuestType;
import 'audio_track_converter.dart';
import 'tables.dart';
import 'daos/books_dao.dart';
import 'daos/reading_sessions_dao.dart';
import 'daos/bookmarks_dao.dart';
import 'daos/quests_dao.dart';
import 'daos/highlights_dao.dart';
import 'daos/dictionary_lookups_dao.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Books,
    ReadingSessions,
    Bookmarks,
    Quests,
    Highlights,
    DictionaryLookups,
  ],
  daos: [
    BooksDao,
    ReadingSessionsDao,
    BookmarksDao,
    QuestsDao,
    HighlightsDao,
    DictionaryLookupsDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      // Future schema migrations will go here.
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await customStatement('PRAGMA journal_mode = WAL');
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'tibeb_drift.db'));
    return NativeDatabase.createInBackground(file);
  });
}
