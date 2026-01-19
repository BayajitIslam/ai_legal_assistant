import 'package:ai_legal_assistant/core/services/local%20storage/storage_service.dart';

/// ═══════════════════════════════════════════════════════════════════════════
/// USER STATUS
/// Simple wrapper for user status/state storage
/// Uses StorageService internally to avoid conflicts
/// ═══════════════════════════════════════════════════════════════════════════
class UserStatus {
  // ═══════════════════════════════════════════════════════════════════════
  // Login Status
  // ═══════════════════════════════════════════════════════════════════════

  /// Set logged in status
  static Future<void> setIsLoggedIn(bool status) async {
    await StorageService.setIsLoggedIn(status);
  }

  /// Get logged in status
  static Future<bool> getIsLoggedIn() async {
    return await StorageService.getIsLoggedIn();
  }

  // ═══════════════════════════════════════════════════════════════════════
  // First Time User
  // ═══════════════════════════════════════════════════════════════════════

  /// Set first time user status
  static Future<void> setIsFirstTimeUser(bool status) async {
    await StorageService.setIsFirstTimeUser(status);
  }

  /// Get first time user status
  static Future<bool> getIsFirstTimeUser() async {
    return await StorageService.getIsFirstTimeUser();
  }
}