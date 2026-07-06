import 'package:flutter/material.dart';
import 'package:tibeb/core/theme/system/color_scheme.dart';
import 'package:tibeb/models/book_model.dart';

class BookBadges extends StatelessWidget {
  final Book book;

  const BookBadges({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    return Stack(
      children: [
        if (book.progress == 0)
          Positioned(
            top: 6,
            left: 6,
            child: _badge('NEW', t.primary, t.textOnPrimary),
          ),

        if (book.isFavorite)
          Positioned(
            top: 6,
            right: 6,
            child: Icon(Icons.favorite, color: t.error, size: 16),
          ),
      ],
    );
  }

  Widget _badge(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: fg,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}