import 'package:flutter/material.dart';
import 'navigation_rail_tokens.dart';

class TibebNavigationRailTheme {
  const TibebNavigationRailTheme._();

  static NavigationRailThemeData dark(TibebNavigationRailThemeTokens tokens) {
    return NavigationRailThemeData(
      backgroundColor: tokens.background,
      selectedIconTheme: IconThemeData(color: tokens.selected),
      unselectedIconTheme: IconThemeData(color: tokens.unselected),
      indicatorColor: tokens.indicator,
    );
  }

  static NavigationRailThemeData light(TibebNavigationRailThemeTokens tokens) {
    return NavigationRailThemeData(
      backgroundColor: tokens.background,
      selectedIconTheme: IconThemeData(color: tokens.selected),
      unselectedIconTheme: IconThemeData(color: tokens.unselected),
      indicatorColor: tokens.indicator,
    );
  }
}
