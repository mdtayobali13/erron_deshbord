import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../middlewares/auth_middleware.dart';
import '../utils/app_colors.dart';

/// GetX-compatible Splash Screen with async auth initialization
class SplashScreenGetX extends StatefulWidget {
  const SplashScreenGetX({super.key});

  @override
  State<SplashScreenGetX> createState() => _SplashScreenGetXState();
}

class _SplashScreenGetXState extends State<SplashScreenGetX>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Setup animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();

    // Initialize auth and navigate
    _initializeAndNavigate();
  }

  Future<void> _initializeAndNavigate() async {
    // Wait for animation and auth check
    await Future.delayed(const Duration(seconds: 2));

    // Get the initial route based on auth state
    final initialRoute = await AuthGuard.getInitialRoute();

    // Navigate to appropriate screen
    Get.offAllNamed(initialRoute);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo container
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.2),
                            AppColors.primary.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.admin_panel_settings_rounded,
                        size: 80,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // App title
                    const Text(
                      'Eron Dashboard',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Admin Control Panel',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Loading indicator
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        strokeWidth: 2,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
