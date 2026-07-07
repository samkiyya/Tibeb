import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Helpers for the staggered entrance animations on the dashboard.
///
/// When [enabled] is true (the screen has already animated once), the widget
/// is returned unchanged — no re-animation on rebuild.
class DashboardAnimation {
  const DashboardAnimation._();

  static Widget fadeSlide(
    Widget child,
    bool enabled, {
    Duration delay = Duration.zero,
    double slideBegin = 0.1,
  }) {
    if (enabled) return child;
    return child
        .animate()
        .fadeIn(delay: delay, duration: 600.ms)
        .slideY(begin: slideBegin, end: 0);
  }

  static Widget fadeIn(
    Widget child,
    bool enabled, {
    Duration delay = Duration.zero,
  }) {
    if (enabled) return child;
    return child.animate().fadeIn(delay: delay, duration: 400.ms);
  }

  static Widget scaleIn(
    Widget child,
    bool enabled, {
    Duration delay = Duration.zero,
  }) {
    if (enabled) return child;
    return child
        .animate()
        .fadeIn(delay: delay, duration: 600.ms)
        .scale(begin: const Offset(0.9, 0.9));
  }
}
