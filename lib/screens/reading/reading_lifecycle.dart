import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/library_provider.dart';
import 'audio_controller.dart';
import 'audio_sync_controller.dart';
import 'auto_scroll_controller.dart';
import 'battery_controller.dart';
import 'bookmark_controller.dart';
import 'progress_controller.dart';
import 'reading_actions.dart';
import 'reading_tutorial_helper.dart';
import 'search_controller.dart';

/// Encapsulates all initState / dispose boilerplate for [ReadingScreen].
/// [ReadingScreen] calls [init] from initState and [teardown] from dispose.
class ReadingLifecycle {
  ReadingLifecycle({
    required this.audio,
    required this.audioSync,
    required this.autoScroll,
    required this.battery,
    required this.bookmarks,
    required this.progress,
    required this.search,
    required this.currentTimeNotifier,
    required this.pullDistanceNotifier,
    required this.isPullingDownNotifier,
    required this.scrollProgressNotifier,
    required this.showControlsNotifier,
    required this.onBatteryChanged,
    required this.onIndexChanged,
    required this.onBookmarkStateChanged,
    required this.onTimeTick,
    required this.tutorialKeys,
    required this.getPdfController,
    required this.getIsEpub,
  });

  final AudioController audio;
  final AudioSyncController audioSync;
  final AutoScrollController autoScroll;
  final BatteryController battery;
  final BookmarkController bookmarks;
  final ProgressController progress;
  final ReaderSearchController search;

  final ValueNotifier<String> currentTimeNotifier;
  final ValueNotifier<double> pullDistanceNotifier;
  final ValueNotifier<bool> isPullingDownNotifier;
  final ValueNotifier<double> scrollProgressNotifier;
  final ValueNotifier<bool> showControlsNotifier;

  final VoidCallback onBatteryChanged;
  final VoidCallback onIndexChanged;
  final VoidCallback onBookmarkStateChanged;
  final VoidCallback onTimeTick;

  final TutorialKeys tutorialKeys;
  final PdfControllerGetter getPdfController;
  final bool Function() getIsEpub;

  Timer? _clockTimer;

  // ── Init ──────────────────────────────────────────────────────────────────

  void init({
    required TickerProvider vsync,
    required WidgetRef ref,
    required BuildContext context,
    required Future<void> Function() loadBookmarks,
  }) {
    Future.microtask(
        () => ref.read(libraryProvider.notifier).setReadingActive(true));

    // Battery
    battery.init();
    battery.onBatteryChanged = onBatteryChanged;

    // Clock
    onTimeTick();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) => onTimeTick());

    // Audio
    audio.init();
    audioSync.init(ref: ref, getContext: () => context);
    audio.onIndexChanged = onIndexChanged;

    // Bookmarks
    bookmarks.onStateChanged = onBookmarkStateChanged;

    // Auto-scroll ticker
    autoScroll.init(vsync, getPdfController);
    autoScroll.isEpubGetter = getIsEpub;

    // Post-frame: bookmarks + tutorial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadBookmarks();
      ref.read(libraryProvider.notifier).setReadingActive(true);
      final book = ref.read(currentlyReadingProvider);
      if (book != null && context.mounted) {
        ReadingTutorialHelper.checkAndShow(
          context: context,
          isPdf: book.filePath.toLowerCase().endsWith('.pdf'),
          tocKey: tutorialKeys.tocKey,
          searchKey: tutorialKeys.searchKey,
          lockKey: tutorialKeys.lockKey,
          audioKey: tutorialKeys.audioKey,
          autoScrollKey: tutorialKeys.autoScrollKey,
          displaySettingsKey: tutorialKeys.displaySettingsKey,
        );
      }
    });
  }

  // ── Teardown ──────────────────────────────────────────────────────────────

  void teardown() {
    audio.dispose();
    progress.dispose();
    search.dispose();
    autoScroll.dispose();
    _clockTimer?.cancel();
    battery.dispose();
    currentTimeNotifier.dispose();
    pullDistanceNotifier.dispose();
    isPullingDownNotifier.dispose();
    scrollProgressNotifier.dispose();
    showControlsNotifier.dispose();
    ReadingActions.resetOrientation();
  }

  // ── Deactivate ────────────────────────────────────────────────────────────

  static void onDeactivate(WidgetRef ref) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Future.microtask(
        () => ref.read(libraryProvider.notifier).setReadingActive(false));
  }
}

// ── Value objects ─────────────────────────────────────────────────────────────

/// Holds the six GlobalKeys used by the tutorial coach marks.
class TutorialKeys {
  const TutorialKeys({
    required this.tocKey,
    required this.searchKey,
    required this.lockKey,
    required this.audioKey,
    required this.autoScrollKey,
    required this.displaySettingsKey,
  });
  final GlobalKey tocKey;
  final GlobalKey searchKey;
  final GlobalKey lockKey;
  final GlobalKey audioKey;
  final GlobalKey autoScrollKey;
  final GlobalKey displaySettingsKey;
}
