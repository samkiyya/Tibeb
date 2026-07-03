import 'package:flutter/material.dart';
import '../components/components.dart';
import '../internal/builders/theme_extension_builder.dart';
import 'design_tokens.dart';

export 'package:tibeb/widgets/empty_state/empty_state.dart';
export 'package:tibeb/widgets/error_state/error_state.dart';
export 'package:tibeb/widgets/loading/loading.dart';
export '../components/components.dart';
export 'design_tokens.dart';
export 'feature_themes.dart';

/// Tibeb Design System — Core Theme Extension
///
/// Holds references to all 50+ specific design system configuration categories.
class TibebThemeExtension extends ThemeExtension<TibebThemeExtension> {
  // ── 1. Color System ──
  final TibebColorSystem colorSystem;

  // ── 2. Typography ──
  final TibebTypographyTokens typography;

  // ── 3. Spacing ──
  final TibebSpacingTokens spacing;

  // ── 4. Radius ──
  final TibebRadiusTokens radiusCat;

  // ── 5. Elevation ──
  final TibebElevationTokens elevationCat;

  // ── 6. Border ──
  final TibebBorderTokens borderCat;

  // ── 7. Icon Theme ──
  final TibebIconThemeTokens iconThemeCat;

  // ── Modifers added: Motion and Opacity ──
  final TibebMotionTokens motion;
  final TibebOpacityTokens opacity;

  // ── 8. App Bar ──
  final TibebAppBarThemeTokens appBar;

  // ── 9. Navigation Bar ──
  final TibebNavigationBarThemeTokens navigationBar;

  // ── 10. Navigation Rail ──
  final TibebNavigationRailThemeTokens navigationRail;

  // ── 11. Navigation Drawer ──
  final TibebNavigationDrawerThemeTokens navigationDrawer;

  // ── 12. Bottom Sheet ──
  final TibebBottomSheetThemeTokens bottomSheet;

  // ── 13. Dialog ──
  final TibebDialogThemeTokens dialog;

  // ── 14. Card ──
  final TibebCardThemeTokens card;

  // ── 15. List Tile ──
  final TibebListTileThemeTokens listTile;

  // ── 16. Buttons ──
  final TibebButtonsThemeTokens buttons;

  // ── 17. Text Field ──
  final TibebTextFieldThemeTokens textField;

  // ── 18. Search Bar ──
  final TibebSearchBarThemeTokens searchBar;

  // ── 19. Chip ──
  final TibebChipThemeTokens chip;

  // ── 20. Menu ──
  final TibebMenuThemeTokens menu;

  // ── 21. Snack Bar ──
  final TibebSnackBarThemeTokens snackBar;

  // ── 22. Tooltip ──
  final TibebTooltipThemeTokens tooltip;

  // ── 23. Progress Indicators ──
  final TibebProgressIndicatorsThemeTokens progress;

  // ── 24. Slider ──
  final TibebSliderThemeTokens slider;

  // ── 25. Switch ──
  final TibebSwitchThemeTokens switchTheme;

  // ── 26. Checkbox ──
  final TibebCheckboxThemeTokens checkbox;

  // ── 27. Radio Button ──
  final TibebRadioButtonThemeTokens radioButton;

  // ── 28. Tabs ──
  final TibebTabsThemeTokens tabs;

  // ── 29. Scrollbar ──
  final TibebScrollbarThemeTokens scrollbar;

  // ── 30. Divider ──
  final TibebDividerThemeTokens dividerCat;

  // ── 31. Badge ──
  final TibebBadgeThemeTokens badge;

  // ── 32. Avatar ──
  final TibebAvatarThemeTokens avatar;

  // ── 33. Loading ──
  final TibebLoadingThemeTokens loading;

  // ── 34. Empty State ──
  final TibebEmptyStateThemeTokens emptyState;

  // ── 35. Error State ──
  final TibebErrorStateThemeTokens errorState;

  // ── 36. Reader Theme ──
  final TibebReaderThemeTokens reader;

