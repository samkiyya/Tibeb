import 'package:flutter/material.dart';
import '../../core/theme/foundation/foundation.dart';

class TibebLoadingThemeTokens {
  final Color skeleton;
  final Color shimmer;
  final Color spinner;
  final Color placeholder;

  const TibebLoadingThemeTokens({
    required this.skeleton,
    required this.shimmer,
    required this.spinner,
    required this.placeholder,
  });

  factory TibebLoadingThemeTokens.light(TibebColorSystem colors) {
    return TibebLoadingThemeTokens(
      skeleton: colors.outlineVariant,
      shimmer: colors.surfaceContainer,
      spinner: colors.primary,
      placeholder: colors.outline,
    );
  }

  factory TibebLoadingThemeTokens.dark(TibebColorSystem colors) {
    return TibebLoadingThemeTokens(
      skeleton: colors.outlineVariant,
      shimmer: colors.surfaceContainer,
      spinner: colors.primary,
      placeholder: colors.outline,
    );
  }
}
