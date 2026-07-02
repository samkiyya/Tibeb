import 'package:tibeb/core/tibeb_rank_data.dart';
import 'package:tibeb/core/tibeb_rank.dart';


class TibebRankRepository {
  List<TibebRank> getAllRanks() {
    return TibebRankData.ranks;
  }

  TibebRank getCurrentRank(int level, int achievements) {
    return TibebRankData.ranks
        .where((r) =>
            level >= r.level &&
            achievements >= r.achievementsRequired)
        .last;
  }
}

// final rank = currentRank;

// Text(rank.name);
// Text(rank.description);