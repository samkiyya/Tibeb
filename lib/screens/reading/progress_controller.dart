import 'dart:async';
import 'package:epub_view/epub_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/book_model.dart';
import '../../providers/library_provider.dart';

/// Handles all reading progress: heartbeat timer, page/chapter read tracking,
/// and syncing progress back to the Drift database via the library provider.
class ProgressController {
  // ── Configuration ─────────────────────────────────────────────────────────
  static const Duration idlenessTimeout = Duration(minutes: 2);
  static const Duration readThreshold = Duration(seconds: 5);

  // ── Timers ────────────────────────────────────────────────────────────────
  Timer? _heartbeatTimer;
  Timer? _debounceTimer;

  // ── State ─────────────────────────────────────────────────────────────────
  bool initialized = false;
  DateTime lastSyncTime = DateTime.now();
  int accumulatedSeconds = 0;
  DateTime lastInteractionTime = DateTime.now();

  // PDF tracking
  DateTime? pageEntryTime;
  final Set<int> pagesReadThisSession = {};

  // EPUB tracking
  DateTime? epubPageEntryTime;
  final Set<int> epubChaptersReadThisSession = {};

  void dispose() {
    _heartbeatTimer?.cancel();
    _debounceTimer?.cancel();
  }

  void cancelDebounce() => _debounceTimer?.cancel();

  // ── Interaction ───────────────────────────────────────────────────────────

  void recordInteraction() {
    lastInteractionTime = DateTime.now();
  }

  bool get isIdle =>
      DateTime.now().difference(lastInteractionTime) > idlenessTimeout;

  // ── Progress calculation ──────────────────────────────────────────────────

  /// Pure calculation of current reading progress (0.0 – 1.0).
  static double calculateCurrentProgress({
    required Book book,
    required List<int> epubChapterLengths,
    required int epubTotalLength,
    required int currentChapterIndex,
    required double scrollProgress,
    required int chaptersLength,
    required int pdfPages,
    required int pdfCurrentPage,
  }) {
    if (book.filePath.toLowerCase().endsWith('.pdf')) {
      if (pdfPages > 0) {
        if (pdfPages == 1) return 1.0;
        return pdfCurrentPage / (pdfPages - 1);
      }
      return book.progress;
    } else if (book.filePath.toLowerCase().endsWith('.epub')) {
      if (chaptersLength > 0 && epubTotalLength > 0) {
        double accumulatedLength = 0.0;
        for (int i = 0; i < currentChapterIndex; i++) {
          accumulatedLength += epubChapterLengths[i].toDouble();
        }

        final double currentChapterProgress =
            (epubChapterLengths[currentChapterIndex].toDouble() *
            scrollProgress);

        final double progress =
            (accumulatedLength + currentChapterProgress) /
            epubTotalLength.toDouble();

        // Snap to 1.0 at end of last chapter
        if (currentChapterIndex == chaptersLength - 1 &&
            scrollProgress > 0.99) {
          return 1.0;
        }
        return progress.clamp(0.0, 1.0);
      } else if (chaptersLength > 0) {
        final double progress =
            (currentChapterIndex + scrollProgress) / chaptersLength;
        return progress.clamp(0.0, 1.0);
      }
    }
    return book.progress;
  }

  // ── Heartbeat ─────────────────────────────────────────────────────────────

