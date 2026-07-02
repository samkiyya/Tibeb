import 'package:flutter/material.dart';
import 'package:tibeb/core/theme/tokens/colors.dart';

class TibebButtonTheme {
  static ElevatedButtonThemeData get theme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: TibebColors.wisdom,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}