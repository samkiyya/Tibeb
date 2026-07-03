import 'package:flutter/material.dart';
import 'design_tokens.dart';

// 36. TibebReaderTheme
class TibebReaderThemeTokens {
  final Color background;
  final TextStyle text;
  final TextStyle heading;
  final TextStyle quote;
  final Color link;
  final TextStyle code;
  final TextStyle footnote;
  final TextStyle annotation;
  final Color highlightYellow;
  final Color highlightGreen;
  final Color highlightBlue;
  final Color highlightPink;
  final Color highlightOrange;
  final Color bookmark;
  final Color selection;
  final Color caret;
  final TextStyle pageNumber;
  final TextStyle chapter;
  final double paragraphSpacing;
  final double lineHeight;
  final double margin;
  final String font;
  final TextStyle dropCap;
  final BoxDecoration images;
  final BoxDecoration tables;
  final TextStyle lists;
  final TextStyle blockquote;
  final TextStyle inlineCode;

  const TibebReaderThemeTokens({
    required this.background,
    required this.text,
    required this.heading,
    required this.quote,
    required this.link,
    required this.code,
    required this.footnote,
    required this.annotation,
    required this.highlightYellow,
    required this.highlightGreen,
    required this.highlightBlue,
    required this.highlightPink,
    required this.highlightOrange,
    required this.bookmark,
    required this.selection,
    required this.caret,
    required this.pageNumber,
    required this.chapter,
    required this.paragraphSpacing,
    required this.lineHeight,
    required this.margin,
    required this.font,
    required this.dropCap,
    required this.images,
    required this.tables,
    required this.lists,
    required this.blockquote,
    required this.inlineCode,
  });

  static TibebReaderThemeTokens dark() {
    return TibebReaderThemeTokens(
      background: Colors.black,
      text: const TextStyle(color: Colors.white, fontSize: 18),
      heading: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      quote: const TextStyle(
        color: Colors.white70,
        fontSize: 18,
        fontStyle: FontStyle.italic,
      ),
      link: Colors.amber,
      code: const TextStyle(
        color: Colors.white54,
        fontFamily: 'Courier',
        fontSize: 14,
      ),
      footnote: const TextStyle(color: Colors.white60, fontSize: 12),
      annotation: const TextStyle(color: Colors.white60, fontSize: 13),
      highlightYellow: Colors.yellow.withValues(alpha: 0.3),
      highlightGreen: Colors.green.withValues(alpha: 0.3),
      highlightBlue: Colors.blue.withValues(alpha: 0.3),
      highlightPink: Colors.pink.withValues(alpha: 0.3),
      highlightOrange: Colors.orange.withValues(alpha: 0.3),
      bookmark: Colors.amber,
      selection: Colors.amber.withValues(alpha: 0.4),
      caret: Colors.amber,
      pageNumber: const TextStyle(color: Colors.white38, fontSize: 11),
      chapter: const TextStyle(color: Colors.white60, fontSize: 14),
      paragraphSpacing: 16.0,
      lineHeight: 1.6,
      margin: 20.0,
      font: 'System',
      dropCap: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
      images: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      tables: BoxDecoration(border: Border.all(color: Colors.white24)),
      lists: const TextStyle(),
      blockquote: const TextStyle(
        color: Colors.white60,
        fontStyle: FontStyle.italic,
      ),
      inlineCode: const TextStyle(fontFamily: 'Courier', fontSize: 14),
    );
  }

