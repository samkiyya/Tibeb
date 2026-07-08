import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tibeb/core/theme/system/color_scheme.dart';

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

      targets: _tutorialService.buildTargets(),

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

        // When audiobook FAB target is tapped during tutorial, show the import sheet
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

        // Audiobook import FAB — accessible from every tab
        floatingActionButton: _AudiobookFab(
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

// ─── Audiobook Import FAB ─────────────────────────────────────────────────────
//
// A compact pulsing FAB that opens AudiobookImportSheet.
// Positioned above the notch bar using floatingActionButtonLocation.

class _AudiobookFab extends ConsumerStatefulWidget {
  final GlobalKey? tutorialKey;
  const _AudiobookFab({this.tutorialKey});

  @override
  ConsumerState<_AudiobookFab> createState() => _AudiobookFabState();
}

class _AudiobookFabState extends ConsumerState<_AudiobookFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;

    return ScaleTransition(
      scale: _scale,
      child: FloatingActionButton(
        key: widget.tutorialKey,
        heroTag: 'audiobook_import_fab',
        onPressed: () => AudiobookImportSheet.show(context),
        backgroundColor: t.primary,
        elevation: 8,
        tooltip: 'Import Audiobook',
        shape: const CircleBorder(),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                t.primary,
                t.primary.withValues(alpha: 0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: t.primary.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.headphones_rounded,
            color: Colors.white,
            size: 26,
          ),
        ),
      ),
    );
  }
}
