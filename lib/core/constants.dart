import 'package:flutter/material.dart';

/// Tibeb Rank Model
///
/// Represents a reading rank in the Ge'ez-inspired tier system.
/// Ranks are determined by user level + achievement count.
class TibebRank {
  final int level;
  final int achievementsRequired;
  final String name;
  final String nameKey;
  final String description;
  final Color color; 
  final IconData icon;

  const TibebRank({
    required this.level,
    required this.achievementsRequired,
    required this.name,
    required this.nameKey,
    required this.description,
    required this.color,
    required this.icon,
  });
}

/// Tibeb Design System — App Constants
///
/// All visual constants now reference the theme system.
/// Colors, spacing, and radius are in `core/theme/tokens/`.
/// Semantic colors are accessed via `context.tibpiColors`.
abstract final class TibebConstants {
  // ──────────────────────────────────────────────
  // Rank System (Ge'ez-inspired tiers)
  // ──────────────────────────────────────────────
  static const List<TibebRank> ranks = [
    TibebRank(
      level: 1,
      achievementsRequired: 0,
      name: 'ተማሪ (Temari)',
      nameKey: 'rank_temari',
      description: 'Beginning the journey of wisdom.',
      color: Color(0xFF94A3B8), // Slate — novice
      icon: Icons.auto_stories_outlined,
    ),
    TibebRank(
      level: 5,
      achievementsRequired: 2,
      name: 'አንባቢ (Anebabi)',
      nameKey: 'rank_anebabi',
      description: 'Building consistency through reading.',
      color: Color(0xFF3CCB7F), // Green — growth
      icon: Icons.menu_book_rounded,
    ),
    TibebRank(
      level: 10,
      achievementsRequired: 5,
      name: 'ጸሐፊ (Tsehafi)',
      nameKey: 'rank_tsehafi',
      description: 'Writing and reflecting on knowledge.',
      color: Color(0xFF4C7DFF), // Blue — clarity
      icon: Icons.edit_note_rounded,
    ),
    TibebRank(
      level: 20,
      achievementsRequired: 8,
      name: 'ሊቅ (Liq)',
      nameKey: 'rank_liq',
      description: 'Deep understanding and mastery.',
      color: Color(0xFF9B59B6), // Purple — depth
      icon: Icons.psychology_rounded,
    ),
    TibebRank(
      level: 40,
      achievementsRequired: 10,
      name: 'ባለጥበብ (Baletibeb)',
      nameKey: 'rank_baletibeb',
      description: 'Applying wisdom in life.',
      color: Color(0xFFD4A843), // Gold — wisdom
      icon: Icons.workspace_premium_rounded,
    ),
    TibebRank(
      level: 50,
      achievementsRequired: 12,
      name: 'ጥበባዊ (Tibebawi)',
      nameKey: 'rank_tibebawi',
      description: 'Embodiment of wisdom.',
      color: Color(0xFFF5DFA0), // Radiant Gold — mastery
      icon: Icons.diamond_rounded,
    ),
  ];

  /// Get the rank for a given level and achievement count.
  static TibebRank getRankForLevel(int level, int achievementCount) {
    TibebRank current = ranks.first;
    for (final rank in ranks) {
      if (level >= rank.level && achievementCount >= rank.achievementsRequired) {
        current = rank;
      } else {
        break;
      }
    }
    return current;
  }

  /// Get the next rank (or null if at max).
  static TibebRank? getNextRank(int level, int achievementCount) {
    final current = getRankForLevel(level, achievementCount);
    final idx = ranks.indexOf(current);
    if (idx < ranks.length - 1) return ranks[idx + 1];
    return null;
  }

  /// Get progress fraction toward the next rank (0.0 to 1.0).
  static double getRankProgress(int level, int achievementCount) {
    final current = getRankForLevel(level, achievementCount);
    final next = getNextRank(level, achievementCount);
    if (next == null) return 1.0;
    final levelRange = next.level - current.level;
    if (levelRange <= 0) return 1.0;
    return ((level - current.level) / levelRange).clamp(0.0, 1.0);
  }
}
