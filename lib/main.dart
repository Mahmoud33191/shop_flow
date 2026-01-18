import 'package:flutter/material.dart';
import 'package:shop_flow/feature/home/home_view.dart';
import 'core/theme/app_theme.dart';
import 'feature/search/search_view.dart';
import 'feature/splash/splash_screen.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/cubit/app_cubit.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(),
      child: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'MarketFlow',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            home: const HomeView(),
          );
        },
      ),
    );
  }
}
