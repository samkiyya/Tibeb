import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_am.dart';
import 'app_localizations_en.dart';
import 'app_localizations_om.dart';
import 'app_localizations_ti.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('am'),
    Locale('en'),
    Locale('om'),
    Locale('ti'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Tibeb'**
  String get appName;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'Tibeb is a free book and audiobook reader for everyone.'**
  String get appDescription;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @library.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get library;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get stats;

  /// No description provided for @engagement.
  ///
  /// In en, this message translates to:
  /// **'Engagement'**
  String get engagement;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @totalWP.
  ///
  /// In en, this message translates to:
  /// **'Total WP'**
  String get totalWP;

  /// No description provided for @streak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streak;

  /// No description provided for @pages.
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get pages;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @alerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alerts;

  /// No description provided for @readingPreferences.
  ///
  /// In en, this message translates to:
  /// **'Reading Preferences'**
  String get readingPreferences;

  /// No description provided for @fontSettings.
  ///
  /// In en, this message translates to:
  /// **'Font Settings'**
  String get fontSettings;

  /// No description provided for @customizeReadingExperience.
  ///
  /// In en, this message translates to:
  /// **'Customize your reading experience'**
  String get customizeReadingExperience;

  /// No description provided for @displayMode.
  ///
  /// In en, this message translates to:
  /// **'Display Mode'**
  String get displayMode;

  /// No description provided for @pageLayoutOrientation.
  ///
  /// In en, this message translates to:
  /// **'Page layout and orientation'**
  String get pageLayoutOrientation;

  /// No description provided for @readingSpeed.
  ///
  /// In en, this message translates to:
  /// **'Reading Speed'**
  String get readingSpeed;

  /// No description provided for @autoScrollPacing.
  ///
  /// In en, this message translates to:
  /// **'Auto-scroll and pacing'**
  String get autoScrollPacing;

  /// No description provided for @appExperience.
  ///
  /// In en, this message translates to:
  /// **'App Experience'**
  String get appExperience;

  /// No description provided for @dailyReminders.
  ///
  /// In en, this message translates to:
  /// **'Daily Reminders'**
  String get dailyReminders;

  /// No description provided for @keepReadingStreakAlive.
  ///
  /// In en, this message translates to:
  /// **'Keep your reading streak alive'**
  String get keepReadingStreakAlive;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @dataPermissions.
  ///
  /// In en, this message translates to:
  /// **'Data and permissions'**
  String get dataPermissions;

  /// No description provided for @storage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get storage;

  /// No description provided for @manageAppData.
  ///
  /// In en, this message translates to:
  /// **'Manage app data'**
  String get manageAppData;

  /// No description provided for @supportAbout.
  ///
  /// In en, this message translates to:
  /// **'Support and About'**
  String get supportAbout;

  /// No description provided for @reminderTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder Time'**
  String get reminderTime;

  /// No description provided for @testNotification.
  ///
  /// In en, this message translates to:
  /// **'Test Notification'**
  String get testNotification;

  /// No description provided for @receiveTestAlert.
  ///
  /// In en, this message translates to:
  /// **'Receive a test notification to verify that reminders work.'**
  String get receiveTestAlert;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @languageSupportComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Language support is coming soon! We\'re working hard to bring you multiple language options.'**
  String get languageSupportComingSoon;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get gotIt;

  /// No description provided for @maybeLater.
  ///
  /// In en, this message translates to:
  /// **'Maybe Later'**
  String get maybeLater;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @notificationsBlocked.
  ///
  /// In en, this message translates to:
  /// **'Notifications Blocked'**
  String get notificationsBlocked;

  /// No description provided for @notificationsBlockedMessage.
  ///
  /// In en, this message translates to:
  /// **'Reading reminders are currently blocked by your system settings. Please enable them to stay on track!'**
  String get notificationsBlockedMessage;

  /// No description provided for @notificationPermissionsRequired.
  ///
  /// In en, this message translates to:
  /// **'Notification permissions are required for reminders.'**
  String get notificationPermissionsRequired;

  /// No description provided for @madeWithLove.
  ///
  /// In en, this message translates to:
  /// **'Made with ❤️ by Samuel'**
  String get madeWithLove;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @continueReading.
  ///
  /// In en, this message translates to:
  /// **'Continue Reading'**
  String get continueReading;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// No description provided for @recentBooks.
  ///
  /// In en, this message translates to:
  /// **'Recent Books'**
  String get recentBooks;

  /// No description provided for @quickStats.
  ///
  /// In en, this message translates to:
  /// **'Quick Stats'**
  String get quickStats;

  /// No description provided for @weeklyActivity.
  ///
  /// In en, this message translates to:
  /// **'Weekly Activity'**
  String get weeklyActivity;

  /// No description provided for @myShelf.
  ///
  /// In en, this message translates to:
  /// **'My Shelf'**
  String get myShelf;

  /// No description provided for @searchBooks.
  ///
  /// In en, this message translates to:
  /// **'Search books...'**
  String get searchBooks;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @addBook.
  ///
  /// In en, this message translates to:
  /// **'Add Book'**
  String get addBook;

  /// No description provided for @importBooks.
  ///
  /// In en, this message translates to:
  /// **'Import Books'**
  String get importBooks;

  /// No description provided for @emptyLibrary.
  ///
  /// In en, this message translates to:
  /// **'Your library is empty'**
  String get emptyLibrary;

  /// No description provided for @emptyLibraryMessage.
  ///
  /// In en, this message translates to:
  /// **'Import your first book to get started'**
  String get emptyLibraryMessage;

  /// No description provided for @importNow.
  ///
  /// In en, this message translates to:
  /// **'Import Now'**
  String get importNow;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @thisYear.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get thisYear;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'See More'**
  String get seeMore;

  /// No description provided for @searchTitlesAuthors.
  ///
  /// In en, this message translates to:
  /// **'Search titles, authors...'**
  String get searchTitlesAuthors;

  /// No description provided for @filterSort.
  ///
  /// In en, this message translates to:
  /// **'Filter and Sort'**
  String get filterSort;

  /// No description provided for @addBooks.
  ///
  /// In en, this message translates to:
  /// **'Add Books'**
  String get addBooks;

  /// No description provided for @editBookInfo.
  ///
  /// In en, this message translates to:
  /// **'Edit Book Information'**
  String get editBookInfo;

  /// No description provided for @storagePermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Storage permission is required to import books.'**
  String get storagePermissionRequired;

  /// No description provided for @successfullyImported.
  ///
  /// In en, this message translates to:
  /// **'Successfully imported {count} books.'**
  String successfullyImported(Object count);

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @author.
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get author;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @folder.
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get folder;

  /// No description provided for @fileType.
  ///
  /// In en, this message translates to:
  /// **'File Type'**
  String get fileType;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @readingStats.
  ///
  /// In en, this message translates to:
  /// **'Reading Stats'**
  String get readingStats;

  /// No description provided for @readingActivity.
  ///
  /// In en, this message translates to:
  /// **'Reading Activity'**
  String get readingActivity;

  /// No description provided for @selectMonth.
  ///
  /// In en, this message translates to:
  /// **'Select Month'**
  String get selectMonth;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @dailyQuests.
  ///
  /// In en, this message translates to:
  /// **'Daily Quests'**
  String get dailyQuests;

  /// No description provided for @doubleWP.
  ///
  /// In en, this message translates to:
  /// **'2X WP'**
  String get doubleWP;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @rewardWP.
  ///
  /// In en, this message translates to:
  /// **'Reward: {count} WP'**
  String rewardWP(Object count);

  /// No description provided for @weeklyGoals.
  ///
  /// In en, this message translates to:
  /// **'Weekly Goals'**
  String get weeklyGoals;

  /// No description provided for @noGoalsSet.
  ///
  /// In en, this message translates to:
  /// **'No goals set for this week'**
  String get noGoalsSet;

  /// No description provided for @currentLevel.
  ///
  /// In en, this message translates to:
  /// **'Current Level'**
  String get currentLevel;

  /// No description provided for @wpToLevelUp.
  ///
  /// In en, this message translates to:
  /// **'{count} WP to level up'**
  String wpToLevelUp(Object count);

  /// No description provided for @searchBook.
  ///
  /// In en, this message translates to:
  /// **'Search book...'**
  String get searchBook;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @importAudiobook.
  ///
  /// In en, this message translates to:
  /// **'Import Audiobook'**
  String get importAudiobook;

  /// No description provided for @cover.
  ///
  /// In en, this message translates to:
  /// **'Cover'**
  String get cover;

  /// No description provided for @importing.
  ///
  /// In en, this message translates to:
  /// **'Importing...'**
  String get importing;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @bookUpdated.
  ///
  /// In en, this message translates to:
  /// **'Book updated'**
  String get bookUpdated;

  /// No description provided for @series.
  ///
  /// In en, this message translates to:
  /// **'Series'**
  String get series;

  /// No description provided for @tagsCommaSeparated.
  ///
  /// In en, this message translates to:
  /// **'Tags (comma separated)'**
  String get tagsCommaSeparated;

  /// No description provided for @audiobookParts.
  ///
  /// In en, this message translates to:
  /// **'Audiobook Parts'**
  String get audiobookParts;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @noAudioPartsAttached.
  ///
  /// In en, this message translates to:
  /// **'No audio parts attached.'**
  String get noAudioPartsAttached;

  /// No description provided for @addParts.
  ///
  /// In en, this message translates to:
  /// **'Add Parts'**
  String get addParts;

  /// No description provided for @bookCover.
  ///
  /// In en, this message translates to:
  /// **'Book Cover'**
  String get bookCover;

  /// No description provided for @changeCover.
  ///
  /// In en, this message translates to:
  /// **'Change Cover'**
  String get changeCover;

  /// No description provided for @searchOnline.
  ///
  /// In en, this message translates to:
  /// **'Search Online'**
  String get searchOnline;

  /// No description provided for @selectFiles.
  ///
  /// In en, this message translates to:
  /// **'Select Files'**
  String get selectFiles;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @supportDeveloper.
  ///
  /// In en, this message translates to:
  /// **'Support the Developer'**
  String get supportDeveloper;

  /// No description provided for @supportDeveloperSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Support the developer and the project ❤️'**
  String get supportDeveloperSubtitle;

  /// No description provided for @contributeGitHub.
  ///
  /// In en, this message translates to:
  /// **'Contribute on GitHub'**
  String get contributeGitHub;

  /// No description provided for @contributeGitHubSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help build the future of Tibeb 🚀'**
  String get contributeGitHubSubtitle;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate the App'**
  String get rateApp;

  /// No description provided for @rateAppSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Love Tibeb? Leave us a review! ⭐'**
  String get rateAppSubtitle;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share the App'**
  String get shareApp;

  /// No description provided for @shareAppSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share Tibeb with friends 📢'**
  String get shareAppSubtitle;

  /// No description provided for @pagesRead.
  ///
  /// In en, this message translates to:
  /// **'Pages Read'**
  String get pagesRead;

  /// No description provided for @minutesRead.
  ///
  /// In en, this message translates to:
  /// **'Minutes Read'**
  String get minutesRead;

  /// No description provided for @wisdomPoints.
  ///
  /// In en, this message translates to:
  /// **'Wisdom Points (WP)'**
  String get wisdomPoints;

  /// No description provided for @noBookSelected.
  ///
  /// In en, this message translates to:
  /// **'No book selected'**
  String get noBookSelected;

  /// No description provided for @tapToSelectBook.
  ///
  /// In en, this message translates to:
  /// **'Tap to select a book'**
  String get tapToSelectBook;

  /// No description provided for @readingTime.
  ///
  /// In en, this message translates to:
  /// **'Reading Time'**
  String get readingTime;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @chapter.
  ///
  /// In en, this message translates to:
  /// **'Chapter'**
  String get chapter;

  /// No description provided for @chapters.
  ///
  /// In en, this message translates to:
  /// **'Chapters'**
  String get chapters;

  /// No description provided for @page.
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get page;

  /// No description provided for @ofLabel.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get ofLabel;

  /// No description provided for @bookmarkAdded.
  ///
  /// In en, this message translates to:
  /// **'Bookmark added'**
  String get bookmarkAdded;

  /// No description provided for @bookmarkRemoved.
  ///
  /// In en, this message translates to:
  /// **'Bookmark removed'**
  String get bookmarkRemoved;

  /// No description provided for @highlightAdded.
  ///
  /// In en, this message translates to:
  /// **'Highlight added'**
  String get highlightAdded;

  /// No description provided for @noteAdded.
  ///
  /// In en, this message translates to:
  /// **'Note added'**
  String get noteAdded;

  /// No description provided for @noBookmarks.
  ///
  /// In en, this message translates to:
  /// **'No bookmarks yet'**
  String get noBookmarks;

  /// No description provided for @noHighlights.
  ///
  /// In en, this message translates to:
  /// **'No highlights yet'**
  String get noHighlights;

  /// No description provided for @noNotes.
  ///
  /// In en, this message translates to:
  /// **'No notes yet'**
  String get noNotes;

  /// No description provided for @addBookmark.
  ///
  /// In en, this message translates to:
  /// **'Add bookmark'**
  String get addBookmark;

  /// No description provided for @addHighlight.
  ///
  /// In en, this message translates to:
  /// **'Add highlight'**
  String get addHighlight;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add note'**
  String get addNote;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchInBook.
  ///
  /// In en, this message translates to:
  /// **'Search in book'**
  String get searchInBook;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @resultsFound.
  ///
  /// In en, this message translates to:
  /// **'{count} results found'**
  String resultsFound(Object count);

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get settingsSaved;

  /// No description provided for @themeChanged.
  ///
  /// In en, this message translates to:
  /// **'Theme changed'**
  String get themeChanged;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed'**
  String get languageChanged;

  /// No description provided for @fontChanged.
  ///
  /// In en, this message translates to:
  /// **'Font changed'**
  String get fontChanged;

  /// No description provided for @backupCreated.
  ///
  /// In en, this message translates to:
  /// **'Backup created'**
  String get backupCreated;

  /// No description provided for @backupRestored.
  ///
  /// In en, this message translates to:
  /// **'Backup restored'**
  String get backupRestored;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @deleteBook.
  ///
  /// In en, this message translates to:
  /// **'Delete Book'**
  String get deleteBook;

  /// No description provided for @deleteBookConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this book?'**
  String get deleteBookConfirm;

  /// No description provided for @deleteBooks.
  ///
  /// In en, this message translates to:
  /// **'Delete Books'**
  String get deleteBooks;

  /// No description provided for @deleteBooksConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {count} books?'**
  String deleteBooksConfirm(Object count);

  /// No description provided for @bookDeleted.
  ///
  /// In en, this message translates to:
  /// **'Book deleted'**
  String get bookDeleted;

  /// No description provided for @booksDeleted.
  ///
  /// In en, this message translates to:
  /// **'{count} books deleted'**
  String booksDeleted(Object count);

  /// No description provided for @removeBook.
  ///
  /// In en, this message translates to:
  /// **'Remove Book'**
  String get removeBook;

  /// No description provided for @removeReadingHistory.
  ///
  /// In en, this message translates to:
  /// **'Remove reading history'**
  String get removeReadingHistory;

  /// No description provided for @addToCategory.
  ///
  /// In en, this message translates to:
  /// **'Add to Category'**
  String get addToCategory;

  /// No description provided for @enterCategoryName.
  ///
  /// In en, this message translates to:
  /// **'Enter category name'**
  String get enterCategoryName;

  /// No description provided for @goalTitle.
  ///
  /// In en, this message translates to:
  /// **'Reading Goal'**
  String get goalTitle;

  /// No description provided for @goalDescription.
  ///
  /// In en, this message translates to:
  /// **'Set your weekly reading goal'**
  String get goalDescription;

  /// No description provided for @pagesPerWeek.
  ///
  /// In en, this message translates to:
  /// **'Pages per week'**
  String get pagesPerWeek;

  /// No description provided for @minutesPerWeek.
  ///
  /// In en, this message translates to:
  /// **'Minutes per week'**
  String get minutesPerWeek;

  /// No description provided for @pagesGoal.
  ///
  /// In en, this message translates to:
  /// **'Pages goal'**
  String get pagesGoal;

  /// No description provided for @minutesGoal.
  ///
  /// In en, this message translates to:
  /// **'Minutes goal'**
  String get minutesGoal;

  /// No description provided for @setGoal.
  ///
  /// In en, this message translates to:
  /// **'Set Goal'**
  String get setGoal;

  /// No description provided for @noGoalSet.
  ///
  /// In en, this message translates to:
  /// **'No goal set'**
  String get noGoalSet;

  /// No description provided for @weeklyGoalProgress.
  ///
  /// In en, this message translates to:
  /// **'Weekly goal progress'**
  String get weeklyGoalProgress;

  /// No description provided for @searchOnlineForImages.
  ///
  /// In en, this message translates to:
  /// **'Search online for book covers'**
  String get searchOnlineForImages;

  /// No description provided for @selectImage.
  ///
  /// In en, this message translates to:
  /// **'Select Image'**
  String get selectImage;

  /// No description provided for @downloadImage.
  ///
  /// In en, this message translates to:
  /// **'Download Image'**
  String get downloadImage;

  /// No description provided for @selectedFiles.
  ///
  /// In en, this message translates to:
  /// **'Selected files'**
  String get selectedFiles;

  /// No description provided for @noFilesSelected.
  ///
  /// In en, this message translates to:
  /// **'No files selected'**
  String get noFilesSelected;

  /// No description provided for @selectAudioFiles.
  ///
  /// In en, this message translates to:
  /// **'Select audio files'**
  String get selectAudioFiles;

  /// No description provided for @noAudioFilesSelected.
  ///
  /// In en, this message translates to:
  /// **'No audio files selected'**
  String get noAudioFilesSelected;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @exportAnnotations.
  ///
  /// In en, this message translates to:
  /// **'Export Annotations'**
  String get exportAnnotations;

  /// No description provided for @exportAsMarkdown.
  ///
  /// In en, this message translates to:
  /// **'Export as Markdown'**
  String get exportAsMarkdown;

  /// No description provided for @exportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Export successful'**
  String get exportSuccess;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed'**
  String get exportFailed;

  /// No description provided for @bookmarkCreated.
  ///
  /// In en, this message translates to:
  /// **'Bookmark created'**
  String get bookmarkCreated;

  /// No description provided for @bookmarkDeleted.
  ///
  /// In en, this message translates to:
  /// **'Bookmark deleted'**
  String get bookmarkDeleted;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'selected'**
  String get selected;

  /// No description provided for @categoryAdded.
  ///
  /// In en, this message translates to:
  /// **'Category added to selected books'**
  String get categoryAdded;

  /// No description provided for @rank_temari.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get rank_temari;

  /// No description provided for @rank_temari_description.
  ///
  /// In en, this message translates to:
  /// **'Beginning the journey of wisdom.'**
  String get rank_temari_description;

  /// No description provided for @rank_anebabi.
  ///
  /// In en, this message translates to:
  /// **'Reader'**
  String get rank_anebabi;

  /// No description provided for @rank_anebabi_description.
  ///
  /// In en, this message translates to:
  /// **'Growing through humble reading and learning.'**
  String get rank_anebabi_description;

  /// No description provided for @rank_tsehafi.
  ///
  /// In en, this message translates to:
  /// **'Writer'**
  String get rank_tsehafi;

  /// No description provided for @rank_tsehafi_description.
  ///
  /// In en, this message translates to:
  /// **'Creating books and sharing valuable knowledge.'**
  String get rank_tsehafi_description;

  /// No description provided for @rank_liq.
  ///
  /// In en, this message translates to:
  /// **'Scholar'**
  String get rank_liq;

  /// No description provided for @rank_liq_description.
  ///
  /// In en, this message translates to:
  /// **'Deep thinking and understanding of knowledge.'**
  String get rank_liq_description;

  /// No description provided for @rank_baletibeb.
  ///
  /// In en, this message translates to:
  /// **'Master of Wisdom'**
  String get rank_baletibeb;

  /// No description provided for @rank_baletibeb_description.
  ///
  /// In en, this message translates to:
  /// **'Applying wisdom in everyday life.'**
  String get rank_baletibeb_description;

  /// No description provided for @rank_tibebawi.
  ///
  /// In en, this message translates to:
  /// **'Wise One'**
  String get rank_tibebawi;

  /// No description provided for @rank_tibebawi_description.
  ///
  /// In en, this message translates to:
  /// **'Wisdom has no boundaries.'**
  String get rank_tibebawi_description;

  /// No description provided for @masteryPath.
  ///
  /// In en, this message translates to:
  /// **'Mastery Path'**
  String get masteryPath;

  /// No description provided for @currentRank.
  ///
  /// In en, this message translates to:
  /// **'Current Rank'**
  String get currentRank;

  /// No description provided for @levelAchievementsDescription.
  ///
  /// In en, this message translates to:
  /// **'Level {level}+ • {achievements} Achievements • {description}'**
  String levelAchievementsDescription(
    Object achievements,
    Object description,
    Object level,
  );

  /// No description provided for @achievement_the_first_page.
  ///
  /// In en, this message translates to:
  /// **'First Page'**
  String get achievement_the_first_page;

  /// No description provided for @achievement_the_first_page_description.
  ///
  /// In en, this message translates to:
  /// **'Finish your first book.'**
  String get achievement_the_first_page_description;

  /// No description provided for @achievement_habit_builder.
  ///
  /// In en, this message translates to:
  /// **'Habit Builder'**
  String get achievement_habit_builder;

  /// No description provided for @achievement_habit_builder_description.
  ///
  /// In en, this message translates to:
  /// **'Read for 3 days in a row.'**
  String get achievement_habit_builder_description;

  /// No description provided for @achievement_seven_day_streak.
  ///
  /// In en, this message translates to:
  /// **'Seven-Day Streak'**
  String get achievement_seven_day_streak;

  /// No description provided for @achievement_seven_day_streak_description.
  ///
  /// In en, this message translates to:
  /// **'Read for 7 days in a row.'**
  String get achievement_seven_day_streak_description;

  /// No description provided for @achievement_bookworm.
  ///
  /// In en, this message translates to:
  /// **'Bookworm'**
  String get achievement_bookworm;

  /// No description provided for @achievement_bookworm_description.
  ///
  /// In en, this message translates to:
  /// **'Read 1,000 pages in total.'**
  String get achievement_bookworm_description;

  /// No description provided for @achievement_night_owl.
  ///
  /// In en, this message translates to:
  /// **'Night Owl'**
  String get achievement_night_owl;

  /// No description provided for @achievement_night_owl_description.
  ///
  /// In en, this message translates to:
  /// **'Read after 10 PM.'**
  String get achievement_night_owl_description;

  /// No description provided for @achievement_early_bird.
  ///
  /// In en, this message translates to:
  /// **'Early Bird'**
  String get achievement_early_bird;

  /// No description provided for @achievement_early_bird_description.
  ///
  /// In en, this message translates to:
  /// **'Read before 9 AM.'**
  String get achievement_early_bird_description;

  /// No description provided for @achievement_century_club.
  ///
  /// In en, this message translates to:
  /// **'Century Club'**
  String get achievement_century_club;

  /// No description provided for @achievement_century_club_description.
  ///
  /// In en, this message translates to:
  /// **'Read 100 pages in one session.'**
  String get achievement_century_club_description;

  /// No description provided for @achievement_unstoppable.
  ///
  /// In en, this message translates to:
  /// **'Unstoppable'**
  String get achievement_unstoppable;

  /// No description provided for @achievement_unstoppable_description.
  ///
  /// In en, this message translates to:
  /// **'Read for 30 consecutive days.'**
  String get achievement_unstoppable_description;

  /// No description provided for @achievement_marathoner.
  ///
  /// In en, this message translates to:
  /// **'Marathoner'**
  String get achievement_marathoner;

  /// No description provided for @achievement_marathoner_description.
  ///
  /// In en, this message translates to:
  /// **'Read for 2 hours in one session.'**
  String get achievement_marathoner_description;

  /// No description provided for @achievement_scholar.
  ///
  /// In en, this message translates to:
  /// **'Scholar'**
  String get achievement_scholar;

  /// No description provided for @achievement_scholar_description.
  ///
  /// In en, this message translates to:
  /// **'Read 5,000 pages in total.'**
  String get achievement_scholar_description;

  /// No description provided for @achievement_yomibito.
  ///
  /// In en, this message translates to:
  /// **'Yomibito'**
  String get achievement_yomibito;

  /// No description provided for @achievement_yomibito_description.
  ///
  /// In en, this message translates to:
  /// **'Finish 10 books.'**
  String get achievement_yomibito_description;

  /// No description provided for @achievement_sensei.
  ///
  /// In en, this message translates to:
  /// **'Sensei'**
  String get achievement_sensei;

  /// No description provided for @achievement_sensei_description.
  ///
  /// In en, this message translates to:
  /// **'Finish 50 books.'**
  String get achievement_sensei_description;

  /// No description provided for @achievement_bibliophile.
  ///
  /// In en, this message translates to:
  /// **'Bibliophile'**
  String get achievement_bibliophile;

  /// No description provided for @achievement_bibliophile_description.
  ///
  /// In en, this message translates to:
  /// **'Add 10 books to your library.'**
  String get achievement_bibliophile_description;

  /// No description provided for @achievement_collector.
  ///
  /// In en, this message translates to:
  /// **'Collector'**
  String get achievement_collector;

  /// No description provided for @achievement_collector_description.
  ///
  /// In en, this message translates to:
  /// **'Add 100 books to your library.'**
  String get achievement_collector_description;

  /// No description provided for @achievement_weekend_warrior.
  ///
  /// In en, this message translates to:
  /// **'Weekend Warrior'**
  String get achievement_weekend_warrior;

  /// No description provided for @achievement_weekend_warrior_description.
  ///
  /// In en, this message translates to:
  /// **'Read on both Saturday and Sunday.'**
  String get achievement_weekend_warrior_description;

  /// No description provided for @achievement_the_translator.
  ///
  /// In en, this message translates to:
  /// **'The Translator'**
  String get achievement_the_translator;

  /// No description provided for @achievement_the_translator_description.
  ///
  /// In en, this message translates to:
  /// **'Look up your first word.'**
  String get achievement_the_translator_description;

  /// No description provided for @achievement_vocabulary_builder.
  ///
  /// In en, this message translates to:
  /// **'Vocabulary Builder'**
  String get achievement_vocabulary_builder;

  /// No description provided for @achievement_vocabulary_builder_description.
  ///
  /// In en, this message translates to:
  /// **'Look up 20 words.'**
  String get achievement_vocabulary_builder_description;

  /// No description provided for @achievement_polyglot.
  ///
  /// In en, this message translates to:
  /// **'Polyglot'**
  String get achievement_polyglot;

  /// No description provided for @achievement_polyglot_description.
  ///
  /// In en, this message translates to:
  /// **'Look up 100 words.'**
  String get achievement_polyglot_description;

  /// No description provided for @achievement_gondar_keep.
  ///
  /// In en, this message translates to:
  /// **'Gondar Keep'**
  String get achievement_gondar_keep;

  /// No description provided for @achievement_gondar_keep_description.
  ///
  /// In en, this message translates to:
  /// **'Read 500 pages.'**
  String get achievement_gondar_keep_description;

  /// No description provided for @achievement_sheba_wisdom.
  ///
  /// In en, this message translates to:
  /// **'Wisdom of Sheba'**
  String get achievement_sheba_wisdom;

  /// No description provided for @achievement_sheba_wisdom_description.
  ///
  /// In en, this message translates to:
  /// **'Read 2,000 pages.'**
  String get achievement_sheba_wisdom_description;

  /// No description provided for @achievement_axum_legacy.
  ///
  /// In en, this message translates to:
  /// **'Axum Legacy'**
  String get achievement_axum_legacy;

  /// No description provided for @achievement_axum_legacy_description.
  ///
  /// In en, this message translates to:
  /// **'Read 10,000 pages.'**
  String get achievement_axum_legacy_description;

  /// No description provided for @achievement_fasil_crown.
  ///
  /// In en, this message translates to:
  /// **'Fasil Crown'**
  String get achievement_fasil_crown;

  /// No description provided for @achievement_fasil_crown_description.
  ///
  /// In en, this message translates to:
  /// **'Finish 5 books.'**
  String get achievement_fasil_crown_description;

  /// No description provided for @achievement_yohannes_torch.
  ///
  /// In en, this message translates to:
  /// **'Yohannes Torch'**
  String get achievement_yohannes_torch;

  /// No description provided for @achievement_yohannes_torch_description.
  ///
  /// In en, this message translates to:
  /// **'Finish 20 books.'**
  String get achievement_yohannes_torch_description;

  /// No description provided for @achievement_menelik_library.
  ///
  /// In en, this message translates to:
  /// **'Menelik\'s Library'**
  String get achievement_menelik_library;

  /// No description provided for @achievement_menelik_library_description.
  ///
  /// In en, this message translates to:
  /// **'Finish 100 books.'**
  String get achievement_menelik_library_description;

  /// No description provided for @achievement_lalibela_vigil.
  ///
  /// In en, this message translates to:
  /// **'Lalibela Vigil'**
  String get achievement_lalibela_vigil;

  /// No description provided for @achievement_lalibela_vigil_description.
  ///
  /// In en, this message translates to:
  /// **'Read for 100 hours.'**
  String get achievement_lalibela_vigil_description;

  /// No description provided for @achievement_selassie_endurance.
  ///
  /// In en, this message translates to:
  /// **'Selassie Endurance'**
  String get achievement_selassie_endurance;

  /// No description provided for @achievement_selassie_endurance_description.
  ///
  /// In en, this message translates to:
  /// **'Read for 100 consecutive days.'**
  String get achievement_selassie_endurance_description;

  /// No description provided for @achievement_geez_mastery.
  ///
  /// In en, this message translates to:
  /// **'Ge\'ez Mastery'**
  String get achievement_geez_mastery;

  /// No description provided for @achievement_geez_mastery_description.
  ///
  /// In en, this message translates to:
  /// **'Look up 500 words.'**
  String get achievement_geez_mastery_description;

  /// No description provided for @achievement_qene_poet.
  ///
  /// In en, this message translates to:
  /// **'Qene Poet'**
  String get achievement_qene_poet;

  /// No description provided for @achievement_qene_poet_description.
  ///
  /// In en, this message translates to:
  /// **'Look up 1,000 words.'**
  String get achievement_qene_poet_description;

  /// No description provided for @achievement_oral_tradition.
  ///
  /// In en, this message translates to:
  /// **'Oral Tradition'**
  String get achievement_oral_tradition;

  /// No description provided for @achievement_oral_tradition_description.
  ///
  /// In en, this message translates to:
  /// **'Listen to your first audiobook.'**
  String get achievement_oral_tradition_description;

  /// No description provided for @achievement_azmari_listener.
  ///
  /// In en, this message translates to:
  /// **'Azmari Listener'**
  String get achievement_azmari_listener;

  /// No description provided for @achievement_azmari_listener_description.
  ///
  /// In en, this message translates to:
  /// **'Listen to 5 audiobooks.'**
  String get achievement_azmari_listener_description;

  /// No description provided for @achievement_fast_reader.
  ///
  /// In en, this message translates to:
  /// **'Fast Reader'**
  String get achievement_fast_reader;

  /// No description provided for @achievement_fast_reader_description.
  ///
  /// In en, this message translates to:
  /// **'Finish a book in under 3 days.'**
  String get achievement_fast_reader_description;

  /// No description provided for @achievement_annotations_scholar.
  ///
  /// In en, this message translates to:
  /// **'Annotation Scholar'**
  String get achievement_annotations_scholar;

  /// No description provided for @achievement_annotations_scholar_description.
  ///
  /// In en, this message translates to:
  /// **'Create 20 highlights or bookmarks.'**
  String get achievement_annotations_scholar_description;

  /// No description provided for @achievement_timkat_reader.
  ///
  /// In en, this message translates to:
  /// **'Timkat Reader'**
  String get achievement_timkat_reader;

  /// No description provided for @achievement_timkat_reader_description.
  ///
  /// In en, this message translates to:
  /// **'Read on Timkat.'**
  String get achievement_timkat_reader_description;

  /// No description provided for @achievement_enkutatash_start.
  ///
  /// In en, this message translates to:
  /// **'Enkutatash Scholar'**
  String get achievement_enkutatash_start;

  /// No description provided for @achievement_enkutatash_start_description.
  ///
  /// In en, this message translates to:
  /// **'Read on Enkutatash.'**
  String get achievement_enkutatash_start_description;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['am', 'en', 'om', 'ti'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'am':
      return AppLocalizationsAm();
    case 'en':
      return AppLocalizationsEn();
    case 'om':
      return AppLocalizationsOm();
    case 'ti':
      return AppLocalizationsTi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
