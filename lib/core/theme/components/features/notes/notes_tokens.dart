import 'package:flutter/material.dart';
import '../../../foundation/foundation.dart';

/// Notes feature design tokens.
class TibebNotesThemeTokens {
  final Color background;
  final TextStyle title;
  final TextStyle content;
  final TextStyle timestamp;
  final Color pinned;
  final Color selected;
  final Color editor;
  final Color markdownPreview;

  const TibebNotesThemeTokens({
    required this.background,
    required this.title,
    required this.content,
    required this.timestamp,
    required this.pinned,
    required this.selected,
    required this.editor,
    required this.markdownPreview,
  });

  factory TibebNotesThemeTokens.light(TibebColorSystem colors) {
    return TibebNotesThemeTokens(
      background: colors.surface,
      title: const TextStyle(fontWeight: FontWeight.bold),
      content: const TextStyle(),
      timestamp: const TextStyle(fontSize: 11),
      pinned: colors.primary,
      selected: colors.primary.withValues(alpha: 0.1),
      editor: colors.surfaceBright,
      markdownPreview: colors.surfaceContainerLow,
    );
  }

  factory TibebNotesThemeTokens.dark(TibebColorSystem colors) {
    return TibebNotesThemeTokens(
      background: colors.surface,
      title: const TextStyle(fontWeight: FontWeight.bold),
      content: const TextStyle(),
      timestamp: const TextStyle(fontSize: 11),
      pinned: colors.primary,
      selected: colors.primary.withValues(alpha: 0.1),
      editor: colors.surfaceBright,
      markdownPreview: colors.surfaceContainerLow,
    );
  }
}
