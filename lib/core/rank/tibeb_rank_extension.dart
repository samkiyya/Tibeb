import 'package:flutter/material.dart';
import 'package:tibeb/core/rank/tibeb_rank.dart';
import 'package:tibeb/l10n/app_localizations.dart';

extension TibebRankUI on TibebRank {
  String get nameKey => 'rank_$id';

  String getName(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (id) {
      case 'temari':
        return l10n.rank_temari;
      case 'anebabi':
        return l10n.rank_anebabi;
      case 'tsehafi':
        return l10n.rank_tsehafi;
      case 'liq':
        return l10n.rank_liq;
      case 'baletibeb':
        return l10n.rank_baletibeb;
      case 'tibebawi':
        return l10n.rank_tibebawi;
      default:
        return id;
    }
  }

  String getDescription(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (id) {
      case 'temari':
        return l10n.rank_temari_description;
      case 'anebabi':
        return l10n.rank_anebabi_description;
      case 'tsehafi':
        return l10n.rank_tsehafi_description;
      case 'liq':
        return l10n.rank_liq_description;
      case 'baletibeb':
        return l10n.rank_baletibeb_description;
      case 'tibebawi':
        return l10n.rank_tibebawi_description;
      default:
        return '';
    }
  }

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
        return Icons.import_contacts_rounded;      // open primer/notebook = a student's first reader
      case 'anebabi':
        return Icons.menu_book_rounded;            // open book = the reader, consistently reading
      case 'tsehafi':
        return Icons.draw_rounded;                 // pen/stylus = the scribe writing knowledge
      case 'liq':
        return Icons.psychology_rounded;           // deep mind = the learned scholar's intellect
      case 'baletibeb':
        return Icons.workspace_premium_rounded;    // premium crest = the master craftsman's seal
      case 'tibebawi':
        return Icons.diamond_rounded;              // diamond = the embodiment of wisdom, rare and perfect
      default:
        return Icons.import_contacts_rounded;
    }
  }

  bool isUnlocked(int level, int achievements) {
    return level >= this.level && achievements >= achievementsRequired;
  }
}
