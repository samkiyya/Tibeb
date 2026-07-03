import 'package:flutter/material.dart';
import '../../foundation/foundation.dart';

class TibebSwitchThemeTokens {
  final Color thumb;
  final Color track;
  final Color outline;
  final Color disabled;

  const TibebSwitchThemeTokens({
    required this.thumb,
    required this.track,
    required this.outline,
    required this.disabled,
  });

  factory TibebSwitchThemeTokens.light(TibebColorSystem colors) {
    return TibebSwitchThemeTokens(
      thumb: colors.surface,
      track: colors.outline,
      outline: colors.outlineVariant,
      disabled: colors.disabled,
    );
  }

  factory TibebSwitchThemeTokens.dark(TibebColorSystem colors) {
    return TibebSwitchThemeTokens(
      thumb: colors.surface,
      track: colors.outline,
      outline: colors.outlineVariant,
      disabled: colors.disabled,
    );
  }
}
