import 'package:flutter/material.dart';
import '../../../foundation/foundation.dart';

/// Audiobook player feature design tokens.
class TibebAudiobookThemeTokens {
  final Color playerBackground;
  final Color waveform;
  final Color seekBar;
  final Color chapterMarker;
  final TextStyle playbackSpeed;
  final TextStyle timer;
  final Color miniPlayer;
  final Color fullPlayer;
  final TextStyle lyricsTranscript;

  const TibebAudiobookThemeTokens({
    required this.playerBackground,
    required this.waveform,
    required this.seekBar,
    required this.chapterMarker,
    required this.playbackSpeed,
    required this.timer,
    required this.miniPlayer,
    required this.fullPlayer,
    required this.lyricsTranscript,
  });

  factory TibebAudiobookThemeTokens.light(TibebColorSystem colors) {
    return TibebAudiobookThemeTokens(
      playerBackground: colors.surface,
      waveform: colors.primary,
      seekBar: colors.textSecondary,
      chapterMarker: colors.outline,
      playbackSpeed: TextStyle(color: colors.textPrimary),
      timer: TextStyle(color: colors.textSecondary),
      miniPlayer: colors.surfaceContainerLow,
      fullPlayer: colors.surface,
      lyricsTranscript: const TextStyle(),
    );
  }

  factory TibebAudiobookThemeTokens.dark(TibebColorSystem colors) {
    return TibebAudiobookThemeTokens(
      playerBackground: colors.surface,
      waveform: colors.primary,
      seekBar: colors.textSecondary,
      chapterMarker: colors.outline,
      playbackSpeed: TextStyle(color: colors.textPrimary),
      timer: TextStyle(color: colors.textSecondary),
      miniPlayer: colors.surfaceContainerLow,
      fullPlayer: colors.surface,
      lyricsTranscript: const TextStyle(),
    );
  }
}
