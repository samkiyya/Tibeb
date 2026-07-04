import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/router.dart';
import '../../../core/theme/theme.dart';
import 'package:tibeb/shared/models/models.dart';
import '../../../providers/library_provider.dart';

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
        ref.read(currentlyReadingProvider.notifier).state = widget.book;
        ref.read(libraryProvider.notifier).markBookAsOpened(widget.book);
        context.push(AppRoutes.reader, extra: widget.book);
      },
      onLongPress: () {
        if (widget.onLongPress != null) widget.onLongPress!(_tapPosition);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: 100,
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: TibebRadius.borderMd,
                  color: t.surfaceOverlay,
                  boxShadow: t.card.shadow,
                ),
                child: ClipRRect(
                  borderRadius: TibebRadius.borderMd,
                  child: widget.book.coverPath.startsWith('assets')
                      ? Image.asset(
                          widget.book.coverPath,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          errorBuilder: (context, error, stackTrace) => Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Image.asset(
                              'assets/icon.png',
                              fit: BoxFit.contain,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        )
                      : Image.file(
                          File(widget.book.coverPath),
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          errorBuilder: (context, error, stackTrace) => Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Image.asset(
                              'assets/icon.png',
                              fit: BoxFit.contain,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        ),
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
          const SizedBox(height: 8),
          SizedBox(
            width: 100,
            child: Text(
              widget.book.title,
              style: TextStyle(
                color: t.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
