import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../view_models/appeals_view_model.dart';
import '../components/appeal_card.dart';

class AppealsCenterScreen extends StatelessWidget {
  const AppealsCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AppealsViewModel>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            "Appeals Center",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Review and process ban appeal requests",
            style: GoogleFonts.outfit(color: Colors.white38, fontSize: 16),
          ),
          const SizedBox(height: 30),

          // Appeals List
          ...viewModel.displayedAppeals
              .map((appeal) => AppealCard(appeal: appeal))
              .toList(),

          const SizedBox(height: 20),

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
