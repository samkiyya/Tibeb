// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmarks_dao.dart';

// ignore_for_file: type=lint
mixin _$BookmarksDaoMixin on DatabaseAccessor<AppDatabase> {
  $BooksTable get books => attachedDatabase.books;
  $BookmarksTable get bookmarks => attachedDatabase.bookmarks;
  BookmarksDaoManager get managers => BookmarksDaoManager(this);
}

class BookmarksDaoManager {
  final _$BookmarksDaoMixin _db;
  BookmarksDaoManager(this._db);
  $$BooksTableTableManager get books =>
      $$BooksTableTableManager(_db.attachedDatabase, _db.books);
  $$BookmarksTableTableManager get bookmarks =>
      $$BookmarksTableTableManager(_db.attachedDatabase, _db.bookmarks);
}
