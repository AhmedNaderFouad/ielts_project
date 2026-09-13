import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferences sharedPreferences;

  SettingsCubit({required this.sharedPreferences})
    : super(
        SettingsState(
          locale: Locale(sharedPreferences.getString(_localeKey) ?? 'en'),
          themeMode:
              ThemeMode.values[sharedPreferences.getInt(_themeKey) ??
                  ThemeMode.light.index],
        ),
      );

  static const String _localeKey = 'language_code';
  static const String _themeKey = 'theme_mode';

  Future<void> changeLanguage(String languageCode) async {
    await sharedPreferences.setString(_localeKey, languageCode);
    emit(state.copyWith(locale: Locale(languageCode)));
  }

  Future<void> changeThemeMode(ThemeMode themeMode) async {
    await sharedPreferences.setInt(_themeKey, themeMode.index);
    emit(state.copyWith(themeMode: themeMode));
  }
}
