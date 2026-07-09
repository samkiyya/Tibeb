import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class _CustomCupertinoLocalizations extends DefaultCupertinoLocalizations {
  const _CustomCupertinoLocalizations();
}
class CustomCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const CustomCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['om', 'ti'].contains(locale.languageCode); // Supports Tigrigna, and oromo
 
 @override
  Future<CupertinoLocalizations> load(Locale locale) {
    // Use English Cupertino strings as fallback
    return SynchronousFuture<CupertinoLocalizations>(
      const _CustomCupertinoLocalizations(),
    );
  }
 

  @override
  bool shouldReload(CustomCupertinoLocalizationsDelegate old) => false;

  @override
  String toString() {
    return 'CustomCupertinoLocalizationsDelegate(om, ti)';
  }
}