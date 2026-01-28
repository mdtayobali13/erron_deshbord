import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';
import '../../view_models/user_management_view_model.dart';
import '../components/user_card.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<UserManagementViewModel>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            "User Management",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Manage user profiles, KYC verification, and moderation controls",
            style: GoogleFonts.outfit(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 30),

          // Search Bar
          Container(
            height: 64,
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF0F1219),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: Colors.white.withOpacity(0.05),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B1E26), // Inset dark pill
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: TextField(
                      onChanged: (value) => viewModel.updateSearch(value),
                      cursorColor: AppColors.primary,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 14,
                        letterSpacing: 0.2,
                      ),
                      decoration: InputDecoration(
                        hintText:
                            "Search by Handle, Phone, Email, or Device ID",
                        hintStyle: GoogleFonts.outfit(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 36),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB), // Precise vibrant blue
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2563EB).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      "Search",
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // User Grid
          // User Grid
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 4;
              if (constraints.maxWidth < 1400) crossAxisCount = 3;
              if (constraints.maxWidth < 1000) crossAxisCount = 2;
              if (constraints.maxWidth < 650) crossAxisCount = 1;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: viewModel.displayedUsers.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: crossAxisCount == 1 ? 1.4 : 0.82,
                ),
                itemBuilder: (context, index) {
                  return UserCard(user: viewModel.displayedUsers[index]);
                },
              );
            },
          ),
          const SizedBox(height: 40),

          // Pagination Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: viewModel.currentPage > 1
                    ? () => viewModel.previousPage()
                    : null,
                icon: Icon(
                  Icons.chevron_left,
                  color: viewModel.currentPage > 1
                      ? Colors.white
                      : Colors.white24,
                ),
              ),
              const SizedBox(width: 10),
              ...List.generate(viewModel.totalPages, (index) {
                int pageNumber = index + 1;
                bool isActive = pageNumber == viewModel.currentPage;
                return GestureDetector(
                  onTap: () => viewModel.setPage(pageNumber),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primary
                          : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isActive
                            ? AppColors.primary
                            : Colors.white.withOpacity(0.1),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "$pageNumber",
                        style: GoogleFonts.outfit(
                          color: isActive ? Colors.white : Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(width: 10),
              IconButton(
                onPressed: viewModel.currentPage < viewModel.totalPages
                    ? () => viewModel.nextPage()
                    : null,
                icon: Icon(
                  Icons.chevron_right,
                  color: viewModel.currentPage < viewModel.totalPages
                      ? Colors.white
                      : Colors.white24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
