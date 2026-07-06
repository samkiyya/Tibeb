// services/navigation_service.dart
import 'dart:async';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:tibeb/core/theme/system/color_scheme.dart';
import 'package:tibeb/providers/library_provider.dart';
import 'package:tibeb/screens/reading_screen.dart';
import 'package:tibeb/services/tutorial_service.dart';
import 'package:tibeb/services/rank_service.dart';

class NavigationService {
  StreamSubscription? _intentDataStreamSubscription;
  late BuildContext _context;
  late WidgetRef _ref;
  late bool Function() _mountedChecker;
  final _tutorialService = TutorialService();

  void initialize({
    required BuildContext context,
    required WidgetRef ref,
    required bool Function() mountedChecker,
  }) {
    _context = context;
    _ref = ref;
    _mountedChecker = mountedChecker;
    _setupIntentListeners();
    _setupRankCelebrationListener();
  }

  void dispose() {
    _intentDataStreamSubscription?.cancel();
  }

  void _setupIntentListeners() {
    // Listen for media sharing while app is running
    _intentDataStreamSubscription = ReceiveSharingIntent.instance
        .getMediaStream()
        .listen(
          (List<SharedMediaFile> value) {
            if (_mountedChecker()) {
              _handleSharedFiles(value);
            }
          },
          onError: (err) {
            debugPrint("getIntentDataStream error: $err");
          },
        );

    // Handle initial media when app is closed
    ReceiveSharingIntent.instance.getInitialMedia().then(
      (List<SharedMediaFile> value) {
        if (_mountedChecker()) {
          _handleSharedFiles(value);
        }
      },
    );
  }

  Future<void> _handleSharedFiles(List<SharedMediaFile> files) async {
    if (files.isEmpty) return;

    final paths = files.map((f) => f.path).toList();
    final books = await _ref.read(libraryProvider.notifier).importFiles(paths);

    if (books.isNotEmpty && _mountedChecker()) {
      final book = books.first;
      _ref.read(currentlyReadingProvider.notifier).state = book;
      _ref.read(libraryProvider.notifier).markBookAsOpened(book);

      Navigator.push(
        _context,
        MaterialPageRoute(builder: (context) => const ReadingScreen()),
      );
    }
  }

  void _setupRankCelebrationListener() {
    final rankService = RankService(_context, _ref);
    
    _ref.listen(libraryProvider.select((s) => s.level), (previous, next) {
      final state = _ref.read(libraryProvider);
      if (!state.isReading) {
        rankService.checkAndShowRankUp(state);
      }
    });

    _ref.listen(libraryProvider.select((s) => s.isReading), (previous, isReading) {
      if (previous == true && isReading == false) {
        final state = _ref.read(libraryProvider);
        rankService.checkAndShowRankUp(state);
      }
    });
  }

  Future<void> checkFirstLaunch() async {
    await _tutorialService.checkAndShowTutorial(
      context: _context,
      ref: _ref,
      mountedChecker: _mountedChecker,
    );
  }

  Widget buildPageTransition({
    required int selectedIndex,
    required bool isReverse,
    required Widget child,
  }) {
    return PageTransitionSwitcher(
      duration: const Duration(milliseconds: 300),
      reverse: isReverse,
      transitionBuilder: (child, animation, secondaryAnimation) {
        return SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          fillColor: _context.tibpiColors.background,
          child: child,
        );
      },
      child: Container(
        key: ValueKey<int>(selectedIndex),
        child: child,
      ),
    );
  }
}