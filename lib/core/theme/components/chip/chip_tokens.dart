import 'package:flutter/material.dart';
import '../../foundation/foundation.dart';

class TibebChipThemeTokens {
  final ChipThemeData assist;
  final ChipThemeData filter;
  final ChipThemeData choice;
  final ChipThemeData input;
  final ChipThemeData tag;
  final Color selected;
  final Color disabled;

  const TibebChipThemeTokens({
    required this.assist,
    required this.filter,
    required this.choice,
    required this.input,
    required this.tag,
    required this.selected,
    required this.disabled,
  });

  factory TibebChipThemeTokens.light(TibebColorSystem colors) {
    return TibebChipThemeTokens(
      assist: ChipThemeData(
        backgroundColor: colors.surface,
        labelStyle: TextStyle(color: colors.textSecondary),
      ),
      filter: ChipThemeData(
        backgroundColor: colors.surface,
        labelStyle: TextStyle(color: colors.textSecondary),
      ),
      choice: ChipThemeData(
        backgroundColor: colors.surface,
        labelStyle: TextStyle(color: colors.textSecondary),
      ),
      input: ChipThemeData(
        backgroundColor: colors.surface,
        labelStyle: TextStyle(color: colors.textSecondary),
      ),
      tag: ChipThemeData(
        backgroundColor: colors.surface,
        labelStyle: TextStyle(color: colors.textSecondary),
      ),
      selected: colors.primary,
      disabled: colors.disabled,
    );
  }

  factory TibebChipThemeTokens.dark(TibebColorSystem colors) {
    return TibebChipThemeTokens(
      assist: ChipThemeData(
        backgroundColor: colors.surface,
        labelStyle: TextStyle(color: colors.textSecondary),
      ),
      filter: ChipThemeData(
        backgroundColor: colors.surface,
        labelStyle: TextStyle(color: colors.textSecondary),
      ),
      choice: ChipThemeData(
        backgroundColor: colors.surface,
        labelStyle: TextStyle(color: colors.textSecondary),
      ),
      input: ChipThemeData(
        backgroundColor: colors.surface,
        labelStyle: TextStyle(color: colors.textSecondary),
      ),
      tag: ChipThemeData(
        backgroundColor: colors.surface,
        labelStyle: TextStyle(color: colors.textSecondary),
      ),
      selected: colors.primary,
      disabled: colors.disabled,
    );
  }
}
