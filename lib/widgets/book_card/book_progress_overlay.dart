import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tibeb/core/theme/theme.dart';
import 'package:tibeb/widgets/book_card/book_card_helpers.dart';
import 'package:tibeb/models/book_model.dart';

class BookProgressOverlay extends StatelessWidget {
  final Book book;

  const BookProgressOverlay({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;

    if (book.progress <= 0 || book.progress >= 1.0) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
                          value: book.progress,
                          backgroundColor: t.glassBorder.withValues(alpha: 0.1),
                          valueColor: AlwaysStoppedAnimation(t.primary),
                          minHeight: 2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${(book.progress * 100).toStringAsFixed(0)}%',
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
                  children: [
                    if (book.totalPages > 0)
                      Text(
                        '${book.filePath.toLowerCase().endsWith('.epub') ? 'Ch.' : 'Pg.'} '
                        '${book.currentPage + 1}/${book.totalPages}',
                        style: TextStyle(
                          color: t.textOnAccent.withValues(alpha: 0.77),
                          fontSize: 9,
                        ),
                      ),
                    if (book.estimatedReadingMinutes > 0)
                      Text(
                        '• ${BookCardHelpers.formatReadingTime(book.estimatedReadingMinutes)}',
                        style: TextStyle(
                          color: t.textOnAccent.withValues(alpha: 0.6),
                          fontSize: 9,
                        ),
                      ),
                    if (book.lastReadAt != null)
                      Text(
                        '• ${BookCardHelpers.formatLastRead(book.lastReadAt!)}',
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
    );
  }
}