  void startHeartbeat(
    Book book,
    WidgetRef ref,
    double Function() getCurrentProgress,
  ) {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isIdle) return;
      accumulatedSeconds++;
      if (accumulatedSeconds >= 60) {
        accumulatedSeconds = 0;
        final progress = getCurrentProgress();
        lastSyncTime = DateTime.now();
        ref
            .read(libraryProvider.notifier)
            .updateBookProgress(
              book.id!,
              progress,
              pagesRead: 0,
              durationMinutes: 1,
            );
        onHeartbeatMinute?.call();
      }
    });
  }

  /// Optional callback so the screen can also save audio position on the beat.
  void Function()? onHeartbeatMinute;

  // ── PDF page tracking ─────────────────────────────────────────────────────

  void onPdfPageEntry() {
    pageEntryTime = DateTime.now();
  }

  /// Returns the number of newly read pages since last sync, then
  /// optionally clears the session set.
  int countAndMaybeClearPdfPages({
    required int previousPage,
    required int newPage,
    required bool clearAfter,
  }) {
    if (pageEntryTime != null) {
      final time = DateTime.now().difference(pageEntryTime!);
      if (time >= readThreshold &&
          previousPage != newPage &&
          !pagesReadThisSession.contains(previousPage)) {
        pagesReadThisSession.add(previousPage);
      }
    }
    final count = pagesReadThisSession.length;
    if (clearAfter) pagesReadThisSession.clear();
    return count;
  }

  void addCurrentPdfPage(int page) {
    if (pageEntryTime != null) {
      final time = DateTime.now().difference(pageEntryTime!);
      if (time >= readThreshold && !pagesReadThisSession.contains(page)) {
        pagesReadThisSession.add(page);
      }
    }
  }

  void schedulePdfProgressUpdate(
    Book book,
    int zeroIndexedPage,
    int totalPages,
    double progress,
    WidgetRef ref, {
    required bool clearSession,
  }) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      final pages = pagesReadThisSession.length;
      ref
          .read(libraryProvider.notifier)
          .updateBookProgress(
            book.id!,
            progress,
            pagesRead: pages,
            durationMinutes: 0,
            currentPage: zeroIndexedPage,
            totalPages: totalPages,
            estimateReadingTime: false,
          );
      if (pages > 0 && clearSession) pagesReadThisSession.clear();
    });
  }

  // ── EPUB chapter tracking ─────────────────────────────────────────────────

  void onEpubChapterEntry() {
    epubPageEntryTime = DateTime.now();
  }

  void recordEpubChapterIfRead(int chapterIndex) {
    if (epubPageEntryTime != null) {
      final time = DateTime.now().difference(epubPageEntryTime!);
      if (time >= readThreshold &&
          !epubChaptersReadThisSession.contains(chapterIndex)) {
        epubChaptersReadThisSession.add(chapterIndex);
      }
    }
  }

  int epubChapterWeight(
    int index,
    List<EpubChapter> chapters,
    List<int> lengths,
  ) {
    if (index < 0 || index >= chapters.length || lengths.isEmpty) return 0;
    return (lengths[index] / 1000).ceil();
  }

  int totalEpubPagesRead(List<EpubChapter> chapters, List<int> lengths) {
    int total = 0;
    for (final idx in epubChaptersReadThisSession) {
      total += epubChapterWeight(idx, chapters, lengths);
    }
    return total;
  }

  // ── Final sync ────────────────────────────────────────────────────────────

  void syncFinalProgress({
    required Book book,
    required WidgetRef ref,
    required double progress,
    required int currentPage,
    required int totalPages,
    required List<EpubChapter> chapters,
    required List<int> epubChapterLengths,
    required int currentChapterIndex,
    required int pdfCurrentPage,
    required int pdfPages,
  }) {
    _debounceTimer?.cancel();
    _heartbeatTimer?.cancel();

    final now = DateTime.now();
    int duration = now.difference(lastSyncTime).inMinutes;
    if (accumulatedSeconds >= 30) duration += 1;

    // Count current page/chapter
    addCurrentPdfPage(pdfCurrentPage);
    recordEpubChapterIfRead(currentChapterIndex);

    int pagesRead = 0;
    final isEpub = book.filePath.toLowerCase().endsWith('.epub');

    if (isEpub) {
      pagesRead = totalEpubPagesRead(chapters, epubChapterLengths);
    } else {
      pagesRead = pagesReadThisSession.length;
    }

    if (pagesRead > 0 || duration > 0 || progress != book.progress) {
      ref
          .read(libraryProvider.notifier)
          .updateBookProgress(
            book.id!,
            progress,
            pagesRead: pagesRead,
            durationMinutes: duration,
            currentPage: currentPage,
            totalPages: totalPages,
            estimateReadingTime: false,
          );
      pagesReadThisSession.clear();
      epubChaptersReadThisSession.clear();
      lastSyncTime = now;
    }
    accumulatedSeconds = 0;
  }
}
