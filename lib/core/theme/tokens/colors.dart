import 'package:flutter/material.dart';

/// Tibeb Design System — Color Palette
///
/// All colors defined here are raw palette values.
/// Semantic usage is mapped via [TibebColorScheme] and [TibebThemeExtension].
/// Never reference these directly in widgets — use `context.tibpiColors` instead.
abstract final class TibebPalette {
  // ──────────────────────────────────────────────
  // Neutrals (AMOLED-tuned dark scale)
  // ──────────────────────────────────────────────
  static const Color ink       = Color(0xFF0A0B0E); // AMOLED black
  static const Color charcoal  = Color(0xFF111826); // Dark surface
  static const Color slate     = Color(0xFF1E293B); // Elevated surface (Slate 800)
  static const Color graphite  = Color(0xFF2C3547); // Card / sheet backgrounds
  static const Color steel     = Color(0xFF475569); // Disabled / tertiary text (Slate 600)
  static const Color ash       = Color(0xFF94A3B8); // Secondary text (Slate 400)
  static const Color cloud     = Color(0xFFCBD5E1); // Subtitle / muted (Slate 300)
  static const Color paper     = Color(0xFFE8E6E3); // Light body text on dark bg
  static const Color snow      = Color(0xFFF8FAFC); // Pure light background

  // ──────────────────────────────────────────────
  // Brand — Wisdom Gold
  // ──────────────────────────────────────────────
  static const Color wisdom       = Color(0xFFD4A843); // Primary brand gold
  static const Color wisdomLight  = Color(0xFFF5DFA0); // Hover / light variant
  static const Color wisdomDark   = Color(0xFF9C7B2F); // Pressed / dark variant

  // ──────────────────────────────────────────────
  // Accent — Knowledge Blue
  // ──────────────────────────────────────────────
  static const Color blue       = Color(0xFF4C7DFF); // Links, interactive
  static const Color blueLight  = Color(0xFF7DA3FF); // Hover
  static const Color blueDark   = Color(0xFF2A5ADB); // Pressed

  // ──────────────────────────────────────────────
  // Status
  // ──────────────────────────────────────────────
  static const Color success      = Color(0xFF3CCB7F); // Green - achievement, complete
  static const Color successLight = Color(0xFF6EDDAA);
  static const Color warning      = Color(0xFFF4B740); // Yellow - attention
  static const Color warningLight = Color(0xFFFDD87D);
  static const Color error        = Color(0xFFFF5A5F); // Red - destructive
  static const Color errorLight   = Color(0xFFFF8C8F);

  // ──────────────────────────────────────────────
  // Highlight palette (reading annotations)
  // ──────────────────────────────────────────────
  static const Color highlightRed    = Color(0xFFE74C3C);
  static const Color highlightYellow = Color(0xFFF1C40F);
  static const Color highlightGreen  = Color(0xFF2ECC71);
  static const Color highlightBlue   = Color(0xFF3498DB);
  static const Color highlightPurple = Color(0xFF9B59B6);

  static const List<Color> highlightColors = [
    highlightRed,
    highlightYellow,
    highlightGreen,
    highlightBlue,
    highlightPurple,
  ];

  // ──────────────────────────────────────────────
  // Activity graph (GitHub-style heatmap)
  // ──────────────────────────────────────────────
  static const List<Color> graphLevels = [
    Color(0xFF161B22), // empty
    Color(0xFF0E4429), // level 1
    Color(0xFF006D32), // level 2
    Color(0xFF26A641), // level 3
    Color(0xFF39D353), // level 4
  ];

  // ──────────────────────────────────────────────
  // Reader themes
  // ──────────────────────────────────────────────
  static const Color readerWhite    = Color(0xFFFFFFFF);
  static const Color readerCream    = Color(0xFFF5F0E1);
  static const Color readerDarkBlue = Color(0xFF1A2744);
  static const Color readerBlack    = Color(0xFF0A0B0E);

  // ──────────────────────────────────────────────
  // Glassmorphism
  // ──────────────────────────────────────────────
  static const Color glassWhite   = Color(0x1AFFFFFF);  // 10% white
  static const Color glassBorder  = Color(0x33FFFFFF);  // 20% white
  static const Color glassOverlay = Color(0x80000000);  // 50% black

  // ──────────────────────────────────────────────
  // Light theme specific
  // ──────────────────────────────────────────────
  static const Color lightBackground  = Color(0xFFF8FAFC);
  static const Color lightSurface     = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);
}