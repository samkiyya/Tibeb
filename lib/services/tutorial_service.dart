// services/tutorial_service.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tibeb/providers/navigation_provider.dart';
import 'package:tibeb/widgets/tutorial_coach.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class TutorialService {
  static const String FIRST_LAUNCH_KEY = 'is_first_launch';

  final GlobalKey homeKey = GlobalKey();
  final GlobalKey libraryKey = GlobalKey();
  final GlobalKey statsKey = GlobalKey();
  final GlobalKey settingsKey = GlobalKey();

  Future<void> checkAndShowTutorial({
    required BuildContext context,
    required WidgetRef ref,
    required bool Function() mountedChecker,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool(FIRST_LAUNCH_KEY) ?? true;

    if (isFirstLaunch && mountedChecker()) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mountedChecker()) {
          _showTutorial(context, ref);
        }
      });
    }
  }

  void _showTutorial(BuildContext context, WidgetRef ref) {
    final targets = [
      TutorialHelper.createTarget(
        identify: "home_target",
        keyTarget: homeKey,
        title: "Home Dashboard",
        description:
            "Welcome to tibeb! Here you can quickly resume your current book and see your recent activity.",
        contentAlign: ContentAlign.top,
      ),
      TutorialHelper.createTarget(
        identify: "library_target",
        keyTarget: libraryKey,
        title: "Your Library",
        description:
            "Access all your imported books here. Tap the plus button to add new EPUB or PDF files.",
        contentAlign: ContentAlign.top,
      ),
      TutorialHelper.createTarget(
        identify: "stats_target",
        keyTarget: statsKey,
        title: "Reading Stats",
        description:
            "Track your reading habits, view your level, and check your achievements as you read more books.",
        contentAlign: ContentAlign.top,
      ),
      TutorialHelper.createTarget(
        identify: "settings_target",
        keyTarget: settingsKey,
        title: "App Settings",
        description:
            "Customize your reading experience, adjust your preferences, and access help or about sections.",
        contentAlign: ContentAlign.top,
      ),
    ];

    TutorialHelper.showTutorial(
      context: context,
      targets: targets,
      onClickTarget: (target) => _handleTutorialNavigation(target, ref),
      onFinish: _markTutorialComplete,
      onSkip: _markTutorialComplete,
    );
  }

  void _handleTutorialNavigation(TargetModel target, WidgetRef ref) {
    final navigationMap = {
      "library_target": 1,
      "stats_target": 2,
      "settings_target": 3,
    };

    final index = navigationMap[target.identify];
    if (index != null) {
      final currentNavState = ref.read(navigationStateProvider);
      ref.read(navigationStateProvider.notifier).state = NavigationState(
        current: index,
        previous: currentNavState.current,
      );
    }
  }

  bool _markTutorialComplete() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(FIRST_LAUNCH_KEY, false);
    });
    return true;
  }

  // Getters for global keys
  GlobalKey getHomeKey() => homeKey;
  GlobalKey getLibraryKey() => libraryKey;
  GlobalKey getStatsKey() => statsKey;
  GlobalKey getSettingsKey() => settingsKey;
}