  static TibebReaderThemeTokens light() {
    return TibebReaderThemeTokens(
      background: const Color(0xFFFDFBF7),
      text: const TextStyle(color: Color(0xFF1A1A1A), fontSize: 18),
      heading: const TextStyle(
        color: Color(0xFF1A1A1A),
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      quote: const TextStyle(
        color: Color(0xFF333333),
        fontSize: 18,
        fontStyle: FontStyle.italic,
      ),
      link: Colors.brown,
      code: const TextStyle(
        color: Colors.black54,
        fontFamily: 'Courier',
        fontSize: 14,
      ),
      footnote: const TextStyle(color: Colors.black54, fontSize: 12),
      annotation: const TextStyle(color: Colors.black54, fontSize: 13),
      highlightYellow: Colors.yellow.withValues(alpha: 0.4),
      highlightGreen: Colors.green.withValues(alpha: 0.4),
      highlightBlue: Colors.blue.withValues(alpha: 0.4),
      highlightPink: Colors.pink.withValues(alpha: 0.4),
      highlightOrange: Colors.orange.withValues(alpha: 0.4),
      bookmark: Colors.brown,
      selection: Colors.brown.withValues(alpha: 0.2),
      caret: Colors.brown,
      pageNumber: const TextStyle(color: Colors.black38, fontSize: 11),
      chapter: const TextStyle(color: Colors.black54, fontSize: 14),
      paragraphSpacing: 16.0,
      lineHeight: 1.6,
      margin: 20.0,
      font: 'System',
      dropCap: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
      images: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      tables: BoxDecoration(border: Border.all(color: Colors.black26)),
      lists: const TextStyle(),
      blockquote: const TextStyle(
        color: Colors.black54,
        fontStyle: FontStyle.italic,
      ),
      inlineCode: const TextStyle(fontFamily: 'Courier', fontSize: 14),
    );
  }
}

// 37. TibebPdfViewerTheme
class TibebPdfViewerThemeTokens {
  final Color background;
  final List<BoxShadow> pageShadow;
  final Color selection;
  final Color searchHighlight;
  final Color annotation;
  final int currentPage;
  final Color thumbnailBackground;
  final Color toolbarBackground;

  const TibebPdfViewerThemeTokens({
    required this.background,
    required this.pageShadow,
    required this.selection,
    required this.searchHighlight,
    required this.annotation,
    required this.currentPage,
    required this.thumbnailBackground,
    required this.toolbarBackground,
  });

  factory TibebPdfViewerThemeTokens.light(
    TibebColorSystem colors,
    TibebElevationTokens elevation,
  ) {
    return TibebPdfViewerThemeTokens(
      background: const Color(0xFFF1F5F9),
      pageShadow: elevation.level2,
      selection: colors.primary.withValues(alpha: 0.2),
      searchHighlight: Colors.yellow.withValues(alpha: 0.5),
      annotation: colors.primary,
      currentPage: 1,
      thumbnailBackground: colors.surfaceContainerLow,
      toolbarBackground: colors.surface,
    );
  }

  factory TibebPdfViewerThemeTokens.dark(
    TibebColorSystem colors,
    TibebElevationTokens elevation,
  ) {
    return TibebPdfViewerThemeTokens(
      background: Colors.black,
      pageShadow: elevation.level2,
      selection: colors.primary.withValues(alpha: 0.2),
      searchHighlight: Colors.yellow.withValues(alpha: 0.5),
      annotation: colors.primary,
      currentPage: 1,
      thumbnailBackground: colors.surfaceContainerLow,
      toolbarBackground: colors.surface,
    );
  }
}

// 38. TibebAudiobookTheme
class TibebAudiobookThemeTokens {
  final Color playerBackground;
  final Color waveform;
  final Color seekBar;
  final Color chapterMarker;
  final TextStyle playbackSpeed;
  final TextStyle timer;
  final Color miniPlayer;
  final Color fullPlayer;
  final TextStyle lyricsTranscript;

  const TibebAudiobookThemeTokens({
    required this.playerBackground,
    required this.waveform,
    required this.seekBar,
    required this.chapterMarker,
    required this.playbackSpeed,
    required this.timer,
    required this.miniPlayer,
    required this.fullPlayer,
    required this.lyricsTranscript,
  });

  factory TibebAudiobookThemeTokens.light(TibebColorSystem colors) {
    return TibebAudiobookThemeTokens(
      playerBackground: colors.surface,
      waveform: colors.primary,
      seekBar: colors.textSecondary,
      chapterMarker: colors.outline,
      playbackSpeed: TextStyle(color: colors.textPrimary),
      timer: TextStyle(color: colors.textSecondary),
      miniPlayer: colors.surfaceContainerLow,
      fullPlayer: colors.surface,
      lyricsTranscript: const TextStyle(),
    );
  }

  factory TibebAudiobookThemeTokens.dark(TibebColorSystem colors) {
    return TibebAudiobookThemeTokens(
      playerBackground: colors.surface,
      waveform: colors.primary,
      seekBar: colors.textSecondary,
      chapterMarker: colors.outline,
      playbackSpeed: TextStyle(color: colors.textPrimary),
      timer: TextStyle(color: colors.textSecondary),
      miniPlayer: colors.surfaceContainerLow,
      fullPlayer: colors.surface,
      lyricsTranscript: const TextStyle(),
    );
  }
}

// 39. TibebNotesTheme
class TibebNotesThemeTokens {
  final Color background;
  final TextStyle title;
  final TextStyle content;
  final TextStyle timestamp;
  final Color pinned;
  final Color selected;
  final Color editor;
  final Color markdownPreview;

