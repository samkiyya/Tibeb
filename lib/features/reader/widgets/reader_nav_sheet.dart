// features/reader/widgets/reader_nav_sheet.dart
//
// Clean wrapper around NavigationSheet (the existing widget),
// wiring ReadingController data into NavigationSheet's props.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfrx/pdfrx.dart';

import 'package:tibeb/shared/models/models.dart';
import 'package:tibeb/shared/services/database_service.dart';

import '../../../widgets/reading/navigation_sheet.dart';
import '../../../features/reader/providers/reader_provider.dart';
import '../controllers/reading_controller.dart';

class ReaderNavSheet extends ConsumerWidget {
  final Book book;
  final ReadingController controller;
  final ReaderSettings readerSettings;
  final VoidCallback? onExport;

  const ReaderNavSheet({
    super.key,
    required this.book,
    required this.controller,
    required this.readerSettings,
    this.onExport,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final annotations = ref.watch(annotationNotifierProvider);
    final epubState = ref.watch(epubReaderNotifierProvider);
    final pdfState = ref.watch(pdfReaderNotifierProvider);

    return NavigationSheet(
      book: book,
      readerSettings: readerSettings,
      chapters: controller.chapters,
      tocChapters: controller.epubBook?.Chapters ?? [],
      pdfOutline: controller.pdfOutline,
      tocPdfOutline: controller.tocPdfOutline,
      currentChapterIndex: epubState.currentChapterIndex,
      currentPdfNode: null, // updated below if needed
      totalPages: pdfState.totalPages,
      focusJump: false,
      highlights: annotations.highlights,
      onExport: onExport,
      getVocabulary: () => ref
          .read(libraryNotifierProvider.notifier)
          .getVocabularyForBook(book.id!),
      onUpdateHighlight: (h) async {
        await DatabaseService().updateHighlight(h);
        await ref
            .read(annotationNotifierProvider.notifier)
            .loadForBook(book.id!);
      },
      onChapterTap: (idx) {
        Navigator.pop(context);
        controller.jumpToChapter(idx, book);
      },
      onPdfOutlineTap: (node) {
        if (node.dest?.pageNumber != null) {
          Navigator.pop(context);
          controller.pdfController.goToPage(
            pageNumber: node.dest!.pageNumber,
            anchor: PdfPageAnchor.top,
          );
        }
      },
      onJumpToPage: (page) {
        FocusManager.instance.primaryFocus?.unfocus();
        Navigator.pop(context);
        controller.pdfController.goToPage(
            pageNumber: page, anchor: PdfPageAnchor.top);
      },
      onJumpToPercent: (percent) {
        FocusManager.instance.primaryFocus?.unfocus();
        Navigator.pop(context);
        Future.delayed(const Duration(milliseconds: 300), () {
          controller.jumpToPercent(percent, book);
        });
      },
      getBookmarks: () =>
          DatabaseService().getBookmarks(book.id!),
      getHighlights: () =>
          DatabaseService().getHighlightsForBook(book.id!),
      onHighlightTap: (h) {
        Navigator.pop(context);
        controller.jumpToHighlight(h, book);
      },
      onDeleteHighlight: (id) async {
        await ref
            .read(annotationNotifierProvider.notifier)
            .deleteHighlight(id);
      },
      onDeleteHighlights: (ids) async {
        await ref
            .read(annotationNotifierProvider.notifier)
            .deleteHighlights(ids);
      },
      onDeleteBookmark: (bm) async {
        if (bm.id != null) {
          await ref
              .read(annotationNotifierProvider.notifier)
              .deleteBookmark(bm.id!);
        }
      },
      onDeleteBookmarks: (bms) async {
        await ref
            .read(annotationNotifierProvider.notifier)
            .deleteBookmarks(bms);
      },
      onBookmarkTap: (bm) {
        Navigator.pop(context);
        controller.jumpToBookmark(bm, book);
      },
      onLookup: (w) => controller.lookupWord(w, book),
      formatDate: (dt) =>
          '${dt.day}/${dt.month} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}',
    );
  }
}
