import 'package:shared_preferences/shared_preferences.dart';

/// A service to manage local storage using SharedPreferences.
class CacheService {
  static CacheService? _instance;
  static SharedPreferences? _prefs;

  CacheService._();

  /// Initialize the cache service
  static Future<CacheService> init() async {
    _prefs = await SharedPreferences.getInstance();
    _instance ??= CacheService._();
    return _instance!;
  }

  /// Get the singleton instance
  static CacheService get instance {
    if (_instance == null) {
      throw Exception('CacheService not initialized. Call init() first.');
    }
    return _instance!;
  }

  // ============= Keys =============
  static const String _keyOnboardingComplete = 'onboarding_complete';
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserName = 'user_name';
  static const String _keyUserPhoto = 'user_photo';
  static const String _keyThemeMode = 'theme_mode';

  // ============= Onboarding =============
  bool get isOnboardingComplete =>
      _prefs?.getBool(_keyOnboardingComplete) ?? false;

  Future<bool> setOnboardingComplete(bool value) async {
    return await _prefs?.setBool(_keyOnboardingComplete, value) ?? false;
  }

  // ============= Auth Tokens =============
  String? get accessToken => _prefs?.getString(_keyAccessToken);
  String? get refreshToken => _prefs?.getString(_keyRefreshToken);

  Future<bool> setAccessToken(String token) async {
    return await _prefs?.setString(_keyAccessToken, token) ?? false;
  }

  Future<bool> setRefreshToken(String token) async {
    return await _prefs?.setString(_keyRefreshToken, token) ?? false;
  }

  bool get isLoggedIn => accessToken != null && accessToken!.isNotEmpty;

  // ============= User Info =============
  String? get userId => _prefs?.getString(_keyUserId);
  String? get userEmail => _prefs?.getString(_keyUserEmail);
  String? get userName => _prefs?.getString(_keyUserName);
  String? get userPhoto => _prefs?.getString(_keyUserPhoto);

  Future<void> saveUserInfo({
    required String id,
    required String email,
    required String name,
    String? photo,
  }) async {
    await _prefs?.setString(_keyUserId, id);
    await _prefs?.setString(_keyUserEmail, email);
    await _prefs?.setString(_keyUserName, name);
    if (photo != null) {
      await _prefs?.setString(_keyUserPhoto, photo);
    }
  }

  // ============= Theme =============
  String get themeMode => _prefs?.getString(_keyThemeMode) ?? 'system';

  Future<bool> setThemeMode(String mode) async {
    return await _prefs?.setString(_keyThemeMode, mode) ?? false;
  }

  // ============= Language =============
  static const String _keyLanguageCode = 'language_code';

  String get languageCode => _prefs?.getString(_keyLanguageCode) ?? 'en';

  Future<bool> setLanguageCode(String code) async {
    return await _prefs?.setString(_keyLanguageCode, code) ?? false;
  }

  // ============= Clear =============
  Future<void> clearAuth() async {
    await _prefs?.remove(_keyAccessToken);
    await _prefs?.remove(_keyRefreshToken);
    await _prefs?.remove(_keyUserId);
    await _prefs?.remove(_keyUserEmail);
    await _prefs?.remove(_keyUserName);
    await _prefs?.remove(_keyUserPhoto);
  }

  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
