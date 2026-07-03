import '../../foundation/foundation.dart';
import '../../components/components.dart';

class TibebButtonBuilder {
  const TibebButtonBuilder._();

  static TibebButtonsThemeTokens light(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
  ) {
    return TibebButtonsThemeTokens.light(colors, radius);
  }

  static TibebButtonsThemeTokens dark(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
  ) {
    return TibebButtonsThemeTokens.dark(colors, radius);
  }
}
