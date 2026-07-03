// ==========================================
// 3. TibebSpacingTokens
// ==========================================
class TibebSpacingTokens {
  final double s0;
  final double s2;
  final double s4;
  final double s6;
  final double s8;
  final double s10;
  final double s12;
  final double s16;
  final double s20;
  final double s24;
  final double s28;
  final double s32;
  final double s40;
  final double s48;
  final double s56;
  final double s64;
  final double s80;
  final double s96;

  const TibebSpacingTokens({
    this.s0 = 0.0,
    this.s2 = 2.0,
    this.s4 = 4.0,
    this.s6 = 6.0,
    this.s8 = 8.0,
    this.s10 = 10.0,
    this.s12 = 12.0,
    this.s16 = 16.0,
    this.s20 = 20.0,
    this.s24 = 24.0,
    this.s28 = 28.0,
    this.s32 = 32.0,
    this.s40 = 40.0,
    this.s48 = 48.0,
    this.s56 = 56.0,
    this.s64 = 64.0,
    this.s80 = 80.0,
    this.s96 = 96.0,
  });

  static const defaultInstance = TibebSpacingTokens();

  TibebSpacingTokens lerp(TibebSpacingTokens? other, double t) {
    return this;
  }
}
