import 'package:flutter/material.dart';
import '../../foundation/foundation.dart';

class TibebBadgeThemeTokens {
  final Color background;
  final TextStyle text;
  final BorderSide border;

  const TibebBadgeThemeTokens({
    required this.background,
    required this.text,
    required this.border,
  });

  factory TibebBadgeThemeTokens.light(TibebColorSystem colors) {
    return TibebBadgeThemeTokens(
      background: colors.error,
      text: const TextStyle(color: Colors.white, fontSize: 10),
      border: BorderSide(color: colors.surface),
    );
  }

  factory TibebBadgeThemeTokens.dark(TibebColorSystem colors) {
    return TibebBadgeThemeTokens(
      background: colors.error,
      text: const TextStyle(color: Colors.white, fontSize: 10),
      border: BorderSide(color: colors.surface),
    );
  }
}
