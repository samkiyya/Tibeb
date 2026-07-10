import 'package:flutter/material.dart';
import 'package:tibeb/widgets/book_card/book_badges.dart';
import 'package:tibeb/widgets/book_card/book_card_gesture_mixin.dart';
import 'package:tibeb/widgets/book_card/book_cover.dart';
import 'package:tibeb/widgets/book_card/book_info.dart';
import 'package:tibeb/widgets/book_card/book_progress_overlay.dart';
import 'package:tibeb/widgets/book_card/book_selection_overlay.dart';
import 'package:tibeb/core/theme/theme.dart';

import 'package:tibeb/widgets/glass_container.dart';
import 'package:tibeb/models/book_model.dart';

typedef PositionCallback = void Function(Offset position);

class BookCard extends StatefulWidget {
  final Book book;
  final VoidCallback? onTap;
  final PositionCallback? onLongPress;
  final PositionCallback? onMenuPressed;
  final GlobalKey? menuKey;
  final bool isSelected;
  final bool selectionMode;

  const BookCard({
    super.key,
    required this.book,
    this.onTap,
    this.onLongPress,
    this.onMenuPressed,
    this.menuKey,
    this.isSelected = false,
    this.selectionMode = false,
  });

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> with BookCardGestureMixin {
  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;

    return GestureDetector(
      onTapDown: updateTapPosition,
      onTap: widget.onTap,
      onLongPress: () => widget.onLongPress?.call(tapPosition),

      child: GlassContainer(
        padding: const EdgeInsets.all(8),
        borderRadius: TibebRadius.md,
        child: Column(
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 2 / 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(TibebRadius.sm),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      BookCover(
                        path: widget.book.coverPath,
                        placeholderColor: t.surfaceOverlay,
                        fit: BoxFit.contain,
                        title: widget.book.title,
                        author: widget.book.author,
                      ),

                      BookBadges(book: widget.book),

                      BookProgressOverlay(book: widget.book),

                      if (widget.selectionMode)
                        BookSelectionOverlay(isSelected: widget.isSelected),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 4),

            Row(
              children: [
                Expanded(child: BookInfo(book: widget.book)),

                if (widget.onMenuPressed != null && !widget.selectionMode)
                  InkWell(
                    onTapDown: updateTapPosition,
                    onTap: () => widget.onMenuPressed?.call(tapPosition),
                    borderRadius: TibebRadius.borderPill,
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.more_vert, size: 18),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
