import 'dart:convert';
import 'package:get/get.dart';
import '../services/prefs_service.dart';
import '../services/network_caller.dart';
import '../utils/app_urls.dart';
import '../models/login_response_model.dart';

class UserRole {
  static const String superBoss = 'SUPERBOSS';
  static const String admin = 'ADMIN';
  static const String moderator = 'MODERATOR';
  static const String user = 'USER';

  static bool isAdminRole(String? role) {
    if (role == null) return false;
    final upperRole = role.toUpperCase();
    return upperRole == superBoss || upperRole == admin;
  }
}

class AuthController extends GetxController {
  static AuthController get to => Get.find<AuthController>();

  final Rx<UserData?> _userData = Rx<UserData?>(null);
  final RxBool _isLoading = false.obs;
  final RxBool _isLoggedIn = false.obs;
  final RxBool _obscurePassword = true.obs;
  final Rx<LoginResponseModel?> _loginResponse = Rx<LoginResponseModel?>(null);

  UserData? get userData => _userData.value;
  bool get isLoading => _isLoading.value;
  bool get isLoggedIn => _isLoggedIn.value;
  bool get obscurePassword => _obscurePassword.value;
  LoginResponseModel? get loginResponse => _loginResponse.value;

  bool get isAdmin => UserRole.isAdminRole(_userData.value?.role);

  String? get userRole => _userData.value?.role;

  @override
  void onInit() {
    super.onInit();
    loadSession();
  }

  Future<void> loadSession() async {
    try {
      final token = await PrefsService.getToken();
      final user = await PrefsService.getUser();

      if (token != null && token.isNotEmpty) {
        _isLoggedIn.value = true;
        _userData.value = user;
      } else {
        _isLoggedIn.value = false;
        _userData.value = null;
      }
    } catch (e) {
      _isLoggedIn.value = false;
      _userData.value = null;
    }
  }

  void togglePasswordVisibility() {
    _obscurePassword.value = !_obscurePassword.value;
  }

  Map<String, dynamic>? _decodeJwt(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      String payload = parts[1];

      int remainder = payload.length % 4;
      if (remainder > 0) {
        payload += '=' * (4 - remainder);
      }

      final decoded = utf8.decode(base64Url.decode(payload));
      return jsonDecode(decoded) as Map<String, dynamic>;
    } catch (e) {
      print('JWT decode error: $e');
      return null;
    }
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading.value = true;

    final LoginRequestModel requestModel = LoginRequestModel(
      username: email,
      password: password,
    );

    final response = await NetworkCaller.postRequest(
      AppUrls.login,
      body: requestModel.toJson(),
    );

    _isLoading.value = false;

    if (response.responseData != null && response.responseData is Map) {
      _loginResponse.value = LoginResponseModel.fromJson(response.responseData);
    }

    if (response.isSuccess && _loginResponse.value?.accessToken != null) {
      final token = _loginResponse.value!.accessToken!.trim();
      await PrefsService.saveToken(token);

      if (_loginResponse.value?.data?.user != null) {
        _userData.value = _loginResponse.value!.data!.user;
      } else {
        final jwtPayload = _decodeJwt(token);
        final roleFromJwt = jwtPayload?['role'] ?? 'USER';
        final emailFromJwt = jwtPayload?['email'] ?? email;

        _userData.value = UserData(
          name: "Admin User",
          email: emailFromJwt,
          role: roleFromJwt,
          avatar:
              "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=150&auto=format&fit=crop",
        );
      }

      await PrefsService.saveUser(_userData.value!);
      _isLoggedIn.value = true;

      print('Login successful! Role: ${_userData.value?.role}');
      return true;
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    await PrefsService.clearAll();
    _loginResponse.value = null;
    _userData.value = null;
    _isLoggedIn.value = false;

    Get.offAllNamed('/signin');
  }

  bool hasRole(List<String> requiredRoles) {
    if (_userData.value?.role == null) return false;
    final userRole = _userData.value!.role!.toUpperCase();
    return requiredRoles.map((r) => r.toUpperCase()).contains(userRole);
  }
}
