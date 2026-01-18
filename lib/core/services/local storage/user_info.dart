import 'package:template/core/services/local%20storage/storage_service.dart';

/// ═══════════════════════════════════════════════════════════════════════════
/// USER INFO
/// Simple wrapper for user information storage
/// Uses StorageService internally to avoid conflicts
/// ═══════════════════════════════════════════════════════════════════════════
class UserInfo {
  // ═══════════════════════════════════════════════════════════════════════
  // User Information
  // ═══════════════════════════════════════════════════════════════════════

  /// Set user name
  static Future<void> setUserName(String name) async {
    await StorageService.setUserName(name);
  }

  /// Get user name
  static Future<String> getUserName() async {
    return await StorageService.getUserName();
  }

  /// Set user email
  static Future<void> setUserEmail(String email) async {
    await StorageService.setUserEmail(email);
  }

  /// Get user email
  static Future<String> getUserEmail() async {
    return await StorageService.getUserEmail();
  }

  /// Set user ID
  static Future<void> setUserId(String id) async {
    await StorageService.setUserId(id);
  }

  /// Get user ID
  static Future<String> getUserId() async {
    return await StorageService.getUserId();
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Authentication Tokens
  // ═══════════════════════════════════════════════════════════════════════

  /// Set access token
  static Future<void> setAccessToken(String token) async {
    await StorageService.setAccessToken(token);
  }

  /// Get access token
  static Future<String> getAccessToken() async {
    return await StorageService.getAccessToken();
  }

  /// Set refresh token
  static Future<void> setRefreshToken(String token) async {
    await StorageService.setRefreshToken(token);
  }

  /// Get refresh token
  static Future<String> getRefreshToken() async {
    return await StorageService.getRefreshToken();
  }

  // ═══════════════════════════════════════════════════════════════════════
  // User Status
  // ═══════════════════════════════════════════════════════════════════════

  /// Set guest status
  static Future<void> setIsGuest(bool status) async {
    await StorageService.setIsGuest(status);
  }

  /// Get guest status
  static Future<bool> getIsGuest() async {
    return await StorageService.getIsGuest();
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Subscription Status
  // ═══════════════════════════════════════════════════════════════════════

  /// Set premium status
  static Future<void> setIsPremium(bool status) async {
    await StorageService.setIsPremium(status);
  }

  /// Get premium status
  static Future<bool> getIsPremium() async {
    return await StorageService.getIsPremium();
  }

  // ═══════════════════════════════════════════════════════════════════════
  // App State
  // ═══════════════════════════════════════════════════════════════════════

  /// Set onboarding completed
  static Future<void> setOnboardingCompleted(bool status) async {
    await StorageService.setOnboardingCompleted(status);
  }

  /// Get onboarding completed
  static Future<bool> getOnboardingCompleted() async {
    return await StorageService.getOnboardingCompleted();
  }

  /// Set last sync date
  static Future<void> setLastSync(String date) async {
    await StorageService.setLastSync(date);
  }

  /// Get last sync date
  static Future<String> getLastSync() async {
    return await StorageService.getLastSync();
  }

  // ═══════════════════════════════════════════════════════════════════════
  // Clear Methods
  // ═══════════════════════════════════════════════════════════════════════

  /// Clear user info (logout)
  static Future<void> clearUserInfo() async {
    await StorageService.clearUserSession();
  }

  /// Clear all data
  static Future<void> clearAll() async {
    await StorageService.clearAll();
  }
}