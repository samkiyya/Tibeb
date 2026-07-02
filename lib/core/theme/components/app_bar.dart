import 'package:flutter/material.dart';
import 'package:tibeb/core/theme/tokens/colors.dart';

class TibebAppBarTheme {
  static AppBarTheme get theme {
    return AppBarTheme(
      backgroundColor: TibebColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}