  const TibebNotesThemeTokens({
    required this.background,
    required this.title,
    required this.content,
    required this.timestamp,
    required this.pinned,
    required this.selected,
    required this.editor,
    required this.markdownPreview,
  });

  factory TibebNotesThemeTokens.light(TibebColorSystem colors) {
    return TibebNotesThemeTokens(
      background: colors.surface,
      title: const TextStyle(fontWeight: FontWeight.bold),
      content: const TextStyle(),
      timestamp: const TextStyle(fontSize: 11),
      pinned: colors.primary,
      selected: colors.primary.withValues(alpha: 0.1),
      editor: colors.surfaceBright,
      markdownPreview: colors.surfaceContainerLow,
    );
  }

  factory TibebNotesThemeTokens.dark(TibebColorSystem colors) {
    return TibebNotesThemeTokens(
      background: colors.surface,
      title: const TextStyle(fontWeight: FontWeight.bold),
      content: const TextStyle(),
      timestamp: const TextStyle(fontSize: 11),
      pinned: colors.primary,
      selected: colors.primary.withValues(alpha: 0.1),
      editor: colors.surfaceBright,
      markdownPreview: colors.surfaceContainerLow,
    );
  }
}

// 40. TibebHighlightTheme
class TibebHighlightThemeTokens {
  final Color yellow;
  final Color blue;
  final Color green;
  final Color pink;
  final Color orange;
  final TextStyle underline;
  final TextStyle strikethrough;
  final Color selected;
  final Color hovered;

  const TibebHighlightThemeTokens({
    required this.yellow,
    required this.blue,
    required this.green,
    required this.pink,
    required this.orange,
    required this.underline,
    required this.strikethrough,
    required this.selected,
    required this.hovered,
  });

  factory TibebHighlightThemeTokens.light(TibebColorSystem colors) {
    return TibebHighlightThemeTokens(
      yellow: Colors.yellow,
      blue: Colors.blue,
      green: Colors.green,
      pink: Colors.pink,
      orange: Colors.orange,
      underline: const TextStyle(decoration: TextDecoration.underline),
      strikethrough: const TextStyle(decoration: TextDecoration.lineThrough),
      selected: colors.primary.withValues(alpha: 0.2),
      hovered: colors.primary.withValues(alpha: 0.1),
    );
  }

  factory TibebHighlightThemeTokens.dark(TibebColorSystem colors) {
    return TibebHighlightThemeTokens(
      yellow: Colors.yellow,
      blue: Colors.blue,
      green: Colors.green,
      pink: Colors.pink,
      orange: Colors.orange,
      underline: const TextStyle(decoration: TextDecoration.underline),
      strikethrough: const TextStyle(decoration: TextDecoration.lineThrough),
      selected: colors.primary.withValues(alpha: 0.2),
      hovered: colors.primary.withValues(alpha: 0.1),
    );
  }
}

// 41. TibebDictionaryTheme
class TibebDictionaryThemeTokens {
  final TextStyle word;
  final TextStyle pronunciation;
  final TextStyle meaning;
  final TextStyle example;
  final TextStyle synonyms;
  final TextStyle antonyms;
  final TextStyle partOfSpeech;

  const TibebDictionaryThemeTokens({
    required this.word,
    required this.pronunciation,
    required this.meaning,
    required this.example,
    required this.synonyms,
    required this.antonyms,
    required this.partOfSpeech,
  });

  factory TibebDictionaryThemeTokens.light(TibebColorSystem colors) {
    return const TibebDictionaryThemeTokens(
      word: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      pronunciation: TextStyle(fontStyle: FontStyle.italic),
      meaning: TextStyle(),
      example: TextStyle(fontStyle: FontStyle.italic),
      synonyms: TextStyle(color: Colors.blue),
      antonyms: TextStyle(color: Colors.red),
      partOfSpeech: TextStyle(fontWeight: FontWeight.w600),
    );
  }