  // ── 37. PDF Viewer Theme ──
  final TibebPdfViewerThemeTokens pdfViewer;

  // ── 38. Audiobook Theme ──
  final TibebAudiobookThemeTokens audiobook;

  // ── 39. Notes Theme ──
  final TibebNotesThemeTokens notes;

  // ── 40. Highlight Theme ──
  final TibebHighlightThemeTokens highlight;

  // ── 41. Dictionary Theme ──
  final TibebDictionaryThemeTokens dictionary;

  // ── 42. Search Theme ──
  final TibebSearchThemeTokens search;

  // ── 43. Library Theme ──
  final TibebLibraryThemeTokens library;

  // ── 44. Download Theme ──
  final TibebDownloadThemeTokens download;

  // ── 45. Statistics Theme ──
  final TibebStatisticsThemeTokens statistics;

  // ── 46. Sync Theme ──
  final TibebSyncThemeTokens syncTheme;

  // ── 47. AI Theme ──
  final TibebAiThemeTokens ai;

  // ── 48. Knowledge Graph Theme ──
  final TibebKnowledgeGraphThemeTokens knowledgeGraph;

  const TibebThemeExtension({
    required this.colorSystem,
    required this.typography,
    required this.spacing,
    required this.radiusCat,
    required this.elevationCat,
    required this.borderCat,
    required this.iconThemeCat,
    required this.motion,
    required this.opacity,
    required this.appBar,
    required this.navigationBar,
    required this.navigationRail,
    required this.navigationDrawer,
    required this.bottomSheet,
    required this.dialog,
    required this.card,
    required this.listTile,
    required this.buttons,
    required this.textField,
    required this.searchBar,
    required this.chip,
    required this.menu,
    required this.snackBar,
    required this.tooltip,
    required this.progress,
    required this.slider,
    required this.switchTheme,
    required this.checkbox,
    required this.radioButton,
    required this.tabs,
    required this.scrollbar,
    required this.dividerCat,
    required this.badge,
    required this.avatar,
    required this.loading,
    required this.emptyState,
    required this.errorState,
    required this.reader,
    required this.pdfViewer,
    required this.audiobook,
    required this.notes,
    required this.highlight,
    required this.dictionary,
    required this.search,
    required this.library,
    required this.download,
    required this.statistics,
    required this.syncTheme,
    required this.ai,
    required this.knowledgeGraph,
  });

  // ── Legacy Compatibility Layer ──
  Color get background => colorSystem.background;
  Color get surface => colorSystem.surface;
  Color get surfaceElevated => colorSystem.surfaceContainerHighest;
  Color get surfaceOverlay => colorSystem.overlay;
  Color get textPrimary => colorSystem.textPrimary;
  Color get textSecondary => colorSystem.textSecondary;
  Color get textTertiary => colorSystem.textTertiary;
  Color get textDisabled => colorSystem.disabled;
  Color get textOnPrimary => Colors.white;
  Color get textOnAccent => Colors.white;
  Color get primary => colorSystem.primary;
  Color get primaryLight => colorSystem.primaryContainer;
  Color get primaryDark => colorSystem.primaryContainer;
  Color get accent => colorSystem.secondary;
  Color get accentLight => colorSystem.secondaryContainer;
  Color get success => colorSystem.success;
  Color get warning => colorSystem.warning;
  Color get error => colorSystem.error;
  Color get border => colorSystem.outline;
  Color get borderSubtle => colorSystem.outlineVariant;
  Color get divider => colorSystem.divider;
  Color get glass => colorSystem.surfaceContainerLow.withValues(alpha: 0.8);
  Color get glassBorder => colorSystem.outlineVariant;
  Color get shimmer => colorSystem.placeholder;
  Color get scrim => colorSystem.scrim;
  Color get ripple => colorSystem.primary.withValues(alpha: 0.1);
  Color get xpGold => colorSystem.primary;
  Color get streakFire => const Color(0xFFFF6B35);
  Color get achievementGlow => colorSystem.primary;
  List<Color> get graphLevels => [
    colorSystem.surface,
    colorSystem.primary.withValues(alpha: 0.3),
    colorSystem.primary.withValues(alpha: 0.5),
    colorSystem.primary.withValues(alpha: 0.7),
    colorSystem.primary,
  ];
  List<Color> get highlightColors => [
    reader.highlightYellow,
    reader.highlightGreen,
    reader.highlightBlue,
    reader.highlightPink,
    reader.highlightOrange,
  ];

