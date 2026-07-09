import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tibeb/core/theme/theme.dart';
import 'package:tibeb/l10n/app_localizations.dart';
import 'package:tibeb/l10n/customLocalization/custom_localization.dart';
import 'package:tibeb/providers/localization_provider.dart';
import 'package:tibeb/screens/main_navigation.dart';
import 'package:tibeb/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('en', null);
  await initializeDateFormatting('am', null);
  await initializeDateFormatting('ti', null);
  await initializeDateFormatting('om', null);

  // Intercept Flutter rendering/layout exceptions globally to show a user-friendly screen
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return MaterialApp(
      title: 'tibeb',
      debugShowCheckedModeBanner: false,
      theme: TibebTheme.dark(),
      home: Scaffold(
        body: ErrorState(
          title: 'An unexpected rendering error occurred',
          description:
              'Tibeb encountered a layout/UI boundary failure. We have logged this error.',
          error: details.exceptionAsString(),
        ),
      ),
    );
  };

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Global Flutter Error: ${details.exception}');
  };

  await NotificationService().init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final sharedPrefs = await SharedPreferences.getInstance();

  if (io.Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    // This ensures that the system navigation bar doesn't have an opaque background
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(sharedPrefs)],
      child: const TibebApp(),
    ),
  );
}

class TibebApp extends ConsumerStatefulWidget {
  const TibebApp({super.key});

  @override
  ConsumerState<TibebApp> createState() => _TibebAppState();
}

class _TibebAppState extends ConsumerState<TibebApp> {
  @override
  void initState() {
    super.initState();
    // Load saved locale on app start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentLocaleProvider.notifier).reload();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final currentLocale = ref.watch(currentLocaleProvider);

    return MaterialApp(
      title: 'tibeb',
      debugShowCheckedModeBanner: false,
      theme: TibebTheme.light(),
      darkTheme: TibebTheme.dark(),
      themeMode: themeMode,
      localizationsDelegates: const [
        AppLocalizations.delegate,

        CustomMaterialLocalizationsDelegate(),
        CustomCupertinoLocalizationsDelegate(),

        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,

        GlobalWidgetsLocalizations.delegate,
      ],
      locale: currentLocale,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MainNavigation(),
    );
  }
}
