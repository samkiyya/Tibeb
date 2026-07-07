import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../../widgets/tutorial_coach.dart';

/// Helper to handle first-launch tutorial coach marks configuration and display.
class ReadingTutorialHelper {
  /// Checks if this is the first launch of the reading screen and shows the tutorial if so.
  static Future<void> checkAndShow({
    required BuildContext context,
    required bool isPdf,
    required GlobalKey tocKey,
    required GlobalKey searchKey,
    required GlobalKey lockKey,
    required GlobalKey audioKey,
    required GlobalKey autoScrollKey,
    required GlobalKey displaySettingsKey,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isMainFirstLaunch = prefs.getBool('is_first_launch') ?? true;
      if (isMainFirstLaunch) return;

      final isFirstLaunch = prefs.getBool('is_first_launch_reading') ?? true;
      if (isFirstLaunch && context.mounted) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (context.mounted) {
            _showTutorial(
              context: context,
              isPdf: isPdf,
              tocKey: tocKey,
              searchKey: searchKey,
              lockKey: lockKey,
              audioKey: audioKey,
              autoScrollKey: autoScrollKey,
              displaySettingsKey: displaySettingsKey,
              onComplete: () {
                SharedPreferences.getInstance().then((prefs) {
                  prefs.setBool('is_first_launch_reading', false);
                });
              },
            );
          }
        });
      }
    } catch (e) {
      debugPrint('Error checking first launch for reading tutorial: $e');
    }
  }

  static void _showTutorial({
    required BuildContext context,
    required bool isPdf,
    required GlobalKey tocKey,
    required GlobalKey searchKey,
    required GlobalKey lockKey,
    required GlobalKey audioKey,
    required GlobalKey autoScrollKey,
    required GlobalKey displaySettingsKey,
    required VoidCallback onComplete,
  }) {
    final targets = <TargetFocus>[
      TutorialHelper.createTarget(
        identify: "toc_target",
        keyTarget: tocKey,
        alignSkip: Alignment.topRight,
        title: "Navigation",
        description:
            "Access the Table of Contents, outlines, and your bookmarks.",
        contentAlign: ContentAlign.top,
      ),
      TutorialHelper.createTarget(
        identify: "search_target",
        keyTarget: searchKey,
        alignSkip: Alignment.bottomLeft,
        title: "Search",
        description: "Find specific phrases or words quickly within the book.",
        contentAlign: ContentAlign.bottom,
        crossAxisAlignment: CrossAxisAlignment.end,
        textAlign: TextAlign.right,
      ),
      if (isPdf)
        TutorialHelper.createTarget(
          identify: "lock_target",
          keyTarget: lockKey,
          alignSkip: Alignment.bottomRight,
          title: "Scroll Lock",
          description:
              "Lock the PDF to horizontal scrolling, vertical scrolling, or lock the zoom level.",
          contentAlign: ContentAlign.bottom,
        ),
      TutorialHelper.createTarget(
        identify: "audio_target",
        keyTarget: audioKey,
        alignSkip: Alignment.topRight,
        title: "Immersive Audio",
        description:
            "Tap the + icon to attach an audiobook file. If one is attached, tap here to open the audio controls.",
        contentAlign: ContentAlign.top,
      ),
      TutorialHelper.createTarget(
        identify: "autoscroll_target",
        keyTarget: autoScrollKey,
        alignSkip: Alignment.topLeft,
        title: "Auto-Scroll",
        description:
            "Sit back and let the app scroll for you. Adjust the speed in the settings.",
        contentAlign: ContentAlign.top,
        crossAxisAlignment: CrossAxisAlignment.end,
        textAlign: TextAlign.right,
      ),
      TutorialHelper.createTarget(
        identify: "display_target",
        keyTarget: displaySettingsKey,
        alignSkip: Alignment.topLeft,
        title: "Display Settings",
        description:
            "Customize fonts, themes, margins, and more to suit your reading style.",
        contentAlign: ContentAlign.top,
        crossAxisAlignment: CrossAxisAlignment.end,
        textAlign: TextAlign.right,
      ),
    ];

    TutorialHelper.showTutorial(
      context: context,
      targets: targets,
      onFinish: onComplete,
      onSkip: () {
        onComplete();
        return true;
      },
    );
  }
}
