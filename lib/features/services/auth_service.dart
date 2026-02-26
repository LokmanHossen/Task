import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _loggedInKey = 'is_logged_in';
  static const String _userIdKey = 'user_id';

  /// Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }

  /// Get saved user ID
  static Future<int?> getSavedUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  /// Save login state
  static Future<bool> saveLoginState(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_loggedInKey, true);
      await prefs.setInt(_userIdKey, userId);
      return true;
    } catch (e) {
      print('Error saving login state: $e');
      return false;
    }
  }

  /// Logout user
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_loggedInKey, false);
      await prefs.remove(_userIdKey);
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  /// Clear all auth data
  static Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      print('Error clearing data: $e');
    }
  }
}
