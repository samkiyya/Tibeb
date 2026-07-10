import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:epub_view/epub_view.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../models/book_model.dart';
import '../../models/reader_settings_model.dart';
import '../../models/bookmark_model.dart';
import '../../models/highlight_model.dart';
import '../../models/markdown_outline_node.dart';
import '../../providers/library_provider.dart';
import '../../providers/database_providers.dart';
import '../../widgets/reading/navigation_sheet.dart';
import 'bookmark_controller.dart';
import 'export_helper.dart';

/// Helper to configure and present the NavigationSheet modal bottom sheet.
class NavigationSheetHelper {
  static void show({
    required BuildContext context,
    required WidgetRef ref,
    required Book book,
    required ReaderSettings settings,
    required List<EpubChapter> chapters,
    required List<EpubChapter> tocChapters,
    required List<PdfOutlineNode> pdfOutline,
    required List<PdfOutlineNode> tocPdfOutline,
    required int currentChapterIndex,
    required PdfOutlineNode? currentPdfNode,
    required int pdfPages,
    required int pdfCurrentPage,
    required BookmarkController bookmarks,
    required ValueNotifier<double> scrollProgressNotifier,
    required VoidCallback onOpenSheet,
    required VoidCallback onCloseSheet,
    required Function(int) onChapterTap,
    required Function(PdfOutlineNode) onPdfOutlineTap,
    required Function(int) onJumpToPage,
    required Function(double) onJumpToPercent,
    required Function(Highlight) onHighlightTap,
    required Function(Bookmark) onBookmarkTap,
    required Function(String) onLookup,
    List<MarkdownOutlineNode> mdOutline = const [],
    MarkdownOutlineNode? currentMdNode,
    void Function(MarkdownOutlineNode)? onMdOutlineTap,
  }) {
    if (!context.mounted) return;
    onOpenSheet();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return NavigationSheet(
          readerSettings: settings,
          book: book,
          chapters: chapters,
          tocChapters: tocChapters,
          pdfOutline: pdfOutline,
          tocPdfOutline: tocPdfOutline,
          currentChapterIndex: currentChapterIndex,
          currentPdfNode: currentPdfNode,
          totalPages: pdfPages,
          focusJump: false,
          mdOutline: mdOutline,
          currentMdNode: currentMdNode,
          onMdOutlineTap: onMdOutlineTap,
          onExport: () => ExportHelper.exportToMarkdown(
            context,
            book,
            ref,
            bookmarks.highlights,
          ),
          getVocabulary: () =>
              ref.read(libraryProvider.notifier).getVocabularyForBook(book.id!),
          onUpdateHighlight: (h) async {
            await bookmarks.updateHighlight(h, ref);
          },
          onChapterTap: onChapterTap,
          onPdfOutlineTap: onPdfOutlineTap,
          onJumpToPage: onJumpToPage,
          onJumpToPercent: onJumpToPercent,
          getBookmarks: () =>
              ref.read(libraryProvider.notifier).getBookmarks(book.id!),
          getHighlights: () => ref
              .read(databaseRepositoryProvider)
              .getHighlightsForBook(book.id!),
          highlights: bookmarks.highlights,
          onHighlightTap: onHighlightTap,
          onLookup: onLookup,
          onDeleteHighlight: (id) async {
            await bookmarks.deleteHighlight(id, ref);
          },
          onDeleteHighlights: (ids) async {
            await bookmarks.deleteHighlights(ids, ref);
          },
          onDeleteBookmark: (bookmark) async {
            await ref
                .read(libraryProvider.notifier)
                .deleteBookmark(bookmark.id!);
            await bookmarks.load(book.id!, ref);
          },
          onDeleteBookmarks: (bookmarksList) async {
            await bookmarks.deleteBookmarks(bookmarksList, ref, book.id!);
          },
          onBookmarkTap: onBookmarkTap,
          formatDate: ExportHelper.formatDate,
        );
      },
    ).then((_) {
      onCloseSheet();
    });
  }
}
