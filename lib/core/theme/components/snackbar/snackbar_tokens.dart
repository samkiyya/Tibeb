import 'package:flutter/material.dart';
import '../../foundation/foundation.dart';

class TibebSnackBarThemeTokens {
  final Color background;
  final TextStyle text;
  final TextStyle action;
  final Color success;
  final Color warning;
  final Color error;
  final Color info;

  const TibebSnackBarThemeTokens({
    required this.background,
    required this.text,
    required this.action,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
  });

  factory TibebSnackBarThemeTokens.light(TibebColorSystem colors) {
    return TibebSnackBarThemeTokens(
      background: colors.inverseSurface,
      text: TextStyle(color: colors.surface),
      action: TextStyle(color: colors.primary),
      success: colors.success,
      warning: colors.warning,
      error: colors.error,
      info: colors.info,
    );
  }

  factory TibebSnackBarThemeTokens.dark(TibebColorSystem colors) {
    return TibebSnackBarThemeTokens(
      background: colors.inverseSurface,
      text: TextStyle(color: colors.surface),
      action: TextStyle(color: colors.primary),
      success: colors.success,
      warning: colors.warning,
      error: colors.error,
      info: colors.info,
    );
  }
}
