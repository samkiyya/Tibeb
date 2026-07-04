import 'dart:async';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import '../app/router.dart';
import '../core/theme/theme.dart';
import '../core/rank/tibeb_rank_repository.dart';
import '../features/library/providers/library_provider.dart';
import '../components/glass_container.dart';
import '../components/rank_up_dialog.dart';

/// The navigation indexes mirror the shell route order.
const _tabs = [
  AppRoutes.home,
  AppRoutes.library,
  AppRoutes.stats,
  AppRoutes.settings,
];

const _icons = [
  Icons.dashboard_rounded,
  Icons.menu_book_rounded,
  Icons.bar_chart_rounded,
  Icons.settings_rounded,
];

class AppShell extends ConsumerStatefulWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  StreamSubscription? _intentSub;
  int _lastIndex = 0;

  @override
  void initState() {
    super.initState();
    _initSharingIntent();
  }

  void _initSharingIntent() {
    _intentSub = ReceiveSharingIntent.instance
        .getMediaStream()
        .listen(_handleSharedFiles);
    ReceiveSharingIntent.instance
        .getInitialMedia()
        .then(_handleSharedFiles);
  }

  Future<void> _handleSharedFiles(List<SharedMediaFile> files) async {
    if (files.isEmpty || !mounted) return;
    final paths = files.map((f) => f.path).toList();
    final books =
        await ref.read(libraryNotifierProvider.notifier).importFiles(paths);
    if (books.isNotEmpty && mounted) {
      final book = books.first;
      ref.read(libraryNotifierProvider.notifier).markBookAsOpened(book);
      ref.read(currentlyReadingProvider.notifier).state = book;
      context.push(AppRoutes.reader, extra: book);
    }
  }

  @override
  void dispose() {
    _intentSub?.cancel();
    super.dispose();
  }

  int _locationToIndex(BuildContext context) {
    final loc = GoRouterState.of(context).uri.path;
    final idx = _tabs.indexOf(loc);
    return idx < 0 ? 0 : idx;
  }

  @override
  Widget build(BuildContext context) {
    // Watch for rank ups
    ref.listen(libraryNotifierProvider.select((s) => s.level), (prev, next) {
      final state = ref.read(libraryNotifierProvider);
      if (!state.isReading) _checkRankUp(next, state);
    });
    ref.listen(libraryNotifierProvider.select((s) => s.isReading),
        (prev, next) {
      if (prev == true && next == false) {
        final state = ref.read(libraryNotifierProvider);
        _checkRankUp(state.level, state);
      }
    });

    final currentIndex = _locationToIndex(context);
    final isReverse = currentIndex < _lastIndex;

    return Scaffold(
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 300),
        reverse: isReverse,
        transitionBuilder: (child, animation, secondaryAnimation) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            fillColor: context.tibpiColors.background,
            child: child,
          );
        },
        child: KeyedSubtree(
          key: ValueKey(currentIndex),
          child: widget.child,
        ),
      ),
      extendBody: true,
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: GlassContainer(
            height: 70,
            blur: 20,
            opacity: 0.1,
            borderRadius: 35,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_tabs.length, (i) {
                final selected = i == currentIndex;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (currentIndex != i) {
                        _lastIndex = currentIndex;
                        context.go(_tabs[i]);
                      }
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _icons[i],
                          color: selected
                              ? context.tibpiColors.primary
                              : context.tibpiColors.textTertiary,
                          size: 28,
                        ),
                        if (selected)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: context.tibpiColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  void _checkRankUp(int level, LibraryState state) {
    if (!mounted) return;
    final currentRank = TibebRankRepository.instance
        .getCurrentRank(level, state.unlockedAchievements.length);
    final lastRank = TibebRankRepository.instance.getCurrentRank(
        state.lastCelebratedLevel, state.unlockedAchievements.length);
    if (currentRank.level > lastRank.level) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) =>
            RankUpDialog(level: level, rankName: state.rankName),
      );
      ref
          .read(libraryNotifierProvider.notifier)
          .markLevelCelebrated(level);
    }
  }
}
