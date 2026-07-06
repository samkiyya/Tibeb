import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'quests_dao.g.dart';

@DriftAccessor(tables: [Quests])
class QuestsDao extends DatabaseAccessor<AppDatabase> with _$QuestsDaoMixin {
  QuestsDao(super.db);

  Future<List<QuestEntity>> getQuestsForDate(String date) {
    return (select(quests)..where((t) => t.date.equals(date))).get();
  }

  Future<int> insertQuest(QuestsCompanion quest) {
    return into(quests).insert(quest, mode: InsertMode.insertOrReplace);
  }

  Future<int> updateQuestProgress(
    String id,
    int currentValue,
    bool isCompleted,
  ) {
    return (update(quests)..where((t) => t.id.equals(id))).write(
      QuestsCompanion(
        currentValue: Value(currentValue),
        isCompleted: Value(isCompleted),
      ),
    );
  }

  Future<int> getTotalQuestXP() async {
    final query = selectOnly(quests)
      ..addColumns([quests.xpReward.sum()])
      ..where(quests.isCompleted.equals(true));

    final result = await query
        .map((row) => row.read(quests.xpReward.sum()))
        .getSingleOrNull();
    return result ?? 0;
  }
}
