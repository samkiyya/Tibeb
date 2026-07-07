// main_navigation.dart (Main orchestrator)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tibeb/providers/navigation_provider.dart';
import 'package:tibeb/screens/dashboard_screen.dart';
import 'package:tibeb/screens/library_screen.dart';
import 'package:tibeb/screens/stats_screen.dart';
import 'package:tibeb/screens/settings_screen.dart';
import 'package:tibeb/services/navigation_service.dart';
import 'package:tibeb/widgets/navigation_bar.dart';

class MainNavigation extends ConsumerStatefulWidget {
  const MainNavigation({super.key});

  @override
  ConsumerState<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends ConsumerState<MainNavigation> {
  final _navigationService = NavigationService();

  @override
  void initState() {
    super.initState();
    _navigationService.initialize(
      context: context,
      ref: ref,
      mountedChecker: () => mounted,
    );
    _navigationService.checkFirstLaunch();
  }

  @override
  void dispose() {
    _navigationService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navState = ref.watch(navigationStateProvider);
    final screens = _buildScreens();

    return Scaffold(
      body: _navigationService.buildPageTransition(
        selectedIndex: navState.current,
        isReverse: navState.current < navState.previous,
        child: screens[navState.current],
      ),
      extendBody: true,
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }

  List<Widget> _buildScreens() => const [
    DashboardScreen(),
    LibraryScreen(),
    StatsScreen(),
    SettingsScreen(),
  ];
}