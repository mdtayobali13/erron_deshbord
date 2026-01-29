import 'package:flutter/material.dart';
import '../services/prefs_service.dart';
import 'auth/sign_in_screen.dart';
import 'main_layout.dart';
import 'components/app_loading_indicator.dart';
import '../../utils/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  int _getIndexFromPath() {
    final path = Uri.base.path;
    if (path.contains("OverView")) return 0;
    if (path.contains("LiveMonitor")) return 1;
    if (path.contains("ModerationQueue")) return 2;
    if (path.contains("UserManagement")) return 3;
    if (path.contains("Moderators")) return 4;
    if (path.contains("AppealsCenter")) return 5;
    if (path.contains("FinancePayouts")) return 6;
    if (path.contains("SystemConfig")) return 7;
    return -1; // Not found
  }

  Future<void> _checkLoginStatus() async {
    // Check login status immediately without delay
    final isLoggedIn = await PrefsService.isLoggedIn();

    if (mounted) {
      if (isLoggedIn) {
        // Prioritize path from URL for deep linking
        int index = _getIndexFromPath();

        // If no valid path in URL, fallback to saved index
        if (index == -1) {
          index = await PrefsService.getDashboardIndex();
        }

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainLayout(initialIndex: index),
            ),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Icon(
                Icons.auto_awesome,
                size: 80,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 32),
            const AppLoadingIndicator(),
          ],
        ),
      ),
    );
  }
}
