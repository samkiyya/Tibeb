import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tibeb/providers/navigation_provider.dart';

import 'package:tibeb/screens/audiobook_player_screen.dart';
import 'package:tibeb/screens/dashboard_screen.dart';
import 'package:tibeb/screens/library_screen.dart';
import 'package:tibeb/screens/stats_screen.dart';
import 'package:tibeb/screens/settings_screen.dart';

import 'package:tibeb/services/navigation_service.dart';
import 'package:tibeb/services/tutorial_service.dart';

import 'package:tibeb/widgets/navigation_bar.dart';
import 'package:tibeb/widgets/tutorial_coach.dart';
import 'package:tibeb/widgets/app_event_listener.dart';
import 'package:tibeb/widgets/audiobook_fab.dart';

class MainNavigation extends ConsumerStatefulWidget {
  const MainNavigation({super.key});

  @override
  ConsumerState<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends ConsumerState<MainNavigation> {
  final NavigationService _navigationService = NavigationService();
  final TutorialService _tutorialService = TutorialService();

  static const List<Widget> _screens = [
    DashboardScreen(),
    LibraryScreen(),
    StatsScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _navigationService.initialize(ref: ref);
    _initializeTutorial();
  }

  Future<void> _initializeTutorial() async {
    final shouldShow = await _tutorialService.shouldShowTutorial();

    if (!mounted || !shouldShow) {
      return;
    }

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) {
      return;
    }

    TutorialHelper.showTutorial(
      context: context,
      targets: _tutorialService.buildTargets(context),
      onClickTarget: (target) {
        const map = {
          'library_target': 1,
          'stats_target': 2,
          'settings_target': 3,
        };

        final index = map[target.identify];

        if (index != null) {
          ref.read(navigationStateProvider.notifier).changeTab(index);
        }

        if (target.identify == 'audiobook_fab_target') {
          AudiobookImportSheet.show(context);
        }
      },
      onFinish: () {
        _tutorialService.markComplete();
      },
      onSkip: () {
        _tutorialService.markComplete();
        return true;
      },
    );
  }

  @override
  void dispose() {
    _navigationService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navigation = ref.watch(navigationStateProvider);
    final index = navigation.current;
    final reverse = navigation.current < navigation.previous;

    return AppEventListener(
      child: Scaffold(
        body: PageTransitionSwitcher(
          duration: const Duration(milliseconds: 300),
          reverse: reverse,
          transitionBuilder: (child, animation, secondaryAnimation) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              fillColor: Theme.of(context).scaffoldBackgroundColor,
              child: child,
            );
          },
          child: KeyedSubtree(key: ValueKey(index), child: _screens[index]),
        ),
        extendBody: true,
        // Using the public, modular decoupled Audiobook FAB instance
        floatingActionButton: AudiobookFab(
          tutorialKey: _tutorialService.audiobookFabKey,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: CustomBottomNavigationBar(
          itemKeys: [
            _tutorialService.homeKey,
            _tutorialService.libraryKey,
            _tutorialService.statsKey,
            _tutorialService.settingsKey,
          ],
        ),
      ),
    );
  }
}
