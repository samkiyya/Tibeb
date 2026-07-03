import 'package:flutter/material.dart';
import 'app_bar_tokens.dart';

class TibebAppBarTheme {
  const TibebAppBarTheme._();

  static AppBarTheme dark(TibebAppBarThemeTokens tokens) {
    return AppBarTheme(
      backgroundColor: tokens.background,
      foregroundColor: tokens.foreground,
      elevation: tokens.elevation,
      scrolledUnderElevation: 0,
      centerTitle: tokens.centerTitle,
      iconTheme: tokens.leadingIcon,
      titleTextStyle: tokens.title,
    );
  }

  static AppBarTheme light(TibebAppBarThemeTokens tokens) {
    return AppBarTheme(
      backgroundColor: tokens.background,
      foregroundColor: tokens.foreground,
      elevation: tokens.elevation,
      scrolledUnderElevation: 0.5,
      centerTitle: tokens.centerTitle,
      iconTheme: tokens.leadingIcon,
      titleTextStyle: tokens.title,
    );
  }
}
