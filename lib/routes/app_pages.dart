import 'package:get/get.dart';
import 'app_routes.dart';
import '../middlewares/auth_middleware.dart';
import '../bindings/auth_binding.dart';
import '../views/splash_screen_getx.dart';
import '../views/auth/sign_in_screen.dart';
import '../views/main_layout.dart';
import '../views/unauthorized_screen.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    // Splash Screen - No middleware needed
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreenGetX(),
      binding: AuthBinding(),
    ),

    // Sign In - Only for guests (not logged in)
    GetPage(
      name: AppRoutes.signin,
      page: () => const SignInScreen(),
      middlewares: [GuestMiddleware()],
    ),

    // Admin Dashboard - Protected route (Admin/SuperBoss only)
    GetPage(
      name: AppRoutes.adminDashboard,
      page: () => const MainLayout(),
      middlewares: [AdminMiddleware()],
    ),

    // Unauthorized - For logged in users without admin access
    GetPage(
      name: AppRoutes.unauthorized,
      page: () => const UnauthorizedScreen(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}
