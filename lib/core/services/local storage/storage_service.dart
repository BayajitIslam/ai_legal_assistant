import 'package:shared_preferences/shared_preferences.dart';
import 'package:template/core/utils/console.dart';

/// ═══════════════════════════════════════════════════════════════════════════
/// STORAGE SERVICE
/// Main storage layer - All keys defined here to avoid conflicts
/// ═══════════════════════════════════════════════════════════════════════════
class StorageService {
  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences - call this in main() before runApp()
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    Console.storage('StorageService initialized');
  }

  static SharedPreferences get _box {
    if (_prefs == null) {
      throw Exception(
        'StorageService not initialized. Call StorageService.init() first.',
      );
    }
    return _prefs!;
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Storage Keys - Single source of truth
  // ═══════════════════════════════════════════════════════════════════════

  // User Info Keys
  static const String keyUserName = 'userName';
  static const String keyUserEmail = 'userEmail';
  static const String keyUserPhone = 'userPhone';
  static const String keyUserId = 'userId';
  static const String keyProfileImageUrl = 'profileImageUrl';

  // Auth Keys
  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyIsLoggedIn = 'isLoggedIn';
  static const String keyIsGuest = 'is_guest';

  // Subscription Keys
  static const String keyIsPremium = 'plan_active';
  static const String keyLastSync = 'last_sync';

  // App State Keys
  static const String keyOnboardingCompleted = 'onboarding_completed';
  static const String keyIsFirstTimeUser = 'isFirstTimeUser';

  // RevenueCat Keys
  static const String keyRcUniqueUserId = 'rc_unique_user_id';
  static const String keyHasUsedTrial = 'has_used_trial';
  static const String keyLastRcUserWithPurchases =
      'last_rc_user_with_purchases';

  // FCM Keys
  static const String keyFcmToken = 'fcmToken';

  /// Get SharedPreferences instance
  static Future<SharedPreferences> get _instance async {
    if (_prefs != null) return _prefs!;
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Generic Methods
  // ═══════════════════════════════════════════════════════════════════════

  /// Set string value
  static Future<void> setString(String key, String value) async {
    final prefs = await _instance;
    await prefs.setString(key, value);
  }

  /// Get string value
  static Future<String> getString(
    String key, {
    String defaultValue = '',
  }) async {
    final prefs = await _instance;
    return prefs.getString(key) ?? defaultValue;
  }

  /// Set bool value
  static Future<void> setBool(String key, bool value) async {
    final prefs = await _instance;
    await prefs.setBool(key, value);
  }

  /// Get bool value
  static Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final prefs = await _instance;
    return prefs.getBool(key) ?? defaultValue;
  }

  /// Set int value
  static Future<void> setInt(String key, int value) async {
    final prefs = await _instance;
    await prefs.setInt(key, value);
  }

  /// Get int value
  static Future<int> getInt(String key, {int defaultValue = 0}) async {
    final prefs = await _instance;
    return prefs.getInt(key) ?? defaultValue;
  }

  /// Remove key
  static Future<void> remove(String key) async {
    final prefs = await _instance;
    await prefs.remove(key);
  }

  /// Check if key exists
  static Future<bool> containsKey(String key) async {
    final prefs = await _instance;
    return prefs.containsKey(key);
  }

  /// Clear all data
  static Future<void> clearAll() async {
    final prefs = await _instance;
    await prefs.clear();
    Console.warning(' All storage cleared');
  }

  // ═══════════════════════════════════════════════════════════════════════
  // User Info Methods
  // ═══════════════════════════════════════════════════════════════════════
  /// Save profile image URL
  static Future<void> setProfileImageUrl(String url) async {
    await _prefs?.setString(keyProfileImageUrl, url);
  }

  /// Get profile image URL
  static Future<String?> getProfileImageUrl() async {
    return _prefs?.getString(keyProfileImageUrl);
  }

  static Future<void> setUserName(String value) async =>
      await setString(keyUserName, value);

  static Future<String> getUserName() async => await getString(keyUserName);

  static Future<void> setUserEmail(String value) async =>
      await setString(keyUserEmail, value);

  static Future<void> setUserPhone(String value) async =>
      await setString(keyUserPhone, value);

  static Future<String> getUserPhone() async => await getString(keyUserPhone);

  static Future<String> getUserEmail() async => await getString(keyUserEmail);

  static Future<void> setUserId(String value) async =>
      await setString(keyUserId, value);

  static Future<String> getUserId() async => await getString(keyUserId);

  // ═══════════════════════════════════════════════════════════════════════
  // Auth Methods
  // ═══════════════════════════════════════════════════════════════════════

  static Future<void> setAccessToken(String value) async =>
      await setString(keyAccessToken, value);

  static Future<String> getAccessToken() async =>
      await getString(keyAccessToken);

  static Future<void> setRefreshToken(String value) async =>
      await setString(keyRefreshToken, value);

  static Future<String> getRefreshToken() async =>
      await getString(keyRefreshToken);

  static Future<void> setIsLoggedIn(bool value) async =>
      await setBool(keyIsLoggedIn, value);

  static Future<bool> getIsLoggedIn() async => await getBool(keyIsLoggedIn);

  static Future<void> setIsGuest(bool value) async =>
      await setBool(keyIsGuest, value);

  static Future<bool> getIsGuest() async =>
      await getBool(keyIsGuest, defaultValue: true);

  // ═══════════════════════════════════════════════════════════════════════
  // Subscription Methods
  // ═══════════════════════════════════════════════════════════════════════

  static Future<void> setIsPremium(bool value) async =>
      await setBool(keyIsPremium, value);

  static Future<bool> getIsPremium() async => await getBool(keyIsPremium);

  static Future<void> setLastSync(String value) async =>
      await setString(keyLastSync, value);

  static Future<String> getLastSync() async => await getString(keyLastSync);

  // ═══════════════════════════════════════════════════════════════════════
  // App State Methods
  // ═══════════════════════════════════════════════════════════════════════

  static Future<void> setOnboardingCompleted(bool value) async =>
      await setBool(keyOnboardingCompleted, value);

  static Future<bool> getOnboardingCompleted() async =>
      await getBool(keyOnboardingCompleted);

  static Future<void> setIsFirstTimeUser(bool value) async =>
      await setBool(keyIsFirstTimeUser, value);

  static Future<bool> getIsFirstTimeUser() async =>
      await getBool(keyIsFirstTimeUser, defaultValue: true);

  // ═══════════════════════════════════════════════════════════════════════
  // RevenueCat Methods
  // ═══════════════════════════════════════════════════════════════════════

  static Future<void> setRcUniqueUserId(String value) async =>
      await setString(keyRcUniqueUserId, value);

  static Future<String> getRcUniqueUserId() async =>
      await getString(keyRcUniqueUserId);

  static Future<void> setHasUsedTrial(bool value) async =>
      await setBool(keyHasUsedTrial, value);

  static Future<bool> getHasUsedTrial() async => await getBool(keyHasUsedTrial);

  static Future<void> setLastRcUserWithPurchases(String value) async =>
      await setString(keyLastRcUserWithPurchases, value);

  static Future<String> getLastRcUserWithPurchases() async =>
      await getString(keyLastRcUserWithPurchases);

  // ═══════════════════════════════════════════════════════════════════════
  // FCM Methods
  // ═══════════════════════════════════════════════════════════════════════

  static Future<void> setFcmToken(String value) async =>
      await setString(keyFcmToken, value);

  static Future<String> getFcmToken() async => await getString(keyFcmToken);

  // ═══════════════════════════════════════════════════════════════════════
  // Session Management
  // ═══════════════════════════════════════════════════════════════════════

  /// Save complete user session
  static Future<void> saveUserSession({
    required String accessToken,
    required String refreshToken,
    String? userName,
    String? email,
    String? userId,
    bool isGuest = true,
    bool isPremium = false,
  }) async {
    await setAccessToken(accessToken);
    await setRefreshToken(refreshToken);
    if (userName != null) await setUserName(userName);
    if (email != null) await setUserEmail(email);
    if (userId != null) await setUserId(userId);
    await setIsGuest(isGuest);
    await setIsLoggedIn(true);
    await setIsPremium(isPremium);
    await setIsFirstTimeUser(false);

    Console.success(' User session saved');
  }

  /// Clear user session (logout)
  static Future<void> clearUserSession() async {
    await remove(keyUserName);
    await remove(keyUserEmail);
    await remove(keyUserId);
    await remove(keyAccessToken);
    await remove(keyRefreshToken);
    await remove(keyIsLoggedIn);
    await remove(keyIsGuest);
    await remove(keyIsPremium);

    Console.info(' User session cleared');
  }

  /// Clear subscription data
  static Future<void> clearSubscriptionData() async {
    await remove(keyIsPremium);
    await remove(keyLastSync);
    await remove(keyHasUsedTrial);

    Console.info('Subscription data cleared');
  }

  static String getAccessTokenString() {
    return _box.getString(keyAccessToken) ?? '';
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Debug Methods
  // ═══════════════════════════════════════════════════════════════════════

  /// Print all stored data
  static Future<void> printAll() async {
    final prefs = await _instance;
    Console.info(' All Stored Data:');
    Console.info('  User Name: ${prefs.getString(keyUserName)}');
    Console.info('  User Email: ${prefs.getString(keyUserEmail)}');
    Console.info(
      '  Access Token: ${prefs.getString(keyAccessToken)?.substring(0, 20)}...',
    );
    Console.info('  Is Logged In: ${prefs.getBool(keyIsLoggedIn)}');
    Console.info('  Is Guest: ${prefs.getBool(keyIsGuest)}');
    Console.info('  Is Premium: ${prefs.getBool(keyIsPremium)}');
    Console.info('  Onboarding: ${prefs.getBool(keyOnboardingCompleted)}');
  }
}
