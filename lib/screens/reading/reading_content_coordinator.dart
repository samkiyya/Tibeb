import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../models/book_model.dart';
import '../../providers/library_provider.dart';
import 'epub_reading_manager.dart';
import 'pdf_reading_manager.dart';
import 'progress_controller.dart';
import 'reading_ui_state.dart';

/// Provides the four callbacks that [ReadingContentArea] needs:
/// [onEpubLoaded], [onEpubPageChanged], [onPdfLoaded], [onPdfPageChanged].
///
/// All business logic lives here; [ReadingScreen] only instantiates this
/// object and passes it through.
class ReadingContentCoordinator {
  ReadingContentCoordinator({
    required this.epub,
    required this.pdf,
    required this.progress,
    required this.ui,
    required this.scrollProgressNotifier,
    required this.ref,
    required this.book,
    required this.onStateChanged,
  });

  final EpubReadingManager epub;
  final PdfReadingManager pdf;
  final ProgressController progress;
  final ReadingUiState ui;
  final ValueNotifier<double> scrollProgressNotifier;
  final WidgetRef ref;
  final Book book;

  /// Called whenever any state change needs a rebuild.
  final VoidCallback onStateChanged;

  // ── Progress helper ───────────────────────────────────────────────────────

  double _currentProgress() {
    return ProgressController.calculateCurrentProgress(
      book: book,
      epubChapterLengths: epub.chapterLengths,
      epubTotalLength: epub.totalLength,
      currentChapterIndex: epub.currentChapterIndex,
      scrollProgress: scrollProgressNotifier.value,
      chaptersLength: epub.chapters.length,
      pdfPages: pdf.pdfPages,
      pdfCurrentPage: pdf.pdfCurrentPage,
    );
  }

  // ── EPUB ──────────────────────────────────────────────────────────────────

  void onEpubLoaded(
    List<EpubChapter> chapters,
    EpubBook epubBook,
    double initialScroll,
    int initialChapterIndex,
  ) {
    epub.load(
      loadedChapters: chapters,
      loadedBook: epubBook,
      savedScrollProgress: initialScroll,
      initialChapterIndex: initialChapterIndex,
    );
    progress.onEpubChapterEntry();
    progress.initialized = true;
    progress.startHeartbeat(book, ref, _currentProgress);
    onStateChanged();
  }

  void onEpubPageChanged(int index) {
    if (index == epub.currentChapterIndex) return;
    epub.onPageChanged(
      newIndex: index,
      isJumpingFromToc: ui.isJumpingFromToc,
      progress: progress,
    );
    scrollProgressNotifier.value = 0.0;
    progress.recordInteraction();

    final prog = _currentProgress();
    final pagesRead =
        progress.totalEpubPagesRead(epub.chapters, epub.chapterLengths);

    ref.read(libraryProvider.notifier).updateBookProgress(
      book.id!, prog,
      pagesRead: pagesRead > 0 ? pagesRead : 0,
      durationMinutes: 0,
      currentPage: epub.currentChapterIndex,
      totalPages: epub.chapters.length,
      estimateReadingTime: false,
    );

    if (pagesRead > 0) {
      progress.epubChaptersReadThisSession.clear();
    }
    onStateChanged();
  }

  // ── PDF ───────────────────────────────────────────────────────────────────

  void onPdfLoaded(
    List<PdfOutlineNode> outline,
    int totalPages,
    int initialPage,
  ) {
    pdf.isPdfReady = true;
    pdf.pdfPages = totalPages;
    pdf.loadOutline(outline);
    pdf.setPage(initialPage, totalPages: totalPages);
    scrollProgressNotifier.value = totalPages > 1
        ? (initialPage / (totalPages - 1)).clamp(0.0, 1.0)
        : 1.0;
    if (!progress.initialized) {
      progress.onPdfPageEntry();
      progress.startHeartbeat(book, ref, _currentProgress);
      progress.initialized = true;
    }
    onStateChanged();
  }

  void onPdfPageChanged(int page, int total) {
    if (ui.isJumpingFromToc) {
      if (page == pdf.pdfCurrentPage) {
        ui.isJumpingFromToc = false;
        onStateChanged();
      } else {
        return;
      }
    }

    if (page == pdf.pdfCurrentPage && total == pdf.pdfPages) return;

    if (!progress.initialized) {
      progress.lastSyncTime = DateTime.now();
      progress.onPdfPageEntry();
      progress.initialized = true;
      pdf.setPage(page, totalPages: total);
      scrollProgressNotifier.value =
          total > 1 ? (page / (total - 1)).clamp(0.0, 1.0) : 1.0;
      ref.read(libraryProvider.notifier).updateBookProgress(
        book.id!, book.progress,
        pagesRead: 0, durationMinutes: 0,
        currentPage: page, totalPages: total,
        estimateReadingTime: false,
      );
      onStateChanged();
      return;
    }

    progress.countAndMaybeClearPdfPages(
        previousPage: pdf.pdfCurrentPage, newPage: page, clearAfter: false);
    progress.onPdfPageEntry();
    pdf.setPage(page, totalPages: total);
    scrollProgressNotifier.value =
        total > 1 ? (page / (total - 1)).clamp(0.0, 1.0) : 1.0;

    final prog = _currentProgress();
    progress.schedulePdfProgressUpdate(book, page, total, prog, ref,
        clearSession: true);
    onStateChanged();
  }
}
