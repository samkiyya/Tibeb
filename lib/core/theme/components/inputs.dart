import 'package:flutter/material.dart';
import '../semantics/design_tokens.dart';

// ==========================================
// TextField Theme
// ==========================================
class TibebTextFieldThemeTokens {
  final Color background;
  final BorderSide border;
  final BorderSide focusedBorder;
  final BorderSide errorBorder;
  final BorderSide disabledBorder;
  final Color cursor;
  final TextStyle hint;
  final TextStyle label;
  final TextStyle helper;
  final TextStyle counter;
  final Color selection;
  final BorderRadius radius;
  final EdgeInsets padding;

  const TibebTextFieldThemeTokens({
    required this.background,
    required this.border,
    required this.focusedBorder,
    required this.errorBorder,
    required this.disabledBorder,
    required this.cursor,
    required this.hint,
    required this.label,
    required this.helper,
    required this.counter,
    required this.selection,
    required this.radius,
    required this.padding,
  });

  factory TibebTextFieldThemeTokens.light(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
  ) {
    return TibebTextFieldThemeTokens(
      background: colors.surfaceContainerLow,
      border: BorderSide(color: colors.outline),
      focusedBorder: BorderSide(color: colors.primary, width: 2),
      errorBorder: BorderSide(color: colors.error, width: 2),
      disabledBorder: BorderSide(color: colors.disabled),
      cursor: colors.primary,
      hint: TextStyle(color: colors.textTertiary),
      label: TextStyle(color: colors.textSecondary),
      helper: TextStyle(color: colors.textTertiary),
      counter: TextStyle(color: colors.textTertiary),
      selection: colors.primary.withValues(alpha: 0.2),
      radius: radius.md,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  factory TibebTextFieldThemeTokens.dark(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
  ) {
    return TibebTextFieldThemeTokens(
      background: colors.surfaceContainerLow,
      border: BorderSide(color: colors.outline),
      focusedBorder: BorderSide(color: colors.primary, width: 2),
      errorBorder: BorderSide(color: colors.error, width: 2),
      disabledBorder: BorderSide(color: colors.disabled),
      cursor: colors.primary,
      hint: TextStyle(color: colors.textTertiary),
      label: TextStyle(color: colors.textSecondary),
      helper: TextStyle(color: colors.textTertiary),
      counter: TextStyle(color: colors.textTertiary),
      selection: colors.primary.withValues(alpha: 0.2),
      radius: radius.md,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}

class TibebInputDecorationTheme {
  const TibebInputDecorationTheme._();

  static InputDecorationTheme dark(TibebTextFieldThemeTokens tokens) {
    return _build(tokens);
  }

  static InputDecorationTheme light(TibebTextFieldThemeTokens tokens) {
    return _build(tokens);
  }

  static InputDecorationTheme _build(TibebTextFieldThemeTokens tokens) {
    return InputDecorationTheme(
      filled: true,
      fillColor: tokens.background,
      contentPadding: tokens.padding,
      border: OutlineInputBorder(
        borderRadius: tokens.radius,
        borderSide: tokens.border,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: tokens.radius,
        borderSide: tokens.border,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: tokens.radius,
        borderSide: tokens.focusedBorder,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: tokens.radius,
        borderSide: tokens.errorBorder,
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: tokens.radius,
        borderSide: tokens.disabledBorder,
      ),
      labelStyle: tokens.label,
      hintStyle: tokens.hint,
      helperStyle: tokens.helper,
      counterStyle: tokens.counter,
    );
  }
}

// ==========================================
// SearchBar Theme
// ==========================================
class TibebSearchBarThemeTokens {
  final Color background;
  final BorderSide border;
  final TextStyle hint;
  final IconThemeData leadingIcon;
  final IconThemeData trailingIcon;
  final Color suggestionBackground;
  final TextStyle suggestionText;

  const TibebSearchBarThemeTokens({
    required this.background,
    required this.border,
    required this.hint,
    required this.leadingIcon,
    required this.trailingIcon,
    required this.suggestionBackground,
    required this.suggestionText,
  });

  factory TibebSearchBarThemeTokens.light(TibebColorSystem colors) {
    return TibebSearchBarThemeTokens(
      background: colors.surfaceContainerLow,
      border: BorderSide(color: colors.outlineVariant),
      hint: TextStyle(color: colors.textTertiary),
      leadingIcon: IconThemeData(color: colors.textSecondary),
      trailingIcon: IconThemeData(color: colors.textSecondary),
      suggestionBackground: colors.surface,
      suggestionText: TextStyle(color: colors.textPrimary),
    );
  }

  factory TibebSearchBarThemeTokens.dark(TibebColorSystem colors) {
    return TibebSearchBarThemeTokens(
      background: colors.surfaceContainerLow,
      border: BorderSide(color: colors.outlineVariant),
      hint: TextStyle(color: colors.textTertiary),
      leadingIcon: IconThemeData(color: colors.textSecondary),
      trailingIcon: IconThemeData(color: colors.textSecondary),
      suggestionBackground: colors.surface,
      suggestionText: TextStyle(color: colors.textPrimary),
    );
  }
}

// ==========================================
// Chip Theme
// ==========================================
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

class TibebChipTheme {
  const TibebChipTheme._();

  static ChipThemeData dark(TibebChipThemeTokens tokens) {
    return _build(tokens);
  }

  static ChipThemeData light(TibebChipThemeTokens tokens) {
    return _build(tokens);
  }

  static ChipThemeData _build(TibebChipThemeTokens tokens) {
    return ChipThemeData(
      backgroundColor: tokens.assist.backgroundColor,
      selectedColor: tokens.selected,
      disabledColor: tokens.disabled,
      labelStyle: tokens.assist.labelStyle,
      shape: tokens.assist.shape,
    );
  }
}

// ==========================================
// Menu Theme
// ==========================================
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
