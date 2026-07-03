import 'package:flutter/material.dart';
import '../semantics/design_tokens.dart';

// ==========================================
// Progress Indicators Theme & Tokens
// ==========================================
class TibebProgressIndicatorsThemeTokens {
  final ProgressIndicatorThemeData linear;
  final ProgressIndicatorThemeData circular;
  final Color readingProgress;
  final Color downloadProgress;
  final Color audiobookProgress;
  final Color syncProgress;

  const TibebProgressIndicatorsThemeTokens({
    required this.linear,
    required this.circular,
    required this.readingProgress,
    required this.downloadProgress,
    required this.audiobookProgress,
    required this.syncProgress,
  });

  factory TibebProgressIndicatorsThemeTokens.light(TibebColorSystem colors) {
    return TibebProgressIndicatorsThemeTokens(
      linear: ProgressIndicatorThemeData(color: colors.primary),
      circular: ProgressIndicatorThemeData(color: colors.primary),
      readingProgress: colors.primary,
      downloadProgress: colors.info,
      audiobookProgress: colors.secondary,
      syncProgress: colors.success,
    );
  }

  factory TibebProgressIndicatorsThemeTokens.dark(TibebColorSystem colors) {
    return TibebProgressIndicatorsThemeTokens(
      linear: ProgressIndicatorThemeData(color: colors.primary),
      circular: ProgressIndicatorThemeData(color: colors.primary),
      readingProgress: colors.primary,
      downloadProgress: colors.info,
      audiobookProgress: colors.secondary,
      syncProgress: colors.success,
    );
  }
}

class TibebProgressTheme {
  const TibebProgressTheme._();

  static ProgressIndicatorThemeData dark(
    TibebProgressIndicatorsThemeTokens tokens,
    Color surfaceColor,
  ) {
    return _build(tokens, surfaceColor);
  }

  static ProgressIndicatorThemeData light(
    TibebProgressIndicatorsThemeTokens tokens,
    Color surfaceColor,
  ) {
    return _build(tokens, surfaceColor);
  }

  static ProgressIndicatorThemeData _build(
    TibebProgressIndicatorsThemeTokens tokens,
    Color surfaceColor,
  ) {
    return ProgressIndicatorThemeData(
      color: tokens.linear.color,
      linearTrackColor: surfaceColor,
      circularTrackColor: surfaceColor,
    );
  }
}

// ==========================================
// Loading Theme & Tokens
// ==========================================
class TibebLoadingThemeTokens {
  final Color skeleton;
  final Color shimmer;
  final Color spinner;
  final Color placeholder;

  const TibebLoadingThemeTokens({
    required this.skeleton,
    required this.shimmer,
    required this.spinner,
    required this.placeholder,
  });

  factory TibebLoadingThemeTokens.light(TibebColorSystem colors) {
    return TibebLoadingThemeTokens(
      skeleton: colors.outlineVariant,
      shimmer: colors.surfaceContainer,
      spinner: colors.primary,
      placeholder: colors.outline,
    );
  }

  factory TibebLoadingThemeTokens.dark(TibebColorSystem colors) {
    return TibebLoadingThemeTokens(
      skeleton: colors.outlineVariant,
      shimmer: colors.surfaceContainer,
      spinner: colors.primary,
      placeholder: colors.outline,
    );
  }
}

// ==========================================
// EmptyState Theme & Tokens
// ==========================================
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

// ==========================================
// ErrorState Theme & Tokens
// ==========================================
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