  // ── Light Theme Instance Builder ──
  factory TibebThemeExtension.light() => TibebThemeExtensionBuilder.light();

  // ── Dark Theme Instance Builder ──
  factory TibebThemeExtension.dark() => TibebThemeExtensionBuilder.dark();

  @override
  TibebThemeExtension copyWith({
    TibebColorSystem? colorSystem,
    TibebTypographyTokens? typography,
    TibebSpacingTokens? spacing,
    TibebRadiusTokens? radiusCat,
    TibebElevationTokens? elevationCat,
    TibebBorderTokens? borderCat,
    TibebIconThemeTokens? iconThemeCat,
    TibebMotionTokens? motion,
    TibebOpacityTokens? opacity,
    TibebThemeExtension? extension, // legacy mapping if needed, ignored
    TibebAppBarThemeTokens? appBar,
    TibebNavigationBarThemeTokens? navigationBar,
    TibebNavigationRailThemeTokens? navigationRail,
    TibebNavigationDrawerThemeTokens? navigationDrawer,
    TibebBottomSheetThemeTokens? bottomSheet,
    TibebDialogThemeTokens? dialog,
    TibebCardThemeTokens? card,
    TibebListTileThemeTokens? listTile,
    TibebButtonsThemeTokens? buttons,
    TibebTextFieldThemeTokens? textField,
    TibebSearchBarThemeTokens? searchBar,
    TibebChipThemeTokens? chip,
    TibebMenuThemeTokens? menu,
    TibebSnackBarThemeTokens? snackBar,
    TibebTooltipThemeTokens? tooltip,
    TibebProgressIndicatorsThemeTokens? progress,
    TibebSliderThemeTokens? slider,
    TibebSwitchThemeTokens? switchTheme,
    TibebCheckboxThemeTokens? checkbox,
    TibebRadioButtonThemeTokens? radioButton,
    TibebTabsThemeTokens? tabs,
    TibebScrollbarThemeTokens? scrollbar,
    TibebDividerThemeTokens? dividerCat,
    TibebBadgeThemeTokens? badge,
    TibebAvatarThemeTokens? avatar,
    TibebLoadingThemeTokens? loading,
    TibebEmptyStateThemeTokens? emptyState,
    TibebErrorStateThemeTokens? errorState,
    TibebReaderThemeTokens? reader,
    TibebPdfViewerThemeTokens? pdfViewer,
    TibebAudiobookThemeTokens? audiobook,
    TibebNotesThemeTokens? notes,
    TibebHighlightThemeTokens? highlight,
    TibebDictionaryThemeTokens? dictionary,
    TibebSearchThemeTokens? search,
    TibebLibraryThemeTokens? library,
    TibebDownloadThemeTokens? download,
    TibebStatisticsThemeTokens? statistics,
    TibebSyncThemeTokens? syncTheme,
    TibebAiThemeTokens? ai,
    TibebKnowledgeGraphThemeTokens? knowledgeGraph,
  }) {
    return TibebThemeExtension(
      colorSystem: colorSystem ?? this.colorSystem,
      typography: typography ?? this.typography,
      spacing: spacing ?? this.spacing,
      radiusCat: radiusCat ?? this.radiusCat,
      elevationCat: elevationCat ?? this.elevationCat,
      borderCat: borderCat ?? this.borderCat,
      iconThemeCat: iconThemeCat ?? this.iconThemeCat,
      motion: motion ?? this.motion,
      opacity: opacity ?? this.opacity,
      appBar: appBar ?? this.appBar,
      navigationBar: navigationBar ?? this.navigationBar,
      navigationRail: navigationRail ?? this.navigationRail,
      navigationDrawer: navigationDrawer ?? this.navigationDrawer,
      bottomSheet: bottomSheet ?? this.bottomSheet,
      dialog: dialog ?? this.dialog,
      card: card ?? this.card,
      listTile: listTile ?? this.listTile,
      buttons: buttons ?? this.buttons,
      textField: textField ?? this.textField,
      searchBar: searchBar ?? this.searchBar,
      chip: chip ?? this.chip,
      menu: menu ?? this.menu,
      snackBar: snackBar ?? this.snackBar,
      tooltip: tooltip ?? this.tooltip,
      progress: progress ?? this.progress,
      slider: slider ?? this.slider,
      switchTheme: switchTheme ?? this.switchTheme,
      checkbox: checkbox ?? this.checkbox,
      radioButton: radioButton ?? this.radioButton,
      tabs: tabs ?? this.tabs,
      scrollbar: scrollbar ?? this.scrollbar,
      dividerCat: dividerCat ?? this.dividerCat,
      badge: badge ?? this.badge,
      avatar: avatar ?? this.avatar,
      loading: loading ?? this.loading,
      emptyState: emptyState ?? this.emptyState,
      errorState: errorState ?? this.errorState,
      reader: reader ?? this.reader,
      pdfViewer: pdfViewer ?? this.pdfViewer,
      audiobook: audiobook ?? this.audiobook,
      notes: notes ?? this.notes,
      highlight: highlight ?? this.highlight,
      dictionary: dictionary ?? this.dictionary,
      search: search ?? this.search,
      library: library ?? this.library,
      download: download ?? this.download,
      statistics: statistics ?? this.statistics,
      syncTheme: syncTheme ?? this.syncTheme,
      ai: ai ?? this.ai,
      knowledgeGraph: knowledgeGraph ?? this.knowledgeGraph,
    );
  }

