import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'utils/app_colors.dart';
import 'view_models/overview_view_model.dart';
import 'view_models/live_monitor_view_model.dart';
import 'view_models/moderation_view_model.dart';
import 'view_models/user_management_view_model.dart';
import 'view_models/moderator_view_model.dart';
import 'view_models/appeals_view_model.dart';
import 'view_models/finance_view_model.dart';
import 'view_models/system_config_view_model.dart';
import 'view_models/auth_view_model.dart';
import 'views/splash_screen.dart';

// The non-guessable path for the admin dashboard
const String secretAdminPath = "/h7x2/k9m4/p1v8/admindash";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OverviewViewModel()),
        ChangeNotifierProvider(create: (_) => LiveMonitorViewModel()),
        ChangeNotifierProvider(create: (_) => ModerationViewModel()),
        ChangeNotifierProvider(create: (_) => UserManagementViewModel()),
        ChangeNotifierProvider(create: (_) => ModeratorViewModel()),
        ChangeNotifierProvider(create: (_) => AppealsViewModel()),
        ChangeNotifierProvider(create: (_) => FinanceViewModel()),
        ChangeNotifierProvider(create: (_) => SystemConfigViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ],
      child: MaterialApp(
        title: 'Eron Dashboard',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.dark,
            background: AppColors.background,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.background,
          textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
              .apply(
                bodyColor: AppColors.textPrimary,
                displayColor: AppColors.textPrimary,
              ),
        ),
        home: _checkAccess() ? const SplashScreen() : const HiddenRootScreen(),
      ),
    );
  }

  bool _checkAccess() {
    // In web, check the current URL path
    final path = Uri.base.path;
    // During development (localhost), we usually allow access to / for convenience,
    // but in production, we strictly check for the secret path.
    if (path == "/" || path.isEmpty) {
      // If it's the root, we show the hidden screen (placeholder for public site)
      return false;
    }
    return path.contains(secretAdminPath);
  }
}

class HiddenRootScreen extends StatelessWidget {
  const HiddenRootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.public, color: Colors.white24, size: 64),
            const SizedBox(height: 16),
            Text(
              "Public Website Coming Soon",
              style: GoogleFonts.outfit(
                color: Colors.white24,
                fontSize: 18,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
