import 'package:flutter/material.dart';
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

import 'views/auth/sign_in_screen.dart';

void main() {
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
        home: const SignInScreen(),
      ),
    );
  }
}
