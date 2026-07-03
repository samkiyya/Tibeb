import 'package:flutter/material.dart';
import '../../semantics/design_tokens.dart';

class TibebListTileThemeTokens {
  final TextStyle title;
  final TextStyle subtitle;
  final IconThemeData leading;
  final IconThemeData trailing;
  final Color selected;
  final Color pressed;
  final Color hover;
  final Color divider;

  const TibebListTileThemeTokens({
    required this.title,
    required this.subtitle,
    required this.leading,
    required this.trailing,
    required this.selected,
    required this.pressed,
    required this.hover,
    required this.divider,
  });

  factory TibebListTileThemeTokens.light(TibebColorSystem colors) {
    return TibebListTileThemeTokens(
      title: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      subtitle: const TextStyle(fontSize: 13),
      leading: IconThemeData(color: colors.textSecondary),
      trailing: IconThemeData(color: colors.textSecondary),
      selected: colors.primary,
      pressed: colors.primary.withValues(alpha: 0.1),
      hover: colors.primary.withValues(alpha: 0.05),
      divider: colors.outlineVariant,
    );
  }

  factory TibebListTileThemeTokens.dark(TibebColorSystem colors) {
    return TibebListTileThemeTokens(
      title: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      subtitle: const TextStyle(fontSize: 13),
      leading: IconThemeData(color: colors.textSecondary),
      trailing: IconThemeData(color: colors.textSecondary),
      selected: colors.primary,
      pressed: colors.primary.withValues(alpha: 0.1),
      hover: colors.primary.withValues(alpha: 0.05),
      divider: colors.outlineVariant,
    );
  }
}
