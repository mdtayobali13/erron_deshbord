import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';
import '../../view_models/moderator_view_model.dart';
import '../components/moderator_card.dart';
import '../components/add_moderator_popup.dart';

class ModeratorManagementScreen extends StatelessWidget {
  const ModeratorManagementScreen({super.key});

  void _showAddModerator(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) => const Center(
        child: Material(color: Colors.transparent, child: AddModeratorPopup()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ModeratorViewModel>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Moderator Management",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Manage moderator accounts and permissions",
                    style: GoogleFonts.outfit(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              // Add Moderator Button
              GestureDetector(
                onTap: () => _showAddModerator(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: const Color(0xFF2563EB).withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.add_moderator,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Add Moderator",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Search Bar
          // Search Bar
          // Search Bar
          // Search Bar
          LayoutBuilder(
            builder: (context, constraints) {
              // Limit width on desktop
              double width = double.infinity;
              if (constraints.maxWidth > 800) width = 600;

              return Container(
                width: width,
                height: 56,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F1219),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1B1E26),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: TextField(
                          onChanged: (v) => viewModel.updateSearch(v),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                          decoration: InputDecoration(
                            hintText: "Search moderators",
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.3),
                              fontSize: 13,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Text(
                        "Search",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 2;
              double childAspectRatio = constraints.maxWidth < 1300 ? 1.8 : 2.0;

              if (constraints.maxWidth < 600) {
                crossAxisCount = 1; // Single column on small mobile
                childAspectRatio = 1.3;
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: viewModel.displayedModerators.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: childAspectRatio,
                ),
                itemBuilder: (context, index) {
                  return ModeratorCard(
                    moderator: viewModel.displayedModerators[index],
                  );
                },
              );
            },
          ),
          const SizedBox(height: 30),

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
                          ? const Color(0xFF2563EB)
                          : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isActive
                            ? const Color(0xFF2563EB)
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
