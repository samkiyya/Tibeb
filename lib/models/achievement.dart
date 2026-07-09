// lib/models/achievement.dart
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final bool isUnlocked;
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
  });

  // Factory to copy with new unlocked state
  Achievement copyWith({bool? isUnlocked}) {
    return Achievement(
      id: id,
      title: title,
      description: description,
      icon: icon,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  String getTitle(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (id) {
      case 'the_first_page':
        return l10n.achievement_the_first_page;
      case 'habit_builder':
        return l10n.achievement_habit_builder;
      case 'seven_day_streak':
        return l10n.achievement_seven_day_streak;
      case 'bookworm':
        return l10n.achievement_bookworm;
      case 'night_owl':
        return l10n.achievement_night_owl;
      case 'early_bird':
        return l10n.achievement_early_bird;
      case 'century_club':
        return l10n.achievement_century_club;
      case 'unstoppable':
        return l10n.achievement_unstoppable;
      case 'marathoner':
        return l10n.achievement_marathoner;
      case 'scholar':
        return l10n.achievement_scholar;
      case 'yomibito':
        return l10n.achievement_yomibito;
      case 'sensei':
        return l10n.achievement_sensei;
      case 'bibliophile':
        return l10n.achievement_bibliophile;
      case 'collector':
        return l10n.achievement_collector;
      case 'weekend_warrior':
        return l10n.achievement_weekend_warrior;
      case 'the_translator':
        return l10n.achievement_the_translator;
      case 'vocabulary_builder':
        return l10n.achievement_vocabulary_builder;
      case 'polyglot':
        return l10n.achievement_polyglot;
      case 'gondar_keep':
        return l10n.achievement_gondar_keep;
      case 'sheba_wisdom':
        return l10n.achievement_sheba_wisdom;
      case 'axum_legacy':
        return l10n.achievement_axum_legacy;
      case 'fasil_crown':
        return l10n.achievement_fasil_crown;
      case 'yohannes_torch':
        return l10n.achievement_yohannes_torch;
      case 'menelik_library':
        return l10n.achievement_menelik_library;
      case 'lalibela_vigil':
        return l10n.achievement_lalibela_vigil;
      case 'selassie_endurance':
        return l10n.achievement_selassie_endurance;
      case 'geez_mastery':
        return l10n.achievement_geez_mastery;
      case 'qene_poet':
        return l10n.achievement_qene_poet;
      case 'oral_tradition':
        return l10n.achievement_oral_tradition;
      case 'azmari_listener':
        return l10n.achievement_azmari_listener;
      case 'fast_reader':
        return l10n.achievement_fast_reader;
      case 'annotations_scholar':
        return l10n.achievement_annotations_scholar;
      case 'timkat_reader':
        return l10n.achievement_timkat_reader;
      case 'enkutatash_start':
        return l10n.achievement_enkutatash_start;
      case 'epiphany_reader':
        return l10n.achievement_epiphany_reader;
      default:
        return title;
    }
  }

  String getDescription(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (id) {
      case 'the_first_page':
        return l10n.achievement_the_first_page_description;
      case 'habit_builder':
        return l10n.achievement_habit_builder_description;
      case 'seven_day_streak':
        return l10n.achievement_seven_day_streak_description;
      case 'bookworm':
        return l10n.achievement_bookworm_description;
      case 'night_owl':
        return l10n.achievement_night_owl_description;
      case 'early_bird':
        return l10n.achievement_early_bird_description;
      case 'century_club':
        return l10n.achievement_century_club_description;
      case 'unstoppable':
        return l10n.achievement_unstoppable_description;
      case 'marathoner':
        return l10n.achievement_marathoner_description;
      case 'scholar':
        return l10n.achievement_scholar_description;
      case 'yomibito':
        return l10n.achievement_yomibito_description;
      case 'sensei':
        return l10n.achievement_sensei_description;
      case 'bibliophile':
        return l10n.achievement_bibliophile_description;
      case 'collector':
        return l10n.achievement_collector_description;
      case 'weekend_warrior':
        return l10n.achievement_weekend_warrior_description;
      case 'the_translator':
        return l10n.achievement_the_translator_description;
      case 'vocabulary_builder':
        return l10n.achievement_vocabulary_builder_description;
      case 'polyglot':
        return l10n.achievement_polyglot_description;
      case 'gondar_keep':
        return l10n.achievement_gondar_keep_description;
      case 'sheba_wisdom':
        return l10n.achievement_sheba_wisdom_description;
      case 'axum_legacy':
        return l10n.achievement_axum_legacy_description;
      case 'fasil_crown':
        return l10n.achievement_fasil_crown_description;
      case 'yohannes_torch':
        return l10n.achievement_yohannes_torch_description;
      case 'menelik_library':
        return l10n.achievement_menelik_library_description;
      case 'lalibela_vigil':
        return l10n.achievement_lalibela_vigil_description;
      case 'selassie_endurance':
        return l10n.achievement_selassie_endurance_description;
      case 'geez_mastery':
        return l10n.achievement_geez_mastery_description;
      case 'qene_poet':
        return l10n.achievement_qene_poet_description;
      case 'oral_tradition':
        return l10n.achievement_oral_tradition_description;
      case 'azmari_listener':
        return l10n.achievement_azmari_listener_description;
      case 'fast_reader':
        return l10n.achievement_fast_reader_description;
      case 'annotations_scholar':
        return l10n.achievement_annotations_scholar_description;
      case 'timkat_reader':
        return l10n.achievement_timkat_reader_description;
      case 'enkutatash_start':
        return l10n.achievement_enkutatash_start_description;
      case 'epiphany_reader':
        return l10n.achievement_epiphany_reader_description;
      default:
        return description;
    }
  }
}