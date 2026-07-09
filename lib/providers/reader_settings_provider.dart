import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tibeb/models/reader_settings_model.dart';
import 'package:tibeb/core/theme/tibeb_theme_provider.dart';
import 'package:tibeb/providers/library_provider.dart';

const String _readerSettingsKey = 'reader_settings';

final readerSettingsProvider =
    StateNotifierProvider<ReaderSettingsNotifier, ReaderSettings>((ref) {
      final prefs = ref.watch(sharedPreferencesProvider);
      return ReaderSettingsNotifier(ref, prefs);
    });

class ReaderSettingsNotifier extends StateNotifier<ReaderSettings> {
  final Ref _ref;
  final SharedPreferences _prefs;
  Timer? _saveTimer;

  ReaderSettingsNotifier(this._ref, this._prefs)
    : super(ReaderSettings.defaults) {
    _loadSettings();
  }

  @override
  void dispose() {
    _saveTimer?.cancel();
    super.dispose();
  }

  void _loadSettings() {
    try {
      final settingsJson = _prefs.getString(_readerSettingsKey);
      if (settingsJson != null) {
        final map = jsonDecode(settingsJson) as Map<String, dynamic>;
        state = ReaderSettings.fromMap(map);
      }
    } catch (e) {
      // Use defaults if loading fails
      state = ReaderSettings.defaults;
    }
  }

  void _saveSettings() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 2), () async {
      try {
        await _prefs.setString(_readerSettingsKey, jsonEncode(state.toMap()));
      } catch (e) {
        // Silently fail - settings will be lost on restart
      }
    });
  }

  void setTheme(ReaderTheme theme) {
    final book = _ref.read(currentlyReadingProvider);
    final isPdf = book?.filePath.toLowerCase().endsWith('.pdf') ?? false;

    if (isPdf) {
      // For PDFs, we update both active theme AND sticky pdfTheme preference
      state = state.copyWith(
        theme: theme,
        pdfTheme: theme,
        usePublisherDefaults: false,
      );
    } else {
      // For EPUBs, we update both active theme AND sticky epubTheme preference
      state = state.copyWith(
        theme: theme,
        epubTheme: theme,
        usePublisherDefaults: false,
      );
    }
    _saveSettings();
  }

  void setTypeface(String typeface) {
    state = state.copyWith(typeface: typeface, usePublisherDefaults: false);
    _saveSettings();
  }

  void setTextSize(double size) {
    state = state.copyWith(
      textSize: size.clamp(12.0, 32.0),
      usePublisherDefaults: false,
    );
    _saveSettings();
  }

  void setLineHeight(double height) {
    state = state.copyWith(
      lineHeight: height.clamp(1.0, 2.5),
      usePublisherDefaults: false,
    );
    _saveSettings();
  }

  void setAlignment(ReaderAlignment alignment) {
    state = state.copyWith(alignment: alignment, usePublisherDefaults: false);
    _saveSettings();
  }

  void togglePublisherDefaults(bool value) {
    if (value) {
      // Reset to defaults when enabled
      state = ReaderSettings.defaults.copyWith(usePublisherDefaults: true);
    } else {
      state = state.copyWith(usePublisherDefaults: false);
    }
    _saveSettings();
  }

  void setAutoScrollSpeed(double speed) {
    state = state.copyWith(autoScrollSpeed: speed);
    _saveSettings();
  }

  void setLockState(ReaderLockState state) {
    this.state = this.state.copyWith(lockState: state);
    _saveSettings();
  }

  void toggleLockState() {
    final nextState = ReaderLockState
        .values[(state.lockState.index + 1) % ReaderLockState.values.length];
    setLockState(nextState);
  }

  void resetToDefaults() {
    state = ReaderSettings.defaults;
    _saveSettings();
  }

  // New methods for settings sheets
  void setFontFamily(String fontFamily) {
    state = state.copyWith(typeface: fontFamily, usePublisherDefaults: false);
    _saveSettings();
  }

  void setFontSize(double fontSize) {
    state = state.copyWith(textSize: fontSize.clamp(12.0, 32.0), usePublisherDefaults: false);
    _saveSettings();
  }

  void setPageMode(String pageMode) {
    // This is a placeholder - page mode logic would need to be implemented
    _saveSettings();
  }

  void setOrientation(String orientation) {
    // This is a placeholder - orientation logic would need to be implemented
    _saveSettings();
  }

  void setReadingTheme(String readingTheme) {
    ReaderTheme theme;
    switch (readingTheme) {
      case 'light':
        theme = ReaderTheme.white;
        break;
      case 'sepia':
        theme = ReaderTheme.cream;
        break;
      case 'dark':
        theme = ReaderTheme.black;
        break;
      default:
        theme = ReaderTheme.black;
    }
    setTheme(theme);
  }
}
