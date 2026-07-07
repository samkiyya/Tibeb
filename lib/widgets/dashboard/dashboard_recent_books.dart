import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tibeb/core/theme/theme.dart';
import 'package:tibeb/models/book_model.dart';
import 'package:tibeb/providers/navigation_provider.dart';
import 'package:tibeb/widgets/dashboard/shelf_item.dart';
import 'dashboard_actions.dart';
import 'dashboard_animation.dart';

/// Horizontal "My Shelf" strip showing up to 5 recently read books
/// (excluding the first book, which is shown in ContinueReadingCard).
class DashboardRecentBooks extends ConsumerWidget {
  final List<Book> books;
  final bool animated;

  const DashboardRecentBooks({
    super.key,
    required this.books,
    required this.animated,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Need at least 2 books: first is in ContinueReadingCard, rest go here.
    if (books.length <= 1) return const SizedBox.shrink();

    final t = context.tibpiColors;
    final shelfBooks = books.skip(1).take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardAnimation.fadeIn(
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
                  ref.read(navigationStateProvider.notifier).changeTab(1);
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
          animated,
          delay: 800.ms,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: shelfBooks.length,
            separatorBuilder: (_, _) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final book = shelfBooks[index];
              return DashboardAnimation.scaleIn(
                ShelfItem(
                  book: book,
                  onLongPress: (pos) =>
                      DashboardActions.show(context, ref, book, pos),
                  onMenuPressed: (pos) =>
                      DashboardActions.show(context, ref, book, pos),
                ),
                animated,
                delay: Duration(milliseconds: 900 + index * 100),
              );
            },
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
