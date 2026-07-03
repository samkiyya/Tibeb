import 'package:flutter/material.dart';
import 'bottom_sheet_tokens.dart';

class TibebBottomSheetTheme {
  const TibebBottomSheetTheme._();

  static BottomSheetThemeData dark(TibebBottomSheetThemeTokens tokens) {
    return BottomSheetThemeData(
      backgroundColor: tokens.background,
      dragHandleColor: tokens.dragHandle,
      elevation: tokens.elevation,
      shape: RoundedRectangleBorder(borderRadius: tokens.radius),
    );
  }

  static BottomSheetThemeData light(TibebBottomSheetThemeTokens tokens) {
    return BottomSheetThemeData(
      backgroundColor: tokens.background,
      dragHandleColor: tokens.dragHandle,
      elevation: tokens.elevation,
      shape: RoundedRectangleBorder(borderRadius: tokens.radius),
    );
  }
}
