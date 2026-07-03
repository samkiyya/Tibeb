import 'package:flutter/material.dart';
import '../../foundation/foundation.dart';

class TibebProgressIndicatorsThemeTokens {
  final ProgressIndicatorThemeData linear;
  final ProgressIndicatorThemeData circular;
  final Color readingProgress;
  final Color downloadProgress;
  final Color audiobookProgress;
  final Color syncProgress;

  const TibebProgressIndicatorsThemeTokens({
    required this.linear,
    required this.circular,
    required this.readingProgress,
    required this.downloadProgress,
    required this.audiobookProgress,
    required this.syncProgress,
  });

  factory TibebProgressIndicatorsThemeTokens.light(TibebColorSystem colors) {
    return TibebProgressIndicatorsThemeTokens(
      linear: ProgressIndicatorThemeData(color: colors.primary),
      circular: ProgressIndicatorThemeData(color: colors.primary),
      readingProgress: colors.primary,
      downloadProgress: colors.info,
      audiobookProgress: colors.secondary,
      syncProgress: colors.success,
    );
  }

  factory TibebProgressIndicatorsThemeTokens.dark(TibebColorSystem colors) {
    return TibebProgressIndicatorsThemeTokens(
      linear: ProgressIndicatorThemeData(color: colors.primary),
      circular: ProgressIndicatorThemeData(color: colors.primary),
      readingProgress: colors.primary,
      downloadProgress: colors.info,
      audiobookProgress: colors.secondary,
      syncProgress: colors.success,
    );
  }
}
