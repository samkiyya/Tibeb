import 'package:flutter/material.dart';
import '../../../foundation/foundation.dart';

/// Download feature design tokens.
class TibebDownloadThemeTokens {
  final Color downloading;
  final Color paused;
  final Color completed;
  final Color failed;
  final Color queued;

  const TibebDownloadThemeTokens({
    required this.downloading,
    required this.paused,
    required this.completed,
    required this.failed,
    required this.queued,
  });

  factory TibebDownloadThemeTokens.light(TibebColorSystem colors) {
    return TibebDownloadThemeTokens(
      downloading: colors.info,
      paused: colors.warning,
      completed: colors.success,
      failed: colors.error,
      queued: colors.textTertiary,
    );
  }

  factory TibebDownloadThemeTokens.dark(TibebColorSystem colors) {
    return TibebDownloadThemeTokens(
      downloading: colors.info,
      paused: colors.warning,
      completed: colors.success,
      failed: colors.error,
      queued: colors.textTertiary,
    );
  }
}
