import 'package:flutter/material.dart';

// Helper class for Button states
class TibebButtonStateStyles {
  final Color background;
  final Color foreground;
  final Color disabled;
  final Color pressed;
  final Color hovered;
  final Color focused;
  final BorderSide? border;
  final double elevation;
  final BorderRadius radius;
  final EdgeInsets padding;

  const TibebButtonStateStyles({
    required this.background,
    required this.foreground,
    required this.disabled,
    required this.pressed,
    required this.hovered,
    required this.focused,
    this.border,
    required this.elevation,
    required this.radius,
    required this.padding,
  });

  static TibebButtonStateStyles createDefault(Color bg, Color fg, Color dis, BorderRadius rad) {
    return TibebButtonStateStyles(
      background: bg,
      foreground: fg,
      disabled: dis,
      pressed: bg.withValues(alpha: 0.8),
      hovered: bg.withValues(alpha: 0.9),
      focused: bg,
      elevation: 0.0,
      radius: rad,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}

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

  static TibebNavigationBarThemeTokens create(Color bg, Color primary, Color textSec, Color borderCol) {
    return TibebNavigationBarThemeTokens(
      background: bg,
      selectedIcon: IconThemeData(color: primary, size: 24),
      unselectedIcon: IconThemeData(color: textSec, size: 24),
      selectedLabel: TextStyle(color: primary, fontSize: 12, fontWeight: FontWeight.w600),
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

// 16. TibebButtonsTheme
class TibebButtonsThemeTokens {
  final TibebButtonStateStyles filled;
  final TibebButtonStateStyles outlined;
  final TibebButtonStateStyles text;
  final TibebButtonStateStyles elevated;
  final TibebButtonStateStyles icon;
  final TibebButtonStateStyles fab;
  final TibebButtonStateStyles segmented;
  final TibebButtonStateStyles toggle;
  final TibebButtonStateStyles readerFloating;

  const TibebButtonsThemeTokens({
    required this.filled,
    required this.outlined,
    required this.text,
    required this.elevated,
    required this.icon,
    required this.fab,
    required this.segmented,
    required this.toggle,
    required this.readerFloating,
  });
}

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

// 23. TibebProgressIndicatorsTheme
class TibebProgressIndicatorsThemeTokens {
  final ProgressIndicatorThemeData linear;
  final ProgressIndicatorThemeData circular;
  final Color readingProgress;
  final Color downloadProgress;
  final Color audiobookProgress;
  final Color syncProgress;

  const TibebProgressIndicatorsThemeTokens({
    required this.linear,
    required this.circular,
    required this.readingProgress,
    required this.downloadProgress,
    required this.audiobookProgress,
    required this.syncProgress,
  });
}

// 24. TibebSliderTheme
class TibebSliderThemeTokens {
  final Color track;
  final Color thumb;
  final Color active;
  final Color inactive;
  final Color tick;
  final TextStyle label;

  const TibebSliderThemeTokens({
    required this.track,
    required this.thumb,
    required this.active,
    required this.inactive,
    required this.tick,
    required this.label,
  });
}

// 25. TibebSwitchTheme
class TibebSwitchThemeTokens {
  final Color thumb;
  final Color track;
  final Color outline;
  final Color disabled;

  const TibebSwitchThemeTokens({
    required this.thumb,
    required this.track,
    required this.outline,
    required this.disabled,
  });
}

// 26. TibebCheckboxTheme
class TibebCheckboxThemeTokens {
  final Color checked;
  final Color unchecked;
  final Color disabled;
  final Color error;

  const TibebCheckboxThemeTokens({
    required this.checked,
    required this.unchecked,
    required this.disabled,
    required this.error,
  });
}

// 27. TibebRadioButtonTheme
class TibebRadioButtonThemeTokens {
  final Color selected;
  final Color unselected;
  final Color disabled;

  const TibebRadioButtonThemeTokens({
    required this.selected,
    required this.unselected,
    required this.disabled,
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

// 33. TibebLoadingTheme
class TibebLoadingThemeTokens {
  final Color skeleton;
  final Color shimmer;
  final Color spinner;
  final Color placeholder;

  const TibebLoadingThemeTokens({
    required this.skeleton,
    required this.shimmer,
    required this.spinner,
    required this.placeholder,
  });
}

// 34. TibebEmptyStateTheme
class TibebEmptyStateThemeTokens {
  final IconThemeData icon;
  final TextStyle title;
  final TextStyle description;
  final ButtonStyle actionButton;

  const TibebEmptyStateThemeTokens({
    required this.icon,
    required this.title,
    required this.description,
    required this.actionButton,
  });
}

// 35. TibebErrorStateTheme
class TibebErrorStateThemeTokens {
  final Widget illustration;
  final TextStyle title;
  final TextStyle description;
  final ButtonStyle retryButton;

  const TibebErrorStateThemeTokens({
    required this.illustration,
    required this.title,
    required this.description,
    required this.retryButton,
  });
}
