import 'package:flutter/material.dart';
import 'package:tibeb/core/theme/system/color_scheme.dart';
import 'package:tibeb/models/book_model.dart';

class BookInfo extends StatelessWidget {
  final Book book;

  const BookInfo({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.tibpiColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          book.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: t.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          book.author,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.bodyMedium?.copyWith(
            color: t.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}