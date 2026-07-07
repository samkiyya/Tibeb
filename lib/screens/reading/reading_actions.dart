import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart';

import '../../models/book_model.dart';
import '../../models/reader_settings_model.dart';
import '../../providers/library_provider.dart';
import '../../providers/reader_settings_provider.dart';
import '../../widgets/display_settings_sheet.dart';
import '../../widgets/reading/track_list_sheet.dart';
import 'audio_controller.dart';
import 'progress_controller.dart';

/// Pure action callbacks extracted from _ReadingScreenState.
/// All methods accept the state they need rather than capturing it via closure.
class ReadingActions {
  ReadingActions._();

  // ── Controls overlay ──────────────────────────────────────────────────────

  static void setControlsVisibility({
    required bool visible,
    required ValueNotifier<bool> showControlsNotifier,
  }) {
    if (showControlsNotifier.value == visible) return;
    showControlsNotifier.value = visible;
    SystemChrome.setEnabledSystemUIMode(
      visible ? SystemUiMode.edgeToEdge : SystemUiMode.immersiveSticky,
    );
  }

  static void toggleControls({
    required ValueNotifier<bool> showControlsNotifier,
    required ProgressController progress,
  }) {
    progress.recordInteraction();
    setControlsVisibility(
      visible: !showControlsNotifier.value,
      showControlsNotifier: showControlsNotifier,
    );
  }

  // ── Orientation ───────────────────────────────────────────────────────────

  /// Flips orientation and returns the new landscape flag.
  static bool toggleOrientation({required bool isCurrentlyLandscape}) {
    final nowLandscape = !isCurrentlyLandscape;
    if (nowLandscape) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    return nowLandscape;
  }

  static void resetOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  // ── Lock ──────────────────────────────────────────────────────────────────

  static void toggleLock({
    required WidgetRef ref,
    required ProgressController progress,
  }) {
    ref.read(readerSettingsProvider.notifier).toggleLockState();
    progress.recordInteraction();
  }

  // ── Auto-scroll ───────────────────────────────────────────────────────────

  /// Returns the new [isAutoScrolling] value and updates [speedNotifier].
  static bool toggleAutoScroll({
    required bool isCurrentlyScrolling,
    required double settingsSpeed,
    required ValueNotifier<double> speedNotifier,
  }) {
    final nowScrolling = !isCurrentlyScrolling;
    final active = settingsSpeed < 0.5 ? 2.0 : settingsSpeed;
    speedNotifier.value = nowScrolling ? active : 0.0;
    return nowScrolling;
  }

  // ── Dictionary ────────────────────────────────────────────────────────────

  static Future<void> lookupDictionary({
    required String word,
    required WidgetRef ref,
  }) async {
    final lookupWord = word.trim().split(RegExp(r'\s+')).first;
    final encoded = Uri.encodeComponent(lookupWord);

    final book = ref.read(currentlyReadingProvider);
    if (book != null) {
      await ref
          .read(libraryProvider.notifier)
          .recordDictionaryLookup(lookupWord, book.id!);
    }

    if (io.Platform.isAndroid) {
      try {
        final intent = AndroidIntent(
          action: 'android.intent.action.PROCESS_TEXT',
          type: 'text/plain',
          arguments: {
            'android.intent.extra.PROCESS_TEXT': lookupWord,
            'android.intent.extra.PROCESS_TEXT_READONLY': true,
          },
        );
        await intent.launch();
        return;
      } catch (e) {
        debugPrint('Dictionary intent failed: $e');
      }
    }
    if (io.Platform.isIOS || io.Platform.isMacOS) {
      final dictUri = Uri.parse('x-dictionary:r:$encoded');
      if (await canLaunchUrl(dictUri)) {
        await launchUrl(dictUri);
        return;
      }
    }
  }

  // ── Display settings ──────────────────────────────────────────────────────

  static void showDisplaySettings(BuildContext context) {
    showDisplaySettingsSheet(context);
  }

  // ── Track list sheet ──────────────────────────────────────────────────────

  static void showTrackList({
    required BuildContext context,
    required ReaderSettings settings,
    required AudioController audio,
    required WidgetRef ref,
  }) {
    showTrackListSheet(
      context: context,
      settings: settings,
      audio: audio,
      ref: ref,
    );
  }

  // ── Theme reset on book switch ────────────────────────────────────────────

  static void resetThemeForBook({
    required Book book,
    required WidgetRef ref,
    required ReaderSettings settings,
  }) {
    final isPdf = book.filePath.toLowerCase().endsWith('.pdf');
    Future.microtask(() {
      if (isPdf) {
        if (settings.pdfTheme != null) {
          ref.read(readerSettingsProvider.notifier).setTheme(settings.pdfTheme!);
        } else {
          ref
              .read(readerSettingsProvider.notifier)
              .setTheme(ReaderTheme.white);
        }
      } else if (settings.epubTheme != null) {
        ref
            .read(readerSettingsProvider.notifier)
            .setTheme(settings.epubTheme!);
      }
    });
  }
}
