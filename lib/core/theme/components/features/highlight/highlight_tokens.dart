import 'package:flutter/material.dart';
import '../../../foundation/foundation.dart';

/// Highlight feature design tokens.
class TibebHighlightThemeTokens {
  final Color yellow;
  final Color blue;
  final Color green;
  final Color pink;
  final Color orange;
  final TextStyle underline;
  final TextStyle strikethrough;
  final Color selected;
  final Color hovered;

  const TibebHighlightThemeTokens({
    required this.yellow,
    required this.blue,
    required this.green,
    required this.pink,
    required this.orange,
    required this.underline,
    required this.strikethrough,
    required this.selected,
    required this.hovered,
  });

  factory TibebHighlightThemeTokens.light(TibebColorSystem colors) {
    return TibebHighlightThemeTokens(
      yellow: const Color(0xFFFFEB3B),
      blue: const Color(0xFF64B5F6),
      green: const Color(0xFF81C784),
      pink: const Color(0xFFF48FB1),
      orange: const Color(0xFFFFB74D),
      underline: const TextStyle(decoration: TextDecoration.underline),
      strikethrough: const TextStyle(decoration: TextDecoration.lineThrough),
      selected: colors.primary.withValues(alpha: 0.2),
      hovered: colors.primary.withValues(alpha: 0.1),
    );
  }

  factory TibebHighlightThemeTokens.dark(TibebColorSystem colors) {
    return TibebHighlightThemeTokens(
      yellow: const Color(0xFFFFF176),
      blue: const Color(0xFF90CAF9),
      green: const Color(0xFFA5D6A7),
      pink: const Color(0xFFF48FB1),
      orange: const Color(0xFFFFCC80),
      underline: const TextStyle(decoration: TextDecoration.underline),
      strikethrough: const TextStyle(decoration: TextDecoration.lineThrough),
      selected: colors.primary.withValues(alpha: 0.25),
      hovered: colors.primary.withValues(alpha: 0.12),
    );
  }
}
