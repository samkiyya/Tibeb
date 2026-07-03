import 'package:flutter/material.dart';
import '../../semantics/design_tokens.dart';

class TibebEmptyStateThemeTokens {
  final IconThemeData icon;
  final TextStyle title;
  final TextStyle description;
  final ButtonStyle actionButton;

  const TibebEmptyStateThemeTokens({
    required this.icon,
    required this.title,
    required this.description,
    required this.actionButton,
  });

  factory TibebEmptyStateThemeTokens.light(TibebColorSystem colors) {
    return TibebEmptyStateThemeTokens(
      icon: IconThemeData(color: colors.textSecondary, size: 64),
      title: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      description: const TextStyle(fontSize: 14),
      actionButton: ElevatedButton.styleFrom(backgroundColor: colors.primary),
    );
  }

  factory TibebEmptyStateThemeTokens.dark(TibebColorSystem colors) {
    return TibebEmptyStateThemeTokens(
      icon: IconThemeData(color: colors.textSecondary, size: 64),
      title: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      description: const TextStyle(fontSize: 14),
      actionButton: ElevatedButton.styleFrom(backgroundColor: colors.primary),
    );
  }
}
