// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'highlights_dao.dart';

// ignore_for_file: type=lint
mixin _$HighlightsDaoMixin on DatabaseAccessor<AppDatabase> {
  $BooksTable get books => attachedDatabase.books;
  $HighlightsTable get highlights => attachedDatabase.highlights;
  HighlightsDaoManager get managers => HighlightsDaoManager(this);
}

class HighlightsDaoManager {
  final _$HighlightsDaoMixin _db;
  HighlightsDaoManager(this._db);
  $$BooksTableTableManager get books =>
      $$BooksTableTableManager(_db.attachedDatabase, _db.books);
  $$HighlightsTableTableManager get highlights =>
      $$HighlightsTableTableManager(_db.attachedDatabase, _db.highlights);
}
