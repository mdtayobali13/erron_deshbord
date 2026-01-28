import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../view_models/overview_view_model.dart';
import '../../../utils/app_colors.dart';
import '../components/stat_card.dart';
import '../components/chart_card.dart';
import '../components/live_stream_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<OverviewViewModel>(context);
    // Trigger data load if empty (handled in init but safe to check)

    if (viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            "Platform Overview",
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Monitor your platform's health and performance",
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 30),

          // Stats Grid
          LayoutBuilder(
            builder: (context, constraints) {
              // Responsive Grid
              int crossAxisCount = 4;
              if (constraints.maxWidth < 1200) crossAxisCount = 2;
              if (constraints.maxWidth < 700) crossAxisCount = 1;

              double childAspectRatio = 1.4;
              if (constraints.maxWidth < 1400) childAspectRatio = 1.2;
              if (crossAxisCount == 1) childAspectRatio = 1.8;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: viewModel.stats.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: childAspectRatio,
                ),
                itemBuilder: (context, index) {
                  return StatCard(stat: viewModel.stats[index]);
                },
              );
            },
          ),

          const SizedBox(height: 30),

          // Charts Row
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 1100) {
                return Column(
                  children: [
                    ChartCard(
                      title: "Revenue Trend",
                      data: viewModel.revenueTrend,
                      baseColor: AppColors.primary,
                      action: _buildYearDropdown(context, viewModel),
                    ),
                    const SizedBox(height: 20),
                    ChartCard(
                      title: "New User",
                      data: viewModel.newUserTrend,
                      baseColor: AppColors.success,
                      action: _buildYearDropdown(context, viewModel),
                    ),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(
                    child: ChartCard(
                      title: "Revenue Trend",
                      data: viewModel.revenueTrend,
                      baseColor: AppColors.primary,
                      action: _buildYearDropdown(context, viewModel),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ChartCard(
                      title: "New User",
                      data: viewModel.newUserTrend,
                      baseColor: AppColors.success,
                      action: _buildYearDropdown(context, viewModel),
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 30),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.primary.withOpacity(0.5),
                width: 1,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(16),
        
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Live Streams",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = 3;
                    if (constraints.maxWidth < 1000) crossAxisCount = 2;
                    if (constraints.maxWidth < 650) crossAxisCount = 1;

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: viewModel.previewStreams.length > 3
                          ? 3
                          : viewModel.previewStreams.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.98, // Taller cards
                      ),
                      itemBuilder: (context, index) {
                        return LiveStreamCard(
                          stream: viewModel.previewStreams[index],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearDropdown(BuildContext context, OverviewViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: viewModel.selectedYear,
          dropdownColor: const Color(0xFF2563EB),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white,
            size: 16,
          ),
          isDense: true,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          items: [
            for (int i = 2020; i <= DateTime.now().year; i++)
              DropdownMenuItem(
                value: i,
                child: Text(
                  "$i",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
          onChanged: (val) {
            if (val != null) viewModel.updateYear(val);
          },
        ),
      ),
    );
  }
}
