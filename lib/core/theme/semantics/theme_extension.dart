import 'package:flutter/material.dart';
import 'design_tokens.dart';
import 'component_themes.dart';
import 'feature_themes.dart';

export 'design_tokens.dart';
export 'component_themes.dart';
export 'feature_themes.dart';

/// Tibeb Design System — Core Theme Extension
///
/// Holds references to all 48 specific design system configuration categories.
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
  factory TibebThemeExtension.light() {
    final colors = TibebColorSystem.light();
    final typography = TibebTypographyTokens.create(colors);
    final spacing = const TibebSpacingTokens();
    final radius = TibebRadiusTokens.create();
    final elevation = TibebElevationTokens.light();
    final border = TibebBorderTokens.light(
      colors.primary,
      colors.error,
      colors.outline,
      colors.disabled,
    );
    final iconTheme = TibebIconThemeTokens.light(
      colors.textPrimary,
      colors.textSecondary,
      colors.disabled,
      colors.primary,
      colors.error,
      colors.success,
    );

    return TibebThemeExtension(
      colorSystem: colors,
      typography: typography,
      spacing: spacing,
      radiusCat: radius,
      elevationCat: elevation,
      borderCat: border,
      iconThemeCat: iconTheme,
      appBar: TibebAppBarThemeTokens.create(
        colors.surface,
        colors.textPrimary,
        colors.outlineVariant,
      ),
      navigationBar: TibebNavigationBarThemeTokens.create(
        colors.surface,
        colors.primary,
        colors.textSecondary,
        colors.outlineVariant,
      ),
      navigationRail: TibebNavigationRailThemeTokens(
        background: colors.surface,
        selected: colors.primary,
        unselected: colors.textSecondary,
        indicator: colors.primary.withValues(alpha: 0.1),
        divider: colors.outlineVariant,
      ),
      navigationDrawer: TibebNavigationDrawerThemeTokens(
        background: colors.surface,
        header: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        selectedItem: colors.primary.withValues(alpha: 0.1),
        hovered: colors.primary.withValues(alpha: 0.05),
        divider: colors.outlineVariant,
        icons: IconThemeData(color: colors.textSecondary),
        text: const TextStyle(fontSize: 14),
      ),
      bottomSheet: TibebBottomSheetThemeTokens(
        background: colors.surface,
        dragHandle: colors.outline,
        elevation: 16.0,
        radius: radius.xl,
        barrier: Colors.black54,
        padding: const EdgeInsets.all(24),
      ),
      dialog: TibebDialogThemeTokens(
        background: colors.surface,
        title: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        content: const TextStyle(fontSize: 15),
        actionsDivider: colors.outlineVariant,
        radius: radius.xl,
        elevation: 24.0,
      ),
      card: TibebCardThemeTokens(
        background: colors.surfaceBright,
        border: BorderSide(color: colors.outlineVariant),
        elevation: 2.0,
        radius: radius.md,
        shadow: elevation.level1,
        padding: const EdgeInsets.all(16),
      ),
      listTile: TibebListTileThemeTokens(
        title: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        subtitle: const TextStyle(fontSize: 13),
        leading: IconThemeData(color: colors.textSecondary),
        trailing: IconThemeData(color: colors.textSecondary),
        selected: colors.primary,
        pressed: colors.primary.withValues(alpha: 0.1),
        hover: colors.primary.withValues(alpha: 0.05),
        divider: colors.outlineVariant,
      ),
      buttons: TibebButtonsThemeTokens(
        filled: TibebButtonStateStyles.createDefault(
          colors.primary,
          Colors.white,
          colors.disabled,
          radius.md,
        ),
        outlined: TibebButtonStateStyles(
          background: Colors.transparent,
          foreground: colors.primary,
          disabled: colors.disabled,
          pressed: colors.primary.withValues(alpha: 0.1),
          hovered: colors.primary.withValues(alpha: 0.05),
          focused: colors.primary,
          border: BorderSide(color: colors.primary),
          elevation: 0.0,
          radius: radius.md,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        text: TibebButtonStateStyles.createDefault(
          Colors.transparent,
          colors.primary,
          colors.disabled,
          radius.md,
        ),
        elevated: TibebButtonStateStyles.createDefault(
          colors.surfaceBright,
          colors.primary,
          colors.disabled,
          radius.md,
        ),
        icon: TibebButtonStateStyles.createDefault(
          Colors.transparent,
          colors.textPrimary,
          colors.disabled,
          radius.circle,
        ),
        fab: TibebButtonStateStyles.createDefault(
          colors.primary,
          Colors.white,
          colors.disabled,
          radius.circle,
        ),
        segmented: TibebButtonStateStyles.createDefault(
          colors.surfaceContainerLow,
          colors.textPrimary,
          colors.disabled,
          radius.md,
        ),
        toggle: TibebButtonStateStyles.createDefault(
          colors.surface,
          colors.primary,
          colors.disabled,
          radius.md,
        ),
        readerFloating: TibebButtonStateStyles.createDefault(
          colors.surfaceBright,
          colors.textPrimary,
          colors.disabled,
          radius.circle,
        ),
      ),
      textField: TibebTextFieldThemeTokens(
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
      ),
      searchBar: TibebSearchBarThemeTokens(
        background: colors.surfaceContainerLow,
        border: BorderSide(color: colors.outlineVariant),
        hint: TextStyle(color: colors.textTertiary),
        leadingIcon: IconThemeData(color: colors.textSecondary),
        trailingIcon: IconThemeData(color: colors.textSecondary),
        suggestionBackground: colors.surface,
        suggestionText: TextStyle(color: colors.textPrimary),
      ),
      chip: TibebChipThemeTokens(
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
      ),
      menu: TibebMenuThemeTokens(
        popupMenu: colors.surface,
        dropdown: colors.surface,
        contextMenu: colors.surface,
        readerMenu: colors.surface,
      ),
      snackBar: TibebSnackBarThemeTokens(
        background: colors.inverseSurface,
        text: TextStyle(color: colors.surface),
        action: TextStyle(color: colors.primary),
        success: colors.success,
        warning: colors.warning,
        error: colors.error,
        info: colors.info,
      ),
      tooltip: TibebTooltipThemeTokens(
        background: colors.inverseSurface,
        foreground: TextStyle(color: colors.surface),
        radius: radius.xs,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      progress: TibebProgressIndicatorsThemeTokens(
        linear: ProgressIndicatorThemeData(color: colors.primary),
        circular: ProgressIndicatorThemeData(color: colors.primary),
        readingProgress: colors.primary,
        downloadProgress: colors.info,
        audiobookProgress: colors.secondary,
        syncProgress: colors.success,
      ),
      slider: TibebSliderThemeTokens(
        track: colors.outlineVariant,
        thumb: colors.primary,
        active: colors.primary,
        inactive: colors.outlineVariant,
        tick: colors.outline,
        label: const TextStyle(fontSize: 12),
      ),
      switchTheme: TibebSwitchThemeTokens(
        thumb: colors.surface,
        track: colors.outline,
        outline: colors.outlineVariant,
        disabled: colors.disabled,
      ),
      checkbox: TibebCheckboxThemeTokens(
        checked: colors.primary,
        unchecked: colors.outline,
        disabled: colors.disabled,
        error: colors.error,
      ),
      radioButton: TibebRadioButtonThemeTokens(
        selected: colors.primary,
        unselected: colors.outline,
        disabled: colors.disabled,
      ),
      tabs: TibebTabsThemeTokens(
        indicator: colors.primary,
        selected: TextStyle(color: colors.primary, fontWeight: FontWeight.bold),
        unselected: TextStyle(color: colors.textSecondary),
        divider: colors.outlineVariant,
        background: colors.surface,
      ),
      scrollbar: TibebScrollbarThemeTokens(
        thumb: colors.outline,
        track: colors.outlineVariant,
        hover: colors.primary,
        radius: radius.pill,
      ),
      dividerCat: TibebDividerThemeTokens(
        color: colors.outlineVariant,
        thickness: 1.0,
        indent: 16.0,
      ),
      badge: TibebBadgeThemeTokens(
        background: colors.error,
        text: const TextStyle(color: Colors.white, fontSize: 10),
        border: BorderSide(color: colors.surface),
      ),
      avatar: TibebAvatarThemeTokens(
        background: colors.primary.withValues(alpha: 0.1),
        foreground: TextStyle(
          color: colors.primary,
          fontWeight: FontWeight.bold,
        ),
        border: BorderSide(color: colors.outlineVariant),
        statusIndicator: colors.success,
      ),
      loading: TibebLoadingThemeTokens(
        skeleton: colors.outlineVariant,
        shimmer: colors.surfaceContainer,
        spinner: colors.primary,
        placeholder: colors.outline,
      ),
      emptyState: TibebEmptyStateThemeTokens(
        icon: IconThemeData(color: colors.textSecondary, size: 64),
        title: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        description: const TextStyle(fontSize: 14),
        actionButton: ElevatedButton.styleFrom(backgroundColor: colors.primary),
      ),
      errorState: TibebErrorStateThemeTokens(
        illustration: const Icon(Icons.error_outline),
        title: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        description: const TextStyle(fontSize: 14),
        retryButton: ElevatedButton.styleFrom(backgroundColor: colors.primary),
      ),
      reader: TibebReaderThemeTokens.light(),
      pdfViewer: TibebPdfViewerThemeTokens(
        background: const Color(0xFFF1F5F9),
        pageShadow: elevation.level2,
        selection: colors.primary.withValues(alpha: 0.2),
        searchHighlight: Colors.yellow.withValues(alpha: 0.5),
        annotation: colors.primary,
        currentPage: 1,
        thumbnailBackground: colors.surfaceContainerLow,
        toolbarBackground: colors.surface,
      ),
      audiobook: TibebAudiobookThemeTokens(
        playerBackground: colors.surface,
        waveform: colors.primary,
        seekBar: colors.textSecondary,
        chapterMarker: colors.outline,
        playbackSpeed: TextStyle(color: colors.textPrimary),
        timer: TextStyle(color: colors.textSecondary),
        miniPlayer: colors.surfaceContainerLow,
        fullPlayer: colors.surface,
        lyricsTranscript: const TextStyle(),
      ),
      notes: TibebNotesThemeTokens(
        background: colors.surface,
        title: const TextStyle(fontWeight: FontWeight.bold),
        content: const TextStyle(),
        timestamp: const TextStyle(fontSize: 11),
        pinned: colors.primary,
        selected: colors.primary.withValues(alpha: 0.1),
        editor: colors.surfaceBright,
        markdownPreview: colors.surfaceContainerLow,
      ),
      highlight: TibebHighlightThemeTokens(
        yellow: Colors.yellow,
        blue: Colors.blue,
        green: Colors.green,
        pink: Colors.pink,
        orange: Colors.orange,
        underline: const TextStyle(decoration: TextDecoration.underline),
        strikethrough: const TextStyle(decoration: TextDecoration.lineThrough),
        selected: colors.primary.withValues(alpha: 0.2),
        hovered: colors.primary.withValues(alpha: 0.1),
      ),
      dictionary: TibebDictionaryThemeTokens(
        word: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        pronunciation: const TextStyle(fontStyle: FontStyle.italic),
        meaning: const TextStyle(),
        example: const TextStyle(fontStyle: FontStyle.italic),
        synonyms: const TextStyle(color: Colors.blue),
        antonyms: const TextStyle(color: Colors.red),
        partOfSpeech: const TextStyle(fontWeight: FontWeight.w600),
      ),
      search: TibebSearchThemeTokens(
        resultCard: colors.surfaceBright,
        highlightedMatch: Colors.yellow,
        sectionHeader: const TextStyle(fontWeight: FontWeight.bold),
        filterChip: colors.primary,
        historyItem: colors.textSecondary,
        recentSearch: const TextStyle(),
      ),
      library: TibebLibraryThemeTokens(
        bookCard: colors.surfaceBright,
        bookCover: radius.md,
        gridLayout: 'grid',
        listLayout: 'list',
        shelf: colors.outlineVariant,
        readingStatus: colors.primary,
        progress: colors.primary,
        downloadedBadge: colors.success,
        favoriteBadge: colors.error,
      ),
      download: TibebDownloadThemeTokens(
        downloading: colors.info,
        paused: colors.warning,
        completed: colors.success,
        failed: colors.error,
        queued: colors.textTertiary,
      ),
      statistics: TibebStatisticsThemeTokens(
        charts: colors.primary,
        readingCalendar: colors.primary,
        heatmap: colors.success,
        streak: const Color(0xFFFF6B35),
        achievement: colors.primary,
        goal: colors.primary,
        xp: colors.primary,
      ),
      syncTheme: TibebSyncThemeTokens(
        syncing: colors.info,
        success: colors.success,
        conflict: colors.warning,
        offline: colors.disabled,
        cloud: colors.primary,
        backup: colors.secondary,
      ),
      ai: TibebAiThemeTokens(
        aiMessage: colors.surfaceContainerLow,
        prompt: colors.primary,
        citation: colors.outline,
        generatedSummary: const TextStyle(),
        explanation: const TextStyle(),
        flashcard: colors.surfaceContainerLow,
        suggestion: colors.primary,
      ),
      knowledgeGraph: TibebKnowledgeGraphThemeTokens(
        node: colors.primary,
        edge: colors.outline,
        selectedNode: colors.primary,
        relatedNode: colors.secondary,
        bookNode: colors.primary,
        personNode: colors.success,
        conceptNode: colors.info,
        tagNode: colors.warning,
      ),
    );
  }

  // ── Dark Theme Instance Builder ──
  factory TibebThemeExtension.dark() {
    final colors = TibebColorSystem.dark();
    final typography = TibebTypographyTokens.create(colors);
    final spacing = const TibebSpacingTokens();
    final radius = TibebRadiusTokens.create();
    final elevation = TibebElevationTokens.dark();
    final border = TibebBorderTokens.dark(
      colors.primary,
      colors.error,
      colors.outline,
      colors.disabled,
    );
    final iconTheme = TibebIconThemeTokens.dark(
      colors.textPrimary,
      colors.textSecondary,
      colors.disabled,
      colors.primary,
      colors.error,
      colors.success,
    );

    return TibebThemeExtension(
      colorSystem: colors,
      typography: typography,
      spacing: spacing,
      radiusCat: radius,
      elevationCat: elevation,
      borderCat: border,
      iconThemeCat: iconTheme,
      appBar: TibebAppBarThemeTokens.create(
        colors.surface,
        colors.textPrimary,
        colors.outlineVariant,
      ),
      navigationBar: TibebNavigationBarThemeTokens.create(
        colors.surface,
        colors.primary,
        colors.textSecondary,
        colors.outlineVariant,
      ),
      navigationRail: TibebNavigationRailThemeTokens(
        background: colors.surface,
        selected: colors.primary,
        unselected: colors.textSecondary,
        indicator: colors.primary.withValues(alpha: 0.1),
        divider: colors.outlineVariant,
      ),
      navigationDrawer: TibebNavigationDrawerThemeTokens(
        background: colors.surface,
        header: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        selectedItem: colors.primary.withValues(alpha: 0.1),
        hovered: colors.primary.withValues(alpha: 0.05),
        divider: colors.outlineVariant,
        icons: IconThemeData(color: colors.textSecondary),
        text: const TextStyle(fontSize: 14),
      ),
      bottomSheet: TibebBottomSheetThemeTokens(
        background: colors.surface,
        dragHandle: colors.outline,
        elevation: 16.0,
        radius: radius.xl,
        barrier: Colors.black54,
        padding: const EdgeInsets.all(24),
      ),
      dialog: TibebDialogThemeTokens(
        background: colors.surface,
        title: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        content: const TextStyle(fontSize: 15),
        actionsDivider: colors.outlineVariant,
        radius: radius.xl,
        elevation: 24.0,
      ),
      card: TibebCardThemeTokens(
        background: colors.surfaceBright,
        border: BorderSide(color: colors.outlineVariant),
        elevation: 2.0,
        radius: radius.md,
        shadow: elevation.level1,
        padding: const EdgeInsets.all(16),
      ),
      listTile: TibebListTileThemeTokens(
        title: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        subtitle: const TextStyle(fontSize: 13),
        leading: IconThemeData(color: colors.textSecondary),
        trailing: IconThemeData(color: colors.textSecondary),
        selected: colors.primary,
        pressed: colors.primary.withValues(alpha: 0.1),
        hover: colors.primary.withValues(alpha: 0.05),
        divider: colors.outlineVariant,
      ),
      buttons: TibebButtonsThemeTokens(
        filled: TibebButtonStateStyles.createDefault(
          colors.primary,
          colors.background,
          colors.disabled,
          radius.md,
        ),
        outlined: TibebButtonStateStyles(
          background: Colors.transparent,
          foreground: colors.primary,
          disabled: colors.disabled,
          pressed: colors.primary.withValues(alpha: 0.1),
          hovered: colors.primary.withValues(alpha: 0.05),
          focused: colors.primary,
          border: BorderSide(color: colors.outline),
          elevation: 0.0,
          radius: radius.md,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        text: TibebButtonStateStyles.createDefault(
          Colors.transparent,
          colors.primary,
          colors.disabled,
          radius.md,
        ),
        elevated: TibebButtonStateStyles.createDefault(
          colors.surfaceBright,
          colors.primary,
          colors.disabled,
          radius.md,
        ),
        icon: TibebButtonStateStyles.createDefault(
          Colors.transparent,
          colors.textPrimary,
          colors.disabled,
          radius.circle,
        ),
        fab: TibebButtonStateStyles.createDefault(
          colors.primary,
          colors.background,
          colors.disabled,
          radius.circle,
        ),
        segmented: TibebButtonStateStyles.createDefault(
          colors.surfaceContainerLow,
          colors.textPrimary,
          colors.disabled,
          radius.md,
        ),
        toggle: TibebButtonStateStyles.createDefault(
          colors.surface,
          colors.primary,
          colors.disabled,
          radius.md,
        ),
        readerFloating: TibebButtonStateStyles.createDefault(
          colors.surfaceBright,
          colors.textPrimary,
          colors.disabled,
          radius.circle,
        ),
      ),
      textField: TibebTextFieldThemeTokens(
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
      ),
      searchBar: TibebSearchBarThemeTokens(
        background: colors.surfaceContainerLow,
        border: BorderSide(color: colors.outlineVariant),
        hint: TextStyle(color: colors.textTertiary),
        leadingIcon: IconThemeData(color: colors.textSecondary),
        trailingIcon: IconThemeData(color: colors.textSecondary),
        suggestionBackground: colors.surface,
        suggestionText: TextStyle(color: colors.textPrimary),
      ),
      chip: TibebChipThemeTokens(
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
      ),
      menu: TibebMenuThemeTokens(
        popupMenu: colors.surface,
        dropdown: colors.surface,
        contextMenu: colors.surface,
        readerMenu: colors.surface,
      ),
      snackBar: TibebSnackBarThemeTokens(
        background: colors.inverseSurface,
        text: TextStyle(color: colors.surface),
        action: TextStyle(color: colors.primary),
        success: colors.success,
        warning: colors.warning,
        error: colors.error,
        info: colors.info,
      ),
      tooltip: TibebTooltipThemeTokens(
        background: colors.inverseSurface,
        foreground: TextStyle(color: colors.surface),
        radius: radius.xs,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      progress: TibebProgressIndicatorsThemeTokens(
        linear: ProgressIndicatorThemeData(color: colors.primary),
        circular: ProgressIndicatorThemeData(color: colors.primary),
        readingProgress: colors.primary,
        downloadProgress: colors.info,
        audiobookProgress: colors.secondary,
        syncProgress: colors.success,
      ),
      slider: TibebSliderThemeTokens(
        track: colors.outlineVariant,
        thumb: colors.primary,
        active: colors.primary,
        inactive: colors.outlineVariant,
        tick: colors.outline,
        label: const TextStyle(fontSize: 12),
      ),
      switchTheme: TibebSwitchThemeTokens(
        thumb: colors.surface,
        track: colors.outline,
        outline: colors.outlineVariant,
        disabled: colors.disabled,
      ),
      checkbox: TibebCheckboxThemeTokens(
        checked: colors.primary,
        unchecked: colors.outline,
        disabled: colors.disabled,
        error: colors.error,
      ),
      radioButton: TibebRadioButtonThemeTokens(
        selected: colors.primary,
        unselected: colors.outline,
        disabled: colors.disabled,
      ),
      tabs: TibebTabsThemeTokens(
        indicator: colors.primary,
        selected: TextStyle(color: colors.primary, fontWeight: FontWeight.bold),
        unselected: TextStyle(color: colors.textSecondary),
        divider: colors.outlineVariant,
        background: colors.surface,
      ),
      scrollbar: TibebScrollbarThemeTokens(
        thumb: colors.outline,
        track: colors.outlineVariant,
        hover: colors.primary,
        radius: radius.pill,
      ),
      dividerCat: TibebDividerThemeTokens(
        color: colors.outlineVariant,
        thickness: 1.0,
        indent: 16.0,
      ),
      badge: TibebBadgeThemeTokens(
        background: colors.error,
        text: const TextStyle(color: Colors.white, fontSize: 10),
        border: BorderSide(color: colors.surface),
      ),
      avatar: TibebAvatarThemeTokens(
        background: colors.primary.withValues(alpha: 0.1),
        foreground: TextStyle(
          color: colors.primary,
          fontWeight: FontWeight.bold,
        ),
        border: BorderSide(color: colors.outlineVariant),
        statusIndicator: colors.success,
      ),
      loading: TibebLoadingThemeTokens(
        skeleton: colors.outlineVariant,
        shimmer: colors.surfaceContainer,
        spinner: colors.primary,
        placeholder: colors.outline,
      ),
      emptyState: TibebEmptyStateThemeTokens(
        icon: IconThemeData(color: colors.textSecondary, size: 64),
        title: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        description: const TextStyle(fontSize: 14),
        actionButton: ElevatedButton.styleFrom(backgroundColor: colors.primary),
      ),
      errorState: TibebErrorStateThemeTokens(
        illustration: const Icon(Icons.error_outline),
        title: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        description: const TextStyle(fontSize: 14),
        retryButton: ElevatedButton.styleFrom(backgroundColor: colors.primary),
      ),
      reader: TibebReaderThemeTokens.dark(),
      pdfViewer: TibebPdfViewerThemeTokens(
        background: Colors.black,
        pageShadow: elevation.level2,
        selection: colors.primary.withValues(alpha: 0.2),
        searchHighlight: Colors.yellow.withValues(alpha: 0.5),
        annotation: colors.primary,
        currentPage: 1,
        thumbnailBackground: colors.surfaceContainerLow,
        toolbarBackground: colors.surface,
      ),
      audiobook: TibebAudiobookThemeTokens(
        playerBackground: colors.surface,
        waveform: colors.primary,
        seekBar: colors.textSecondary,
        chapterMarker: colors.outline,
        playbackSpeed: TextStyle(color: colors.textPrimary),
        timer: TextStyle(color: colors.textSecondary),
        miniPlayer: colors.surfaceContainerLow,
        fullPlayer: colors.surface,
        lyricsTranscript: const TextStyle(),
      ),
      notes: TibebNotesThemeTokens(
        background: colors.surface,
        title: const TextStyle(fontWeight: FontWeight.bold),
        content: const TextStyle(),
        timestamp: const TextStyle(fontSize: 11),
        pinned: colors.primary,
        selected: colors.primary.withValues(alpha: 0.1),
        editor: colors.surfaceBright,
        markdownPreview: colors.surfaceContainerLow,
      ),
      highlight: TibebHighlightThemeTokens(
        yellow: Colors.yellow,
        blue: Colors.blue,
        green: Colors.green,
        pink: Colors.pink,
        orange: Colors.orange,
        underline: const TextStyle(decoration: TextDecoration.underline),
        strikethrough: const TextStyle(decoration: TextDecoration.lineThrough),
        selected: colors.primary.withValues(alpha: 0.2),
        hovered: colors.primary.withValues(alpha: 0.1),
      ),
      dictionary: TibebDictionaryThemeTokens(
        word: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        pronunciation: const TextStyle(fontStyle: FontStyle.italic),
        meaning: const TextStyle(),
        example: const TextStyle(fontStyle: FontStyle.italic),
        synonyms: const TextStyle(color: Colors.blue),
        antonyms: const TextStyle(color: Colors.red),
        partOfSpeech: const TextStyle(fontWeight: FontWeight.w600),
      ),
      search: TibebSearchThemeTokens(
        resultCard: colors.surfaceBright,
        highlightedMatch: Colors.yellow,
        sectionHeader: const TextStyle(fontWeight: FontWeight.bold),
        filterChip: colors.primary,
        historyItem: colors.textSecondary,
        recentSearch: const TextStyle(),
      ),
      library: TibebLibraryThemeTokens(
        bookCard: colors.surfaceBright,
        bookCover: radius.md,
        gridLayout: 'grid',
        listLayout: 'list',
        shelf: colors.outlineVariant,
        readingStatus: colors.primary,
        progress: colors.primary,
        downloadedBadge: colors.success,
        favoriteBadge: colors.error,
      ),
      download: TibebDownloadThemeTokens(
        downloading: colors.info,
        paused: colors.warning,
        completed: colors.success,
        failed: colors.error,
        queued: colors.textTertiary,
      ),
      statistics: TibebStatisticsThemeTokens(
        charts: colors.primary,
        readingCalendar: colors.primary,
        heatmap: colors.success,
        streak: const Color(0xFFFF6B35),
        achievement: colors.primary,
        goal: colors.primary,
        xp: colors.primary,
      ),
      syncTheme: TibebSyncThemeTokens(
        syncing: colors.info,
        success: colors.success,
        conflict: colors.warning,
        offline: colors.disabled,
        cloud: colors.primary,
        backup: colors.secondary,
      ),
      ai: TibebAiThemeTokens(
        aiMessage: colors.surfaceContainerLow,
        prompt: colors.primary,
        citation: colors.outline,
        generatedSummary: const TextStyle(),
        explanation: const TextStyle(),
        flashcard: colors.surfaceContainerLow,
        suggestion: colors.primary,
      ),
      knowledgeGraph: TibebKnowledgeGraphThemeTokens(
        node: colors.primary,
        edge: colors.outline,
        selectedNode: colors.primary,
        relatedNode: colors.secondary,
        bookNode: colors.primary,
        personNode: colors.success,
        conceptNode: colors.info,
        tagNode: colors.warning,
      ),
    );
  }

  @override
  TibebThemeExtension copyWith({
    TibebColorSystem? colorSystem,
    TibebTypographyTokens? typography,
    TibebSpacingTokens? spacing,
    TibebRadiusTokens? radiusCat,
    TibebElevationTokens? elevationCat,
    TibebBorderTokens? borderCat,
    TibebIconThemeTokens? iconThemeCat,
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
