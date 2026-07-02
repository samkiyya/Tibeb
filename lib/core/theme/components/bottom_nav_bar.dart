import 'package:flutter/material.dart';
import 'package:tibeb/core/theme/tokens/colors.dart';

class TibebBottomNavigationBarTheme {
  static BottomNavigationBarThemeData get theme {
    return BottomNavigationBarThemeData(
      backgroundColor: TibebColors.surface,
      selectedItemColor: TibebColors.wisdom,
      unselectedItemColor: TibebColors.ink,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    );
  }
}