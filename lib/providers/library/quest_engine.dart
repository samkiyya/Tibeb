import '../../models/quest_model.dart';

class QuestUpdateResult {
  final List<DailyQuest> updatedQuests;
  final List<DailyQuest> newlyCompletedQuests;
  final bool isChanged;

  QuestUpdateResult({
    required this.updatedQuests,
    required this.newlyCompletedQuests,
    required this.isChanged,
  });
}

class QuestEngine {
  static List<DailyQuest> generateDaily(String dateStr) {
    final date = DateTime.parse(dateStr);
    final isWeekend =
        date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
    final multiplier = isWeekend ? 2 : 1;

    return [
      DailyQuest(
        id: 'pages_$dateStr',
        title: 'Daily Reader',
        description: 'Read 5 pages today.',
        type: QuestType.pages,
        targetValue: 5,
        wpReward: 100 * multiplier,
        date: date,
      ),
      DailyQuest(
        id: 'minutes_$dateStr',
        title: 'Deep Focus',
        description: 'Read for 15 minutes.',
        type: QuestType.minutes,
        targetValue: 15,
        wpReward: 150 * multiplier,
        date: date,
      ),
      DailyQuest(
        id: 'early_$dateStr',
        title: 'Early Bird',
        description: 'Read before 9:00 AM.',
        type: QuestType.earlyBird,
        targetValue: 1,
        wpReward: 200 * multiplier,
        date: date,
      ),
    ];
  }

  static QuestUpdateResult applyProgress({
    required List<DailyQuest> currentQuests,
    required int pagesRead,
    required int minutesRead,
    required DateTime timestamp,
  }) {
    final updatedQuests = <DailyQuest>[];
    final newlyCompletedQuests = <DailyQuest>[];
    bool isChanged = false;

    for (var quest in currentQuests) {
      if (quest.isCompleted) {
        updatedQuests.add(quest);
        continue;
      }

      int newVal = quest.currentValue;
      bool newlyCompleted = false;

      switch (quest.type) {
        case QuestType.pages:
          newVal += pagesRead;
          break;
        case QuestType.minutes:
          newVal += minutesRead;
          break;
        case QuestType.earlyBird:
          if (timestamp.hour < 9) {
            newVal = 1;
          }
          break;
        case QuestType.nightOwl:
          if (timestamp.hour >= 22 || timestamp.hour < 1) {
            newVal = 1;
          }
          break;
        case QuestType.bookFinished:
          break;
        case QuestType.dictionaryLookup:
          newVal += 1;
          break;
      }

      if (newVal >= quest.targetValue) {
        newVal = quest.targetValue;
        newlyCompleted = true;
      }

      if (newVal != quest.currentValue || newlyCompleted) {
        final updated = quest.copyWith(
          currentValue: newVal,
          isCompleted: newlyCompleted,
        );
        updatedQuests.add(updated);
        if (newlyCompleted) {
          newlyCompletedQuests.add(updated);
        }
        isChanged = true;
      } else {
        updatedQuests.add(quest);
      }
    }

    return QuestUpdateResult(
      updatedQuests: updatedQuests,
      newlyCompletedQuests: newlyCompletedQuests,
      isChanged: isChanged,
    );
  }

  static QuestUpdateResult applyDictionaryLookup({
    required List<DailyQuest> currentQuests,
  }) {
    final updatedQuests = <DailyQuest>[];
    final newlyCompletedQuests = <DailyQuest>[];
    bool isChanged = false;

    for (var quest in currentQuests) {
      if (quest.type == QuestType.dictionaryLookup && !quest.isCompleted) {
        int newVal = quest.currentValue + 1;
        bool newlyCompleted = newVal >= quest.targetValue;
        final updated = quest.copyWith(
          currentValue: newlyCompleted ? quest.targetValue : newVal,
          isCompleted: newlyCompleted,
        );
        updatedQuests.add(updated);
        if (newlyCompleted) {
          newlyCompletedQuests.add(updated);
        }
        isChanged = true;
      } else {
        updatedQuests.add(quest);
      }
    }

    return QuestUpdateResult(
      updatedQuests: updatedQuests,
      newlyCompletedQuests: newlyCompletedQuests,
      isChanged: isChanged,
    );
  }
}
