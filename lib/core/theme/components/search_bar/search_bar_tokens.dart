import 'package:flutter/material.dart';
import '../../foundation/foundation.dart';

class TibebSearchBarThemeTokens {
  final Color background;
  final BorderSide border;
  final TextStyle hint;
  final IconThemeData leadingIcon;
  final IconThemeData trailingIcon;
  final Color suggestionBackground;
  final TextStyle suggestionText;

  const TibebSearchBarThemeTokens({
    required this.background,
    required this.border,
    required this.hint,
    required this.leadingIcon,
    required this.trailingIcon,
    required this.suggestionBackground,
    required this.suggestionText,
  });

  factory TibebSearchBarThemeTokens.light(TibebColorSystem colors) {
    return TibebSearchBarThemeTokens(
      background: colors.surfaceContainerLow,
      border: BorderSide(color: colors.outlineVariant),
      hint: TextStyle(color: colors.textTertiary),
      leadingIcon: IconThemeData(color: colors.textSecondary),
      trailingIcon: IconThemeData(color: colors.textSecondary),
      suggestionBackground: colors.surface,
      suggestionText: TextStyle(color: colors.textPrimary),
    );
  }

  factory TibebSearchBarThemeTokens.dark(TibebColorSystem colors) {
    return TibebSearchBarThemeTokens(
      background: colors.surfaceContainerLow,
      border: BorderSide(color: colors.outlineVariant),
      hint: TextStyle(color: colors.textTertiary),
      leadingIcon: IconThemeData(color: colors.textSecondary),
      trailingIcon: IconThemeData(color: colors.textSecondary),
      suggestionBackground: colors.surface,
      suggestionText: TextStyle(color: colors.textPrimary),
    );
  }
}
