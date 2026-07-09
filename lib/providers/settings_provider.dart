import 'package:flutter_riverpod/legacy.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:share_plus/share_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import '../core/theme/tibeb_theme_provider.dart';

/// Settings state management
class SettingsState {
  final bool notificationsEnabled;
  final int reminderHour;
  final int reminderMinute;
  final String? selectedLanguage;
  final bool isLoading;

  const SettingsState({
    this.notificationsEnabled = true,
    this.reminderHour = AppConstants.defaultReminderHour,
    this.reminderMinute = AppConstants.defaultReminderMinute,
    this.selectedLanguage,
    this.isLoading = false,
  });

  SettingsState copyWith({
    bool? notificationsEnabled,
    int? reminderHour,
    int? reminderMinute,
    String? selectedLanguage,
    bool? isLoading,
  }) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Settings notifier
class SettingsNotifier extends StateNotifier<SettingsState> {
  final SharedPreferences _prefs;

  SettingsNotifier(this._prefs) : super(const SettingsState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    state = state.copyWith(isLoading: true);
    
    final notificationsEnabled = _prefs.getBool(AppConstants.notificationsEnabledKey) ?? true;
    final reminderHour = _prefs.getInt(AppConstants.reminderHourKey) ?? AppConstants.defaultReminderHour;
    final reminderMinute = _prefs.getInt(AppConstants.reminderMinuteKey) ?? AppConstants.defaultReminderMinute;
    final selectedLanguage = _prefs.getString(AppConstants.languageKey);

    state = state.copyWith(
      notificationsEnabled: notificationsEnabled,
      reminderHour: reminderHour,
      reminderMinute: reminderMinute,
      selectedLanguage: selectedLanguage,
      isLoading: false,
    );
  }

  Future<void> updateNotificationSettings({
    bool? enabled,
    int? hour,
    int? minute,
  }) async {
    if (enabled != null) {
      await _prefs.setBool(AppConstants.notificationsEnabledKey, enabled);
    }
    if (hour != null) {
      await _prefs.setInt(AppConstants.reminderHourKey, hour);
    }
    if (minute != null) {
      await _prefs.setInt(AppConstants.reminderMinuteKey, minute);
    }

    state = state.copyWith(
      notificationsEnabled: enabled ?? state.notificationsEnabled,
      reminderHour: hour ?? state.reminderHour,
      reminderMinute: minute ?? state.reminderMinute,
    );

    // Note: Notification scheduling should be handled by the calling layer
    // This provider only manages the state
  }

  Future<void> setLanguage(String? language) async {
    if (language != null) {
      await _prefs.setString(AppConstants.languageKey, language);
      state = state.copyWith(selectedLanguage: language);
    }
  }

Future<bool> launchUrl(String url) async {
  try {
    final uri = Uri.parse(url);

    return await launcher.launchUrl(
      uri,
      mode: launcher.LaunchMode.externalApplication,
    );
  } catch (_) {
    return false;
  }
}

Future<void> shareApp() async {
  final shareText =
      'Check out ${AppConstants.appName} - ${AppConstants.appDescription}\n\n'
      '${AppConstants.playStoreUrl}';

  try {
    await SharePlus.instance.share(
      ShareParams(
        text: shareText,
      ),
    );
  } catch (e) {
    throw Exception('Could not share app: $e');
  }
}

  Future<void> rateApp() async {
    // Try to launch the appropriate store based on platform
    try {
      final uri = Uri.parse(AppConstants.playStoreUrl);
      if (await launcher.canLaunchUrl(uri)) {
        await launcher.launchUrl(uri);
      } else {
        throw Exception('Could not launch store URL');
      }
    } catch (e) {
      throw Exception('Could not open store for rating: $e');
    }
  }

  Future<String> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return 'v${packageInfo.version}+${packageInfo.buildNumber}';
  }
}

// Settings provider
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsNotifier(prefs);
});