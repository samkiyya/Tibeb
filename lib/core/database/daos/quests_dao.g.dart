// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quests_dao.dart';

// ignore_for_file: type=lint
mixin _$QuestsDaoMixin on DatabaseAccessor<AppDatabase> {
  $QuestsTable get quests => attachedDatabase.quests;
  QuestsDaoManager get managers => QuestsDaoManager(this);
}

class QuestsDaoManager {
  final _$QuestsDaoMixin _db;
  QuestsDaoManager(this._db);
  $$QuestsTableTableManager get quests =>
      $$QuestsTableTableManager(_db.attachedDatabase, _db.quests);
}
