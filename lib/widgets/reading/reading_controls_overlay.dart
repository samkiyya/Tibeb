import 'package:flutter/material.dart';
import '../../models/book_model.dart';
import '../../models/reader_settings_model.dart';
import '../../models/search_result_model.dart';
import '../../screens/reading/audio_controller.dart';
import '../../screens/reading/bookmark_controller.dart';
import '../../screens/reading/search_controller.dart';
import 'reading_header.dart';
import 'reading_search_overlay.dart';
import 'reading_bottom_controls.dart';
import 'reading_audio_section.dart';
import 'play_pause_button.dart';

/// Renders the overall slide-in/menu controls overlay for searching, actions, bookmarks, and audio controls.
class ReadingControlsOverlay extends StatelessWidget {
  final Book book;
  final ReaderSettings settings;
  final AudioController audio;
  final BookmarkController bookmarks;
  final ReaderSearchController search;

  final ValueNotifier<bool> showControlsNotifier;
  final ValueNotifier<String> currentTimeNotifier;
  final ValueNotifier<double> scrollProgressNotifier;
  final ValueNotifier<double> autoScrollSpeedNotifier;

  final bool isSearching;
  final bool isSearchLoading;
  final bool isSearchResultsCollapsed;
  final List<SearchResult> searchResults;

  final String currentChapter;
  final int currentChapterIndex;
  final int pdfCurrentPage;
  final int pdfPages;
  final bool isPdfReady;

  final bool isNavigationSheetOpen;
  final bool isAutoScrolling;
  final bool isOrientationLandscape;
  final bool isAudioControlsExpanded;

  // GlobalKeys for tutorial alignment
  final GlobalKey tocKey;
  final GlobalKey audioKey;
  final GlobalKey autoScrollKey;
  final GlobalKey displaySettingsKey;
  final GlobalKey searchKey;
  final GlobalKey lockKey;

  // Action callbacks
  final VoidCallback onBackPressed;
  final VoidCallback onToggleSearch;
  final VoidCallback onClearSearch;
  final ValueChanged<String> onSearchSubmitted;
  final VoidCallback onToggleSearchResultsCollapse;
  final VoidCallback onToggleLock;
  final VoidCallback onToggleAudioControls;
  final VoidCallback onPickAudio;
  final VoidCallback onShowNavigationSheet;
  final VoidCallback onToggleBookmark;
  final VoidCallback onToggleAutoScroll;
  final VoidCallback onToggleOrientation;
  final VoidCallback onShowDisplaySettings;
  final VoidCallback onIncrementPlaybackSpeed;
  final ValueChanged<Duration> onSkip;
  final VoidCallback? onNextTrack;
  final VoidCallback? onPrevTrack;
  final VoidCallback onShowTrackList;
  final double Function() getDisplayProgress;
  final ValueChanged<SearchResult> onResultTap;

  const ReadingControlsOverlay({
    super.key,
    required this.book,
    required this.settings,
    required this.audio,
    required this.bookmarks,
    required this.search,
    required this.showControlsNotifier,
    required this.currentTimeNotifier,
    required this.scrollProgressNotifier,
    required this.autoScrollSpeedNotifier,
    required this.isSearching,
    required this.isSearchLoading,
    required this.isSearchResultsCollapsed,
    required this.searchResults,
    required this.currentChapter,
    required this.currentChapterIndex,
    required this.pdfCurrentPage,
    required this.pdfPages,
    required this.isPdfReady,
    required this.isNavigationSheetOpen,
    required this.isAutoScrolling,
    required this.isOrientationLandscape,
    required this.isAudioControlsExpanded,
    required this.tocKey,
    required this.audioKey,
    required this.autoScrollKey,
    required this.displaySettingsKey,
    required this.searchKey,
    required this.lockKey,
    required this.onBackPressed,
    required this.onToggleSearch,
    required this.onClearSearch,
    required this.onSearchSubmitted,
    required this.onToggleSearchResultsCollapse,
    required this.onToggleLock,
    required this.onToggleAudioControls,
    required this.onPickAudio,
    required this.onShowNavigationSheet,
    required this.onToggleBookmark,
    required this.onToggleAutoScroll,
    required this.onToggleOrientation,
    required this.onShowDisplaySettings,
    required this.onIncrementPlaybackSpeed,
    required this.onSkip,
    this.onNextTrack,
    this.onPrevTrack,
    required this.onShowTrackList,
    required this.getDisplayProgress,
    required this.onResultTap,
  });

