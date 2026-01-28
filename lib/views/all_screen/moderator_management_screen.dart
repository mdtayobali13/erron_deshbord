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
      child: viewModel.isLoading
          ? const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 100),
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            )
          : Column(
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
                Container(
                  width: double.infinity,
                  height: 64,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A0C12),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.12),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(
                            color: const Color(0xFF161B24),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.04),
                            ),
                          ),
                          child: Center(
                            child: TextField(
                              onChanged: (v) => viewModel.updateSearch(v),
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
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
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          // Search logic
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          height: double.infinity,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF2563EB,
                                ).withOpacity(0.35),
                                blurRadius: 15,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "Search",
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = 2;
                    double childAspectRatio = constraints.maxWidth < 1300
                        ? 3.0
                        : 3.3;

                    if (constraints.maxWidth < 600) {
                      crossAxisCount = 1;
                      childAspectRatio = 2.1;
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
