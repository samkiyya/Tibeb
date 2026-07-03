import 'package:flutter/material.dart';
import '../semantics/design_tokens.dart';

// ==========================================
// AppBar Theme
// ==========================================
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

class TibebAppBarTheme {
  const TibebAppBarTheme._();

  static AppBarTheme dark(TibebAppBarThemeTokens tokens) {
    return AppBarTheme(
      backgroundColor: tokens.background,
      foregroundColor: tokens.foreground,
      elevation: tokens.elevation,
      scrolledUnderElevation: 0,
      centerTitle: tokens.centerTitle,
      iconTheme: tokens.leadingIcon,
      titleTextStyle: tokens.title,
    );
  }

  static AppBarTheme light(TibebAppBarThemeTokens tokens) {
    return AppBarTheme(
      backgroundColor: tokens.background,
      foregroundColor: tokens.foreground,
      elevation: tokens.elevation,
      scrolledUnderElevation: 0.5,
      centerTitle: tokens.centerTitle,
      iconTheme: tokens.leadingIcon,
      titleTextStyle: tokens.title,
    );
  }
}

// ==========================================
// NavigationBar Theme
// ==========================================
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

  factory TibebNavigationBarThemeTokens.light(TibebColorSystem colors) {
    return TibebNavigationBarThemeTokens(
      background: colors.surface,
      selectedIcon: IconThemeData(color: colors.primary, size: 24),
      unselectedIcon: IconThemeData(color: colors.textSecondary, size: 24),
      selectedLabel: TextStyle(
        color: colors.primary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabel: TextStyle(color: colors.textSecondary, fontSize: 12),
      indicator: colors.primary.withValues(alpha: 0.1),
      elevation: 0.0,
      divider: colors.outlineVariant,
      badgeBackground: Colors.redAccent,
    );
  }

  factory TibebNavigationBarThemeTokens.dark(TibebColorSystem colors) {
    return TibebNavigationBarThemeTokens(
      background: colors.surface,
      selectedIcon: IconThemeData(color: colors.primary, size: 24),
      unselectedIcon: IconThemeData(color: colors.textSecondary, size: 24),
      selectedLabel: TextStyle(
        color: colors.primary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabel: TextStyle(color: colors.textSecondary, fontSize: 12),
      indicator: colors.primary.withValues(alpha: 0.1),
      elevation: 0.0,
      divider: colors.outlineVariant,
      badgeBackground: Colors.redAccent,
    );
  }
}

class TibebNavigationBarTheme {
  const TibebNavigationBarTheme._();

  static BottomNavigationBarThemeData bottomNavDark(
    TibebNavigationBarThemeTokens tokens,
  ) {
    return BottomNavigationBarThemeData(
      backgroundColor: tokens.background,
      selectedItemColor: tokens.selectedIcon.color,
      unselectedItemColor: tokens.unselectedIcon.color,
      type: BottomNavigationBarType.fixed,
      elevation: tokens.elevation,
      selectedLabelStyle: tokens.selectedLabel,
      unselectedLabelStyle: tokens.unselectedLabel,
    );
  }

  static BottomNavigationBarThemeData bottomNavLight(
    TibebNavigationBarThemeTokens tokens,
  ) {
    return BottomNavigationBarThemeData(
      backgroundColor: tokens.background,
      selectedItemColor: tokens.selectedIcon.color,
      unselectedItemColor: tokens.unselectedIcon.color,
      type: BottomNavigationBarType.fixed,
      elevation: 2.0,
      selectedLabelStyle: tokens.selectedLabel,
      unselectedLabelStyle: tokens.unselectedLabel,
    );
  }

  static NavigationBarThemeData navBarDark(
    TibebNavigationBarThemeTokens tokens,
  ) {
    return NavigationBarThemeData(
      backgroundColor: tokens.background,
      indicatorColor: tokens.indicator,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return tokens.selectedIcon;
        }
        return tokens.unselectedIcon;
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return tokens.selectedLabel;
        }
        return tokens.unselectedLabel;
      }),
    );
  }

  static NavigationBarThemeData navBarLight(
    TibebNavigationBarThemeTokens tokens,
  ) {
    return NavigationBarThemeData(
      backgroundColor: tokens.background,
      indicatorColor: tokens.indicator,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return tokens.selectedIcon;
        }
        return tokens.unselectedIcon;
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return tokens.selectedLabel;
        }
        return tokens.unselectedLabel;
      }),
    );
  }
}

// ==========================================
// NavigationRail Theme
// ==========================================
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

  factory TibebNavigationRailThemeTokens.light(TibebColorSystem colors) {
    return TibebNavigationRailThemeTokens(
      background: colors.surface,
      selected: colors.primary,
      unselected: colors.textSecondary,
      indicator: colors.primary.withValues(alpha: 0.1),
      divider: colors.outlineVariant,
    );
  }

  factory TibebNavigationRailThemeTokens.dark(TibebColorSystem colors) {
    return TibebNavigationRailThemeTokens(
      background: colors.surface,
      selected: colors.primary,
      unselected: colors.textSecondary,
      indicator: colors.primary.withValues(alpha: 0.1),
      divider: colors.outlineVariant,
    );
  }
}

