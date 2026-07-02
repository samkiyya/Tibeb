import 'package:flutter/material.dart';
import 'package:tibeb/core/theme/tokens/colors.dart';

class TibebProgressTheme {
  static ProgressIndicatorThemeData get theme {
    return const ProgressIndicatorThemeData(
      color: TibebColors.wisdom,
      linearTrackColor: TibebColors.surface,
    );
  }
}