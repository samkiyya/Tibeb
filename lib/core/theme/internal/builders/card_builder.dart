import '../../foundation/foundation.dart';
import '../../components/components.dart';

class TibebCardBuilder {
  const TibebCardBuilder._();

  static TibebCardThemeTokens light(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
    TibebElevationTokens elevation,
  ) {
    return TibebCardThemeTokens.light(colors, radius, elevation);
  }

  static TibebCardThemeTokens dark(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
    TibebElevationTokens elevation,
  ) {
    return TibebCardThemeTokens.dark(colors, radius, elevation);
  }
}
