import 'package:flutter/material.dart';
import '../../semantics/design_tokens.dart';

class TibebDividerThemeTokens {
  final Color color;
  final double thickness;
  final double indent;

  const TibebDividerThemeTokens({
    required this.color,
    required this.thickness,
    required this.indent,
  });

  factory TibebDividerThemeTokens.light(TibebColorSystem colors) {
    return TibebDividerThemeTokens(
      color: colors.outlineVariant,
      thickness: 1.0,
      indent: 16.0,
    );
  }

  factory TibebDividerThemeTokens.dark(TibebColorSystem colors) {
    return TibebDividerThemeTokens(
      color: colors.outlineVariant,
      thickness: 1.0,
      indent: 16.0,
    );
  }
}
