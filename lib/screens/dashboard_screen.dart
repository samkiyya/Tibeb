import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/theme.dart';

import '../components/activity_graph.dart';
import '../components/stat_badge.dart';
import '../components/daily_activity_sheet.dart';
import '../providers/library_provider.dart';
import './dashboard/widgets/dashboard_header.dart';
import './dashboard/widgets/continue_reading_card.dart';
import './dashboard/widgets/shelf_item.dart';
import '../components/streak_widget.dart';
import 'main_navigation.dart';
import '../models/book_model.dart';
import 'edit_book_screen.dart';
import '../components/book_overlay_menu.dart';

final hasDashboardAnimatedProvider = StateProvider<bool>((ref) => false);

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
        ref.read(hasDashboardAnimatedProvider.notifier).state = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final libraryState = ref.watch(libraryProvider);
    final hasAnimated = ref.watch(hasDashboardAnimatedProvider);
    final t = context.tibpiColors;

    final recentBooks =
        libraryState.allBooks.where((b) => b.lastReadAt != null).toList()
          ..sort((a, b) => b.lastReadAt!.compareTo(a.lastReadAt!));

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
              _animateIf(
                const DashboardHeader(),
                hasAnimated,
                (w) => w
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.1, end: 0),
              ),
              const SizedBox(height: 30),
              if (recentBooks.isNotEmpty) ...[
                _animateIf(
                  ContinueReadingCard(
                    book: recentBooks.first,
                    onLongPress: (pos) =>
                        _showBookOptions(recentBooks.first, pos),
                    onMenuPressed: (pos) =>
                        _showBookOptions(recentBooks.first, pos),
                  ),
                  hasAnimated,
                  (w) => w
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 600.ms)
                      .slideY(begin: 0.1, end: 0),
                ),
                const SizedBox(height: 30),
              ],
              const SizedBox(height: 30),
              _animateIf(
                _buildQuickStats(context, t, libraryState),
                hasAnimated,
                (w) => w
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 600.ms)
                    .slideY(begin: 0.1, end: 0),
              ),
              const SizedBox(height: 30),
              _animateIf(
                Text(
                  'Reading Activity',
                  style: context.textTheme.titleLarge?.copyWith(
                    color: t.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                hasAnimated,
                (w) => w.animate().fadeIn(delay: 500.ms),
              ),
              const SizedBox(height: 4),
              _animateIf(
                Text(
                  'Current Month',
                  style: TextStyle(color: t.textSecondary, fontSize: 12),
                ),
                hasAnimated,
                (w) => w.animate().fadeIn(delay: 550.ms),
              ),
              const SizedBox(height: 12),
              _animateIf(
                ActivityGraph(
                  dailyValues: libraryState.dailyReadingValues,
                  selectedMonth: DateFormat('MMMM yyyy').format(DateTime.now()),
                  weeklyGoalType: libraryState.weeklyGoalType,
                  weeklyGoalValue: libraryState.weeklyGoalValue,
                  onDateTapped: (date, value) => _showDailyActivityDetail(
                    context,
                    t,
                    libraryState,
                    date,
                    value,
                  ),
                ),
                hasAnimated,
                (w) => w
                    .animate()
                    .fadeIn(delay: 600.ms)
                    .slideY(begin: 0.05, end: 0),
              ),
              const SizedBox(height: 30),
              if (recentBooks.length > 1) ...[
                _animateIf(
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'My Shelf',
                        style: context.textTheme.titleLarge?.copyWith(
                          color: t.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          ref.read(navigationStateProvider.notifier).state =
                              NavigationState(current: 1, previous: 0);
                        },
                        child: Text(
                          'See More',
                          style: TextStyle(
                            color: t.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final book = recentBooks[index + 1];
                      return _animateIf(
                        ShelfItem(
                          book: book,
                          onLongPress: (pos) => _showBookOptions(book, pos),
                          onMenuPressed: (pos) => _showBookOptions(book, pos),
                        ),
                        hasAnimated,
                        (w) => w
                            .animate()
                            .fadeIn(delay: (900 + (index * 100)).ms)
                            .scale(begin: const Offset(0.9, 0.9)),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
              ],
              const SizedBox(height: 30),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _animateIf(
    Widget widget,
    bool hasAnimated,
    Widget Function(Widget) animator,
  ) {
    if (hasAnimated) return widget;
    return animator(widget);
  }

  Widget _buildQuickStats(
    BuildContext context,
    TibebThemeExtension t,
    LibraryState state,
  ) {
    return Row(
      children: [
        Expanded(
          child: StreakWidget(
            streak: state.currentStreak,
            isActive: state.isStreakActiveToday,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: StatBadge(
            label: 'Pages',
            value: '${state.totalPagesRead}',
            icon: Icons.auto_stories,
            color: t.success,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: StatBadge(
            label: 'Minutes',
            value: '${state.totalMinutesRead}',
            icon: Icons.timer,
            color: t.streakFire,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: StatBadge(
            label: 'Level',
            value: '${state.level}',
            icon: Icons.stars_rounded,
            color: t.primary,
          ),
        ),
      ],
    );
  }

  void _showDailyActivityDetail(
    BuildContext context,
    TibebThemeExtension t,
    LibraryState state,
    DateTime date,
    int totalValue,
  ) {
    if (totalValue == 0) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => DailyActivitySheet(
        date: date,
        totalValue: totalValue,
        goalType: state.weeklyGoalType,
        allBooks: state.allBooks,
        sessionHistory: state.sessionHistory,
      ),
    );
  }

  void _showBookOptions(Book book, Offset tapPosition) {
    BookOverlayMenu.show(
      context: context,
      book: book,
      position: tapPosition,
      onAction: (action) {
        switch (action) {
          case 'favorite':
            ref.read(libraryProvider.notifier).toggleBookFavorite(book);
            break;
          case 'edit':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditBookScreen(book: book),
              ),
            );
            break;
          case 'delete':
            _showDeleteConfirmation(book);
            break;
        }
      },
    );
  }

  void _showDeleteConfirmation(Book book) async {
    final t = context.tibpiColors;
    bool deleteHistory = false;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: t.surface,
            title: Text('Remove Book', style: TextStyle(color: t.textPrimary)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Are you sure you want to remove "${book.title}"?',
                  style: TextStyle(color: t.textSecondary),
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Remove reading history',
                    style: TextStyle(fontSize: 14, color: t.textSecondary),
                  ),
                  value: deleteHistory,
                  activeColor: t.primary,
                  onChanged: (val) {
                    setDialogState(() {
                      deleteHistory = val ?? false;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancel', style: TextStyle(color: t.textSecondary)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('Remove', style: TextStyle(color: t.error)),
              ),
            ],
          );
        },
      ),
    );

    if (confirm == true) {
      ref
          .read(libraryProvider.notifier)
          .deleteBook(book.id!, deleteHistory: deleteHistory);
    }
  }
}
