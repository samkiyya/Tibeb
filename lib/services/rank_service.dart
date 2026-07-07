import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tibeb/core/rank/tibeb_rank_repository.dart';
import 'package:tibeb/providers/library_provider.dart';
import 'package:tibeb/providers/rank_provider.dart';

/// Handles rank-up detection.
///
/// This service:
/// - Calculates whether a user ranked up
/// - Emits a UI event
///
/// It does NOT display dialogs.
class RankService {
  const RankService();

  void checkForRankUp(WidgetRef ref, LibraryState state) {
    final currentRank = TibebRankRepository.instance.getCurrentRank(
      state.level,
      state.unlockedAchievements.length,
    );

    final lastRank = TibebRankRepository.instance.getCurrentRank(
      state.lastCelebratedLevel,
      state.unlockedAchievements.length,
    );

    if (currentRank.level <= lastRank.level) {
      return;
    }

    ref
        .read(rankEventProvider.notifier)
        .show(RankUpEvent(level: state.level, rankName: state.rankName));

    ref.read(libraryProvider.notifier).markLevelCelebrated(state.level);
  }
}
