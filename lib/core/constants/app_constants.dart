/// App-wide constants for Tibeb
/// 
/// This file contains all constant values used throughout the application
/// including URLs, app information, and configuration values.
class AppConstants {
  AppConstants._();

  // App Information
  static const String appName = 'tibeb';
  static const String appDescription = 'tibeb is a free book + audiobook reader for everyone.';
  
  // Support and Developer Links
  static const String supportUrl = 'https://www.gurshaplus.com/samkiyya';
  static const String githubUrl = 'https://github.com/samkiyya/tibeb';
  static const String privacyPolicyUrl = 'https://github.com/samkiyya/tibeb/blob/main/PRIVACY.md';
  static const String termsOfServiceUrl = 'https://github.com/samkiyya/tibeb/blob/main/TERMS.md';
  
  // Store URLs (for rating)
  static const String playStoreUrl = 'https://play.google.com/store/apps/details?id=com.samkiyya.tibeb';
  static const String appStoreUrl = 'https://apps.apple.com/app/tibeb/id123456789'; // Placeholder
  
  // Social Media
  static const String twitterUrl = 'https://twitter.com/samkiyya';
  static const String linkedInUrl = 'https://linkedin.com/in/samkiyya';
  
  // Feature Flags
  static const bool languageToggleEnabled = false; // Coming soon
  static const bool syncEnabled = false; // Coming soon
  static const bool cloudEnabled = false; // Coming soon
  
  // Default Settings
  static const int defaultReminderHour = 20;
  static const int defaultReminderMinute = 0;
  static const double defaultWeeklyPageGoal = 100.0;
  static const double defaultWeeklyMinuteGoal = 0.0;
  static const double defaultWeeklyWPGoal = 0.0;
  static const String defaultGoalType = 'pages';
  
  // Notification IDs
  static const int dailyReminderNotificationId = 999;
  static const int weekendBoostNotificationId = 1000;
  static const int weekendBoostNotificationId2 = 1001;
  static const int testNotificationId = 888;
  
  // SharedPreferences Keys
  static const String themeModeKey = 'tibeb_theme_mode';
  static const String notificationsEnabledKey = 'notificationsEnabled';
  static const String reminderHourKey = 'reminderHour';
  static const String reminderMinuteKey = 'reminderMinute';
  static const String weeklyPageGoalKey = 'weeklyPageGoal';
  static const String weeklyMinuteGoalKey = 'weeklyMinuteGoal';
  static const String weeklyWPGoalKey = 'weeklyWPGoal';
  static const String weeklyGoalTypeKey = 'weeklyGoalType';
  static const String lastCelebratedLevelKey = 'lastCelebratedLevel';
  static const String totalLookupsKey = 'totalLookups';
  static const String languageKey = 'tibeb_language';
  
  // Supported Languages (for future localization)
  static const List<String> supportedLanguages = ['en', 'am', 'om', 'ti'];
  static const Map<String, String> languageNames = {
    'en': 'English',
    'am': 'አማርኛ',
    'om': 'Afaan Oromoo',
    'ti': 'ትግርኛ',
  };
}

/// Settings section categories for organization
class SettingsSection {
  SettingsSection._();

  static const String engagement = 'engagement';
  static const String notifications = 'notifications';
  static const String appearance = 'appearance';
  static const String language = 'language';
  static const String support = 'support';
  static const String about = 'about';
}