import 'package:flutter/material.dart';
import '../../semantics/design_tokens.dart';

class TibebErrorStateThemeTokens {
  final Widget illustration;
  final TextStyle title;
  final TextStyle description;
  final ButtonStyle retryButton;

  const TibebErrorStateThemeTokens({
    required this.illustration,
    required this.title,
    required this.description,
    required this.retryButton,
  });

  factory TibebErrorStateThemeTokens.light(TibebColorSystem colors) {
    return TibebErrorStateThemeTokens(
      illustration: const Icon(Icons.error_outline),
      title: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      description: const TextStyle(fontSize: 14),
      retryButton: ElevatedButton.styleFrom(backgroundColor: colors.primary),
    );
  }

  factory TibebErrorStateThemeTokens.dark(TibebColorSystem colors) {
    return TibebErrorStateThemeTokens(
      illustration: const Icon(Icons.error_outline),
      title: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      description: const TextStyle(fontSize: 14),
      retryButton: ElevatedButton.styleFrom(backgroundColor: colors.primary),
    );
  }
}
