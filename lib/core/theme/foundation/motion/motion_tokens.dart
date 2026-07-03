import 'package:flutter/animation.dart';

class TibebMotionTokens {
  // Durations
  static const Duration fast = Duration(milliseconds: 100);
  final Duration durationFast = fast;

  static const Duration normal = Duration(milliseconds: 200);
  final Duration durationNormal = normal;

  static const Duration slow = Duration(milliseconds: 300);
  final Duration durationSlow = slow;

  static const Duration pageTransition = Duration(milliseconds: 350);
  final Duration durationPageTransition = pageTransition;

  static const Duration dialogTransition = Duration(milliseconds: 250);
  final Duration durationDialogTransition = dialogTransition;

  // Curves (Material 3 standard ease curves)
  static const Curve standard = Curves.easeInOutCubic;
  final Curve curveStandard = standard;

  static const Curve emphasized = Curves.fastEaseInToSlowEaseOut;
  final Curve curveEmphasized = emphasized;

  static const Curve decelerate = Curves.easeOutCubic;
  final Curve curveDecelerate = decelerate;

  static const Curve accelerate = Curves.easeInCubic;
  final Curve curveAccelerate = accelerate;

  const TibebMotionTokens();

  TibebMotionTokens lerp(TibebMotionTokens? other, double t) => this;
}
