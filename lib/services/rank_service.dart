// services/rank_service.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tibeb/core/rank/tibeb_rank.dart';
import 'package:tibeb/core/rank/tibeb_rank_repository.dart';
import 'package:tibeb/providers/library_provider.dart';
import 'package:tibeb/widgets/rank_up_dialog.dart';

class RankService {
  final BuildContext context;
  final WidgetRef ref;

  RankService(this.context, this.ref);

  void checkAndShowRankUp(LibraryState state) {
    final currentRank = TibebRankRepository.instance.getCurrentRank(
      state.level,
      state.unlockedAchievements.length,
    );
    final lastRank = TibebRankRepository.instance.getCurrentRank(
      state.lastCelebratedLevel,
      state.unlockedAchievements.length,
    );

    if (currentRank.level > lastRank.level) {
      _showRankUpDialog(state);
      ref.read(libraryProvider.notifier).markLevelCelebrated(state.level);
    }
  }

  void _showRankUpDialog(LibraryState state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RankUpDialog(
        level: state.level,
        rankName: state.rankName,
      ),
    );
  }
}