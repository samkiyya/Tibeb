import 'package:flutter/material.dart';
import '../../../foundation/foundation.dart';

/// Library feature design tokens.
class TibebLibraryThemeTokens {
  final Color bookCard;
  final BorderRadius bookCover;
  final Color shelf;
  final Color readingStatus;
  final Color progress;
  final Color downloadedBadge;
  final Color favoriteBadge;

  const TibebLibraryThemeTokens({
    required this.bookCard,
    required this.bookCover,
    required this.shelf,
    required this.readingStatus,
    required this.progress,
    required this.downloadedBadge,
    required this.favoriteBadge,
  });

  factory TibebLibraryThemeTokens.light(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
  ) {
    return TibebLibraryThemeTokens(
      bookCard: colors.surfaceBright,
      bookCover: radius.md,
      shelf: colors.outlineVariant,
      readingStatus: colors.primary,
      progress: colors.primary,
      downloadedBadge: colors.success,
      favoriteBadge: colors.error,
    );
  }

  factory TibebLibraryThemeTokens.dark(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
  ) {
    return TibebLibraryThemeTokens(
      bookCard: colors.surfaceBright,
      bookCover: radius.md,
      shelf: colors.outlineVariant,
      readingStatus: colors.primary,
      progress: colors.primary,
      downloadedBadge: colors.success,
      favoriteBadge: colors.error,
    );
  }
}
