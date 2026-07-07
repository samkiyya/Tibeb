import 'package:flutter/material.dart';
import '../../../foundation/foundation.dart';

/// Statistics feature design tokens.
class TibebStatisticsThemeTokens {
  final Color charts;
  final Color readingCalendar;
  final Color heatmap;
  final Color streak;
  final Color achievement;
  final Color goal;
  final Color wp;

  const TibebStatisticsThemeTokens({
    required this.charts,
    required this.readingCalendar,
    required this.heatmap,
    required this.streak,
    required this.achievement,
    required this.goal,
    required this.wp,
  });

  factory TibebStatisticsThemeTokens.light(TibebColorSystem colors) {
    return TibebStatisticsThemeTokens(
      charts: colors.primary,
      readingCalendar: colors.primary,
      heatmap: colors.success,
      streak: const Color(0xFFFF6B35),
      achievement: colors.primary,
      goal: colors.primary,
      wp: colors.primary,
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
      wp: colors.primary,
    );
  }
}
