import 'package:flutter/material.dart';
import '../semantics/theme_extension.dart';

class TibebAppBarTheme {
  TibebAppBarTheme._();

  static AppBarTheme dark(TibebThemeExtension ext) {
    return AppBarTheme(
      backgroundColor: ext.background,
      foregroundColor: ext.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: ext.textPrimary),
      titleTextStyle: TextStyle(
        color: ext.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  static AppBarTheme light(TibebThemeExtension ext) {
    return AppBarTheme(
      backgroundColor: ext.background,
      foregroundColor: ext.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      centerTitle: false,
      iconTheme: IconThemeData(color: ext.textPrimary),
      titleTextStyle: TextStyle(
        color: ext.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}