import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class _CustomMaterialLocalizations extends DefaultMaterialLocalizations {
  const _CustomMaterialLocalizations();
}

class CustomMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const CustomMaterialLocalizationsDelegate();


  @override
  bool isSupported(Locale locale) =>
      ['om', 'ti'].contains(locale.languageCode); // Supports Tigrigna, and oromo

  @override
  Future<MaterialLocalizations> load(Locale locale) {
    // Return a SynchronousFuture here because the data is already loaded.
    return SynchronousFuture<MaterialLocalizations>(
      const _CustomMaterialLocalizations(),
    );
  }

  @override
  bool shouldReload(CustomMaterialLocalizationsDelegate old) => false;

  @override
  String toString() => 'CustomMaterialLocalizations.delegate(om, ti)';
}