  @override
  TibebThemeExtension lerp(covariant TibebThemeExtension? other, double t) {
    if (other is! TibebThemeExtension) return this;
    return TibebThemeExtension(
      colorSystem: colorSystem.lerp(other.colorSystem, t),
      typography: typography.lerp(other.typography, t),
      spacing: spacing.lerp(other.spacing, t),
      radiusCat: radiusCat.lerp(other.radiusCat, t),
      elevationCat: elevationCat.lerp(other.elevationCat, t),
      borderCat: borderCat.lerp(other.borderCat, t),
      iconThemeCat: iconThemeCat.lerp(other.iconThemeCat, t),
      motion: motion.lerp(other.motion, t),
      opacity: opacity.lerp(other.opacity, t),
      appBar: other.appBar,
      navigationBar: other.navigationBar,
      navigationRail: other.navigationRail,
      navigationDrawer: other.navigationDrawer,
      bottomSheet: other.bottomSheet,
      dialog: other.dialog,
      card: other.card,
      listTile: other.listTile,
      buttons: other.buttons,
      textField: other.textField,
      searchBar: other.searchBar,
      chip: other.chip,
      menu: other.menu,
      snackBar: other.snackBar,
      tooltip: other.tooltip,
      progress: other.progress,
      slider: other.slider,
      switchTheme: other.switchTheme,
      checkbox: other.checkbox,
      radioButton: other.radioButton,
      tabs: other.tabs,
      scrollbar: other.scrollbar,
      dividerCat: other.dividerCat,
      badge: other.badge,
      avatar: other.avatar,
      loading: other.loading,
      emptyState: other.emptyState,
      errorState: other.errorState,
      reader: other.reader,
      pdfViewer: other.pdfViewer,
      audiobook: other.audiobook,
      notes: other.notes,
      highlight: other.highlight,
      dictionary: other.dictionary,
      search: other.search,
      library: other.library,
      download: other.download,
      statistics: other.statistics,
      syncTheme: other.syncTheme,
      ai: other.ai,
      knowledgeGraph: other.knowledgeGraph,
    );
  }
}
