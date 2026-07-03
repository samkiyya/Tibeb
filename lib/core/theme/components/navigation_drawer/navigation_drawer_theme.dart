import 'package:flutter/material.dart';
import 'navigation_drawer_tokens.dart';

class TibebDrawerTheme {
  const TibebDrawerTheme._();

  static DrawerThemeData drawerDark(TibebNavigationDrawerThemeTokens tokens) {
    return DrawerThemeData(backgroundColor: tokens.background, elevation: 0.0);
  }

  static DrawerThemeData drawerLight(TibebNavigationDrawerThemeTokens tokens) {
    return DrawerThemeData(backgroundColor: tokens.background, elevation: 0.0);
  }

  static NavigationDrawerThemeData navDrawerDark(
    TibebNavigationDrawerThemeTokens tokens,
  ) {
    return NavigationDrawerThemeData(
      backgroundColor: tokens.background,
      indicatorColor: tokens.selectedItem,
    );
  }

  static NavigationDrawerThemeData navDrawerLight(
    TibebNavigationDrawerThemeTokens tokens,
  ) {
    return NavigationDrawerThemeData(
      backgroundColor: tokens.background,
      indicatorColor: tokens.selectedItem,
    );
  }
}
