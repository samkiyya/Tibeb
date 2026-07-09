import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:flutter/material.dart';

import 'package:tibeb/widgets/tutorial_coach.dart';


class TutorialService {

  static const String _firstLaunchKey = 'is_first_launch';


  final GlobalKey homeKey = GlobalKey();
  final GlobalKey libraryKey = GlobalKey();
  final GlobalKey audiobookFabKey = GlobalKey();
  final GlobalKey statsKey = GlobalKey();
  final GlobalKey settingsKey = GlobalKey();



  Future<bool> shouldShowTutorial() async {

    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getBool(_firstLaunchKey) ?? true;

  }



  List<TargetFocus> buildTargets() {

    return [

      TutorialHelper.createTarget(
        identify: 'home_target',
        keyTarget: homeKey,
        title: 'Home Dashboard',
        description:
            'Welcome to Tibeb! Resume your current book and see your recent activity here.',
        contentAlign: ContentAlign.top,
      ),



      TutorialHelper.createTarget(
        identify: 'library_target',
        keyTarget: libraryKey,
        title: 'Your Library',
        description:
            'All your imported books live here. Tap the + button to add EPUB or PDF files.',
        contentAlign: ContentAlign.top,
      ),



      TutorialHelper.createTarget(
        identify: 'audiobook_fab_target',
        keyTarget: audiobookFabKey,
        title: 'Import Audiobooks',
        description:
            'Tap this button to import standalone audiobooks (MP3, M4A, M4B, FLAC…). '
            'Title, author, and cover art are extracted automatically from embedded tags.',
        contentAlign: ContentAlign.top,
      ),



      TutorialHelper.createTarget(
        identify: 'stats_target',
        keyTarget: statsKey,
        title: 'Reading Stats',
        description:
            'Track streaks, Wisdom Points, levels, and achievements as you read.',
        contentAlign: ContentAlign.top,
      ),



      TutorialHelper.createTarget(
        identify: 'settings_target',
        keyTarget: settingsKey,
        title: 'App Settings',
        description:
            'Customise notifications, appearance, and more.',
        contentAlign: ContentAlign.top,
      ),

    ];

  }



  Future<void> markComplete() async {

    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      _firstLaunchKey,
      false,
    );

  }

}