  @override
  Widget build(BuildContext context) {
    final isEpub = book.filePath.toLowerCase().endsWith('.epub');
    final currentTracks = audio.effectiveTracks(book);

    return ValueListenableBuilder<bool>(
      valueListenable: showControlsNotifier,
      builder: (context, showControls, _) {
        return Stack(
          children: [
            // Top Header: Title, Search triggers, etc.
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              top: showControls ? 0 : -200,
              left: 0,
              right: 0,
              child: ValueListenableBuilder<String>(
                valueListenable: currentTimeNotifier,
                builder: (context, currentTime, _) {
                  return ReadingHeader(
                    searchKey: searchKey,
                    lockKey: lockKey,
                    book: book,
                    settings: settings,
                    currentChapter: currentChapter,
                    pageInfo: isEpub
                        ? ValueListenableBuilder<double>(
                            valueListenable: scrollProgressNotifier,
                            builder: (context, scrollProgress, _) {
                              final displayProgress = getDisplayProgress();
                              return Text(
                                '${(displayProgress * 100).toStringAsFixed(0)}%',
                                style: TextStyle(
                                  color: settings.textColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            },
                          )
                        : Text(
                            '${pdfCurrentPage + 1} / $pdfPages',
                            style: TextStyle(
                              color: settings.textColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                    isSearching: isSearching,
                    isSearchLoading: isSearchLoading,
                    isSearchResultsCollapsed: isSearchResultsCollapsed,
                    searchResultsCount: searchResults.length,
                    searchController: search.textController,
                    searchFocusNode: search.focusNode,
                    onBackPressed: onBackPressed,
                    onToggleSearch: onToggleSearch,
                    onClearSearch: onClearSearch,
                    onSearchSubmitted: onSearchSubmitted,
                    onToggleSearchResultsCollapse:
                        onToggleSearchResultsCollapse,
                    onToggleLock: onToggleLock,
                    searchResultsOverlay: ReadingSearchOverlay(
                      book: book,
                      settings: settings,
                      searchResults: searchResults,
                      onResultTap: onResultTap,
                    ),
                  );
                },
              ),
            ),

            // Bottom Panel: Navigation options, Audio player controls
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              bottom: showControls ? 0 : -800,
              left: 0,
              right: 0,
              child: ReadingBottomControls(
                tocKey: tocKey,
                audioKey: audioKey,
                autoScrollKey: autoScrollKey,
                displaySettingsKey: displaySettingsKey,
                book: book,
                settings: settings,
                isAudioControlsExpanded: isAudioControlsExpanded,
                isNavigationSheetOpen: isNavigationSheetOpen,
                isAutoScrolling: isAutoScrolling,
                isBookmarked:
                    bookmarks.getCurrentBookmark(
                      book: book,
                      currentChapterIndex: currentChapterIndex,
                      scrollProgress: scrollProgressNotifier.value,
                      isPdfReady: isPdfReady,
                      pdfCurrentPage: pdfCurrentPage,
                    ) !=
                    null,
                playbackSpeed: audio.playbackSpeed,
                isOrientationLandscape: isOrientationLandscape,
                audioSection: ReadingAudioSection(
                  settings: settings,
                  isLoading: audio.isLoading,
                  positionNotifier: audio.positionNotifier,
                  durationNotifier: audio.durationNotifier,
                  currentIndexNotifier: audio.indexNotifier,
                  audioTracks: currentTracks,
                  isDraggingSlider: audio.isDraggingSlider,
                  sliderDragValue: audio.sliderDragValue,
                  onChangeStart: (value) {
                    audio.isDraggingSlider = true;
                    audio.sliderDragValue = value;
                  },
                  onChanged: (value) {
                    audio.sliderDragValue = value;
                    audio.positionNotifier.value = Duration(
                      milliseconds: value.toInt(),
                    );
                  },
                  onChangeEnd: (value) async {
                    await audio.player.seek(
                      Duration(milliseconds: value.toInt()),
                    );
                    audio.isDraggingSlider = false;
                  },
                  formatDuration: audio.formatDuration,
                  isOrientationLandscape: isOrientationLandscape,
                ),
                playPauseButton: PlayPauseButton(
                  isPlayingNotifier: audio.isPlayingNotifier,
                  onTap: audio.togglePlayPause,
                ),
                onToggleAudioControls: onToggleAudioControls,
                onPickAudio: onPickAudio,
                onShowNavigationSheet: onShowNavigationSheet,
                onToggleBookmark: onToggleBookmark,
                onToggleAutoScroll: onToggleAutoScroll,
                onToggleOrientation: onToggleOrientation,
                onShowDisplaySettings: onShowDisplaySettings,
                onIncrementPlaybackSpeed: onIncrementPlaybackSpeed,
                onSkip: onSkip,
                onNextTrack: onNextTrack,
                onPrevTrack: onPrevTrack,
                onShowTrackList: onShowTrackList,
              ),
            ),
          ],
        );
      },
    );
  }
}
