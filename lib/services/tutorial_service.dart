import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:flutter/material.dart';

import 'package:tibeb/l10n/app_localizations.dart';
import 'package:tibeb/widgets/tutorial_coach.dart';

class TutorialService {
  static const String _firstLaunchKey = 'is_first_launch';

  final GlobalKey homeKey = GlobalKey();
  final GlobalKey libraryKey = GlobalKey();
  final GlobalKey audiobookFabKey = GlobalKey();
  final GlobalKey statsKey = GlobalKey();
  final GlobalKey settingsKey = GlobalKey();

  Future<bool> shouldShowTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_firstLaunchKey) ?? true;
  }

  List<TargetFocus> buildTargets(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return [
      TutorialHelper.createTarget(
        identify: 'home_target',
        keyTarget: homeKey,
        title: l10n.tutHomeDashTitle,
        description: l10n.tutHomeDashDesc,
        contentAlign: ContentAlign.top,
      ),

      TutorialHelper.createTarget(
        identify: 'library_target',
        keyTarget: libraryKey,
        title: l10n.tutLibraryTitle,
        description: l10n.tutLibraryDesc,
        contentAlign: ContentAlign.top,
      ),

      TutorialHelper.createTarget(
        identify: 'audiobook_fab_target',
        keyTarget: audiobookFabKey,
        title: l10n.tutAudiobookFabTitle,
        description: l10n.tutAudiobookFabDesc,
        contentAlign: ContentAlign.top,
      ),

      TutorialHelper.createTarget(
        identify: 'stats_target',
        keyTarget: statsKey,
        title: l10n.mainTutStatsTitle,
        description: l10n.mainTutStatsDesc,
        contentAlign: ContentAlign.top,
      ),

      TutorialHelper.createTarget(
        identify: 'settings_target',
        keyTarget: settingsKey,
        title: l10n.mainTutSettingsTitle,
        description: l10n.mainTutSettingsDesc,
        contentAlign: ContentAlign.top,
      ),
    ];
  }

  Future<void> markComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstLaunchKey, false);
  }
}