class TibebNavigationRailTheme {
  const TibebNavigationRailTheme._();

  static NavigationRailThemeData dark(TibebNavigationRailThemeTokens tokens) {
    return NavigationRailThemeData(
      backgroundColor: tokens.background,
      selectedIconTheme: IconThemeData(color: tokens.selected),
      unselectedIconTheme: IconThemeData(color: tokens.unselected),
      indicatorColor: tokens.indicator,
    );
  }

  static NavigationRailThemeData light(TibebNavigationRailThemeTokens tokens) {
    return NavigationRailThemeData(
      backgroundColor: tokens.background,
      selectedIconTheme: IconThemeData(color: tokens.selected),
      unselectedIconTheme: IconThemeData(color: tokens.unselected),
      indicatorColor: tokens.indicator,
    );
  }
}

// ==========================================
// Drawer & NavigationDrawer Theme
// ==========================================
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

  factory TibebNavigationDrawerThemeTokens.light(TibebColorSystem colors) {
    return TibebNavigationDrawerThemeTokens(
      background: colors.surface,
      header: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      selectedItem: colors.primary.withValues(alpha: 0.1),
      hovered: colors.primary.withValues(alpha: 0.05),
      divider: colors.outlineVariant,
      icons: IconThemeData(color: colors.textSecondary),
      text: const TextStyle(fontSize: 14),
    );
  }

  factory TibebNavigationDrawerThemeTokens.dark(TibebColorSystem colors) {
    return TibebNavigationDrawerThemeTokens(
      background: colors.surface,
      header: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      selectedItem: colors.primary.withValues(alpha: 0.1),
      hovered: colors.primary.withValues(alpha: 0.05),
      divider: colors.outlineVariant,
      icons: IconThemeData(color: colors.textSecondary),
      text: const TextStyle(fontSize: 14),
    );
  }
}

class TibebDrawerTheme {
  const TibebDrawerTheme._();

  static DrawerThemeData drawerDark(TibebNavigationDrawerThemeTokens tokens) {
    return DrawerThemeData(backgroundColor: tokens.background, elevation: 0.0);
  }

  static DrawerThemeData drawerLight(TibebNavigationDrawerThemeTokens tokens) {
    return DrawerThemeData(backgroundColor: tokens.background, elevation: 0.0);
  }

  static NavigationDrawerThemeData navDrawerDark(
    TibebNavigationDrawerThemeTokens tokens,
  ) {
    return NavigationDrawerThemeData(
      backgroundColor: tokens.background,
      indicatorColor: tokens.selectedItem,
    );
  }

  static NavigationDrawerThemeData navDrawerLight(
    TibebNavigationDrawerThemeTokens tokens,
  ) {
    return NavigationDrawerThemeData(
      backgroundColor: tokens.background,
      indicatorColor: tokens.selectedItem,
    );
  }
}

// ==========================================
// BottomSheet Theme
// ==========================================
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

  factory TibebBottomSheetThemeTokens.light(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
  ) {
    return TibebBottomSheetThemeTokens(
      background: colors.surface,
      dragHandle: colors.outline,
      elevation: 16.0,
      radius: radius.xl,
      barrier: Colors.black54,
      padding: const EdgeInsets.all(24),
    );
  }

  factory TibebBottomSheetThemeTokens.dark(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
  ) {
    return TibebBottomSheetThemeTokens(
      background: colors.surface,
      dragHandle: colors.outline,
      elevation: 16.0,
      radius: radius.xl,
      barrier: Colors.black54,
      padding: const EdgeInsets.all(24),
    );
  }
}

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

// ==========================================
// Tabs Theme
// ==========================================
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

  factory TibebTabsThemeTokens.light(TibebColorSystem colors) {
    return TibebTabsThemeTokens(
      indicator: colors.primary,
      selected: TextStyle(color: colors.primary, fontWeight: FontWeight.bold),
      unselected: TextStyle(color: colors.textSecondary),
      divider: colors.outlineVariant,
      background: colors.surface,
    );
  }

  factory TibebTabsThemeTokens.dark(TibebColorSystem colors) {
    return TibebTabsThemeTokens(
      indicator: colors.primary,
      selected: TextStyle(color: colors.primary, fontWeight: FontWeight.bold),
      unselected: TextStyle(color: colors.textSecondary),
      divider: colors.outlineVariant,
      background: colors.surface,
    );
  }
}

class TibebTabBarTheme {
  const TibebTabBarTheme._();

  static TabBarThemeData dark(TibebTabsThemeTokens tokens) {
    return TabBarThemeData(
      indicatorColor: tokens.indicator,
      labelStyle: tokens.selected,
      unselectedLabelStyle: tokens.unselected,
      dividerColor: tokens.divider,
    );
  }

  static TabBarThemeData light(TibebTabsThemeTokens tokens) {
    return TabBarThemeData(
      indicatorColor: tokens.indicator,
      labelStyle: tokens.selected,
      unselectedLabelStyle: tokens.unselected,
      dividerColor: tokens.divider,
    );
  }
}
