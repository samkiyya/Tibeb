import 'package:flutter/material.dart';
import '../../../foundation/foundation.dart';

/// PDF Viewer feature design tokens.
///
/// Covers page chrome, selection, annotation, and toolbar surface colors.
class TibebPdfViewerThemeTokens {
  final Color background;
  final List<BoxShadow> pageShadow;
  final Color selection;
  final Color searchHighlight;
  final Color annotation;
  final Color thumbnailBackground;
  final Color toolbarBackground;

  const TibebPdfViewerThemeTokens({
    required this.background,
    required this.pageShadow,
    required this.selection,
    required this.searchHighlight,
    required this.annotation,
    required this.thumbnailBackground,
    required this.toolbarBackground,
  });

  factory TibebPdfViewerThemeTokens.light(
    TibebColorSystem colors,
    TibebElevationTokens elevation,
  ) {
    return TibebPdfViewerThemeTokens(
      background: const Color(0xFFF1F5F9),
      pageShadow: elevation.level2,
      selection: colors.primary.withValues(alpha: 0.2),
      searchHighlight: Colors.yellow.withValues(alpha: 0.5),
      annotation: colors.primary,
      thumbnailBackground: colors.surfaceContainerLow,
      toolbarBackground: colors.surface,
    );
  }

  factory TibebPdfViewerThemeTokens.dark(
    TibebColorSystem colors,
    TibebElevationTokens elevation,
  ) {
    return TibebPdfViewerThemeTokens(
      background: Colors.black,
      pageShadow: elevation.level2,
      selection: colors.primary.withValues(alpha: 0.2),
      searchHighlight: Colors.yellow.withValues(alpha: 0.5),
      annotation: colors.primary,
      thumbnailBackground: colors.surfaceContainerLow,
      toolbarBackground: colors.surface,
    );
  }
}
