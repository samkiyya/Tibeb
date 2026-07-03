import 'package:flutter/material.dart';
import '../semantics/theme_extension.dart';
import '../tokens/radius.dart';

class TibebCardTheme {
  TibebCardTheme._();

  static CardThemeData dark(TibebThemeExtension ext) {
    return CardThemeData(
      color: ext.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: TibebRadius.borderLg,
        side: BorderSide(color: ext.border, width: 0.5),
      ),
      margin: EdgeInsets.zero,
    );
  }

  static CardThemeData light(TibebThemeExtension ext) {
    return CardThemeData(
      color: ext.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: TibebRadius.borderLg,
        side: BorderSide(color: ext.border, width: 0.5),
      ),
      margin: EdgeInsets.zero,
    );
  }
}