import 'package:flutter/material.dart';
import 'navigation_bar_tokens.dart';

class TibebNavigationBarTheme {
  const TibebNavigationBarTheme._();

  static BottomNavigationBarThemeData bottomNavDark(
    TibebNavigationBarThemeTokens tokens,
  ) {
    return BottomNavigationBarThemeData(
      backgroundColor: tokens.background,
      selectedItemColor: tokens.selectedIcon.color,
      unselectedItemColor: tokens.unselectedIcon.color,
      type: BottomNavigationBarType.fixed,
      elevation: tokens.elevation,
      selectedLabelStyle: tokens.selectedLabel,
      unselectedLabelStyle: tokens.unselectedLabel,
    );
  }

  static BottomNavigationBarThemeData bottomNavLight(
    TibebNavigationBarThemeTokens tokens,
  ) {
    return BottomNavigationBarThemeData(
      backgroundColor: tokens.background,
      selectedItemColor: tokens.selectedIcon.color,
      unselectedItemColor: tokens.unselectedIcon.color,
      type: BottomNavigationBarType.fixed,
      elevation: 2.0,
      selectedLabelStyle: tokens.selectedLabel,
      unselectedLabelStyle: tokens.unselectedLabel,
    );
  }

  static NavigationBarThemeData navBarDark(
    TibebNavigationBarThemeTokens tokens,
  ) {
    return NavigationBarThemeData(
      backgroundColor: tokens.background,
      indicatorColor: tokens.indicator,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return tokens.selectedIcon;
        }
        return tokens.unselectedIcon;
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return tokens.selectedLabel;
        }
        return tokens.unselectedLabel;
      }),
    );
  }

  static NavigationBarThemeData navBarLight(
    TibebNavigationBarThemeTokens tokens,
  ) {
    return NavigationBarThemeData(
      backgroundColor: tokens.background,
      indicatorColor: tokens.indicator,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return tokens.selectedIcon;
        }
        return tokens.unselectedIcon;
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return tokens.selectedLabel;
        }
        return tokens.unselectedLabel;
      }),
    );
  }
}
