import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'utils/app_colors.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'bindings/auth_binding.dart';

import 'view_models/overview_view_model.dart';
import 'view_models/live_monitor_view_model.dart';
import 'view_models/moderation_view_model.dart';
import 'view_models/user_management_view_model.dart';
import 'view_models/moderator_view_model.dart';
import 'view_models/appeals_view_model.dart';
import 'view_models/finance_view_model.dart';
import 'view_models/system_config_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      ],
      child: GetMaterialApp(
        title: 'Eron Dashboard',
        debugShowCheckedModeBanner: false,
        initialBinding: InitialBinding(),
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.dark,
            background: AppColors.background,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.background,
          textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme)
              .apply(
                bodyColor: AppColors.textPrimary,
                displayColor: AppColors.textPrimary,
              ),
        ),

        // Default transition
        defaultTransition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 200),


        unknownRoute: GetPage(
          name: '/not-found',
          page: () => const Scaffold(
            body: Center(
              child: Text(
                '404 - Page Not Found',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
