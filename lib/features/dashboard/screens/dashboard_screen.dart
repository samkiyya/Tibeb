// features/dashboard/screens/dashboard_screen.dart
//
// Clean replacement — uses go_router for navigation, no Navigator.push.

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' show StateProvider;
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tibeb/shared/models/book_model.dart';

import '../../../app/router.dart';
import '../../../core/theme/theme.dart';
import '../../../features/library/providers/library_provider.dart';
import '../../../components/activity_graph.dart';
import '../../../components/book_overlay_menu.dart';
import '../../../components/daily_activity_sheet.dart';
import '../../../components/stat_badge.dart';
import '../../../components/streak_widget.dart';
import '../../../widgets/dashboard/continue_reading_card.dart';
import '../../../widgets/dashboard/dashboard_header.dart';
import '../../../widgets/dashboard/shelf_item.dart';

// One-shot animation guard — stays alive as long as app is running.
final _dashboardAnimatedProvider = StateProvider<bool>((ref) => false);

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(_dashboardAnimatedProvider.notifier).state = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(libraryNotifierProvider);
    final hasAnimated = ref.watch(_dashboardAnimatedProvider);
    final t = context.tibpiColors;

    final recentBooks = state.allBooks
        .where((b) => b.lastReadAt != null)
        .toList()
      ..sort((a, b) => b.lastReadAt!.compareTo(a.lastReadAt!));

    return Scaffold(
      backgroundColor: t.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(horizontal: TibebSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _anim(const DashboardHeader(), hasAnimated,
                  (w) => w.animate().fadeIn(duration: 600.ms).slideY(begin: 0.1)),
              const SizedBox(height: 30),
              if (recentBooks.isNotEmpty) ...[
                _anim(
                  _ContinueCard(
                    book: recentBooks.first,
                    onOpen: _openBook,
                    onOptions: _showBookOptions,
                  ),
                  hasAnimated,
                  (w) => w.animate().fadeIn(delay: 200.ms, duration: 600.ms)
                      .slideY(begin: 0.1),
                ),
                const SizedBox(height: 30),
              ],
              _anim(
                _QuickStats(state: state),
                hasAnimated,
                (w) => w.animate().fadeIn(delay: 400.ms, duration: 600.ms)
                    .slideY(begin: 0.1),
              ),
              const SizedBox(height: 30),
              _anim(
                Text('Reading Activity',
                    style: context.textTheme.titleLarge
                        ?.copyWith(color: t.textPrimary, fontWeight: FontWeight.bold)),
                hasAnimated,
                (w) => w.animate().fadeIn(delay: 500.ms),
              ),
              const SizedBox(height: 4),
              _anim(
                Text('Current Month',
                    style: TextStyle(color: t.textSecondary, fontSize: 12)),
                hasAnimated,
                (w) => w.animate().fadeIn(delay: 550.ms),
              ),
              const SizedBox(height: 12),
              _anim(
                ActivityGraph(
                  dailyValues: state.dailyReadingValues,
                  selectedMonth:
                      DateFormat('MMMM yyyy').format(DateTime.now()),
                  weeklyGoalType: state.weeklyGoalType,
                  weeklyGoalValue: state.weeklyGoalValue,
                  onDateTapped: (date, value) =>
                      _showDailyDetail(context, state, date, value),
                ),
                hasAnimated,
                (w) => w.animate().fadeIn(delay: 600.ms).slideY(begin: 0.05),
              ),
              if (recentBooks.length > 1) ...[
                const SizedBox(height: 30),
                _anim(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('My Shelf',
                          style: context.textTheme.titleLarge?.copyWith(
                              color: t.textPrimary,
                              fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () => context.go(AppRoutes.library),
                        child: Text('See More',
                            style: TextStyle(
                                color: t.primary,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  hasAnimated,
                  (w) => w.animate().fadeIn(delay: 800.ms),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 180,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: (recentBooks.length - 1).clamp(0, 5),
                    separatorBuilder: (_, _) => const SizedBox(width: 16),
                    itemBuilder: (ctx, i) {
                      final book = recentBooks[i + 1];
                      return _anim(
                        ShelfItem(
                          book: book,
                          onLongPress: (p) => _showBookOptions(book, p),
                          onMenuPressed: (p) => _showBookOptions(book, p),
                        ),
                        hasAnimated,
                        (w) => w
                            .animate()
                            .fadeIn(delay: (900 + i * 100).ms)
                            .scale(begin: const Offset(0.9, 0.9)),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _anim(Widget w, bool hasAnimated, Widget Function(Widget) animator) =>
      hasAnimated ? w : animator(w);

  void _openBook(Book book) {
    ref.read(libraryNotifierProvider.notifier).markBookAsOpened(book);
    ref.read(currentlyReadingProvider.notifier).state = book;
    context.push(AppRoutes.reader, extra: book);
  }

  void _showBookOptions(Book book, Offset pos) {
    BookOverlayMenu.show(
      context: context,
      book: book,
      position: pos,
      onAction: (action) {
        switch (action) {
          case 'favorite':
            ref.read(libraryNotifierProvider.notifier)
                .toggleBookFavorite(book);
            break;
          case 'edit':
            context.push(AppRoutes.editBook, extra: book);
            break;
          case 'delete':
            _showDeleteDialog(book);
            break;
        }
      },
    );
  }

  void _showDeleteDialog(Book book) async {
    final t = context.tibpiColors;
    bool deleteHistory = false;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          backgroundColor: t.surface,
          title: Text('Remove Book',
              style: TextStyle(color: t.textPrimary)),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('Remove "${book.title}"?',
                style: TextStyle(color: t.textSecondary)),
            const SizedBox(height: 16),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('Remove reading history',
                  style: TextStyle(fontSize: 14, color: t.textSecondary)),
              value: deleteHistory,
              activeColor: t.primary,
              onChanged: (v) => setS(() => deleteHistory = v ?? false),
            ),
          ]),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text('Cancel',
                    style: TextStyle(color: t.textSecondary))),
            TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text('Remove',
                    style: TextStyle(color: t.error))),
          ],
        ),
      ),
    );
    if (ok == true) {
      ref.read(libraryNotifierProvider.notifier)
          .deleteBook(book.id!, deleteHistory: deleteHistory);
    }
  }

  void _showDailyDetail(
      BuildContext context, LibraryState state, DateTime date, int value) {
    if (value == 0) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => DailyActivitySheet(
        date: date,
        totalValue: value,
        goalType: state.weeklyGoalType,
        allBooks: state.allBooks,
        sessionHistory: state.sessionHistory,
      ),
    );
  }
}

