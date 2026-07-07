import 'package:epub_view/epub_view.dart';
import 'package:pdfrx/pdfrx.dart';
import '../../models/bookmark_model.dart';
import '../../models/highlight_model.dart';
import '../../models/search_result_model.dart';

/// Immutable snapshot of everything the ReadingScreen build method needs.
/// Controller classes mutate their own fields and call setState on the widget.
/// We never put this in a provider — it lives purely in widget state.
class ReadingState {
  // ── EPUB ──────────────────────────────────────────────────────────────────
  final List<EpubChapter> chapters;
  final List<int> epubChapterLengths;
  final int epubTotalLength;
  final int currentChapterIndex;
  final String currentChapter;
  final double initialScrollProgress;
  final bool shouldJumpToBottom;
  final EpubBook? epubBook;

  // ── PDF ───────────────────────────────────────────────────────────────────
  final int pdfPages;
  final int pdfCurrentPage;
  final bool isPdfReady;
  final List<PdfOutlineNode> pdfOutline;
  final List<PdfOutlineNode> tocPdfOutline;
  final PdfOutlineNode? currentPdfNode;

  // ── AUDIO ─────────────────────────────────────────────────────────────────
  final bool isAudioLoading;
  final bool isAudioControlsExpanded;
  final double playbackSpeed;
  final bool isDraggingSlider;
  final double sliderDragValue;

  // ── UI ────────────────────────────────────────────────────────────────────
  final bool isAutoScrolling;
  final bool isNavigationSheetOpen;
  final bool isSearching;
  final bool isSearchLoading;
  final bool isSearchResultsCollapsed;
  final bool isOrientationLandscape;
  final bool isJumpingFromToc;
  final String? activeSearchQuery;
  final List<SearchResult> searchResults;
  final int batteryLevel;

  // ── ANNOTATIONS ───────────────────────────────────────────────────────────
  final List<Bookmark> bookmarks;
  final List<Highlight> highlights;

  const ReadingState({
    this.chapters = const [],
    this.epubChapterLengths = const [],
    this.epubTotalLength = 0,
    this.currentChapterIndex = 0,
    this.currentChapter = 'Chapter 1',
    this.initialScrollProgress = 0.0,
    this.shouldJumpToBottom = false,
    this.epubBook,
    this.pdfPages = 0,
    this.pdfCurrentPage = 0,
    this.isPdfReady = false,
    this.pdfOutline = const [],
    this.tocPdfOutline = const [],
    this.currentPdfNode,
    this.isAudioLoading = false,
    this.isAudioControlsExpanded = false,
    this.playbackSpeed = 1.0,
    this.isDraggingSlider = false,
    this.sliderDragValue = 0.0,
    this.isAutoScrolling = false,
    this.isNavigationSheetOpen = false,
    this.isSearching = false,
    this.isSearchLoading = false,
    this.isSearchResultsCollapsed = false,
    this.isOrientationLandscape = false,
    this.isJumpingFromToc = false,
    this.activeSearchQuery,
    this.searchResults = const [],
    this.batteryLevel = 100,
    this.bookmarks = const [],
    this.highlights = const [],
  });

  ReadingState copyWith({
    List<EpubChapter>? chapters,
    List<int>? epubChapterLengths,
    int? epubTotalLength,
    int? currentChapterIndex,
    String? currentChapter,
    double? initialScrollProgress,
    bool? shouldJumpToBottom,
    EpubBook? epubBook,
    bool clearEpubBook = false,
    int? pdfPages,
    int? pdfCurrentPage,
    bool? isPdfReady,
    List<PdfOutlineNode>? pdfOutline,
    List<PdfOutlineNode>? tocPdfOutline,
    PdfOutlineNode? currentPdfNode,
    bool clearCurrentPdfNode = false,
    bool? isAudioLoading,
    bool? isAudioControlsExpanded,
    double? playbackSpeed,
    bool? isDraggingSlider,
    double? sliderDragValue,
    bool? isAutoScrolling,
    bool? isNavigationSheetOpen,
    bool? isSearching,
    bool? isSearchLoading,
    bool? isSearchResultsCollapsed,
    bool? isOrientationLandscape,
    bool? isJumpingFromToc,
    String? activeSearchQuery,
    bool clearActiveSearchQuery = false,
    List<SearchResult>? searchResults,
    int? batteryLevel,
    List<Bookmark>? bookmarks,
    List<Highlight>? highlights,
  }) {
    return ReadingState(
      chapters: chapters ?? this.chapters,
      epubChapterLengths: epubChapterLengths ?? this.epubChapterLengths,
      epubTotalLength: epubTotalLength ?? this.epubTotalLength,
      currentChapterIndex: currentChapterIndex ?? this.currentChapterIndex,
      currentChapter: currentChapter ?? this.currentChapter,
      initialScrollProgress:
          initialScrollProgress ?? this.initialScrollProgress,
      shouldJumpToBottom: shouldJumpToBottom ?? this.shouldJumpToBottom,
      epubBook: clearEpubBook ? null : (epubBook ?? this.epubBook),
      pdfPages: pdfPages ?? this.pdfPages,
      pdfCurrentPage: pdfCurrentPage ?? this.pdfCurrentPage,
      isPdfReady: isPdfReady ?? this.isPdfReady,
      pdfOutline: pdfOutline ?? this.pdfOutline,
      tocPdfOutline: tocPdfOutline ?? this.tocPdfOutline,
      currentPdfNode: clearCurrentPdfNode
          ? null
          : (currentPdfNode ?? this.currentPdfNode),
      isAudioLoading: isAudioLoading ?? this.isAudioLoading,
      isAudioControlsExpanded:
          isAudioControlsExpanded ?? this.isAudioControlsExpanded,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      isDraggingSlider: isDraggingSlider ?? this.isDraggingSlider,
      sliderDragValue: sliderDragValue ?? this.sliderDragValue,
      isAutoScrolling: isAutoScrolling ?? this.isAutoScrolling,
      isNavigationSheetOpen:
          isNavigationSheetOpen ?? this.isNavigationSheetOpen,
      isSearching: isSearching ?? this.isSearching,
      isSearchLoading: isSearchLoading ?? this.isSearchLoading,
      isSearchResultsCollapsed:
          isSearchResultsCollapsed ?? this.isSearchResultsCollapsed,
      isOrientationLandscape:
          isOrientationLandscape ?? this.isOrientationLandscape,
      isJumpingFromToc: isJumpingFromToc ?? this.isJumpingFromToc,
      activeSearchQuery: clearActiveSearchQuery
          ? null
          : (activeSearchQuery ?? this.activeSearchQuery),
      searchResults: searchResults ?? this.searchResults,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      bookmarks: bookmarks ?? this.bookmarks,
      highlights: highlights ?? this.highlights,
    );
  }
}
