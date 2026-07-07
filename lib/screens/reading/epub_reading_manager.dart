import 'package:epub_view/epub_view.dart';
import 'package:tibeb/screens/reading/progress_controller.dart';

/// Manages EPUB-specific state: chapters, lengths, chapter index, and
/// jump-to-percent logic. Pure class — no Flutter/Riverpod dependencies.
class EpubReadingManager {
  // ── State ─────────────────────────────────────────────────────────────────
  List<EpubChapter> chapters = [];
  List<int> chapterLengths = [];
  int totalLength = 0;
  int currentChapterIndex = 0;
  String currentChapter = 'Chapter 1';
  EpubBook? epubBook;

  bool shouldJumpToBottom = false;
  double initialScrollProgress = 0.0;

  // ── Load ──────────────────────────────────────────────────────────────────

  /// Called when the EpubReaderLayer fires onLoaded.
  void load({
    required List<EpubChapter> loadedChapters,
    required EpubBook loadedBook,
    required double savedScrollProgress,
    required int initialChapterIndex,
  }) {
    final lengths = loadedChapters
        .map((c) => c.HtmlContent?.length ?? 0)
        .toList();
    chapters = loadedChapters;
    epubBook = loadedBook;
    chapterLengths = lengths;
    totalLength = lengths.fold(0, (s, l) => s + l);
    currentChapterIndex = initialChapterIndex;
    currentChapter = (initialChapterIndex < loadedChapters.length
            ? loadedChapters[initialChapterIndex].Title
            : null) ??
        'Chapter ${initialChapterIndex + 1}';
    initialScrollProgress = savedScrollProgress;
  }

  // ── Chapter change ────────────────────────────────────────────────────────

  /// Record a chapter page turn. Updates internal state.
  /// [isJumpingFromToc] prevents counting the left-behind chapter as read.
  /// Returns the updated shouldJumpToBottom value.
  bool onPageChanged({
    required int newIndex,
    required bool isJumpingFromToc,
    required ProgressController progress,
  }) {
    if (newIndex == currentChapterIndex) return shouldJumpToBottom;

    if (!isJumpingFromToc) {
      progress.recordEpubChapterIfRead(currentChapterIndex);
    }
    progress.onEpubChapterEntry();

    final jumpToBottom = !isJumpingFromToc && newIndex < currentChapterIndex;
    currentChapterIndex = newIndex;
    currentChapter = (newIndex < chapters.length
        ? chapters[newIndex].Title
        : null) ?? 'Chapter ${newIndex + 1}';
    shouldJumpToBottom = jumpToBottom;
    return jumpToBottom;
  }

  // ── Jump to percent ───────────────────────────────────────────────────────

  /// Returns the [chapterIndex] and intra-chapter [scrollFraction] for [percent].
  ({int chapterIndex, double scrollFraction}) resolvePercent(double percent) {
    if (chapters.isEmpty || totalLength == 0) {
      return (chapterIndex: 0, scrollFraction: 0.0);
    }
    final target = percent * totalLength;
    int idx = 0;
    double accumulated = 0;
    for (int i = 0; i < chapterLengths.length; i++) {
      final len = chapterLengths[i];
      if (accumulated + len >= target) {
        idx = i;
        break;
      }
      accumulated += len;
      if (i == chapterLengths.length - 1) idx = i;
    }
    final remaining = target - accumulated;
    final chapterLen = chapterLengths[idx].toDouble();
    final fraction =
        (chapterLen > 0 ? remaining / chapterLen : 0.0).clamp(0.0, 1.0);
    return (chapterIndex: idx, scrollFraction: fraction);
  }

  // ── Progress ──────────────────────────────────────────────────────────────

  /// Returns EPUB progress fraction (0.0–1.0) using weighted chapter lengths.
  double calculateProgress(double scrollProgress) {
    if (chapters.isEmpty) return 0.0;
    if (totalLength > 0) {
      double acc = 0.0;
      for (int i = 0; i < currentChapterIndex; i++) {
        acc += chapterLengths[i].toDouble();
      }
      final chapterProgress =
          chapterLengths[currentChapterIndex].toDouble() * scrollProgress;
      final progress = (acc + chapterProgress) / totalLength.toDouble();
      if (currentChapterIndex == chapters.length - 1 && scrollProgress > 0.99) {
        return 1.0;
      }
      return progress.clamp(0.0, 1.0);
    }
    // Fallback: equal chapter weights
    return ((currentChapterIndex + scrollProgress) / chapters.length)
        .clamp(0.0, 1.0);
  }

  // ── Reset ─────────────────────────────────────────────────────────────────

  void reset() {
    chapters = [];
    chapterLengths = [];
    totalLength = 0;
    currentChapterIndex = 0;
    currentChapter = 'Chapter 1';
    epubBook = null;
    shouldJumpToBottom = false;
    initialScrollProgress = 0.0;
  }
}
