import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/toast_helper.dart';
import '../../models/report_model.dart';
import '../../view_models/moderation_view_model.dart';

class ModerationQueueScreen extends StatefulWidget {
  const ModerationQueueScreen({super.key});

  @override
  State<ModerationQueueScreen> createState() => _ModerationQueueScreenState();
}

class _ModerationQueueScreenState extends State<ModerationQueueScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ModerationViewModel>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (viewModel.isLoading)
            const LinearProgressIndicator(
              color: AppColors.primary,
              backgroundColor: Colors.transparent,
            ),
          const SizedBox(height: 10),
          // Header
          Text(
            "Moderation Queue",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Review and manage user reports",
            style: GoogleFonts.outfit(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 30),

          // Search and Filter Bar
          // Search and Filter Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _buildFilterBtn(viewModel, "All"),
                    const SizedBox(width: 8),
                    _buildFilterBtn(viewModel, "New"),
                    const SizedBox(width: 8),
                    _buildFilterBtn(viewModel, "Resolved"),
                    const Spacer(),
                    // Search Bar
                    Container(
                      width: 320,
                      height: 40,
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            size: 18,
                            color: Colors.white.withOpacity(0.3),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                              decoration: InputDecoration(
                                hintText:
                                    "Search creators, tags, or categories",
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.25),
                                  fontSize: 12,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Tickets Table
          // Tickets Table
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF13131A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                // Table Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 24,
                  ),
                  child: Row(
                    children: [
                      _buildHeaderCell("Ticket", flex: 2),
                      _buildHeaderCell("Reporter", flex: 2),
                      _buildHeaderCell("Target", flex: 2),
                      _buildHeaderCell("Category", flex: 2),
                      _buildHeaderCell("Time", flex: 2),
                      _buildHeaderCell("Actions", flex: 1, isEnd: true),
                    ],
                  ),
                ),
                const Divider(color: Colors.white10, height: 1),
                // Table Body
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: viewModel.displayedTickets.length,
                  separatorBuilder: (context, index) =>
                      const Divider(color: Colors.white10, height: 1),
                  itemBuilder: (context, index) {
                    final ticket = viewModel.displayedTickets[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 20,
                      ),
                      child: Row(
                        children: [
                          _buildDataCell(
                            ticket.id?.substring(0, 8) ?? "N/A",
                            flex: 2,
                          ),
                          _buildDataCell(
                            "${ticket.reporterUser?.firstName ?? ""} ${ticket.reporterUser?.lastName ?? ""}",
                            flex: 2,
                          ),
                          _buildDataCell(
                            "${ticket.session?.host?.firstName ?? ""} ${ticket.session?.host?.lastName ?? ""}",
                            flex: 2,
                          ),
                          _buildDataCell(ticket.category ?? "General", flex: 2),
                          _buildDataCell(
                            ticket.createdAt != null
                                ? "${DateTime.now().difference(DateTime.parse(ticket.createdAt!)).inMinutes} min ago"
                                : "N/A",
                            flex: 2,
                          ),
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: _buildReviewBtn(
                                onTap: () => _showReviewPopup(context, ticket),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(color: Colors.white10, height: 1),
                // Pagination Controls
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Previous Button
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
                      // Page Numbers
                      ...List.generate(viewModel.totalPages, (index) {
                        int pageNumber = index + 1;
                        bool isActive = pageNumber == viewModel.currentPage;
                        return GestureDetector(
                          onTap: () => viewModel.setCurrentPage(pageNumber),
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBtn(ModerationViewModel viewModel, String label) {
    bool isSelected = viewModel.selectedFilter == label;
    return GestureDetector(
      onTap: () => viewModel.setSelectedFilter(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : Colors.white.withOpacity(0.1),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCell(
    String label, {
    required int flex,
    bool isEnd = false,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        textAlign: isEnd ? TextAlign.right : TextAlign.left,
        style: GoogleFonts.outfit(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDataCell(String value, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Text(
        value,
        style: GoogleFonts.outfit(color: Colors.white70, fontSize: 13),
      ),
    );
  }

  Widget _buildReviewBtn({VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          "Review",
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showReviewPopup(BuildContext context, ReportModel ticket) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (context) => _ReviewTicketPopup(ticket: ticket),
    );
  }
}

class _ReviewTicketPopup extends StatelessWidget {
  final ReportModel ticket;

  const _ReviewTicketPopup({required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 800,
        decoration: BoxDecoration(
          color: const Color(0xFF0F0F1A),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${ticket.session?.host?.firstName ?? ""} ${ticket.session?.host?.lastName ?? ""}",
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ticket.session?.title ?? "Live Streaming",
                      style: GoogleFonts.outfit(
                        color: Colors.white60,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Content Area
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildDetailRow(
                        "Reporter",
                        "${ticket.reporterUser?.firstName ?? ""} ${ticket.reporterUser?.lastName ?? ""}",
                      ),
                      const SizedBox(width: 40),
                      _buildDetailRow(
                        "Target",
                        "${ticket.session?.host?.firstName ?? ""} ${ticket.session?.host?.lastName ?? ""}",
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildDetailRow("Category", ticket.category ?? "General"),
                      const SizedBox(width: 40),
                      _buildDetailRow(
                        "Reported",
                        ticket.createdAt != null
                            ? "${DateTime.now().difference(DateTime.parse(ticket.createdAt!)).inMinutes} min ago"
                            : "N/A",
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "Evidence",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      ticket.session?.thumbnail ??
                          "https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?ixlib=rb-1.2.1&auto=format&fit=crop&w=1200&q=80",
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 300,
                        width: double.infinity,
                        color: Colors.white.withOpacity(0.05),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image_outlined,
                              color: Colors.white24,
                              size: 48,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Evidence image not available",
                              style: GoogleFonts.outfit(color: Colors.white24),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Note Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: TextField(
                      maxLines: 3,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        hintText: "Type here",
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.2),
                        ),
                        labelText: "Add Note (Optional)",
                        labelStyle: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 12,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(16),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Actions
            Consumer<ModerationViewModel>(
              builder: (context, viewModel, child) => Row(
                children: [
                  _buildActionBtn("Dismiss", const Color(0xFF1F2937), () {
                    ToastHelper.success(
                      context,
                      title: "Report Dismissed",
                      message: "The report has been resolved without action",
                    );
                    Navigator.pop(context);
                  }),
                  const SizedBox(width: 12),
                  _buildActionBtn("Ban User", const Color(0xFFEF4444), () async {
                    if (ticket.session?.host?.id == null) return;
                    // Passing "ACTIVE" as current status will force the toggle to set it to "INACTIVE"
                    final success = await viewModel.toggleUserStatus(
                      ticket.session!.host!.id!,
                      "ACTIVE",
                    );
                    if (context.mounted) {
                      if (success) {
                        ToastHelper.success(
                          context,
                          title: "Success",
                          message: "User account deactivated",
                        );
                        Navigator.pop(context);
                      } else {
                        ToastHelper.error(
                          context,
                          title: "Error",
                          message:
                              viewModel.errorMessage ??
                              "Failed to deactivate account",
                        );
                      }
                    }
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              color: Colors.white38,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.outfit(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtn(String label, Color color, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
