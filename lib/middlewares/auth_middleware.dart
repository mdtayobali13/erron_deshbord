import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../services/prefs_service.dart';

/// Middleware to protect routes that require authentication
class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    // If not logged in, redirect to signin
    if (!authController.isLoggedIn) {
      return const RouteSettings(name: '/signin');
    }

    return null; // Allow access
  }
}

/// Middleware to protect admin-only routes
/// Only allows SUPERBOSS and ADMIN roles
class AdminMiddleware extends GetMiddleware {
  @override
  int? get priority => 2; // Higher priority, runs after AuthMiddleware

  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    // First check if logged in
    if (!authController.isLoggedIn) {
      return const RouteSettings(name: '/signin');
    }

    // Then check if user has admin role
    if (!authController.isAdmin) {
      return const RouteSettings(name: '/unauthorized');
    }

    return null; // Allow access
  }
}

/// Middleware to redirect already logged-in users away from auth pages
class GuestMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    // If already logged in, redirect to dashboard
    if (authController.isLoggedIn) {
      if (authController.isAdmin) {
        return const RouteSettings(name: '/admin-dashboard');
      }
      return const RouteSettings(name: '/unauthorized');
    }

    return null; // Allow access to guest routes
  }
}

/// Extended middleware with async initialization support
/// Use this for initial app load to ensure auth state is loaded
class AuthGuard {
  static Future<bool> checkAuth() async {
    final isLoggedIn = await PrefsService.isLoggedIn();
    return isLoggedIn;
  }

  static Future<bool> checkAdminRole() async {
    final user = await PrefsService.getUser();
    if (user == null) return false;

    final role = user.role?.toUpperCase();
    return role == 'SUPERBOSS' || role == 'ADMIN';
  }

  /// Initialize and return redirect route based on auth state
  static Future<String> getInitialRoute() async {
    final isLoggedIn = await checkAuth();

    if (!isLoggedIn) {
      return '/signin';
    }

    final isAdmin = await checkAdminRole();
    if (isAdmin) {
      return '/admin-dashboard';
    }

    return '/unauthorized';
  }
}
