import 'package:flutter/material.dart';
import 'tab_bar_tokens.dart';

class TibebTabBarTheme {
  const TibebTabBarTheme._();

  static TabBarThemeData dark(TibebTabsThemeTokens tokens) {
    return TabBarThemeData(
      indicatorColor: tokens.indicator,
      labelStyle: tokens.selected,
      unselectedLabelStyle: tokens.unselected,
      dividerColor: tokens.divider,
    );
  }

  static TabBarThemeData light(TibebTabsThemeTokens tokens) {
    return TabBarThemeData(
      indicatorColor: tokens.indicator,
      labelStyle: tokens.selected,
      unselectedLabelStyle: tokens.unselected,
      dividerColor: tokens.divider,
    );
  }
}
