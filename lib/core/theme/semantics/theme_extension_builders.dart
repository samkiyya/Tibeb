part of 'theme_extension.dart';

// ── Theme Instance Builders ──

extension TibebThemeExtensionBuilders on TibebThemeExtension {
  // ── Light Theme Instance Builder ──
  static TibebThemeExtension light() {
    final colors = TibebColorSystem.light();
    final typography = TibebTypographyTokens.create(colors);
    final radius = TibebRadiusTokens.create();
    final elevation = TibebElevationTokens.light();
    final border = TibebBorderTokens.light(
      colors.primary,
      colors.error,
      colors.outline,
      colors.disabled,
    );
    final iconTheme = TibebIconThemeTokens.light(
      colors.primary,
      colors.secondary,
      colors.disabled,
      colors.primary,
      colors.error,
      colors.success,
    );

    return TibebThemeExtension(
      colorSystem: colors,
      typography: typography,
      spacing: const TibebSpacingTokens(),
      radiusCat: radius,
      elevationCat: elevation,
      borderCat: border,
      iconThemeCat: iconTheme,

      // Components
      appBar: TibebAppBarThemeTokens.light(colors),
      navigationBar: TibebNavigationBarThemeTokens.light(colors),
      navigationRail: TibebNavigationRailThemeTokens.light(colors),
      navigationDrawer: TibebNavigationDrawerThemeTokens.light(colors),
      bottomSheet: TibebBottomSheetThemeTokens.light(colors, radius),
      dialog: TibebDialogThemeTokens.light(colors, radius),
      card: TibebCardThemeTokens.light(colors, radius, elevation),
      listTile: TibebListTileThemeTokens.light(colors),
      buttons: TibebButtonsThemeTokens.light(colors, radius),
      textField: TibebTextFieldThemeTokens.light(colors, radius),
      searchBar: TibebSearchBarThemeTokens.light(colors),
      chip: TibebChipThemeTokens.light(colors),
      menu: TibebMenuThemeTokens.light(colors),
      snackBar: TibebSnackBarThemeTokens.light(colors),
      tooltip: TibebTooltipThemeTokens.light(colors, radius),
      progress: TibebProgressIndicatorsThemeTokens.light(colors),
      slider: TibebSliderThemeTokens.light(colors),
      switchTheme: TibebSwitchThemeTokens.light(colors),
      checkbox: TibebCheckboxThemeTokens.light(colors),
      radioButton: TibebRadioButtonThemeTokens.light(colors),
      tabs: TibebTabsThemeTokens.light(colors),
      scrollbar: TibebScrollbarThemeTokens.light(colors, radius),
      dividerCat: TibebDividerThemeTokens.light(colors),
      badge: TibebBadgeThemeTokens.light(colors),
      avatar: TibebAvatarThemeTokens.light(colors),
      loading: TibebLoadingThemeTokens.light(colors),
      emptyState: TibebEmptyStateThemeTokens.light(colors),
      errorState: TibebErrorStateThemeTokens.light(colors),

      // Features
      reader: TibebReaderThemeTokens.light(),
      pdfViewer: TibebPdfViewerThemeTokens.light(colors, elevation),
      audiobook: TibebAudiobookThemeTokens.light(colors),
      notes: TibebNotesThemeTokens.light(colors),
      highlight: TibebHighlightThemeTokens.light(colors),
      dictionary: TibebDictionaryThemeTokens.light(colors),
      search: TibebSearchThemeTokens.light(colors),
      library: TibebLibraryThemeTokens.light(colors, radius),
      download: TibebDownloadThemeTokens.light(colors),
      statistics: TibebStatisticsThemeTokens.light(colors),
      syncTheme: TibebSyncThemeTokens.light(colors),
      ai: TibebAiThemeTokens.light(colors),
      knowledgeGraph: TibebKnowledgeGraphThemeTokens.light(colors),
    );
  }

  // ── Dark Theme Instance Builder ──
  static TibebThemeExtension dark() {
    final colors = TibebColorSystem.dark();
    final typography = TibebTypographyTokens.create(colors);
    final radius = TibebRadiusTokens.create();
    final elevation = TibebElevationTokens.dark();
    final border = TibebBorderTokens.dark(
      colors.primary,
      colors.error,
      colors.outline,
      colors.disabled,
    );
    final iconTheme = TibebIconThemeTokens.dark(
      colors.primary,
      colors.secondary,
      colors.disabled,
      colors.primary,
      colors.error,
      colors.success,
    );

    return TibebThemeExtension(
      colorSystem: colors,
      typography: typography,
      spacing: const TibebSpacingTokens(),
      radiusCat: radius,
      elevationCat: elevation,
      borderCat: border,
      iconThemeCat: iconTheme,

      // Components
      appBar: TibebAppBarThemeTokens.dark(colors),
      navigationBar: TibebNavigationBarThemeTokens.dark(colors),
      navigationRail: TibebNavigationRailThemeTokens.dark(colors),
      navigationDrawer: TibebNavigationDrawerThemeTokens.dark(colors),
      bottomSheet: TibebBottomSheetThemeTokens.dark(colors, radius),
      dialog: TibebDialogThemeTokens.dark(colors, radius),
      card: TibebCardThemeTokens.dark(colors, radius, elevation),
      listTile: TibebListTileThemeTokens.dark(colors),
      buttons: TibebButtonsThemeTokens.dark(colors, radius),
      textField: TibebTextFieldThemeTokens.dark(colors, radius),
      searchBar: TibebSearchBarThemeTokens.dark(colors),
      chip: TibebChipThemeTokens.dark(colors),
      menu: TibebMenuThemeTokens.dark(colors),
      snackBar: TibebSnackBarThemeTokens.dark(colors),
      tooltip: TibebTooltipThemeTokens.dark(colors, radius),
      progress: TibebProgressIndicatorsThemeTokens.dark(colors),
      slider: TibebSliderThemeTokens.dark(colors),
      switchTheme: TibebSwitchThemeTokens.dark(colors),
      checkbox: TibebCheckboxThemeTokens.dark(colors),
      radioButton: TibebRadioButtonThemeTokens.dark(colors),
      tabs: TibebTabsThemeTokens.dark(colors),
      scrollbar: TibebScrollbarThemeTokens.dark(colors, radius),
      dividerCat: TibebDividerThemeTokens.dark(colors),
      badge: TibebBadgeThemeTokens.dark(colors),
      avatar: TibebAvatarThemeTokens.dark(colors),
      loading: TibebLoadingThemeTokens.dark(colors),
      emptyState: TibebEmptyStateThemeTokens.dark(colors),
      errorState: TibebErrorStateThemeTokens.dark(colors),

      // Features
      reader: TibebReaderThemeTokens.dark(),
      pdfViewer: TibebPdfViewerThemeTokens.dark(colors, elevation),
      audiobook: TibebAudiobookThemeTokens.dark(colors),
      notes: TibebNotesThemeTokens.dark(colors),
      highlight: TibebHighlightThemeTokens.dark(colors),
      dictionary: TibebDictionaryThemeTokens.dark(colors),
      search: TibebSearchThemeTokens.dark(colors),
      library: TibebLibraryThemeTokens.dark(colors, radius),
      download: TibebDownloadThemeTokens.dark(colors),
      statistics: TibebStatisticsThemeTokens.dark(colors),
      syncTheme: TibebSyncThemeTokens.dark(colors),
      ai: TibebAiThemeTokens.dark(colors),
      knowledgeGraph: TibebKnowledgeGraphThemeTokens.dark(colors),
    );
  }
}
