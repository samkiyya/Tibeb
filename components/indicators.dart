import 'package:flutter/material.dart';

// 23. TibebProgressIndicatorsTheme
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
}

// 33. TibebLoadingTheme
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
}

// 34. TibebEmptyStateTheme
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
}

// 35. TibebErrorStateTheme
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
}