  factory TibebDictionaryThemeTokens.dark(TibebColorSystem colors) {
    return const TibebDictionaryThemeTokens(
      word: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      pronunciation: TextStyle(fontStyle: FontStyle.italic),
      meaning: TextStyle(),
      example: TextStyle(fontStyle: FontStyle.italic),
      synonyms: TextStyle(color: Colors.blue),
      antonyms: TextStyle(color: Colors.red),
      partOfSpeech: TextStyle(fontWeight: FontWeight.w600),
    );
  }
}

// 42. TibebSearchTheme
class TibebSearchThemeTokens {
  final Color resultCard;
  final Color highlightedMatch;
  final TextStyle sectionHeader;
  final Color filterChip;
  final Color historyItem;
  final TextStyle recentSearch;

  const TibebSearchThemeTokens({
    required this.resultCard,
    required this.highlightedMatch,
    required this.sectionHeader,
    required this.filterChip,
    required this.historyItem,
    required this.recentSearch,
  });

  factory TibebSearchThemeTokens.light(TibebColorSystem colors) {
    return TibebSearchThemeTokens(
      resultCard: colors.surfaceBright,
      highlightedMatch: Colors.yellow,
      sectionHeader: const TextStyle(fontWeight: FontWeight.bold),
      filterChip: colors.primary,
      historyItem: colors.textSecondary,
      recentSearch: const TextStyle(),
    );
  }

  factory TibebSearchThemeTokens.dark(TibebColorSystem colors) {
    return TibebSearchThemeTokens(
      resultCard: colors.surfaceBright,
      highlightedMatch: Colors.yellow,
      sectionHeader: const TextStyle(fontWeight: FontWeight.bold),
      filterChip: colors.primary,
      historyItem: colors.textSecondary,
      recentSearch: const TextStyle(),
    );
  }
}

// 43. TibebLibraryTheme
class TibebLibraryThemeTokens {
  final Color bookCard;
  final BorderRadius bookCover;
  final String gridLayout;
  final String listLayout;
  final Color shelf;
  final Color readingStatus;
  final Color progress;
  final Color downloadedBadge;
  final Color favoriteBadge;

  const TibebLibraryThemeTokens({
    required this.bookCard,
    required this.bookCover,
    required this.gridLayout,
    required this.listLayout,
    required this.shelf,
    required this.readingStatus,
    required this.progress,
    required this.downloadedBadge,
    required this.favoriteBadge,
  });

  factory TibebLibraryThemeTokens.light(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
  ) {
    return TibebLibraryThemeTokens(
      bookCard: colors.surfaceBright,
      bookCover: radius.md,
      gridLayout: 'grid',
      listLayout: 'list',
      shelf: colors.outlineVariant,
      readingStatus: colors.primary,
      progress: colors.primary,
      downloadedBadge: colors.success,
      favoriteBadge: colors.error,
    );
  }

  factory TibebLibraryThemeTokens.dark(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
  ) {
    return TibebLibraryThemeTokens(
      bookCard: colors.surfaceBright,
      bookCover: radius.md,
      gridLayout: 'grid',
      listLayout: 'list',
      shelf: colors.outlineVariant,
      readingStatus: colors.primary,
      progress: colors.primary,
      downloadedBadge: colors.success,
      favoriteBadge: colors.error,
    );
  }
}

// 44. TibebDownloadTheme
class TibebDownloadThemeTokens {
  final Color downloading;
  final Color paused;
  final Color completed;
  final Color failed;
  final Color queued;

  const TibebDownloadThemeTokens({
    required this.downloading,
    required this.paused,
    required this.completed,
    required this.failed,
    required this.queued,
  });

  factory TibebDownloadThemeTokens.light(TibebColorSystem colors) {
    return TibebDownloadThemeTokens(
      downloading: colors.info,
      paused: colors.warning,
      completed: colors.success,
      failed: colors.error,
      queued: colors.textTertiary,
    );
  }

  factory TibebDownloadThemeTokens.dark(TibebColorSystem colors) {
    return TibebDownloadThemeTokens(
      downloading: colors.info,
      paused: colors.warning,
      completed: colors.success,
      failed: colors.error,
      queued: colors.textTertiary,
    );
  }
}

// 45. TibebStatisticsTheme
class TibebStatisticsThemeTokens {
  final Color charts;
  final Color readingCalendar;
  final Color heatmap;
  final Color streak;
  final Color achievement;
  final Color goal;
  final Color xp;

  const TibebStatisticsThemeTokens({
    required this.charts,
    required this.readingCalendar,
    required this.heatmap,
    required this.streak,
    required this.achievement,
    required this.goal,
    required this.xp,
  });

