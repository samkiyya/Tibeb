import 'package:flutter/material.dart';
import '../../semantics/design_tokens.dart';

class TibebNavigationRailThemeTokens {
  final Color background;
  final Color selected;
  final Color unselected;
  final Color indicator;
  final Color divider;

  const TibebNavigationRailThemeTokens({
    required this.background,
    required this.selected,
    required this.unselected,
    required this.indicator,
    required this.divider,
  });

  factory TibebNavigationRailThemeTokens.light(TibebColorSystem colors) {
    return TibebNavigationRailThemeTokens(
      background: colors.surface,
      selected: colors.primary,
      unselected: colors.textSecondary,
      indicator: colors.primary.withValues(alpha: 0.1),
      divider: colors.outlineVariant,
    );
  }

  factory TibebNavigationRailThemeTokens.dark(TibebColorSystem colors) {
    return TibebNavigationRailThemeTokens(
      background: colors.surface,
      selected: colors.primary,
      unselected: colors.textSecondary,
      indicator: colors.primary.withValues(alpha: 0.1),
      divider: colors.outlineVariant,
    );
  }
}
