import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/toast_helper.dart';
import '../../view_models/auth_view_model.dart';
import '../auth/sign_in_screen.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  final List<Map<String, dynamic>> _menuItems = const [
    {"icon": Icons.grid_view, "title": "Over View"},
    {"icon": Icons.monitor, "title": "Live Monitor"},
    {"icon": Icons.flag_outlined, "title": "Moderation Queue"},
    {"icon": Icons.person_outline, "title": "User Management"},
    {"icon": Icons.security, "title": "Moderators"},
    {"icon": Icons.mail_outline, "title": "Appeals Center"},
    {"icon": Icons.currency_exchange, "title": "Finance & Payouts"},
    {"icon": Icons.settings_outlined, "title": "System Config"},
  ];

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final user = authViewModel.userData;

    return Container(
      width: 250,
      color: AppColors.sidebar,
      child: Column(
        children: [
          const SizedBox(height: 30),
          // Logo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  height: 40,
                  fit: BoxFit.contain,
                  errorBuilder: (c, o, s) => const Icon(
                    Icons.show_chart,
                    color: AppColors.primary,
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Menu Items
          Expanded(
            child: ListView.builder(
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                return _buildMenuItem(
                  _menuItems[index]["icon"],
                  _menuItems[index]["title"],
                  index == selectedIndex,
                  index,
                );
              },
            ),
          ),

          // User Profile
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              border: const Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                // Profile Image with Glow/Border
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(21),
                    child: Image.network(
                      user?.avatar ??
                          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=150&auto=format&fit=crop",
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(
                        color: AppColors.surface,
                        child: const Icon(Icons.person, color: Colors.white54),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Name & Email
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        user?.name ?? "Super Admin",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user?.email ?? "Admin@platform.com",
                        style: GoogleFonts.inter(
                          color: Colors.white54,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Logout Button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      await authViewModel.logout();
                      if (context.mounted) {
                        ToastHelper.success(
                          context,
                          title: "Logged Out",
                          message: "You have been logged out successfully",
                        );
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignInScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.logout_rounded,
                        color: Colors.white.withOpacity(0.4),
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, bool isActive, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        gradient: isActive
            ? const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          icon,
          color: isActive ? Colors.white : AppColors.textSecondary,
          size: 20,
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            color: isActive ? Colors.white : AppColors.textSecondary,
            fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
            fontSize: 13,
          ),
        ),
        onTap: () {
          onItemSelected(index);
        },
      ),
    );
  }
}
