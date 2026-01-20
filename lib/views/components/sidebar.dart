import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

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
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                    image: const DecorationImage(
                      image: NetworkImage(
                        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=150&auto=format&fit=crop",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Super Admin",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "Admin@platform.com",
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
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
