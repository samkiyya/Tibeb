// features/reader/providers/reader_provider.dart
//
// Reader providers — Riverpod 3.x (no AutoDispose prefix, no codegen).
// All NotifierProviders are auto-disposed when the reader screen leaves scope.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tibeb/shared/models/models.dart';
import 'package:tibeb/shared/services/database_service.dart';


export '../../../features/library/providers/library_provider.dart'
    show currentlyReadingProvider, libraryNotifierProvider;
export '../../../providers/reader_settings_provider.dart';

// ─── EPUB State ───────────────────────────────────────────────────────────────

class EpubReaderState {
  final int currentChapterIndex;
  final double scrollProgress;
  final List<int> chapterLengths;
  final int totalLength;
  final bool isInitialized;

  const EpubReaderState({
    this.currentChapterIndex = 0,
    this.scrollProgress = 0.0,
    this.chapterLengths = const [],
    this.totalLength = 0,
    this.isInitialized = false,
  });

  EpubReaderState copyWith({
    int? currentChapterIndex,
    double? scrollProgress,
    List<int>? chapterLengths,
    int? totalLength,
    bool? isInitialized,
  }) =>
      EpubReaderState(
        currentChapterIndex: currentChapterIndex ?? this.currentChapterIndex,
        scrollProgress: scrollProgress ?? this.scrollProgress,
        chapterLengths: chapterLengths ?? this.chapterLengths,
        totalLength: totalLength ?? this.totalLength,
        isInitialized: isInitialized ?? this.isInitialized,
      );

  double get overallProgress {
    if (totalLength == 0 || chapterLengths.isEmpty) return 0.0;
    if (currentChapterIndex >= chapterLengths.length) return 1.0;
    double acc = 0;
    for (int i = 0; i < currentChapterIndex; i++) {
      acc += chapterLengths[i];
    }
    final chLen = chapterLengths[currentChapterIndex].toDouble();
    return ((acc + chLen * scrollProgress) / totalLength).clamp(0.0, 1.0);
  }
}

class EpubReaderNotifier extends Notifier<EpubReaderState> {
  @override
  EpubReaderState build() => const EpubReaderState();

  void initialize({
    required List<int> chapterLengths,
    required int initialChapterIndex,
    required double initialScrollProgress,
  }) {
    final total = chapterLengths.fold(0, (s, l) => s + l);
    state = EpubReaderState(
      currentChapterIndex: initialChapterIndex,
      scrollProgress: initialScrollProgress,
      chapterLengths: chapterLengths,
      totalLength: total,
      isInitialized: true,
    );
  }

  void updateChapterIndex(int index) =>
      state = state.copyWith(currentChapterIndex: index, scrollProgress: 0.0);

  void updateScrollProgress(double progress) {
    if ((progress - state.scrollProgress).abs() < 0.001) return;
    state = state.copyWith(scrollProgress: progress);
  }

  void reset() => state = const EpubReaderState();
}

final epubReaderNotifierProvider =
    NotifierProvider<EpubReaderNotifier, EpubReaderState>(
  EpubReaderNotifier.new,
);

// ─── PDF State ────────────────────────────────────────────────────────────────

class PdfReaderState {
  final int currentPage;
  final int totalPages;
  final bool isReady;
  final String currentChapterTitle;

  const PdfReaderState({
    this.currentPage = 0,
    this.totalPages = 0,
    this.isReady = false,
    this.currentChapterTitle = '',
  });

  double get scrollProgress =>
      totalPages > 1 ? currentPage / (totalPages - 1) : (isReady ? 1.0 : 0.0);

  PdfReaderState copyWith({
    int? currentPage,
    int? totalPages,
    bool? isReady,
    String? currentChapterTitle,
  }) =>
      PdfReaderState(
        currentPage: currentPage ?? this.currentPage,
        totalPages: totalPages ?? this.totalPages,
        isReady: isReady ?? this.isReady,
        currentChapterTitle: currentChapterTitle ?? this.currentChapterTitle,
      );
}

class PdfReaderNotifier extends Notifier<PdfReaderState> {
  @override
  PdfReaderState build() => const PdfReaderState();

  void setReady(int totalPages) =>
      state = state.copyWith(isReady: true, totalPages: totalPages);

  void updatePage(int page, int total) =>
      state = state.copyWith(currentPage: page, totalPages: total);

  void updateChapterTitle(String title) =>
      state = state.copyWith(currentChapterTitle: title);

  void reset() => state = const PdfReaderState();
}

final pdfReaderNotifierProvider =
    NotifierProvider<PdfReaderNotifier, PdfReaderState>(
  PdfReaderNotifier.new,
);

// ─── Audio Player State ───────────────────────────────────────────────────────
// Defined here so reading_screen.dart can use AudioPlayerState without a
// circular import through audio_provider.dart.

class AudioPlayerState {
  final bool isPlaying;
  final bool isLoading;
  final Duration position;
  final Duration duration;
  final int currentTrackIndex;
  final double playbackSpeed;
  final String? loadedBookId;
  final Duration? sleepTimerRemaining;

  const AudioPlayerState({
    this.isPlaying = false,
    this.isLoading = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.currentTrackIndex = 0,
    this.playbackSpeed = 1.0,
    this.loadedBookId,
    this.sleepTimerRemaining,
  });

