import '../../foundation/foundation.dart';
import '../../components/components.dart';

class TibebDialogBuilder {
  const TibebDialogBuilder._();

  static TibebDialogThemeTokens light(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
  ) {
    return TibebDialogThemeTokens.light(colors, radius);
  }

  static TibebDialogThemeTokens dark(
    TibebColorSystem colors,
    TibebRadiusTokens radius,
  ) {
    return TibebDialogThemeTokens.dark(colors, radius);
  }
}
