import 'package:flutter/material.dart';
import 'package:tibeb/core/rank/tibeb_rank_strings.dart';
import 'package:tibeb/core/rank/tibeb_rank.dart';

extension TibebRankUI on TibebRank {
  String get name => TibebRankStrings.name[id] ?? id;

  String get nameKey => 'rank_$id';

  String get description => TibebRankStrings.description[id] ?? '';

  Color get color {
    switch (id) {
      case 'temari':
        return const Color(0xFF94A3B8); // Slate
      case 'anebabi':
        return const Color(0xFF3CCB7F); // Green
      case 'tsehafi':
        return const Color(0xFF4C7DFF); // Blue
      case 'liq':
        return const Color(0xFF9B59B6); // Purple
      case 'baletibeb':
        return const Color(0xFFD4A843); // Gold
      case 'tibebawi':
        return const Color(0xFFF5DFA0); // Radiant Gold
      default:
        return const Color(0xFF94A3B8);
    }
  }

  IconData get icon {
    switch (id) {
      case 'temari':
        return Icons.auto_stories_outlined;
      case 'anebabi':
        return Icons.menu_book_rounded;
      case 'tsehafi':
        return Icons.edit_note_rounded;
      case 'liq':
        return Icons.psychology_rounded;
      case 'baletibeb':
        return Icons.workspace_premium_rounded;
      case 'tibebawi':
        return Icons.diamond_rounded;
      default:
        return Icons.auto_stories_outlined;
    }
  }

  bool isUnlocked(int level, int achievements) {
    return level >= this.level && achievements >= achievementsRequired;
  }
}
