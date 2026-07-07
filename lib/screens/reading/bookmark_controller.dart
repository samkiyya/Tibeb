import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tibeb/core/theme/theme.dart';
import '../../models/book_model.dart';
import '../../models/bookmark_model.dart';
import '../../models/highlight_model.dart';
import '../../providers/library_provider.dart';
import '../../providers/database_providers.dart';

/// Manages bookmarks and highlights for the currently open book.
/// Extracted from reading_screen.dart — all DB access goes through Riverpod.
class BookmarkController {
  List<Bookmark> bookmarks = [];
  List<Highlight> highlights = [];

  /// Called after every mutation so the screen can rebuild.
  VoidCallback? onStateChanged;

  // ── Loading ───────────────────────────────────────────────────────────────

  Future<void> load(int bookId, WidgetRef ref) async {
    final bm = await ref.read(libraryProvider.notifier).getBookmarks(bookId);
    final db = ref.read(databaseRepositoryProvider);
    final hl = await db.getHighlightsForBook(bookId);
    bookmarks = bm;
    highlights = hl;
    onStateChanged?.call();
  }

  void reset() {
    bookmarks = [];
    highlights = [];
  }

  // ── Current bookmark detection ────────────────────────────────────────────

  Bookmark? getCurrentBookmark({
    required Book book,
    required int currentChapterIndex,
    required double scrollProgress,
    required bool isPdfReady,
    required int pdfCurrentPage,
  }) {
    if (bookmarks.isEmpty) return null;

    if (book.filePath.toLowerCase().endsWith('.epub')) {
      final prefix = '$currentChapterIndex:';
      for (final b in bookmarks) {
        if (b.position.startsWith(prefix)) {
          final parts = b.position.split(':');
          if (parts.length > 1) {
            final bp = double.tryParse(parts[1]) ?? 0.0;
            if (scrollProgress >= bp && scrollProgress < bp + 0.05) return b;
          }
        } else if (b.position == currentChapterIndex.toString()) {
          return b;
        }
      }
    } else {
      if (!isPdfReady) return null;
      final pageStr = (pdfCurrentPage + 1).toString();
      for (final b in bookmarks) {
        if (b.position == pageStr) return b;
      }
    }
    return null;
  }

  // ── Toggle bookmark ───────────────────────────────────────────────────────

  Future<void> toggleBookmark({
    required BuildContext context,
    required Book book,
    required WidgetRef ref,
    required double progress,
    required int currentChapterIndex,
    required double scrollProgress,
    required bool isPdfReady,
    required int pdfCurrentPage,
    required List<EpubChapter> chapters,
  }) async {
    final current = getCurrentBookmark(
      book: book,
      currentChapterIndex: currentChapterIndex,
      scrollProgress: scrollProgress,
      isPdfReady: isPdfReady,
      pdfCurrentPage: pdfCurrentPage,
    );

    if (current != null) {
      await ref.read(libraryProvider.notifier).deleteBookmark(current.id!);
      await load(book.id!, ref);
      if (context.mounted) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            SnackBar(
              content: const Text('Bookmark removed'),
              backgroundColor: context.tibpiColors.accent,
              behavior: SnackBarBehavior.floating,
              width: 200,
            ),
          );
      }
    } else {
      String position = '0';
      if (book.filePath.toLowerCase().endsWith('.epub')) {
        position = '$currentChapterIndex:$scrollProgress';
      } else if (book.filePath.toLowerCase().endsWith('.pdf')) {
        position = (pdfCurrentPage + 1).toString();
      }

      String title = 'Bookmark';
      if (book.filePath.toLowerCase().endsWith('.epub')) {
        if (chapters.isNotEmpty && currentChapterIndex < chapters.length) {
          title = chapters[currentChapterIndex].Title ?? 'Bookmark';
        }
      } else if (isPdfReady) {
        title = 'Page ${pdfCurrentPage + 1}';
      }

      final bookmark = Bookmark(
        bookId: book.id!,
        title: title,
        progress: progress,
        createdAt: DateTime.now(),
        position: position,
      );

      await ref.read(libraryProvider.notifier).addBookmark(bookmark);
      await load(book.id!, ref);

      if (context.mounted) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            SnackBar(
              content: const Text('Position bookmarked'),
              backgroundColor: context.tibpiColors.accent,
              behavior: SnackBarBehavior.floating,
              width: 200,
            ),
          );
      }
    }
  }

  // ── Highlights ────────────────────────────────────────────────────────────

  Future<void> addHighlight(Highlight highlight, WidgetRef ref) async {
    final book = ref.read(currentlyReadingProvider);
    if (book?.id == null) return;

    // Check if this exact text+chapter already has a highlight
    final existing = highlights
        .where(
          (h) =>
              h.chapterIndex == highlight.chapterIndex &&
              h.text == highlight.text &&
              h.position == highlight.position,
        )
        .firstOrNull;

    final db = ref.read(databaseRepositoryProvider);

    if (existing != null) {
      final updated = existing.copyWith(
        color: highlight.color,
        note: highlight.note,
      );
      await db.updateHighlight(updated);
    } else {
      final withBookId = highlight.copyWith(bookId: book!.id!);
      await db.insertHighlight(withBookId);
    }

    // Reload from DB to get correct IDs
    final updatedHighlights = await db.getHighlightsForBook(book!.id!);
    highlights = updatedHighlights;
    onStateChanged?.call();
  }

  Future<void> deleteHighlight(int highlightId, WidgetRef ref) async {
    final book = ref.read(currentlyReadingProvider);
    if (book?.id == null) return;

    final db = ref.read(databaseRepositoryProvider);
    await db.deleteHighlight(highlightId);

    final updatedHighlights = await db.getHighlightsForBook(book!.id!);
    highlights = updatedHighlights;
    onStateChanged?.call();
  }

  Future<void> updateHighlight(Highlight highlight, WidgetRef ref) async {
    final book = ref.read(currentlyReadingProvider);
    if (book?.id == null) return;

    final db = ref.read(databaseRepositoryProvider);
    await db.updateHighlight(highlight);

    final updatedHighlights = await db.getHighlightsForBook(book!.id!);
    highlights = updatedHighlights;
    onStateChanged?.call();
  }

  Future<void> deleteHighlights(List<int> ids, WidgetRef ref) async {
    final book = ref.read(currentlyReadingProvider);
    if (book?.id == null) return;

    final db = ref.read(databaseRepositoryProvider);
    for (final id in ids) {
      await db.deleteHighlight(id);
    }

    final updatedHighlights = await db.getHighlightsForBook(book!.id!);
    highlights = updatedHighlights;
    onStateChanged?.call();
  }

  Future<void> deleteBookmarks(
    List<Bookmark> toDelete,
    WidgetRef ref,
    int bookId,
  ) async {
    for (final bookmark in toDelete) {
      await ref.read(libraryProvider.notifier).deleteBookmark(bookmark.id!);
    }
    await load(bookId, ref);
  }
}
