import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tibeb/models/book_model.dart';
import 'package:tibeb/providers/library_provider.dart';
import 'package:tibeb/screens/edit_book_screen.dart';
import 'package:tibeb/widgets/book_overlay_menu.dart';
import 'package:tibeb/l10n/app_localizations.dart';

class BookActionService {
  static void show(
    BuildContext context,
    WidgetRef ref,
    Book book,
    Offset position,
  ) {
    BookOverlayMenu.show(
      context: context,

      book: book,

      position: position,

      onAction: (action) {
        switch (action) {
          case 'favorite':
            ref.read(libraryProvider.notifier).toggleBookFavorite(book);

            break;

          case 'edit':
            Navigator.push(
              context,

              MaterialPageRoute(builder: (_) => EditBookScreen(book: book)),
            );

            break;

          case 'delete':
            _showDelete(context, ref, book);

            break;
        }
      },
    );
  }

  static Future<void> _showDelete(
    BuildContext context,
    WidgetRef ref,
    Book book,
  ) async {
    bool deleteHistory = false;
    final l10n = AppLocalizations.of(context)!;

    final result = await showDialog<bool>(
      context: context,

      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(l10n.removeBook),

              content: CheckboxListTile(
                title: Text(l10n.removeReadingHistory),

                value: deleteHistory,

                onChanged: (value) {
                  setState(() {
                    deleteHistory = value ?? false;
                  });
                },
              ),

              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },

                  child: Text(l10n.cancel),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },

                  child: Text(l10n.delete),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == true) {
      ref
          .read(libraryProvider.notifier)
          .deleteBook(book.id!, deleteHistory: deleteHistory);
    }
  }
}
