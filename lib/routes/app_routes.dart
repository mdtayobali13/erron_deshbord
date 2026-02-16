/// Route names as constants for type-safe navigation
abstract class AppRoutes {
  // Base prefix for all routes
  static const String _prefix = '/deshbord';

  static const String splash = '$_prefix';
  static const String signin = '$_prefix/signin';
  static const String adminDashboard = '$_prefix/admin-dashboard';
  static const String unauthorized = '$_prefix/unauthorized';

  // Add more routes as needed
  static const String liveMonitor = '$_prefix/live-monitor';
  static const String moderation = '$_prefix/moderation';
  static const String userManagement = '$_prefix/user-management';
  static const String finance = '$_prefix/finance';
  static const String settings = '$_prefix/settings';
}
