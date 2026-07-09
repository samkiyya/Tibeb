import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tibeb/core/constants/app_constants.dart';

class LocalizationService {
  static const String languageKey = 'tibeb_language';

  static Future<String> getSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(languageKey) ?? 'en';
  }

  static Future<void> saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(languageKey, languageCode);
  }

  static Locale localeFromLanguage(String languageCode) {
    switch (languageCode) {
      case 'am':
        return const Locale('am');
      case 'om':
        return const Locale('om');
      case 'ti':
        return const Locale('ti');
      default:
        return const Locale('en');
    }
  }

  static String languageName(String languageCode) {
    return AppConstants.languageNames[languageCode] ?? 'English';
  }
}

final localizationServiceProvider = Provider<LocalizationService>((ref) {
  return LocalizationService();
});

final currentLocaleProvider =
    NotifierProvider<CurrentLocaleNotifier, Locale>(
  CurrentLocaleNotifier.new,
);

class CurrentLocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    _loadSavedLocale();
    return const Locale('en');
  }

  Future<void> _loadSavedLocale() async {
    final savedLanguage = await LocalizationService.getSavedLanguage();
    state = LocalizationService.localeFromLanguage(savedLanguage);
  }

  Future<void> updateLocale(String languageCode) async {
    await LocalizationService.saveLanguage(languageCode);
    state = LocalizationService.localeFromLanguage(languageCode);
  }

  Future<void> reload() async {
    final savedLanguage = await LocalizationService.getSavedLanguage();
    state = LocalizationService.localeFromLanguage(savedLanguage);
  }
}