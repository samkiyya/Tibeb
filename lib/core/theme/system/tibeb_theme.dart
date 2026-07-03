import 'package:flutter/material.dart';
import 'theme_extensions.dart';

/// Tibeb Design System ThemeData Builders
///
/// Builds global MaterialApp themes using custom semantic component tokens.
/// Standard Widget styles are delegated to modular category components.
class TibebTheme {
  const TibebTheme._();

  // ──────────────────────────────────────────────
  // Dark Theme (AMOLED/Dark)
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

      // Delegated component themes
      appBarTheme: TibebAppBarTheme.dark(ext.appBar),
      bottomNavigationBarTheme: TibebNavigationBarTheme.bottomNavDark(
        ext.navigationBar,
      ),
      navigationBarTheme: TibebNavigationBarTheme.navBarDark(ext.navigationBar),
      navigationRailTheme: TibebNavigationRailTheme.dark(ext.navigationRail),
      drawerTheme: TibebDrawerTheme.drawerDark(ext.navigationDrawer),
      navigationDrawerTheme: TibebDrawerTheme.navDrawerDark(
        ext.navigationDrawer,
      ),
      tabBarTheme: TibebTabBarTheme.dark(ext.tabs),

      inputDecorationTheme: TibebInputDecorationTheme.dark(ext.textField),
      chipTheme: TibebChipTheme.dark(ext.chip),

      elevatedButtonTheme: TibebButtonTheme.elevated(ext.buttons),
      sliderTheme: TibebSliderTheme.dark(ext.slider),
      switchTheme: TibebSwitchTheme.dark(ext.switchTheme, ext.primary),
      checkboxTheme: TibebCheckboxTheme.dark(ext.checkbox),
      radioTheme: TibebRadioTheme.dark(ext.radioButton),

      dialogTheme: TibebDialogTheme.dark(ext.dialog),
      bottomSheetTheme: TibebBottomSheetTheme.dark(ext.bottomSheet),
      snackBarTheme: TibebSnackBarTheme.dark(ext.snackBar, ext.radiusCat.md),
      cardTheme: TibebCardTheme.dark(ext.card, ext.surface),
      listTileTheme: TibebListTileTheme.dark(ext.listTile),
      tooltipTheme: TibebTooltipTheme.dark(ext.tooltip),
      badgeTheme: TibebBadgeTheme.dark(ext.badge),
      dividerTheme: TibebDividerTheme.dark(ext.dividerCat),

      progressIndicatorTheme: TibebProgressTheme.dark(
        ext.progress,
        ext.surface,
      ),
      iconTheme: IconThemeData(color: ext.textSecondary),

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

      // Delegated component themes
      appBarTheme: TibebAppBarTheme.light(ext.appBar),
      bottomNavigationBarTheme: TibebNavigationBarTheme.bottomNavLight(
        ext.navigationBar,
      ),
      navigationBarTheme: TibebNavigationBarTheme.navBarLight(
        ext.navigationBar,
      ),
      navigationRailTheme: TibebNavigationRailTheme.light(ext.navigationRail),
      drawerTheme: TibebDrawerTheme.drawerLight(ext.navigationDrawer),
      navigationDrawerTheme: TibebDrawerTheme.navDrawerLight(
        ext.navigationDrawer,
      ),
      tabBarTheme: TibebTabBarTheme.light(ext.tabs),

      inputDecorationTheme: TibebInputDecorationTheme.light(ext.textField),
      chipTheme: TibebChipTheme.light(ext.chip),

      elevatedButtonTheme: TibebButtonTheme.elevated(ext.buttons),
      sliderTheme: TibebSliderTheme.light(ext.slider),
      switchTheme: TibebSwitchTheme.light(ext.switchTheme, ext.primary),
      checkboxTheme: TibebCheckboxTheme.light(ext.checkbox),
      radioTheme: TibebRadioTheme.light(ext.radioButton),

      dialogTheme: TibebDialogTheme.light(ext.dialog),
      bottomSheetTheme: TibebBottomSheetTheme.light(ext.bottomSheet),
      snackBarTheme: TibebSnackBarTheme.light(ext.snackBar, ext.radiusCat.md),
      cardTheme: TibebCardTheme.light(ext.card, ext.surface),
      listTileTheme: TibebListTileTheme.light(ext.listTile),
      tooltipTheme: TibebTooltipTheme.light(ext.tooltip),
      badgeTheme: TibebBadgeTheme.light(ext.badge),
      dividerTheme: TibebDividerTheme.light(ext.dividerCat),

      progressIndicatorTheme: TibebProgressTheme.light(
        ext.progress,
        ext.surface,
      ),
      iconTheme: IconThemeData(color: ext.textSecondary),

      extensions: [ext],
    );
  }
}
