import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tibeb/widgets/book_card/book_cover.dart';
import 'package:tibeb/core/theme/theme.dart';

import 'package:tibeb/models/book_model.dart';
import 'package:tibeb/services/navigation_service.dart';

class ShelfItem extends ConsumerStatefulWidget {
  final Book book;
  final Function(Offset)? onLongPress;
  final Function(Offset)? onMenuPressed;

  const ShelfItem({
    super.key,
    required this.book,
    this.onLongPress,
    this.onMenuPressed,
  });

  @override
  ConsumerState<ShelfItem> createState() => _ShelfItemState();
}

class _ShelfItemState extends ConsumerState<ShelfItem> {
  Offset _tapPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          _tapPosition = details.globalPosition;
        });
      },
      onTap: () {
        BookRouter.openBook(context, ref, widget.book);
      },
      onLongPress: () {
        if (widget.onLongPress != null) widget.onLongPress!(_tapPosition);
      },
      child: SizedBox(
        width: 110,
        height: 180,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 110,
              height: 140,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: TibebRadius.borderMd,
                    child: BookCover(
                      path: widget.book.coverPath,
                      placeholderColor: t.surfaceOverlay,
                      fit: BoxFit.contain,
                    ),
                  ),
                  if (widget.onMenuPressed != null)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: InkWell(
                        onTapDown: (details) {
                          setState(() {
                            _tapPosition = details.globalPosition;
                          });
                        },
                        onTap: () => widget.onMenuPressed!(_tapPosition),
                        borderRadius: TibebRadius.borderPill,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: t.scrim.withValues(alpha: 0.45),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.more_vert,
                            size: 16,
                            color: t.textOnPrimary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                widget.book.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: TextStyle(
                  color: t.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
