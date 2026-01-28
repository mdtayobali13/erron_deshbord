import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/login_response_model.dart';

class PrefsService {
  static const String keyToken = 'auth_token';
  static const String keyUserData = 'user_data';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyToken, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyToken);
  }

  static Future<void> saveUser(UserData user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyUserData, jsonEncode(user.toJson()));
  }

  static Future<UserData?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString(keyUserData);
    if (userJson == null) return null;
    return UserData.fromJson(jsonDecode(userJson));
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
