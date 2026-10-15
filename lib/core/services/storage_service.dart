import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Currency Preference (Defaulting to Rupee ₹)
  static String get currencySymbol => _prefs?.getString('currency_symbol') ?? '₹';
  static Future<void> setCurrencySymbol(String symbol) async {
    await _prefs?.setString('currency_symbol', symbol);
  }

  // Hide Balance Preference
  static bool get hideBalance => _prefs?.getBool('hide_balance') ?? false;
  static Future<void> setHideBalance(bool hide) async {
    await _prefs?.setBool('hide_balance', hide);
  }

  // Theme Preference
  static String get themeMode => _prefs?.getString('theme_mode') ?? 'dark';
  static Future<void> setThemeMode(String mode) async {
    await _prefs?.setString('theme_mode', mode);
  }

  // Security Lock Preferences
  static bool get isSecurityEnabled => _prefs?.getBool('security_enabled') ?? false;
  static Future<void> setSecurityEnabled(bool enabled) async {
    await _prefs?.setBool('security_enabled', enabled);
  }

  static String? get appPin => _prefs?.getString('app_pin');
  static Future<void> setAppPin(String? pin) async {
    if (pin == null) {
      await _prefs?.remove('app_pin');
    } else {
      await _prefs?.setString('app_pin', pin);
    }
  }

  static bool get isFingerprintEnabled => _prefs?.getBool('fingerprint_enabled') ?? false;
  static Future<void> setFingerprintEnabled(bool enabled) async {
    await _prefs?.setBool('fingerprint_enabled', enabled);
  }

  static bool get isFaceIdEnabled => _prefs?.getBool('face_id_enabled') ?? false;
  static Future<void> setFaceIdEnabled(bool enabled) async {
    await _prefs?.setBool('face_id_enabled', enabled);
  }

  static bool get isBiometricsEnabled => isFingerprintEnabled || isFaceIdEnabled;

  // Daily Limit
  static double get dailyLimit => _prefs?.getDouble('daily_limit') ?? 400.0;
  static Future<void> setDailyLimit(double limit) async {
    await _prefs?.setDouble('daily_limit', limit);
  }
}
