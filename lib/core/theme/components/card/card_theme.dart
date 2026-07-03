import 'package:flutter/material.dart';
import '../../tokens/radius.dart';
import 'card_tokens.dart';

class TibebCardTheme {
  const TibebCardTheme._();

  static CardThemeData dark(TibebCardThemeTokens tokens, Color surfaceColor) {
    return CardThemeData(
      color: surfaceColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: TibebRadius.borderLg,
        side: tokens.border,
      ),
      margin: EdgeInsets.zero,
    );
  }

  static CardThemeData light(TibebCardThemeTokens tokens, Color surfaceColor) {
    return CardThemeData(
      color: surfaceColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: TibebRadius.borderLg,
        side: tokens.border,
      ),
      margin: EdgeInsets.zero,
    );
  }
}
