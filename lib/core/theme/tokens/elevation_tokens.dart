import 'package:flutter/material.dart';

// ==========================================
// 5. TibebElevationTokens
// ==========================================
class TibebElevationTokens {
  final List<BoxShadow> level0;
  final List<BoxShadow> level1;
  final List<BoxShadow> level2;
  final List<BoxShadow> level3;
  final List<BoxShadow> level4;
  final List<BoxShadow> level5;

  const TibebElevationTokens({
    required this.level0,
    required this.level1,
    required this.level2,
    required this.level3,
    required this.level4,
    required this.level5,
  });

  static TibebElevationTokens dark() {
    return const TibebElevationTokens(
      level0: [],
      level1: [
        BoxShadow(color: Colors.black26, offset: Offset(0, 1), blurRadius: 3),
      ],
      level2: [
        BoxShadow(color: Colors.black38, offset: Offset(0, 2), blurRadius: 6),
      ],
      level3: [
        BoxShadow(color: Colors.black45, offset: Offset(0, 4), blurRadius: 10),
      ],
      level4: [
        BoxShadow(color: Colors.black54, offset: Offset(0, 8), blurRadius: 16),
      ],
      level5: [
        BoxShadow(color: Colors.black54, offset: Offset(0, 12), blurRadius: 24),
      ],
    );
  }

  static TibebElevationTokens light() {
    return const TibebElevationTokens(
      level0: [],
      level1: [
        BoxShadow(
          color: Color(0x1F000000),
          offset: Offset(0, 1),
          blurRadius: 3,
        ),
      ],
      level2: [
        BoxShadow(
          color: Color(0x24000000),
          offset: Offset(0, 2),
          blurRadius: 6,
        ),
      ],
      level3: [
        BoxShadow(
          color: Color(0x29000000),
          offset: Offset(0, 4),
          blurRadius: 10,
        ),
      ],
      level4: [
        BoxShadow(
          color: Color(0x2E000000),
          offset: Offset(0, 8),
          blurRadius: 16,
        ),
      ],
      level5: [
        BoxShadow(
          color: Color(0x33000000),
          offset: Offset(0, 12),
          blurRadius: 24,
        ),
      ],
    );
  }

  TibebElevationTokens lerp(TibebElevationTokens? other, double t) {
    return this;
  }
}
