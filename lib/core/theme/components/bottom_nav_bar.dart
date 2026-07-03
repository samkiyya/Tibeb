import 'package:flutter/material.dart';
import '../semantics/theme_extension.dart';

class TibebBottomNavTheme {
  TibebBottomNavTheme._();

  static BottomNavigationBarThemeData dark(TibebThemeExtension ext) {
    return BottomNavigationBarThemeData(
      backgroundColor: ext.surface,
      selectedItemColor: ext.primary,
      unselectedItemColor: ext.textTertiary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
    );
  }

  static BottomNavigationBarThemeData light(TibebThemeExtension ext) {
    return BottomNavigationBarThemeData(
      backgroundColor: ext.surface,
      selectedItemColor: ext.primary,
      unselectedItemColor: ext.textTertiary,
      type: BottomNavigationBarType.fixed,
      elevation: 2,
      selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
    );
  }
}