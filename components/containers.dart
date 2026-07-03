import 'package:flutter/material.dart';

// 13. TibebDialogTheme
class TibebDialogThemeTokens {
  final Color background;
  final TextStyle title;
  final TextStyle content;
  final Color actionsDivider;
  final BorderRadius radius;
  final double elevation;

  const TibebDialogThemeTokens({
    required this.background,
    required this.title,
    required this.content,
    required this.actionsDivider,
    required this.radius,
    required this.elevation,
  });
}

// 14. TibebCardTheme
class TibebCardThemeTokens {
  final Color background;
  final BorderSide border;
  final double elevation;
  final BorderRadius radius;
  final List<BoxShadow> shadow;
  final EdgeInsets padding;

  const TibebCardThemeTokens({
    required this.background,
    required this.border,
    required this.elevation,
    required this.radius,
    required this.shadow,
    required this.padding,
  });
}

// 15. TibebListTileTheme
class TibebListTileThemeTokens {
  final TextStyle title;
  final TextStyle subtitle;
  final IconThemeData leading;
  final IconThemeData trailing;
  final Color selected;
  final Color pressed;
  final Color hover;
  final Color divider;

  const TibebListTileThemeTokens({
    required this.title,
    required this.subtitle,
    required this.leading,
    required this.trailing,
    required this.selected,
    required this.pressed,
    required this.hover,
    required this.divider,
  });
}

// 21. TibebSnackBarTheme
class TibebSnackBarThemeTokens {
  final Color background;
  final TextStyle text;
  final TextStyle action;
  final Color success;
  final Color warning;
  final Color error;
  final Color info;

  const TibebSnackBarThemeTokens({
    required this.background,
    required this.text,
    required this.action,
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
  });
}

// 22. TibebTooltipTheme
class TibebTooltipThemeTokens {
  final Color background;
  final TextStyle foreground;
  final BorderRadius radius;
  final EdgeInsets padding;

  const TibebTooltipThemeTokens({
    required this.background,
    required this.foreground,
    required this.radius,
    required this.padding,
  });
}

// 30. TibebDividerTheme
class TibebDividerThemeTokens {
  final Color color;
  final double thickness;
  final double indent;

  const TibebDividerThemeTokens({
    required this.color,
    required this.thickness,
    required this.indent,
  });
}

// 31. TibebBadgeTheme
class TibebBadgeThemeTokens {
  final Color background;
  final TextStyle text;
  final BorderSide border;

  const TibebBadgeThemeTokens({
    required this.background,
    required this.text,
    required this.border,
  });
}

// 32. TibebAvatarTheme
class TibebAvatarThemeTokens {
  final Color background;
  final TextStyle foreground;
  final BorderSide border;
  final Color statusIndicator;

  const TibebAvatarThemeTokens({
    required this.background,
    required this.foreground,
    required this.border,
    required this.statusIndicator,
  });
}

// 29. TibebScrollbarTheme
class TibebScrollbarThemeTokens {
  final Color thumb;
  final Color track;
  final Color hover;
  final BorderRadius radius;

  const TibebScrollbarThemeTokens({
    required this.thumb,
    required this.track,
    required this.hover,
    required this.radius,
  });
}
