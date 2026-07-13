import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  // Constants for preference keys
  static const String _tokenKey = 'token';
  static const String _idKey = 'userId';
  static const String _resetTokenKey = 'resetToken';
  static const String _fcmTokenKey = 'fcmToken';
  static const String _nameKey = 'name';

  // Singleton instance for SharedPreferences
  static SharedPreferences? _preferences;

  // Initialize SharedPreferences (call this during app startup)
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Check if a token exists in local storage
  static bool hasToken() {
    final token = _preferences?.getString(_tokenKey);
    return token != null;
  }

  // Save the token and user ID to local storage
  static Future<void> saveToken(String token, String id) async {
    await _preferences?.setString(_tokenKey, token);
    await _preferences?.setString(_idKey, id);
  }

  // Remove the token and user ID from local storage (for logout)
  static Future<void> logoutUser() async {
    await _preferences?.remove(_tokenKey);
    await _preferences?.remove(_idKey);
    await _preferences?.remove(_imageUrlKey);
    // Navigate to the login screen
    // Get.offAllNamed('/login');
  }

  // Getter for user ID
  static String? get userId => _preferences?.getString(_idKey);

  // Getter for token
  static String? get token => _preferences?.getString(_tokenKey);

  // Reset token methods
  static Future<void> saveResetToken(String token) async {
    await _preferences?.setString(_resetTokenKey, token);
  }

  static String? get resetToken => _preferences?.getString(_resetTokenKey);

  static Future<void> clearResetToken() async {
    await _preferences?.remove(_resetTokenKey);
  }

  // FCM token methods
  static Future<void> saveFcmToken(String token) async {
    await _preferences?.setString(_fcmTokenKey, token);
  }

  static String? get fcmToken => _preferences?.getString(_fcmTokenKey);

  // Name methods
  static Future<void> saveName(String name) async {
    await _preferences?.setString(_nameKey, name);
  }

  static String? get name => _preferences?.getString(_nameKey);

  // Image methods
  static const String _imageUrlKey = 'imageUrl';
  
  static Future<void> saveImageUrl(String imageUrl) async {
    await _preferences?.setString(_imageUrlKey, imageUrl);
  }

  static String? get imageUrl => _preferences?.getString(_imageUrlKey);
}
