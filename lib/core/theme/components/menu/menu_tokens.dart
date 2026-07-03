import 'package:flutter/material.dart';
import '../../foundation/foundation.dart';

class TibebMenuThemeTokens {
  final Color popupMenu;
  final Color dropdown;
  final Color contextMenu;
  final Color readerMenu;

  const TibebMenuThemeTokens({
    required this.popupMenu,
    required this.dropdown,
    required this.contextMenu,
    required this.readerMenu,
  });

  factory TibebMenuThemeTokens.light(TibebColorSystem colors) {
    return TibebMenuThemeTokens(
      popupMenu: colors.surface,
      dropdown: colors.surface,
      contextMenu: colors.surface,
      readerMenu: colors.surface,
    );
  }

  factory TibebMenuThemeTokens.dark(TibebColorSystem colors) {
    return TibebMenuThemeTokens(
      popupMenu: colors.surface,
      dropdown: colors.surface,
      contextMenu: colors.surface,
      readerMenu: colors.surface,
    );
  }
}
