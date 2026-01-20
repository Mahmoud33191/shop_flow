import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_flow/core/utils/nav_bar.dart';
import '../../core/theme/app_colors.dart';
import 'bouncing_dots.dart';
import 'package:shop_flow/l10n/app_localizations.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize Animation Controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Total animation duration
    );

    // Fade Animation for Logo and Text
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    // Slide Animation for Text (coming from bottom)
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
          ),
        );

    // Start Animation
    _animationController.forward();

    // Navigation Timer
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            pageBuilder: (_, __, ___) => MainPage(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Logo
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.elasticOut,
                      ),
                    ),
                    child: SvgPicture.asset(
                      isDarkMode
                          ? 'assets/img/online_shop_logo_dark.svg'
                          : 'assets/img/online_shop_logo.svg',
                      width: 160,
                      placeholderBuilder: (context) =>
                          const SizedBox(height: 160, width: 160),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Animated Text
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.appTitle,
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                fontSize: 32,
                                color: isDarkMode
                                    ? Colors.white
                                    : AppColors.textPrimaryLight,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.slogan,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: isDarkMode
                                    ? Colors.grey[400]
                                    : const Color(0xFF7D838B),
                                letterSpacing: 1.2,
                                fontSize: 16,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                FadeTransition(
                  opacity: _fadeAnimation,
                  child: BouncingDots(isDarkMode: isDarkMode),
                ),
              ],
            ),
          ),

          // Bottom Version Text
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _animationController.drive(
                CurveTween(
                  curve: const Interval(0.8, 1.0, curve: Curves.easeIn),
                ),
              ),
              child: Center(
                child: Text(
                  "V1.0.0",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
