class TibebOpacityTokens {
  // Standard opacity constants for UI states (interaction states)
  static const double hover = 0.08;
  final double opacityHover = hover;

  static const double focus = 0.12;
  final double opacityFocus = focus;

  static const double pressed = 0.16;
  final double opacityPressed = pressed;

  static const double drag = 0.16;
  final double opacityDrag = drag;

  static const double disabled = 0.38;
  final double opacityDisabled = disabled;

  static const double scrim = 0.60;
  final double opacityScrim = scrim;

  static const double selected = 0.12;
  final double opacitySelected = selected;

  const TibebOpacityTokens();

  TibebOpacityTokens lerp(TibebOpacityTokens? other, double t) => this;
}
