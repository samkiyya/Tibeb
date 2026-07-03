import 'package:flutter/material.dart';
import '../../../foundation/foundation.dart';

/// Dictionary feature design tokens.
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
    return TibebDictionaryThemeTokens(
      word: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: colors.textPrimary,
      ),
      pronunciation: TextStyle(
        fontStyle: FontStyle.italic,
        color: colors.textSecondary,
      ),
      meaning: TextStyle(color: colors.textPrimary),
      example: TextStyle(
        fontStyle: FontStyle.italic,
        color: colors.textSecondary,
      ),
      synonyms: TextStyle(color: colors.info),
      antonyms: TextStyle(color: colors.error),
      partOfSpeech: TextStyle(
        fontWeight: FontWeight.w600,
        color: colors.primary,
      ),
    );
  }

  factory TibebDictionaryThemeTokens.dark(TibebColorSystem colors) {
    return TibebDictionaryThemeTokens(
      word: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: colors.textPrimary,
      ),
      pronunciation: TextStyle(
        fontStyle: FontStyle.italic,
        color: colors.textSecondary,
      ),
      meaning: TextStyle(color: colors.textPrimary),
      example: TextStyle(
        fontStyle: FontStyle.italic,
        color: colors.textSecondary,
      ),
      synonyms: TextStyle(color: colors.info),
      antonyms: TextStyle(color: colors.error),
      partOfSpeech: TextStyle(
        fontWeight: FontWeight.w600,
        color: colors.primary,
      ),
    );
  }
}
