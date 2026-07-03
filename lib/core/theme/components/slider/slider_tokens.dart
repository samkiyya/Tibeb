import 'package:flutter/material.dart';
import '../../foundation/foundation.dart';

class TibebSliderThemeTokens {
  final Color track;
  final Color thumb;
  final Color active;
  final Color inactive;
  final Color tick;
  final TextStyle label;

  const TibebSliderThemeTokens({
    required this.track,
    required this.thumb,
    required this.active,
    required this.inactive,
    required this.tick,
    required this.label,
  });

  factory TibebSliderThemeTokens.light(TibebColorSystem colors) {
    return TibebSliderThemeTokens(
      track: colors.outlineVariant,
      thumb: colors.primary,
      active: colors.primary,
      inactive: colors.outlineVariant,
      tick: colors.outline,
      label: const TextStyle(fontSize: 12),
    );
  }

  factory TibebSliderThemeTokens.dark(TibebColorSystem colors) {
    return TibebSliderThemeTokens(
      track: colors.outlineVariant,
      thumb: colors.primary,
      active: colors.primary,
      inactive: colors.outlineVariant,
      tick: colors.outline,
      label: const TextStyle(fontSize: 12),
    );
  }
}
