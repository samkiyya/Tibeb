import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tibeb/shared/models/book_model.dart';
import '../core/theme/theme.dart';

import '../components/glass_container.dart';

class BookCard extends StatefulWidget {
  final Book book;
  final VoidCallback? onTap;
  final Function(Offset)? onLongPress;
  final Function(Offset)? onMenuPressed;
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

class _BookCardState extends State<BookCard> {
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
      onTap: widget.onTap,
      onLongPress: () {
        if (widget.onLongPress != null) widget.onLongPress!(_tapPosition);
      },
      child: GlassContainer(
        padding: const EdgeInsets.all(8),
        borderRadius: TibebRadius.md,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top: Book Cover (Fixed Aspect Ratio)
            AspectRatio(
              aspectRatio: 2 / 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  TibebRadius.sm,
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    widget.book.coverPath.startsWith('http')
                        ? CachedNetworkImage(
                            imageUrl: widget.book.coverPath,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                            placeholder: (context, url) =>
                                Container(color: t.surfaceOverlay),
                            errorWidget: (context, url, error) => Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Image.asset(
                                'assets/icon.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          )
                        : widget.book.coverPath.isNotEmpty
                        ? Image.file(
                            File(widget.book.coverPath),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                            errorBuilder: (context, error, stackTrace) =>
                                Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: Image.asset(
                                    'assets/icon.png',
                                    fit: BoxFit.contain,
                                    alignment: Alignment.topCenter,
                                  ),
                                ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Image.asset(
                              'assets/icon.png',
                              fit: BoxFit.contain,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                    // New Tag
                    if (widget.book.progress == 0)
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: t.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'NEW',
                            style: TextStyle(
                              color: t.textOnPrimary,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    if (widget.book.isFavorite)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Icon(
                          Icons.favorite,
                          color: t.error,
                          size: 16,
                        ),
                      ),
                    // Bottom Metadata Overlay (Glassy)
                    if (widget.book.progress > 0 && widget.book.progress < 1.0)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: t.scrim.withValues(alpha: 0.5),
                                border: Border(
                                  top: BorderSide(
                                    color: t.glassBorder.withValues(alpha: 0.15),
                                    width: 0.5,
                                  ),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(1),
                                          child: LinearProgressIndicator(
                                            value: widget.book.progress,
                                            backgroundColor: t.glassBorder.withValues(alpha: 0.1),
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              t.primary,
                                            ),
                                            minHeight: 2,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${(widget.book.progress * 100).toStringAsFixed(0)}%',
                                        style: TextStyle(
                                          color: t.textOnAccent,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Wrap(
                                    spacing: 4,
                                    runSpacing: 0,
                                    children: [
                                      if (widget.book.totalPages > 0)
                                        Text(
                                          '${widget.book.filePath.toLowerCase().endsWith('.epub') ? 'Ch.' : 'Pg.'} ${widget.book.currentPage + 1}/${widget.book.totalPages}',
                                          style: TextStyle(
                                            color: t.textOnAccent.withValues(alpha: 0.77),
                                            fontSize: 9,
                                          ),
                                        ),
                                      if (widget.book.estimatedReadingMinutes > 0)
                                        Text(
                                          '• ${_formatReadingTime(widget.book.estimatedReadingMinutes)}',
                                          style: TextStyle(
                                            color: t.textOnAccent.withValues(alpha: 0.6),
                                            fontSize: 9,
                                          ),
                                        ),
                                      if (widget.book.lastReadAt != null)
                                        Text(
                                          '• ${_formatLastRead(widget.book.lastReadAt!)}',
                                          style: TextStyle(
                                            color: t.textOnAccent.withValues(alpha: 0.38),
                                            fontSize: 8,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    // Selection Overlay
                    if (widget.selectionMode)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: widget.isSelected
                                ? t.primary.withValues(alpha: 0.3)
                                : t.scrim.withValues(alpha: 0.26),
                          ),
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                color: widget.isSelected
                                    ? t.primary
                                    : t.glassBorder.withValues(alpha: 0.24),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: t.textOnAccent,
                                  width: 2,
                                ),
                              ),
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                widget.isSelected ? Icons.check : Icons.add,
                                color: widget.isSelected
                                    ? t.textOnPrimary
                                    : t.textOnAccent,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            // Middle: Title and Author
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.book.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                          height: 1.1,
                          color: t.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.book.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: t.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.onMenuPressed != null && !widget.selectionMode)
                  InkWell(
                    key: widget.menuKey,
                    onTapDown: (details) {
                      setState(() {
                        _tapPosition = details.globalPosition;
                      });
                    },
                    onTap: () => widget.onMenuPressed!(_tapPosition),
                    borderRadius: TibebRadius.borderPill,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.more_vert,
                        size: 18,
                        color: t.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatReadingTime(int minutes) {
    if (minutes < 60) {
      return '~$minutes min left';
    } else if (minutes < 1440) {
      final hours = (minutes / 60).floor();
      final mins = minutes % 60;
      if (mins == 0) {
        return '~$hours hr left';
      }
      return '~$hours hr $mins min left';
    } else {
      final days = (minutes / 1440).floor();
      return '~$days day${days > 1 ? 's' : ''} left';
    }
  }

  String _formatLastRead(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return 'Read ${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return 'Read ${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return 'Read ${difference.inDays}d ago';
    } else {
      return 'Read on ${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
