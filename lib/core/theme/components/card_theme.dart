import 'package:flutter/material.dart';
import 'package:tibeb/core/theme/tokens/colors.dart';

class TibebCardTheme {
  static CardThemeData get theme {
    return CardThemeData(
      color: TibebColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}