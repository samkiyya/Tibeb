import 'package:flutter/material.dart';

import 'semantics/theme_extension.dart';
import 'semantics/color_scheme.dart';
import 'tokens/typography.dart';
import 'components/button_theme.dart';
import 'components/card_theme.dart';
import 'components/progress_theme.dart';
import 'components/app_bar.dart';
import 'components/bottom_nav_bar.dart';

/// Tibeb Design System — Theme Factory
///
/// Produces [ThemeData] for light and dark modes, wiring together:
/// - Material [ColorScheme]
/// - [TibebThemeExtension] (semantic colors)
/// - [TibebTypography] (Inter font scale)
/// - Component themes (AppBar, BottomNav, Card, Button, Progress)
class TibebTheme {
  TibebTheme._();

  // ──────────────────────────────────────────────
  // Dark Theme (Primary — AMOLED)
  // ──────────────────────────────────────────────
  static ThemeData dark() {
    final ext = TibebThemeExtension.dark();

    final scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: ext.primary,
      onPrimary: ext.textOnPrimary,
      secondary: ext.accent,
      onSecondary: ext.textOnAccent,
      error: ext.error,
      onError: Colors.white,
      surface: ext.surface,
      onSurface: ext.textPrimary,
      outline: ext.border,
      outlineVariant: ext.borderSubtle,
      surfaceContainerHighest: ext.surfaceElevated,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      textTheme: TibebTypography.textTheme,
      scaffoldBackgroundColor: ext.background,

      // Component themes
      appBarTheme: TibebAppBarTheme.dark(ext),
      bottomNavigationBarTheme: TibebBottomNavTheme.dark(ext),
      elevatedButtonTheme: TibebButtonTheme.elevated(ext),
      cardTheme: TibebCardTheme.dark(ext),
      progressIndicatorTheme: TibebProgressTheme.theme(ext),
      dividerTheme: DividerThemeData(color: ext.divider, thickness: 0.5),
      iconTheme: IconThemeData(color: ext.textSecondary),

      // Dialogs & sheets
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: ext.surface,
        shape: RoundedRectangleBorder(borderRadius: ext.radiusCat.xl),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: ext.surface,
        shape: RoundedRectangleBorder(borderRadius: ext.radiusCat.xl),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ext.surfaceElevated,
        contentTextStyle: TextStyle(color: ext.textPrimary),
        shape: RoundedRectangleBorder(borderRadius: ext.radiusCat.md),
        behavior: SnackBarBehavior.floating,
      ),

      // Input
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ext.surface,
        border: OutlineInputBorder(
          borderRadius: ext.radiusCat.md,
          borderSide: BorderSide(color: ext.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: ext.radiusCat.md,
          borderSide: BorderSide(color: ext.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: ext.radiusCat.md,
          borderSide: BorderSide(color: ext.primary, width: 2),
        ),
        hintStyle: TextStyle(color: ext.textTertiary),
      ),

      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: ext.surface,
        selectedColor: ext.primary.withValues(alpha: 0.2),
        labelStyle: TextStyle(color: ext.textSecondary),
        shape: RoundedRectangleBorder(
          borderRadius: ext.radiusCat.pill,
          side: BorderSide(color: ext.border),
        ),
      ),

      // Extensions
      extensions: [ext],
    );
  }

  // ──────────────────────────────────────────────
  // Light Theme
  // ──────────────────────────────────────────────
  static ThemeData light() {
    final ext = TibebThemeExtension.light();

    final scheme = ColorScheme(
      brightness: Brightness.light,
      primary: ext.primary,
      onPrimary: ext.textOnPrimary,
      secondary: ext.accent,
      onSecondary: ext.textOnAccent,
      error: ext.error,
      onError: Colors.white,
      surface: ext.surface,
      onSurface: ext.textPrimary,
      outline: ext.border,
      outlineVariant: ext.borderSubtle,
      surfaceContainerHighest: ext.surfaceElevated,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      textTheme: TibebTypography.textTheme,
      scaffoldBackgroundColor: ext.background,

      appBarTheme: TibebAppBarTheme.light(ext),
      bottomNavigationBarTheme: TibebBottomNavTheme.light(ext),
      elevatedButtonTheme: TibebButtonTheme.elevated(ext),
      cardTheme: TibebCardTheme.light(ext),
      progressIndicatorTheme: TibebProgressTheme.theme(ext),
      dividerTheme: DividerThemeData(color: ext.divider, thickness: 0.5),
      iconTheme: IconThemeData(color: ext.textSecondary),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: ext.surface,
        shape: RoundedRectangleBorder(borderRadius: ext.radiusCat.xl),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: ext.surface,
        shape: RoundedRectangleBorder(borderRadius: ext.radiusCat.xl),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ext.surfaceElevated,
        contentTextStyle: TextStyle(color: ext.textPrimary),
        shape: RoundedRectangleBorder(borderRadius: ext.radiusCat.md),
        behavior: SnackBarBehavior.floating,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ext.surfaceOverlay,
        border: OutlineInputBorder(
          borderRadius: ext.radiusCat.md,
          borderSide: BorderSide(color: ext.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: ext.radiusCat.md,
          borderSide: BorderSide(color: ext.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: ext.radiusCat.md,
          borderSide: BorderSide(color: ext.primary, width: 2),
        ),
        hintStyle: TextStyle(color: ext.textTertiary),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: ext.surfaceOverlay,
        selectedColor: ext.primary.withValues(alpha: 0.1),
        labelStyle: TextStyle(color: ext.textSecondary),
        shape: RoundedRectangleBorder(
          borderRadius: ext.radiusCat.pill,
          side: BorderSide(color: ext.border),
        ),
      ),

      extensions: [ext],
    );
  }
}
