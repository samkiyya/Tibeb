import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tibeb/providers/library_provider.dart';
import 'package:tibeb/providers/navigation_provider.dart';
import 'package:tibeb/providers/rank_provider.dart';

import 'package:tibeb/screens/reading_screen.dart';
import 'package:tibeb/screens/audiobook_player_screen.dart';

import 'package:tibeb/services/rank_service.dart';

import 'package:tibeb/widgets/rank_up_dialog.dart';

class AppEventListener extends ConsumerStatefulWidget {
  final Widget child;

  const AppEventListener({super.key, required this.child});

  @override
  ConsumerState<AppEventListener> createState() => _AppEventListenerState();
}

class _AppEventListenerState extends ConsumerState<AppEventListener> {
  static const RankService _rankService = RankService();

  @override
  void initState() {
    super.initState();

    _setupListeners();
  }

  void _setupListeners() {
    // Detect rank changes
    ref.listenManual(libraryProvider.select((state) => state.level), (
      previous,
      next,
    ) {
      final state = ref.read(libraryProvider);

      if (!state.isReading) {
        _rankService.checkForRankUp(ref, state);
      }
    });

    // Detect leaving reader
    ref.listenManual(libraryProvider.select((state) => state.isReading), (
      previous,
      next,
    ) {
      if (previous == true && next == false) {
        final state = ref.read(libraryProvider);

        _rankService.checkForRankUp(ref, state);
      }
    });

    // Navigation events
    ref.listenManual(navigationEventProvider, (previous, event) async {
      if (!mounted || event == null) {
        return;
      }

      switch (event.type) {
        case NavigationEventType.openReader:
          final book = ref.read(currentlyReadingProvider);
          final isAudioOnly = book?.isAudioOnly ?? false;

          if (isAudioOnly && book != null) {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AudioOnlyPlayerScreen(book: book),
              ),
            );
          } else {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const ReadingScreen()),
            );
          }

          if (!mounted) return;
          ref.read(navigationEventProvider.notifier).clear();
          break;
      }
    });

    // Rank dialogs
    ref.listenManual(rankEventProvider, (previous, event) {
      if (!mounted || event == null) {
        return;
      }

      showDialog(
        context: context,

        barrierDismissible: false,

        builder: (_) {
          return RankUpDialog(level: event.level, rankName: event.rankName);
        },
      );

      ref.read(rankEventProvider.notifier).clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
