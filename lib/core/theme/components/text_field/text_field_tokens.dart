import 'package:flutter/material.dart';
import '../../semantics/design_tokens.dart';

class TibebTextFieldThemeTokens {
  final Color background;
  final BorderSide border;
  final BorderSide focusedBorder;
  final BorderSide errorBorder;
  final BorderSide disabledBorder;
  final Color cursor;
  final TextStyle hint;
  final TextStyle label;
  final TextStyle helper;
  final TextStyle counter;
  final Color selection;
  final BorderRadius radius;
  final EdgeInsets padding;

  const TibebTextFieldThemeTokens({
    required this.background,
    required this.border,
    required this.focusedBorder,
    required this.errorBorder,
    required this.disabledBorder,
    required this.cursor,
    required this.hint,
    required this.label,
    required this.helper,
    required this.counter,
    required this.selection,
    required this.radius,
    required this.padding,
  });

  factory TibebTextFieldThemeTokens.light(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
  ) {
    return TibebTextFieldThemeTokens(
      background: colors.surfaceContainerLow,
      border: BorderSide(color: colors.outline),
      focusedBorder: BorderSide(color: colors.primary, width: 2),
      errorBorder: BorderSide(color: colors.error, width: 2),
      disabledBorder: BorderSide(color: colors.disabled),
      cursor: colors.primary,
      hint: TextStyle(color: colors.textTertiary),
      label: TextStyle(color: colors.textSecondary),
      helper: TextStyle(color: colors.textTertiary),
      counter: TextStyle(color: colors.textTertiary),
      selection: colors.primary.withValues(alpha: 0.2),
      radius: radius.md,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  factory TibebTextFieldThemeTokens.dark(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
  ) {
    return TibebTextFieldThemeTokens(
      background: colors.surfaceContainerLow,
      border: BorderSide(color: colors.outline),
      focusedBorder: BorderSide(color: colors.primary, width: 2),
      errorBorder: BorderSide(color: colors.error, width: 2),
      disabledBorder: BorderSide(color: colors.disabled),
      cursor: colors.primary,
      hint: TextStyle(color: colors.textTertiary),
      label: TextStyle(color: colors.textSecondary),
      helper: TextStyle(color: colors.textTertiary),
      counter: TextStyle(color: colors.textTertiary),
      selection: colors.primary.withValues(alpha: 0.2),
      radius: radius.md,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}
