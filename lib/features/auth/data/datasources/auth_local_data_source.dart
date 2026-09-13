import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> setRememberMe(bool value);
  bool getRememberMe();
  Future<void> setPreferencesCompleted(bool value);
  bool getPreferencesCompleted();
  Future<void> clearAll();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> setRememberMe(bool value) async {
    await sharedPreferences.setBool('remember_me', value);
  }

  @override
  bool getRememberMe() {
    return sharedPreferences.getBool('remember_me') ?? false;
  }

  @override
  Future<void> setPreferencesCompleted(bool value) async {
    await sharedPreferences.setBool('isPreferencesCompleted', value);
  }

  @override
  bool getPreferencesCompleted() {
    return sharedPreferences.getBool('isPreferencesCompleted') ?? false;
  }

  @override
  Future<void> clearAll() async {
    await sharedPreferences.setBool('remember_me', false);
    // Note: We might want to keep isPreferencesCompleted or not,
    // but the requirement says "On explicit Sign Out, reset remember_me back to false".
  }
}
