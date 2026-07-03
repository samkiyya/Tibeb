import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tibeb/core/rank/tibeb_rank_data.dart';
import 'package:tibeb/core/rank/tibeb_rank.dart';

final tibebRankRepositoryProvider = Provider<TibebRankRepository>((ref) {
  return TibebRankRepository.instance;
});

class TibebRankRepository {
  static final TibebRankRepository instance = TibebRankRepository._();

  TibebRankRepository._();

  List<TibebRank> getAllRanks() {
    return TibebRankData.ranks;
  }

  TibebRank getCurrentRank(int level, int achievements) {
    TibebRank current = TibebRankData.ranks.first;
    for (final rank in TibebRankData.ranks) {
      if (level >= rank.level && achievements >= rank.achievementsRequired) {
        current = rank;
      } else {
        break;
      }
    }
    return current;
  }

  TibebRank? getNextRank(int level, int achievements) {
    final current = getCurrentRank(level, achievements);
    final idx = TibebRankData.ranks.indexOf(current);
    if (idx < TibebRankData.ranks.length - 1) {
      return TibebRankData.ranks[idx + 1];
    }
    return null;
  }

  double getRankProgress(int level, int achievements) {
    final current = getCurrentRank(level, achievements);
    final next = getNextRank(level, achievements);
    if (next == null) return 1.0;
    final levelRange = next.level - current.level;
    if (levelRange <= 0) return 1.0;
    return ((level - current.level) / levelRange).clamp(0.0, 1.0);
  }
}

// final rank = currentRank;

// Text(rank.name);
// Text(rank.description);