  factory TibebStatisticsThemeTokens.light(TibebColorSystem colors) {
    return TibebStatisticsThemeTokens(
      charts: colors.primary,
      readingCalendar: colors.primary,
      heatmap: colors.success,
      streak: const Color(0xFFFF6B35),
      achievement: colors.primary,
      goal: colors.primary,
      xp: colors.primary,
    );
  }

  factory TibebStatisticsThemeTokens.dark(TibebColorSystem colors) {
    return TibebStatisticsThemeTokens(
      charts: colors.primary,
      readingCalendar: colors.primary,
      heatmap: colors.success,
      streak: const Color(0xFFFF6B35),
      achievement: colors.primary,
      goal: colors.primary,
      xp: colors.primary,
    );
  }
}

// 46. TibebSyncTheme
class TibebSyncThemeTokens {
  final Color syncing;
  final Color success;
  final Color conflict;
  final Color offline;
  final Color cloud;
  final Color backup;

  const TibebSyncThemeTokens({
    required this.syncing,
    required this.success,
    required this.conflict,
    required this.offline,
    required this.cloud,
    required this.backup,
  });

  factory TibebSyncThemeTokens.light(TibebColorSystem colors) {
    return TibebSyncThemeTokens(
      syncing: colors.info,
      success: colors.success,
      conflict: colors.warning,
      offline: colors.disabled,
      cloud: colors.primary,
      backup: colors.secondary,
    );
  }

  factory TibebSyncThemeTokens.dark(TibebColorSystem colors) {
    return TibebSyncThemeTokens(
      syncing: colors.info,
      success: colors.success,
      conflict: colors.warning,
      offline: colors.disabled,
      cloud: colors.primary,
      backup: colors.secondary,
    );
  }
}

// 47. TibebAiTheme
class TibebAiThemeTokens {
  final Color aiMessage;
  final Color prompt;
  final Color citation;
  final TextStyle generatedSummary;
  final TextStyle explanation;
  final Color flashcard;
  final Color suggestion;

  const TibebAiThemeTokens({
    required this.aiMessage,
    required this.prompt,
    required this.citation,
    required this.generatedSummary,
    required this.explanation,
    required this.flashcard,
    required this.suggestion,
  });

  factory TibebAiThemeTokens.light(TibebColorSystem colors) {
    return TibebAiThemeTokens(
      aiMessage: colors.surfaceContainerLow,
      prompt: colors.primary,
      citation: colors.outline,
      generatedSummary: const TextStyle(),
      explanation: const TextStyle(),
      flashcard: colors.surfaceContainerLow,
      suggestion: colors.primary,
    );
  }

  factory TibebAiThemeTokens.dark(TibebColorSystem colors) {
    return TibebAiThemeTokens(
      aiMessage: colors.surfaceContainerLow,
      prompt: colors.primary,
      citation: colors.outline,
      generatedSummary: const TextStyle(),
      explanation: const TextStyle(),
      flashcard: colors.surfaceContainerLow,
      suggestion: colors.primary,
    );
  }
}

// 48. TibebKnowledgeGraphTheme
class TibebKnowledgeGraphThemeTokens {
  final Color node;
  final Color edge;
  final Color selectedNode;
  final Color relatedNode;
  final Color bookNode;
  final Color personNode;
  final Color conceptNode;
  final Color tagNode;

  const TibebKnowledgeGraphThemeTokens({
    required this.node,
    required this.edge,
    required this.selectedNode,
    required this.relatedNode,
    required this.bookNode,
    required this.personNode,
    required this.conceptNode,
    required this.tagNode,
  });

  factory TibebKnowledgeGraphThemeTokens.light(TibebColorSystem colors) {
    return TibebKnowledgeGraphThemeTokens(
      node: colors.primary,
      edge: colors.outline,
      selectedNode: colors.primary,
      relatedNode: colors.secondary,
      bookNode: colors.primary,
      personNode: colors.success,
      conceptNode: colors.info,
      tagNode: colors.warning,
    );
  }

  factory TibebKnowledgeGraphThemeTokens.dark(TibebColorSystem colors) {
    return TibebKnowledgeGraphThemeTokens(
      node: colors.primary,
      edge: colors.outline,
      selectedNode: colors.primary,
      relatedNode: colors.secondary,
      bookNode: colors.primary,
      personNode: colors.success,
      conceptNode: colors.info,
      tagNode: colors.warning,
    );
  }
}
