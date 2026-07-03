import 'package:flutter/material.dart';
import '../../semantics/design_tokens.dart';

class TibebTabsThemeTokens {
  final Color indicator;
  final TextStyle selected;
  final TextStyle unselected;
  final Color divider;
  final Color background;

  const TibebTabsThemeTokens({
    required this.indicator,
    required this.selected,
    required this.unselected,
    required this.divider,
    required this.background,
  });

  factory TibebTabsThemeTokens.light(TibebColorSystem colors) {
    return TibebTabsThemeTokens(
      indicator: colors.primary,
      selected: TextStyle(color: colors.primary, fontWeight: FontWeight.bold),
      unselected: TextStyle(color: colors.textSecondary),
      divider: colors.outlineVariant,
      background: colors.surface,
    );
  }

  factory TibebTabsThemeTokens.dark(TibebColorSystem colors) {
    return TibebTabsThemeTokens(
      indicator: colors.primary,
      selected: TextStyle(color: colors.primary, fontWeight: FontWeight.bold),
      unselected: TextStyle(color: colors.textSecondary),
      divider: colors.outlineVariant,
      background: colors.surface,
    );
  }
}