  static const Object _s = Object();

  AudioPlayerState copyWith({
    bool? isPlaying,
    bool? isLoading,
    Duration? position,
    Duration? duration,
    int? currentTrackIndex,
    double? playbackSpeed,
    Object? loadedBookId = _s,
    Object? sleepTimerRemaining = _s,
  }) =>
      AudioPlayerState(
        isPlaying: isPlaying ?? this.isPlaying,
        isLoading: isLoading ?? this.isLoading,
        position: position ?? this.position,
        duration: duration ?? this.duration,
        currentTrackIndex: currentTrackIndex ?? this.currentTrackIndex,
        playbackSpeed: playbackSpeed ?? this.playbackSpeed,
        loadedBookId:
            loadedBookId == _s ? this.loadedBookId : loadedBookId as String?,
        sleepTimerRemaining: sleepTimerRemaining == _s
            ? this.sleepTimerRemaining
            : sleepTimerRemaining as Duration?,
      );
}

// ─── Search State ─────────────────────────────────────────────────────────────

class SearchState {
  final bool isActive;
  final bool isLoading;
  final String query;
  final List<dynamic> results;
  final bool isCollapsed;

  const SearchState({
    this.isActive = false,
    this.isLoading = false,
    this.query = '',
    this.results = const [],
    this.isCollapsed = false,
  });

  SearchState copyWith({
    bool? isActive,
    bool? isLoading,
    String? query,
    List<dynamic>? results,
    bool? isCollapsed,
  }) =>
      SearchState(
        isActive: isActive ?? this.isActive,
        isLoading: isLoading ?? this.isLoading,
        query: query ?? this.query,
        results: results ?? this.results,
        isCollapsed: isCollapsed ?? this.isCollapsed,
      );
}

class SearchNotifier extends Notifier<SearchState> {
  @override
  SearchState build() => const SearchState();

  void open() => state = state.copyWith(isActive: true);
  void clear() => state = const SearchState();
  void setLoading(bool v) => state = state.copyWith(isLoading: v);
  void setResults(String q, List<dynamic> r) =>
      state = state.copyWith(
          query: q, results: r, isLoading: false, isCollapsed: false);
  void toggleCollapse() =>
      state = state.copyWith(isCollapsed: !state.isCollapsed);
}

final searchNotifierProvider =
    NotifierProvider<SearchNotifier, SearchState>(SearchNotifier.new);

// ─── Annotation State ─────────────────────────────────────────────────────────

class AnnotationState {
  final List<Highlight> highlights;
  final List<Bookmark> bookmarks;
  final int? bookId;

  const AnnotationState({
    this.highlights = const [],
    this.bookmarks = const [],
    this.bookId,
  });

  AnnotationState copyWith({
    List<Highlight>? highlights,
    List<Bookmark>? bookmarks,
    int? bookId,
  }) =>
      AnnotationState(
        highlights: highlights ?? this.highlights,
        bookmarks: bookmarks ?? this.bookmarks,
        bookId: bookId ?? this.bookId,
      );
}

class AnnotationNotifier extends Notifier<AnnotationState> {
  final _db = DatabaseService();

  @override
  AnnotationState build() => const AnnotationState();

  Future<void> loadForBook(int bookId) async {
    final highlights = await _db.getHighlightsForBook(bookId);
    final bookmarks = await _db.getBookmarks(bookId);
    state = AnnotationState(
        bookId: bookId, highlights: highlights, bookmarks: bookmarks);
  }

  Future<void> addHighlight(Highlight h) async {
    final existing = state.highlights
        .where((e) =>
            e.chapterIndex == h.chapterIndex &&
            e.text == h.text &&
            e.position == h.position)
        .firstOrNull;
    if (existing != null) {
      await _db.updateHighlight(
          existing.copyWith(color: h.color, note: h.note));
    } else {
      await _db.insertHighlight(h);
    }
    if (state.bookId != null) await loadForBook(state.bookId!);
  }

  Future<void> updateHighlight(Highlight h) async {
    await _db.updateHighlight(h);
    if (state.bookId != null) await loadForBook(state.bookId!);
  }

  Future<void> deleteHighlight(int id) async {
    await _db.deleteHighlight(id);
    if (state.bookId != null) await loadForBook(state.bookId!);
  }

  Future<void> deleteHighlights(List<int> ids) async {
    for (final id in ids) {await _db.deleteHighlight(id);}
    if (state.bookId != null) await loadForBook(state.bookId!);
  }

  Future<void> addBookmark(Bookmark b) async {
    await _db.insertBookmark(b);
    if (state.bookId != null) await loadForBook(state.bookId!);
  }

  Future<void> deleteBookmark(int id) async {
    await _db.deleteBookmark(id);
    if (state.bookId != null) await loadForBook(state.bookId!);
  }

  Future<void> deleteBookmarks(List<Bookmark> bms) async {
    for (final b in bms) {
      if (b.id != null) await _db.deleteBookmark(b.id!);
    }
    if (state.bookId != null) await loadForBook(state.bookId!);
  }
}

final annotationNotifierProvider =
    NotifierProvider<AnnotationNotifier, AnnotationState>(
  AnnotationNotifier.new,
);
