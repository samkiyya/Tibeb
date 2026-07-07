import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tibeb/core/theme/system/color_scheme.dart';
import 'package:tibeb/models/book_model.dart';
import 'package:tibeb/providers/library_provider.dart';
import 'package:tibeb/screens/edit_book_screen.dart';
import 'package:tibeb/widgets/book_overlay_menu.dart';

/// Centralises book context-menu actions for the dashboard.
///
/// Call [DashboardActions.show] from any dashboard widget that exposes
/// long-press / menu-pressed callbacks.
class DashboardActions {
  const DashboardActions._();

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
      onAction: (action) => _handleAction(context, ref, book, action),
    );
  }

  static void _handleAction(
    BuildContext context,
    WidgetRef ref,
    Book book,
    String action,
  ) {
    switch (action) {
      case 'favorite':
        ref.read(libraryProvider.notifier).toggleBookFavorite(book);
      case 'edit':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EditBookScreen(book: book)),
        );
      case 'delete':
        _confirmDelete(context, ref, book);
    }
  }

  static Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Book book,
  ) async {
    bool deleteHistory = false;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          final t = ctx.tibpiColors;
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
                    style: TextStyle(color: t.textSecondary, fontSize: 14),
                  ),
                  value: deleteHistory,
                  activeColor: t.primary,
                  onChanged: (val) =>
                      setDialogState(() => deleteHistory = val ?? false),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text('Cancel', style: TextStyle(color: t.textSecondary)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text('Remove', style: TextStyle(color: t.error)),
              ),
            ],
          );
        },
      ),
    );

    if (confirm == true && context.mounted) {
      ref
          .read(libraryProvider.notifier)
          .deleteBook(book.id!, deleteHistory: deleteHistory);
    }
  }
}
