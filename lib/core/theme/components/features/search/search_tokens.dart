import 'package:flutter/material.dart';
import '../../../foundation/foundation.dart';

/// Search feature design tokens.
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
      highlightedMatch: const Color(0xFFFFEB3B),
      sectionHeader: TextStyle(
        fontWeight: FontWeight.bold,
        color: colors.textPrimary,
      ),
      filterChip: colors.primary,
      historyItem: colors.textSecondary,
      recentSearch: TextStyle(color: colors.textSecondary),
    );
  }

  factory TibebSearchThemeTokens.dark(TibebColorSystem colors) {
    return TibebSearchThemeTokens(
      resultCard: colors.surfaceBright,
      highlightedMatch: const Color(0xFFFFF176),
      sectionHeader: TextStyle(
        fontWeight: FontWeight.bold,
        color: colors.textPrimary,
      ),
      filterChip: colors.primary,
      historyItem: colors.textSecondary,
      recentSearch: TextStyle(color: colors.textSecondary),
    );
  }
}
