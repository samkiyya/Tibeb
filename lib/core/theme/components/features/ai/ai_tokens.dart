import 'package:flutter/material.dart';
import '../../../foundation/foundation.dart';

/// AI assistant feature design tokens.
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
      generatedSummary: TextStyle(color: colors.textPrimary),
      explanation: TextStyle(color: colors.textSecondary),
      flashcard: colors.surfaceContainerLow,
      suggestion: colors.primary,
    );
  }

  factory TibebAiThemeTokens.dark(TibebColorSystem colors) {
    return TibebAiThemeTokens(
      aiMessage: colors.surfaceContainerLow,
      prompt: colors.primary,
      citation: colors.outline,
      generatedSummary: TextStyle(color: colors.textPrimary),
      explanation: TextStyle(color: colors.textSecondary),
      flashcard: colors.surfaceContainerLow,
      suggestion: colors.primary,
    );
  }
}
