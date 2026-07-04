// app/router.dart — go_router configuration using plain Riverpod Provider.
// No code generation required.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tibeb/shared/models/book_model.dart';

import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/library/screens/library_screen.dart';
import '../features/reader/screens/reading_screen.dart';
import '../features/reader/screens/edit_book_screen.dart';
import '../features/reader/screens/google_image_search_screen.dart';
import '../features/stats/screens/stats_screen.dart';
import '../features/settings/screens/settings_screen.dart';
import '../app/shell.dart';

// ─── Route path constants ────────────────────────────────────────────────────

abstract class AppRoutes {
  static const home = '/';
  static const library = '/library';
  static const stats = '/stats';
  static const settings = '/settings';
  static const reader = '/reader';
  static const editBook = '/edit-book';
  static const imageSearch = '/image-search';
}

// ─── Provider ────────────────────────────────────────────────────────────────

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: false,
    routes: [
      // ── Shell (bottom nav tabs) ───────────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.library,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: LibraryScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.stats,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: StatsScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.settings,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsScreen(),
            ),
          ),
        ],
      ),

      // ── Full-screen routes (outside shell) ───────────────────────────────
      GoRoute(
        path: AppRoutes.reader,
        builder: (context, state) {
          final book = state.extra as Book?;
          return ReadingScreen(book: book);
        },
      ),
      GoRoute(
        path: AppRoutes.editBook,
        builder: (context, state) {
          final book = state.extra as Book;
          return EditBookScreen(book: book);
        },
      ),
      GoRoute(
        path: AppRoutes.imageSearch,
        builder: (context, state) {
          final query = state.extra as String? ?? '';
          return GoogleImageSearchScreen(query: query);
        },
      ),
    ],
  );
});
