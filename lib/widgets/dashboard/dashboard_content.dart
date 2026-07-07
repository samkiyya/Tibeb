import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tibeb/core/theme/theme.dart';
import 'package:tibeb/providers/dashboard_provider.dart';
import 'package:tibeb/widgets/dashboard/continue_reading_card.dart';
import 'package:tibeb/widgets/dashboard/dashboard_actions.dart';
import 'package:tibeb/widgets/dashboard/dashboard_activity_section.dart';
import 'package:tibeb/widgets/dashboard/dashboard_animation.dart';
import 'package:tibeb/widgets/dashboard/dashboard_header.dart';
import 'package:tibeb/widgets/dashboard/dashboard_quick_stats.dart';
import 'package:tibeb/widgets/dashboard/dashboard_recent_books.dart';

/// The full scrollable body of the Dashboard screen.
///
/// Receives [DashboardState] so it stays purely presentational — all business
/// logic lives in [DashboardNotifier].  Uses [ConsumerWidget] only for the
/// book-action callbacks that need [WidgetRef].
class DashboardContent extends ConsumerWidget {
  final DashboardState state;

  const DashboardContent({super.key, required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.tibpiColors;
    final animated = state.animated;
    final library = state.library;
    final recentBooks = state.recentBooks;

    return Scaffold(
      backgroundColor: t.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: TibebSpacing.screenPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // ── Greeting + WP progress bar ──────────────────────────────
              DashboardAnimation.fadeSlide(
                const DashboardHeader(),
                animated,
                delay: Duration.zero,
              ),

              const SizedBox(height: 30),

              // ── Continue Reading card ───────────────────────────────────
              if (recentBooks.isNotEmpty) ...[
                DashboardAnimation.fadeSlide(
                  ContinueReadingCard(
                    book: recentBooks.first,
                    onLongPress: (pos) => DashboardActions.show(
                      context,
                      ref,
                      recentBooks.first,
                      pos,
                    ),
                    onMenuPressed: (pos) => DashboardActions.show(
                      context,
                      ref,
                      recentBooks.first,
                      pos,
                    ),
                  ),
                  animated,
                  delay: 200.ms,
                ),
                const SizedBox(height: 30),
              ],

              // ── Streak / Pages / Minutes / Level badges ─────────────────
              DashboardAnimation.fadeSlide(
                DashboardQuickStats(state: library),
                animated,
                delay: 400.ms,
              ),

              const SizedBox(height: 30),

              // ── Monthly activity heatmap ────────────────────────────────
              DashboardAnimation.fadeSlide(
                DashboardActivitySection(state: library),
                animated,
                delay: 550.ms,
              ),

              const SizedBox(height: 30),

              // ── "My Shelf" horizontal strip ─────────────────────────────
              DashboardRecentBooks(
                books: recentBooks,
                animated: animated,
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
