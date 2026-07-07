import '../../models/search_result_model.dart';

/// Holds all UI-only flags for the reading screen.
/// Grouping these in one class keeps ReadingScreen fields to a minimum and
/// makes it easy to reset them atomically on a book switch.
class ReadingUiState {
  // ── Navigation sheet ──────────────────────────────────────────────────────
  bool isNavigationSheetOpen = false;

  // ── Orientation ───────────────────────────────────────────────────────────
  bool isOrientationLandscape = false;

  // ── Audio controls panel ──────────────────────────────────────────────────
  bool isAudioControlsExpanded = false;

  // ── TOC / search jump flag ────────────────────────────────────────────────
  /// True while the reader is scrolling to a programmatic target so that
  /// intermediate page-change events are ignored.
  bool isJumpingFromToc = false;

  // ── Search ────────────────────────────────────────────────────────────────
  bool isSearching = false;
  bool isSearchLoading = false;
  bool isSearchResultsCollapsed = false;
  List<SearchResult> searchResults = [];
  String? activeSearchQuery;

  // ── Reset ─────────────────────────────────────────────────────────────────

  /// Resets all search-specific state; called on search clear and book switch.
  void resetSearch() {
    isSearching = false;
    isSearchLoading = false;
    isSearchResultsCollapsed = false;
    searchResults = [];
    activeSearchQuery = null;
  }

  /// Full reset on book switch.
  void reset() {
    isNavigationSheetOpen = false;
    isOrientationLandscape = false;
    isAudioControlsExpanded = false;
    isJumpingFromToc = false;
    resetSearch();
  }
}
