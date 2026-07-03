import 'package:flutter/material.dart';
import '../../semantics/design_tokens.dart';

class TibebNavigationBarThemeTokens {
  final Color background;
  final IconThemeData selectedIcon;
  final IconThemeData unselectedIcon;
  final TextStyle selectedLabel;
  final TextStyle unselectedLabel;
  final Color indicator;
  final double elevation;
  final Color divider;
  final Color badgeBackground;

  const TibebNavigationBarThemeTokens({
    required this.background,
    required this.selectedIcon,
    required this.unselectedIcon,
    required this.selectedLabel,
    required this.unselectedLabel,
    required this.indicator,
    required this.elevation,
    required this.divider,
    required this.badgeBackground,
  });

  factory TibebNavigationBarThemeTokens.light(TibebColorSystem colors) {
    return TibebNavigationBarThemeTokens(
      background: colors.surface,
      selectedIcon: IconThemeData(color: colors.primary, size: 24),
      unselectedIcon: IconThemeData(color: colors.textSecondary, size: 24),
      selectedLabel: TextStyle(
        color: colors.primary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabel: TextStyle(color: colors.textSecondary, fontSize: 12),
      indicator: colors.primary.withValues(alpha: 0.1),
      elevation: 0.0,
      divider: colors.outlineVariant,
      badgeBackground: Colors.redAccent,
    );
  }

  factory TibebNavigationBarThemeTokens.dark(TibebColorSystem colors) {
    return TibebNavigationBarThemeTokens(
      background: colors.surface,
      selectedIcon: IconThemeData(color: colors.primary, size: 24),
      unselectedIcon: IconThemeData(color: colors.textSecondary, size: 24),
      selectedLabel: TextStyle(
        color: colors.primary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabel: TextStyle(color: colors.textSecondary, fontSize: 12),
      indicator: colors.primary.withValues(alpha: 0.1),
      elevation: 0.0,
      divider: colors.outlineVariant,
      badgeBackground: Colors.redAccent,
    );
  }
}
