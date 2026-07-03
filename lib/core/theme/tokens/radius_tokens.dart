import 'package:flutter/material.dart';

// ==========================================
// 4. TibebRadiusTokens
// ==========================================
class TibebRadiusTokens {
  final BorderRadius none;
  final BorderRadius xs;
  final BorderRadius sm;
  final BorderRadius md;
  final BorderRadius lg;
  final BorderRadius xl;
  final BorderRadius xxl;
  final BorderRadius pill;
  final BorderRadius circle;

  const TibebRadiusTokens({
    required this.none,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.pill,
    required this.circle,
  });

  static TibebRadiusTokens create() {
    return TibebRadiusTokens(
      none: BorderRadius.zero,
      xs: BorderRadius.circular(4.0),
      sm: BorderRadius.circular(8.0),
      md: BorderRadius.circular(12.0),
      lg: BorderRadius.circular(16.0),
      xl: BorderRadius.circular(20.0),
      xxl: BorderRadius.circular(24.0),
      pill: BorderRadius.circular(999.0),
      circle: BorderRadius.circular(9999.0),
    );
  }

  TibebRadiusTokens lerp(TibebRadiusTokens? other, double t) {
    if (other == null) return this;
    return TibebRadiusTokens(
      none: BorderRadius.lerp(none, other.none, t)!,
      xs: BorderRadius.lerp(xs, other.xs, t)!,
      sm: BorderRadius.lerp(sm, other.sm, t)!,
      md: BorderRadius.lerp(md, other.md, t)!,
      lg: BorderRadius.lerp(lg, other.lg, t)!,
      xl: BorderRadius.lerp(xl, other.xl, t)!,
      xxl: BorderRadius.lerp(xxl, other.xxl, t)!,
      pill: BorderRadius.lerp(pill, other.pill, t)!,
      circle: BorderRadius.lerp(circle, other.circle, t)!,
    );
  }
}
