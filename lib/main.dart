import 'package:flutter/material.dart';
import 'package:shop_flow/core/services/cache_service.dart';
import 'package:shop_flow/l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'feature/splash/splash_screen.dart';
import 'feature/onboarding/onboarding_screen.dart';
import 'feature/auth/presentation/screens/login_screen.dart';
import 'core/utils/nav_bar.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/cubit/app_cubit.dart';

// Localization
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize cache service
  await CacheService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'MarketFlow',
            debugShowCheckedModeBanner: false,

            // Themes
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,

            // Localization
            locale: state.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('ar'), // Arabic
            ],

            home: const AppStartup(),
          );
        },
      ),
    );
  }
}

/// Widget to determine the initial screen based on app state
class AppStartup extends StatefulWidget {
  const AppStartup({super.key});

  @override
  State<AppStartup> createState() => _AppStartupState();
}

class _AppStartupState extends State<AppStartup> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    // Wait for splash animation
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    Widget nextScreen;

    // Check if onboarding is complete
    if (!CacheService.instance.isOnboardingComplete) {
      nextScreen = const OnboardingScreen();
    }
    // Check if user is logged in
    else if (CacheService.instance.isLoggedIn) {
      nextScreen = MainPage();
    }
    // Show login screen
    else {
      nextScreen = const LoginScreen();
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (_, __, ___) => nextScreen,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
