import 'package:flutter/material.dart';
import '../../foundation/foundation.dart';

class TibebDialogThemeTokens {
  final Color background;
  final TextStyle title;
  final TextStyle content;
  final Color actionsDivider;
  final BorderRadius radius;
  final double elevation;

  const TibebDialogThemeTokens({
    required this.background,
    required this.title,
    required this.content,
    required this.actionsDivider,
    required this.radius,
    required this.elevation,
  });

  factory TibebDialogThemeTokens.light(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
  ) {
    return TibebDialogThemeTokens(
      background: colors.surface,
      title: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      content: const TextStyle(fontSize: 15),
      actionsDivider: colors.outlineVariant,
      radius: radius.xl,
      elevation: 24.0,
    );
  }

  factory TibebDialogThemeTokens.dark(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
  ) {
    return TibebDialogThemeTokens(
      background: colors.surface,
      title: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      content: const TextStyle(fontSize: 15),
      actionsDivider: colors.outlineVariant,
      radius: radius.xl,
      elevation: 24.0,
    );
  }
}
