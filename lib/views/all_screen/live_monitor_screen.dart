import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../view_models/live_monitor_view_model.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/toast_helper.dart';
import '../components/live_stream_card.dart';

class LiveMonitorScreen extends StatefulWidget {
  const LiveMonitorScreen({super.key});

  @override
  State<LiveMonitorScreen> createState() => _LiveMonitorScreenState();
}

class _LiveMonitorScreenState extends State<LiveMonitorScreen> {
  int _currentPage = 1;
  final int _itemsPerPage = 6;
  String _selectedFilter = "All"; // Track selected filter

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LiveMonitorViewModel>(context);

    // Trigger loading if needed or show loading
    if (viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    // Pagination Logic
    final totalItems = viewModel.liveStreams.length;
    final totalPages = (totalItems / _itemsPerPage).ceil();

    // Ensure current page is valid
    if (_currentPage > totalPages && totalPages > 0) {
      _currentPage = totalPages;
    }
    if (_currentPage < 1) _currentPage = 1;

    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    final currentStreams = viewModel.liveStreams.sublist(
      startIndex,
      endIndex > totalItems ? totalItems : endIndex,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            "Live Monitor",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "CCTV-style surveillance of all active streams",
            style: GoogleFonts.outfit(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 30),

          // Filter Bar Section
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filter Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.12),
                          Colors.white.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(50), // Pill shape
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Status left
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Active ${viewModel.streamStats?.total ?? 0} Streams",
                          style: GoogleFonts.outfit(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 24),
                        const Icon(
                          Icons.person_outline,
                          size: 14,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "${viewModel.totalViewers.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} Total Viewers",
                          style: GoogleFonts.outfit(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(width: 24),
                    
                        const Spacer(),

                        // Right Filters
                        GestureDetector(
                          onTap: () => setState(() => _selectedFilter = "All"),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _selectedFilter == "All"
                                  ? AppColors.primary
                                  : null,
                              gradient: _selectedFilter == "All"
                                  ? null
                                  : LinearGradient(
                                      colors: [
                                        Colors.white.withOpacity(0.15),
                                        Colors.white.withOpacity(0.05),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                              borderRadius: BorderRadius.circular(20),
                              border: _selectedFilter == "All"
                                  ? null
                                  : Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                            ),
                            child: Text(
                              "All",
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        _buildGlassyFilterBtn("Free"),
                        const SizedBox(width: 10),
                        _buildGlassyFilterBtn("Paid"),
                        const SizedBox(width: 10),
                        _buildGlassyFilterBtn("Refresh", icon: Icons.refresh),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Grid (Paginated)
                LayoutBuilder(
                  builder: (context, constraints) {
                    int crossAxisCount = 3;
                    if (constraints.maxWidth < 1000) crossAxisCount = 2;
                    if (constraints.maxWidth < 650) crossAxisCount = 1;

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: currentStreams.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 0.98,
                      ),
                      itemBuilder: (context, index) {
                        return LiveStreamCard(stream: currentStreams[index]);
                      },
                    );
                  },
                ),

                const SizedBox(height: 30),

                // Pagination Controls
                if (totalPages > 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Previous Button
                      IconButton(
                        onPressed: _currentPage > 1
                            ? () => setState(() => _currentPage--)
                            : null,
                        icon: Icon(
                          Icons.chevron_left,
                          color: _currentPage > 1
                              ? Colors.white
                              : Colors.white24,
                        ),
                      ),
                      const SizedBox(width: 10),

                      // Page Numbers
                      ...List.generate(totalPages, (index) {
                        int pageNumber = index + 1;
                        bool isActive = pageNumber == _currentPage;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _currentPage = pageNumber),
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
                                  color: isActive
                                      ? Colors.white
                                      : Colors.white70,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),

                      const SizedBox(width: 10),

                      // Next Button
                      IconButton(
                        onPressed: _currentPage < totalPages
                            ? () => setState(() => _currentPage++)
                            : null,
                        icon: Icon(
                          Icons.chevron_right,
                          color: _currentPage < totalPages
                              ? Colors.white
                              : Colors.white24,
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

  Widget _buildGlassyFilterBtn(String label, {IconData? icon}) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () {
        if (label == "Refresh") {
          context.read<LiveMonitorViewModel>().loadData();
          ToastHelper.success(
            context,
            title: "Refreshing",
            message: "Live streams data is being refreshed...",
          );
        } else {
          setState(() => _selectedFilter = label);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : null,
          gradient: isSelected
              ? null
              : LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? null
              : Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: Colors.white70),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: GoogleFonts.outfit(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
