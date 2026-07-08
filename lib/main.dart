import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tibeb/core/theme/theme.dart';
import 'package:tibeb/screens/main_navigation.dart';
import 'package:tibeb/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Intercept Flutter rendering/layout exceptions globally to show a user-friendly screen
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return MaterialApp(
      title: 'tibeb',
      debugShowCheckedModeBanner: false,
      theme: TibebTheme.dark(),
      home: Scaffold(
        body: ErrorState(
          title: 'An unexpected rendering error occurred',
          description: 'Tibeb encountered a layout/UI boundary failure. We have logged this error.',
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

class TibebApp extends ConsumerWidget {
  const TibebApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'tibeb',
      debugShowCheckedModeBanner: false,
      theme: TibebTheme.light(),
      darkTheme: TibebTheme.dark(),
      themeMode: themeMode,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', 'US')],
      home: const MainNavigation(),
    );
  }
}
