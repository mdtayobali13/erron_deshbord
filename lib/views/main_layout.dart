import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import 'components/sidebar.dart';

import 'all_screen/live_monitor_screen.dart';
import 'all_screen/dashboard_screen.dart';
import 'all_screen/moderation_queue_screen.dart';
import 'all_screen/user_management_screen.dart';
import 'all_screen/moderator_management_screen.dart';
import 'all_screen/appeals_center_screen.dart';
import 'all_screen/finance_payouts_screen.dart';
import 'all_screen/system_config_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const LiveMonitorScreen(),
    const ModerationQueueScreen(),
    const UserManagementScreen(),
    const ModeratorManagementScreen(),
    const AppealsCenterScreen(),
    const FinancePayoutsScreen(),
    const SystemConfigScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // Sidebar - Hide on small screens (can be improved with a drawer later)
          if (MediaQuery.of(context).size.width > 800)
            Sidebar(
              selectedIndex: _selectedIndex,
              onItemSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),

          // Main Content
          Expanded(
            child: Column(
              children: [
                // Header could go here
                Expanded(child: _screens[_selectedIndex]),
              ],
            ),
          ),
        ],
      ),
      drawer: MediaQuery.of(context).size.width <= 800
          ? Drawer(
              child: Sidebar(
                selectedIndex: _selectedIndex,
                onItemSelected: (index) {
                  setState(() {
                    _selectedIndex = index;
                    Navigator.pop(context); // Close drawer
                  });
                },
              ),
            )
          : null,
      appBar: MediaQuery.of(context).size.width <= 800
          ? AppBar(
              backgroundColor: AppColors.surface,
              iconTheme: const IconThemeData(color: AppColors.textPrimary),
              elevation: 0,
            )
          : null,
    );
  }
}
