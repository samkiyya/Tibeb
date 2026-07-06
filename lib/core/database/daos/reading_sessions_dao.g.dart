// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_sessions_dao.dart';

// ignore_for_file: type=lint
mixin _$ReadingSessionsDaoMixin on DatabaseAccessor<AppDatabase> {
  $BooksTable get books => attachedDatabase.books;
  $ReadingSessionsTable get readingSessions => attachedDatabase.readingSessions;
  ReadingSessionsDaoManager get managers => ReadingSessionsDaoManager(this);
}

class ReadingSessionsDaoManager {
  final _$ReadingSessionsDaoMixin _db;
  ReadingSessionsDaoManager(this._db);
  $$BooksTableTableManager get books =>
      $$BooksTableTableManager(_db.attachedDatabase, _db.books);
  $$ReadingSessionsTableTableManager get readingSessions =>
      $$ReadingSessionsTableTableManager(
        _db.attachedDatabase,
        _db.readingSessions,
      );
}
