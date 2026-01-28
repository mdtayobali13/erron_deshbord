import 'package:flutter/material.dart';
import '../services/network_caller.dart';
import '../services/prefs_service.dart';
import '../utils/app_urls.dart';
import '../models/login_response_model.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  LoginResponseModel? _loginResponse;
  LoginResponseModel? get loginResponse => _loginResponse;

  UserData? _userData;
  UserData? get userData => _userData;

  AuthViewModel() {
    loadSession();
  }

  Future<void> loadSession() async {
    _userData = await PrefsService.getUser();
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final LoginRequestModel requestModel = LoginRequestModel(
      username: email,
      password: password,
    );

    final response = await NetworkCaller.postRequest(
      AppUrls.login,
      body: requestModel.toJson(),
    );

    _isLoading = false;

    if (response.responseData != null && response.responseData is Map) {
      _loginResponse = LoginResponseModel.fromJson(response.responseData);
    }

    if (response.isSuccess && _loginResponse?.accessToken != null) {
      await PrefsService.saveToken(_loginResponse!.accessToken!.trim());

      // Since the API only returns access_token, we create a basic UserData
      // object or update it once we have a profile API.
      _userData = UserData(
        name: "Admin User",
        email: email,
        role: "ADMIN",
        avatar:
            "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=150&auto=format&fit=crop",
      );
      await PrefsService.saveUser(_userData!);

      debugPrint("Login Success");
      notifyListeners();
      return true;
    } else {
      debugPrint("Login Failed: ${response.statusCode}");
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await PrefsService.clearAll();
    _loginResponse = null;
    _userData = null;
    notifyListeners();
  }
}
