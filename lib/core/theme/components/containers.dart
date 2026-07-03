import 'package:flutter/material.dart';
import '../semantics/design_tokens.dart';
import '../tokens/radius.dart';

// ==========================================
// Dialog Theme & Tokens
// ==========================================
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

  factory TibebDialogThemeTokens.light(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
  ) {
    return TibebDialogThemeTokens(
      background: colors.surface,
      title: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      content: const TextStyle(fontSize: 15),
      actionsDivider: colors.outlineVariant,
      radius: radius.xl,
      elevation: 24.0,
    );
  }

  factory TibebDialogThemeTokens.dark(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
  ) {
    return TibebDialogThemeTokens(
      background: colors.surface,
      title: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      content: const TextStyle(fontSize: 15),
      actionsDivider: colors.outlineVariant,
      radius: radius.xl,
      elevation: 24.0,
    );
  }
}

class TibebDialogTheme {
  const TibebDialogTheme._();

  static DialogThemeData dark(TibebDialogThemeTokens tokens) {
    return _build(tokens);
  }

  static DialogThemeData light(TibebDialogThemeTokens tokens) {
    return _build(tokens);
  }

  static DialogThemeData _build(TibebDialogThemeTokens tokens) {
    return DialogThemeData(
      backgroundColor: tokens.background,
      titleTextStyle: tokens.title,
      contentTextStyle: tokens.content,
      shape: RoundedRectangleBorder(borderRadius: tokens.radius),
      elevation: tokens.elevation,
    );
  }
}

// ==========================================
// Card Theme & Tokens
// ==========================================
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

  factory TibebCardThemeTokens.light(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
    TibebElevationTokens elevation,
  ) {
    return TibebCardThemeTokens(
      background: colors.surfaceBright,
      border: BorderSide(color: colors.outlineVariant),
      elevation: 2.0,
      radius: radius.md,
      shadow: elevation.level1,
      padding: const EdgeInsets.all(16),
    );
  }

  factory TibebCardThemeTokens.dark(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
    TibebElevationTokens elevation,
  ) {
    return TibebCardThemeTokens(
      background: colors.surfaceBright,
      border: BorderSide(color: colors.outlineVariant),
      elevation: 2.0,
      radius: radius.md,
      shadow: elevation.level1,
      padding: const EdgeInsets.all(16),
    );
  }
}

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

// ==========================================
// ListTile Theme & Tokens
// ==========================================
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

  factory TibebListTileThemeTokens.light(TibebColorSystem colors) {
    return TibebListTileThemeTokens(
      title: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      subtitle: const TextStyle(fontSize: 13),
      leading: IconThemeData(color: colors.textSecondary),
      trailing: IconThemeData(color: colors.textSecondary),
      selected: colors.primary,
      pressed: colors.primary.withValues(alpha: 0.1),
      hover: colors.primary.withValues(alpha: 0.05),
      divider: colors.outlineVariant,
    );
  }

  factory TibebListTileThemeTokens.dark(TibebColorSystem colors) {
    return TibebListTileThemeTokens(
      title: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      subtitle: const TextStyle(fontSize: 13),
      leading: IconThemeData(color: colors.textSecondary),
      trailing: IconThemeData(color: colors.textSecondary),
      selected: colors.primary,
      pressed: colors.primary.withValues(alpha: 0.1),
      hover: colors.primary.withValues(alpha: 0.05),
      divider: colors.outlineVariant,
    );
  }
}

class TibebListTileTheme {
  const TibebListTileTheme._();

  static ListTileThemeData dark(TibebListTileThemeTokens tokens) {
    return _build(tokens);
  }

  static ListTileThemeData light(TibebListTileThemeTokens tokens) {
    return _build(tokens);
  }

  static ListTileThemeData _build(TibebListTileThemeTokens tokens) {
    return ListTileThemeData(
      titleTextStyle: tokens.title,
      subtitleTextStyle: tokens.subtitle,
      iconColor: tokens.leading.color,
      selectedColor: tokens.selected,
    );
  }
}

// ==========================================
// SnackBar Theme & Tokens
// ==========================================
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

  factory TibebSnackBarThemeTokens.light(TibebColorSystem colors) {
    return TibebSnackBarThemeTokens(
      background: colors.inverseSurface,
      text: TextStyle(color: colors.surface),
      action: TextStyle(color: colors.primary),
      success: colors.success,
      warning: colors.warning,
      error: colors.error,
      info: colors.info,
    );
  }

  factory TibebSnackBarThemeTokens.dark(TibebColorSystem colors) {
    return TibebSnackBarThemeTokens(
      background: colors.inverseSurface,
      text: TextStyle(color: colors.surface),
      action: TextStyle(color: colors.primary),
      success: colors.success,
      warning: colors.warning,
      error: colors.error,
      info: colors.info,
    );
  }
}

class TibebSnackBarTheme {
  const TibebSnackBarTheme._();

  static SnackBarThemeData dark(
    TibebSnackBarThemeTokens tokens,
    BorderRadius radius,
  ) {
    return _build(tokens, radius);
  }

