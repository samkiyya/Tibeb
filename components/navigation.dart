import 'package:flutter/material.dart';

// 8. TibebAppBarTheme
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

  static TibebAppBarThemeTokens create(Color bg, Color fg, Color borderCol) {
    return TibebAppBarThemeTokens(
      background: bg,
      foreground: fg,
      title: TextStyle(color: fg, fontSize: 18, fontWeight: FontWeight.bold),
      subtitle: TextStyle(color: fg.withValues(alpha: 0.7), fontSize: 12),
      leadingIcon: IconThemeData(color: fg, size: 24),
      actionIcon: IconThemeData(color: fg, size: 24),
      divider: borderCol,
      elevation: 0.0,
      centerTitle: true,
      height: 56.0,
      largeAppBarHeight: 120.0,
      collapsedAppBarHeight: 56.0,
      readerAppBarBg: bg.withValues(alpha: 0.95),
      transparentAppBarBg: Colors.transparent,
    );
  }
}

// 9. TibebNavigationBarTheme
class TibebNavigationBarThemeTokens {
  final Color background;
  final IconThemeData selectedIcon;
  final IconThemeData unselectedIcon;
  final TextStyle selectedLabel;
  final TextStyle unselectedLabel;
  final Color indicator;
  final double elevation;
  final Color divider;
  final Color badgeBackground;

  const TibebNavigationBarThemeTokens({
    required this.background,
    required this.selectedIcon,
    required this.unselectedIcon,
    required this.selectedLabel,
    required this.unselectedLabel,
    required this.indicator,
    required this.elevation,
    required this.divider,
    required this.badgeBackground,
  });

  static TibebNavigationBarThemeTokens create(
    Color bg,
    Color primary,
    Color textSec,
    Color borderCol,
  ) {
    return TibebNavigationBarThemeTokens(
      background: bg,
      selectedIcon: IconThemeData(color: primary, size: 24),
      unselectedIcon: IconThemeData(color: textSec, size: 24),
      selectedLabel: TextStyle(
        color: primary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabel: TextStyle(color: textSec, fontSize: 12),
      indicator: primary.withValues(alpha: 0.1),
      elevation: 0.0,
      divider: borderCol,
      badgeBackground: Colors.redAccent,
    );
  }
}

// 10. TibebNavigationRailTheme
class TibebNavigationRailThemeTokens {
  final Color background;
  final Color selected;
  final Color unselected;
  final Color indicator;
  final Color divider;

  const TibebNavigationRailThemeTokens({
    required this.background,
    required this.selected,
    required this.unselected,
    required this.indicator,
    required this.divider,
  });
}

// 11. TibebNavigationDrawerTheme
class TibebNavigationDrawerThemeTokens {
  final Color background;
  final TextStyle header;
  final Color selectedItem;
  final Color hovered;
  final Color divider;
  final IconThemeData icons;
  final TextStyle text;

  const TibebNavigationDrawerThemeTokens({
    required this.background,
    required this.header,
    required this.selectedItem,
    required this.hovered,
    required this.divider,
    required this.icons,
    required this.text,
  });
}

// 12. TibebBottomSheetTheme
class TibebBottomSheetThemeTokens {
  final Color background;
  final Color dragHandle;
  final double elevation;
  final BorderRadius radius;
  final Color barrier;
  final EdgeInsets padding;

  const TibebBottomSheetThemeTokens({
    required this.background,
    required this.dragHandle,
    required this.elevation,
    required this.radius,
    required this.barrier,
    required this.padding,
  });
}

// 28. TibebTabsTheme
class TibebTabsThemeTokens {
  final Color indicator;
  final TextStyle selected;
  final TextStyle unselected;
  final Color divider;
  final Color background;

  const TibebTabsThemeTokens({
    required this.indicator,
    required this.selected,
    required this.unselected,
    required this.divider,
    required this.background,
  });
}
