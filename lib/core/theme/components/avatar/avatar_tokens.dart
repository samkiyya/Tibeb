import 'package:flutter/material.dart';
import '../../foundation/foundation.dart';

class TibebAvatarThemeTokens {
  final Color background;
  final Color foreground;
  final double radiusSmall;
  final double radiusMedium;
  final double radiusLarge;

  const TibebAvatarThemeTokens({
    required this.background,
    required this.foreground,
    required this.radiusSmall,
    required this.radiusMedium,
    required this.radiusLarge,
  });

  factory TibebAvatarThemeTokens.light(TibebColorSystem colors) {
    return TibebAvatarThemeTokens(
      background: colors.primary.withValues(alpha: 0.1),
      foreground: colors.primary,
      radiusSmall: 16.0,
      radiusMedium: 24.0,
      radiusLarge: 32.0,
    );
  }

  factory TibebAvatarThemeTokens.dark(TibebColorSystem colors) {
    return TibebAvatarThemeTokens(
      background: colors.primary.withValues(alpha: 0.1),
      foreground: colors.primary,
      radiusSmall: 16.0,
      radiusMedium: 24.0,
      radiusLarge: 32.0,
    );
  }
}
