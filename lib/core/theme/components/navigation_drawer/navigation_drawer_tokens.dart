import 'package:flutter/material.dart';
import '../../foundation/foundation.dart';

class TibebNavigationDrawerThemeTokens {
  final Color background;
  final TextStyle header;
  final Color selectedItem;
  final Color hovered;
  final Color divider;
  final IconThemeData icons;
  final TextStyle text;

  const TibebNavigationDrawerThemeTokens({
    required this.background,
    required this.header,
    required this.selectedItem,
    required this.hovered,
    required this.divider,
    required this.icons,
    required this.text,
  });

  factory TibebNavigationDrawerThemeTokens.light(TibebColorSystem colors) {
    return TibebNavigationDrawerThemeTokens(
      background: colors.surface,
      header: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      selectedItem: colors.primary.withValues(alpha: 0.1),
      hovered: colors.primary.withValues(alpha: 0.05),
      divider: colors.outlineVariant,
      icons: IconThemeData(color: colors.textSecondary),
      text: const TextStyle(fontSize: 14),
    );
  }

  factory TibebNavigationDrawerThemeTokens.dark(TibebColorSystem colors) {
    return TibebNavigationDrawerThemeTokens(
      background: colors.surface,
      header: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      selectedItem: colors.primary.withValues(alpha: 0.1),
      hovered: colors.primary.withValues(alpha: 0.05),
      divider: colors.outlineVariant,
      icons: IconThemeData(color: colors.textSecondary),
      text: const TextStyle(fontSize: 14),
    );
  }
}
