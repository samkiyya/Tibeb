// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dictionary_lookups_dao.dart';

// ignore_for_file: type=lint
mixin _$DictionaryLookupsDaoMixin on DatabaseAccessor<AppDatabase> {
  $BooksTable get books => attachedDatabase.books;
  $DictionaryLookupsTable get dictionaryLookups =>
      attachedDatabase.dictionaryLookups;
  DictionaryLookupsDaoManager get managers => DictionaryLookupsDaoManager(this);
}

class DictionaryLookupsDaoManager {
  final _$DictionaryLookupsDaoMixin _db;
  DictionaryLookupsDaoManager(this._db);
  $$BooksTableTableManager get books =>
      $$BooksTableTableManager(_db.attachedDatabase, _db.books);
  $$DictionaryLookupsTableTableManager get dictionaryLookups =>
      $$DictionaryLookupsTableTableManager(
        _db.attachedDatabase,
        _db.dictionaryLookups,
      );
}
