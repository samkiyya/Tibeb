import 'package:flutter/material.dart';

// 17. TibebTextFieldTheme
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
}

// 18. TibebSearchBarTheme
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
}

// 19. TibebChipTheme
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
}

// 20. TibebMenuTheme
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
}
