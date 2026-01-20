import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/cache_service.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit()
    : super(
        AppState(
          themeMode: ThemeMode.system,
          locale: Locale(CacheService.instance.languageCode),
        ),
      );

  void toggleTheme() {
    final newMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    emit(AppState(themeMode: newMode, locale: state.locale));
  }

  void changeLanguage(String languageCode) async {
    await CacheService.instance.setLanguageCode(languageCode);
    emit(AppState(themeMode: state.themeMode, locale: Locale(languageCode)));
  }
}