// ─── Extracted sub-widgets ───────────────────────────────────────────────────

class _ContinueCard extends StatelessWidget {
  final Book book;
  final void Function(Book) onOpen;
  final void Function(Book, Offset) onOptions;

  const _ContinueCard(
      {required this.book, required this.onOpen, required this.onOptions});

  @override
  Widget build(BuildContext context) {
    return ContinueReadingCard(
      book: book,
      onLongPress: (pos) => onOptions(book, pos),
      onMenuPressed: (pos) => onOptions(book, pos),
    );
  }
}

class _QuickStats extends StatelessWidget {
  final LibraryState state;
  const _QuickStats({required this.state});

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    return Row(children: [
      Expanded(
          child: StreakWidget(
              streak: state.currentStreak,
              isActive: state.isStreakActiveToday)),
      const SizedBox(width: 8),
      Expanded(
          child: StatBadge(
              label: 'Pages',
              value: '${state.totalPagesRead}',
              icon: Icons.auto_stories,
              color: t.success)),
      const SizedBox(width: 8),
      Expanded(
          child: StatBadge(
              label: 'Minutes',
              value: '${state.totalMinutesRead}',
              icon: Icons.timer,
              color: t.streakFire)),
      const SizedBox(width: 8),
      Expanded(
          child: StatBadge(
              label: 'Level',
              value: '${state.level}',
              icon: Icons.stars_rounded,
              color: t.primary)),
    ]);
  }
}
