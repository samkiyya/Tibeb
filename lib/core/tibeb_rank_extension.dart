import 'package:tibeb/core/tibeb_rank_strings.dart';
import 'package:tibeb/core/tibeb_rank.dart';

extension TibebRankUI on TibebRank {
  String get name => TibebRankStrings.name[id] ?? id;

  String get description =>
      TibebRankStrings.description[id] ?? '';

  bool isUnlocked(int level, int achievements) {
    return level >= this.level &&
        achievements >= achievementsRequired;
  }
}