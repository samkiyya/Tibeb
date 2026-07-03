import 'package:flutter/material.dart';
import 'theme_extension.dart';
export 'theme_extension.dart';

/// Tibeb Design System — BuildContext Extensions
///
/// Provides ergonomic access to theme tokens from any widget.
///
/// Usage:
/// ```dart
/// final colors = context.tibpiColors;
/// Container(color: colors.surface);
/// Text('Hello', style: context.textTheme.titleLarge);
/// ```
extension TibebContextX on BuildContext {
  /// Access the full Tibeb semantic color system.
  /// This is the PRIMARY way to reference colors in all widgets.
  TibebThemeExtension get tibpiColors =>
      Theme.of(this).extension<TibebThemeExtension>()!;

  /// Access the Material ColorScheme (for Material components).
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Access the text theme.
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Current brightness (light or dark).
  Brightness get brightness => Theme.of(this).brightness;

  /// Whether the current theme is dark.
  bool get isDark => brightness == Brightness.dark;
}