  static SnackBarThemeData light(
    TibebSnackBarThemeTokens tokens,
    BorderRadius radius,
  ) {
    return _build(tokens, radius);
  }

  static SnackBarThemeData _build(
    TibebSnackBarThemeTokens tokens,
    BorderRadius radius,
  ) {
    return SnackBarThemeData(
      backgroundColor: tokens.background,
      contentTextStyle: tokens.text,
      actionTextColor: tokens.action.color,
      shape: RoundedRectangleBorder(borderRadius: radius),
      behavior: SnackBarBehavior.floating,
    );
  }
}

// ==========================================
// Tooltip Theme & Tokens
// ==========================================
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

  factory TibebTooltipThemeTokens.light(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
  ) {
    return TibebTooltipThemeTokens(
      background: colors.inverseSurface,
      foreground: TextStyle(color: colors.surface),
      radius: radius.xs,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  factory TibebTooltipThemeTokens.dark(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
  ) {
    return TibebTooltipThemeTokens(
      background: colors.inverseSurface,
      foreground: TextStyle(color: colors.surface),
      radius: radius.xs,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}

class TibebTooltipTheme {
  const TibebTooltipTheme._();

  static TooltipThemeData dark(TibebTooltipThemeTokens tokens) {
    return _build(tokens);
  }

  static TooltipThemeData light(TibebTooltipThemeTokens tokens) {
    return _build(tokens);
  }

  static TooltipThemeData _build(TibebTooltipThemeTokens tokens) {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: tokens.background,
        borderRadius: tokens.radius,
      ),
      textStyle: tokens.foreground,
      padding: tokens.padding,
    );
  }
}

// ==========================================
// Divider Theme & Tokens
// ==========================================
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

class TibebDividerTheme {
  const TibebDividerTheme._();

  static DividerThemeData dark(TibebDividerThemeTokens tokens) {
    return _build(tokens);
  }

  static DividerThemeData light(TibebDividerThemeTokens tokens) {
    return _build(tokens);
  }

  static DividerThemeData _build(TibebDividerThemeTokens tokens) {
    return DividerThemeData(
      color: tokens.color,
      thickness: tokens.thickness,
      indent: tokens.indent,
    );
  }
}

// ==========================================
// Badge Theme & Tokens
// ==========================================
class TibebBadgeThemeTokens {
  final Color background;
  final TextStyle text;
  final BorderSide border;

  const TibebBadgeThemeTokens({
    required this.background,
    required this.text,
    required this.border,
  });

  factory TibebBadgeThemeTokens.light(TibebColorSystem colors) {
    return TibebBadgeThemeTokens(
      background: colors.error,
      text: const TextStyle(color: Colors.white, fontSize: 10),
      border: BorderSide(color: colors.surface),
    );
  }

  factory TibebBadgeThemeTokens.dark(TibebColorSystem colors) {
    return TibebBadgeThemeTokens(
      background: colors.error,
      text: const TextStyle(color: Colors.white, fontSize: 10),
      border: BorderSide(color: colors.surface),
    );
  }
}

class TibebBadgeTheme {
  const TibebBadgeTheme._();

  static BadgeThemeData dark(TibebBadgeThemeTokens tokens) {
    return _build(tokens);
  }

  static BadgeThemeData light(TibebBadgeThemeTokens tokens) {
    return _build(tokens);
  }

  static BadgeThemeData _build(TibebBadgeThemeTokens tokens) {
    return BadgeThemeData(
      backgroundColor: tokens.background,
      textStyle: tokens.text,
    );
  }
}

// ==========================================
// Avatar Tokens
// ==========================================
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

  factory TibebAvatarThemeTokens.light(TibebColorSystem colors) {
    return TibebAvatarThemeTokens(
      background: colors.primary.withValues(alpha: 0.1),
      foreground: TextStyle(color: colors.primary, fontWeight: FontWeight.bold),
      border: BorderSide(color: colors.outlineVariant),
      statusIndicator: colors.success,
    );
  }

  factory TibebAvatarThemeTokens.dark(TibebColorSystem colors) {
    return TibebAvatarThemeTokens(
      background: colors.primary.withValues(alpha: 0.1),
      foreground: TextStyle(color: colors.primary, fontWeight: FontWeight.bold),
      border: BorderSide(color: colors.outlineVariant),
      statusIndicator: colors.success,
    );
  }
}

// ==========================================
// Scrollbar Tokens
// ==========================================
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

  factory TibebScrollbarThemeTokens.light(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
  ) {
    return TibebScrollbarThemeTokens(
      thumb: colors.outline,
      track: colors.outlineVariant,
      hover: colors.primary,
      radius: radius.pill,
    );
  }

  factory TibebScrollbarThemeTokens.dark(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
  ) {
    return TibebScrollbarThemeTokens(
      thumb: colors.outline,
      track: colors.outlineVariant,
      hover: colors.primary,
      radius: radius.pill,
    );
  }
}
