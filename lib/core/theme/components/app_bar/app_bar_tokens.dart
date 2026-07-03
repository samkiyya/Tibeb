import 'package:flutter/material.dart';
import '../../foundation/foundation.dart';

class TibebAppBarThemeTokens {
  final Color background;
  final Color foreground;
  final TextStyle title;
  final TextStyle subtitle;
  final IconThemeData leadingIcon;
  final IconThemeData actionIcon;
  final Color divider;
  final double elevation;
  final bool centerTitle;
  final double height;
  final double largeAppBarHeight;
  final double collapsedAppBarHeight;
  final Color readerAppBarBg;
  final Color transparentAppBarBg;

  const TibebAppBarThemeTokens({
    required this.background,
    required this.foreground,
    required this.title,
    required this.subtitle,
    required this.leadingIcon,
    required this.actionIcon,
    required this.divider,
    required this.elevation,
    required this.centerTitle,
    required this.height,
    required this.largeAppBarHeight,
    required this.collapsedAppBarHeight,
    required this.readerAppBarBg,
    required this.transparentAppBarBg,
  });

  factory TibebAppBarThemeTokens.light(TibebColorSystem colors) {
    return TibebAppBarThemeTokens(
      background: colors.surface,
      foreground: colors.textPrimary,
      title: TextStyle(
        color: colors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      subtitle: TextStyle(
        color: colors.textPrimary.withValues(alpha: 0.7),
        fontSize: 12,
      ),
      leadingIcon: IconThemeData(color: colors.textPrimary, size: 24),
      actionIcon: IconThemeData(color: colors.textPrimary, size: 24),
      divider: colors.outlineVariant,
      elevation: 0.0,
      centerTitle: true,
      height: 56.0,
      largeAppBarHeight: 120.0,
      collapsedAppBarHeight: 56.0,
      readerAppBarBg: colors.surface.withValues(alpha: 0.95),
      transparentAppBarBg: Colors.transparent,
    );
  }

  factory TibebAppBarThemeTokens.dark(TibebColorSystem colors) {
    return TibebAppBarThemeTokens(
      background: colors.surface,
      foreground: colors.textPrimary,
      title: TextStyle(
        color: colors.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      subtitle: TextStyle(
        color: colors.textPrimary.withValues(alpha: 0.7),
        fontSize: 12,
      ),
      leadingIcon: IconThemeData(color: colors.textPrimary, size: 24),
      actionIcon: IconThemeData(color: colors.textPrimary, size: 24),
      divider: colors.outlineVariant,
      elevation: 0.0,
      centerTitle: true,
      height: 56.0,
      largeAppBarHeight: 120.0,
      collapsedAppBarHeight: 56.0,
      readerAppBarBg: colors.surface.withValues(alpha: 0.95),
      transparentAppBarBg: Colors.transparent,
    );
  }
}
