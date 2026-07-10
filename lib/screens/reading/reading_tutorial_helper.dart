import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/tutorial_coach.dart';

/// Helper to handle first-launch tutorial coach marks for the reading screen.
class ReadingTutorialHelper {
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
    final l10n = AppLocalizations.of(context)!;
    final targets = <TargetFocus>[
      TutorialHelper.createTarget(
        identify: "toc_target",
        keyTarget: tocKey,
        alignSkip: Alignment.topRight,
        title: l10n.tutNavTitle,
        description: l10n.tutNavDesc,
        contentAlign: ContentAlign.top,
      ),
      TutorialHelper.createTarget(
        identify: "search_target",
        keyTarget: searchKey,
        alignSkip: Alignment.bottomLeft,
        title: l10n.tutSearchTitle,
        description: l10n.tutSearchDesc,
        contentAlign: ContentAlign.bottom,
        crossAxisAlignment: CrossAxisAlignment.end,
        textAlign: TextAlign.right,
      ),
      if (isPdf)
        TutorialHelper.createTarget(
          identify: "lock_target",
          keyTarget: lockKey,
          alignSkip: Alignment.bottomRight,
          title: l10n.tutScrollLockTitle,
          description: l10n.tutScrollLockDesc,
          contentAlign: ContentAlign.bottom,
        ),
      TutorialHelper.createTarget(
        identify: "audio_target",
        keyTarget: audioKey,
        alignSkip: Alignment.topRight,
        title: l10n.tutAudioTitle,
        description: l10n.tutAudioDesc,
        contentAlign: ContentAlign.top,
      ),
      TutorialHelper.createTarget(
        identify: "autoscroll_target",
        keyTarget: autoScrollKey,
        alignSkip: Alignment.topLeft,
        title: l10n.tutAutoScrollTitle,
        description: l10n.tutAutoScrollDesc,
        contentAlign: ContentAlign.top,
        crossAxisAlignment: CrossAxisAlignment.end,
        textAlign: TextAlign.right,
      ),
      TutorialHelper.createTarget(
        identify: "display_target",
        keyTarget: displaySettingsKey,
        alignSkip: Alignment.topLeft,
        title: l10n.tutDisplayTitle,
        description: l10n.tutDisplayDesc,
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
