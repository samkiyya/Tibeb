import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tibeb/l10n/app_localizations.dart';
import 'package:tibeb/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationService {
  static const String _languageKey = 'tibeb_language';

  static Future<String> getSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'en';
  }

  static Future<void> saveLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }

  static Locale getLocaleFromLanguage(String languageCode) {
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

  static String getLanguageName(String languageCode) {
    return AppConstants.languageNames[languageCode] ?? 'English';
  }
}

final localizationProvider = Provider<LocalizationService>((ref) {
  return LocalizationService();
});

final currentLocaleProvider = StateProvider<Locale>((ref) {
  return const Locale('en');
});

final supportedLocalesProvider = Provider<List<Locale>>((ref) {
  return const [
    Locale('en'),
    Locale('am'),
    Locale('om'),
    Locale('ti'),
  ];
});

final localizationsDelegatesProvider = Provider<List<LocalizationsDelegate<dynamic>>>((ref) {
  return [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
});