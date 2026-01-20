import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../view_models/finance_view_model.dart';
import '../../models/payout_model.dart';
import '../components/payout_review_popup.dart';

class FinancePayoutsScreen extends StatelessWidget {
  const FinancePayoutsScreen({super.key});

  void _showReviewPopup(BuildContext context, PayoutRequest request) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: PayoutReviewPopup(request: request),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<FinanceViewModel>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            "Finance & Payouts",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Manage payout requests and platform revenue (Super Admin Only)",
            style: GoogleFonts.outfit(color: Colors.white38, fontSize: 16),
          ),
          const SizedBox(height: 30),

          // Summary Cards
          // Summary Cards
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 700) {
                // Mobile: Column
                return Column(
                  children: [
                    _buildSummaryCard(
                      "\$245.7k",
                      "Total Token Sales",
                      Icons.account_balance_wallet_outlined,
                      const Color(0xFF2563EB).withOpacity(0.1),
                    ),
                    const SizedBox(height: 16),
                    _buildSummaryCard(
                      "\$156.4k",
                      "Total Payouts",
                      Icons.arrow_upward,
                      const Color(0xFFEF4444).withOpacity(0.1),
                      textColor: const Color(0xFFEF4444),
                    ),
                    const SizedBox(height: 16),
                    _buildSummaryCard(
                      "\$245.7k",
                      "Profit Margin",
                      Icons.percent,
                      Colors.white.withOpacity(0.05),
                    ),
                    const SizedBox(height: 16),
                    _buildSummaryCard(
                      "\$245.7k",
                      "Pending Payouts",
                      Icons.history,
                      Colors.white.withOpacity(0.05),
                    ),
                  ],
                );
              } else if (constraints.maxWidth < 1200) {
                // Tablet: Grid (2x2)
                return Column(
                  children: [
                    Row(
                      children: [
                        _buildSummaryCard(
                          "\$245.7k",
                          "Total Token Sales",
                          Icons.account_balance_wallet_outlined,
                          const Color(0xFF2563EB).withOpacity(0.1),
                        ),
                        const SizedBox(width: 20),
                        _buildSummaryCard(
                          "\$156.4k",
                          "Total Payouts",
                          Icons.arrow_upward,
                          const Color(0xFFEF4444).withOpacity(0.1),
                          textColor: const Color(0xFFEF4444),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _buildSummaryCard(
                          "\$245.7k",
                          "Profit Margin",
                          Icons.percent,
                          Colors.white.withOpacity(0.05),
                        ),
                        const SizedBox(width: 20),
                        _buildSummaryCard(
                          "\$245.7k",
                          "Pending Payouts",
                          Icons.history,
                          Colors.white.withOpacity(0.05),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                // Desktop: Row
                return Row(
                  children: [
                    _buildSummaryCard(
                      "\$245.7k",
                      "Total Token Sales",
                      Icons.account_balance_wallet_outlined,
                      const Color(0xFF2563EB).withOpacity(0.1),
                    ),
                    const SizedBox(width: 20),
                    _buildSummaryCard(
                      "\$156.4k",
                      "Total Payouts",
                      Icons.arrow_upward,
                      const Color(0xFFEF4444).withOpacity(0.1),
                      textColor: const Color(0xFFEF4444),
                    ),
                    const SizedBox(width: 20),
                    _buildSummaryCard(
                      "\$245.7k",
                      "Profit Margin",
                      Icons.percent,
                      Colors.white.withOpacity(0.05),
                    ),
                    const SizedBox(width: 20),
                    _buildSummaryCard(
                      "\$245.7k",
                      "Pending Payouts",
                      Icons.history,
                      Colors.white.withOpacity(0.05),
                    ),
                  ],
                );
              }
            },
          ),

          const SizedBox(height: 50),
          Text(
            "Payout Requests",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Payout Table
          // Payout Table
          LayoutBuilder(
            builder: (context, constraints) {
              const double minWidth = 1100;
              final bool shouldScroll = constraints.maxWidth < minWidth;

              Widget tableContent = Container(
                width: shouldScroll ? minWidth : double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF11141D),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  children: [
                    // Table Header
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      child: Row(
                        children: [
                          Expanded(flex: 3, child: _headerCell("Host")),
                          Expanded(flex: 2, child: _headerCell("KYC Status")),
                          Expanded(flex: 2, child: _headerCell("Amount")),
                          Expanded(flex: 3, child: _headerCell("Destination")),
                          Expanded(flex: 2, child: _headerCell("Status")),
                          Expanded(flex: 2, child: _headerCell("Actions")),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: Colors.white10),
                    // Table Rows
                    ...viewModel.displayedRequests
                        .map((request) => _buildRow(context, request))
                        .toList(),
                  ],
                ),
              );

              if (shouldScroll) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: tableContent,
                );
              }
              return tableContent;
            },
          ),

          const SizedBox(height: 30),

          // Pagination
          _buildPagination(viewModel),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String value,
    String title,
    IconData icon,
    Color iconBg, {
    Color textColor = Colors.white,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF11141D),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white70, size: 18),
            ),
            const SizedBox(height: 20),
            Text(
              value,
              style: GoogleFonts.outfit(
                color: textColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: GoogleFonts.outfit(color: Colors.white38, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerCell(String text) {
    return Text(
      text,
      style: GoogleFonts.outfit(
        color: Colors.white38,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildRow(BuildContext context, PayoutRequest request) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
      ),
      child: Row(
        children: [
          // Host
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(request.hostAvatar),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.hostName,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      request.timeAgo,
                      style: GoogleFonts.outfit(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // KYC Status
          Expanded(
            flex: 2,
            child: UnconstrainedBox(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(request.kycStatus).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  request.kycStatus,
                  style: GoogleFonts.outfit(
                    color: _getStatusColor(request.kycStatus),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          // Amount
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "\$${request.amount}",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "${request.tokens} Tokens",
                  style: GoogleFonts.outfit(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Destination
          Expanded(
            flex: 3,
            child: Text(
              request.destination,
              style: GoogleFonts.outfit(color: Colors.white70, fontSize: 14),
            ),
          ),
          // Status
          Expanded(
            flex: 2,
            child: UnconstrainedBox(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(request.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  request.status,
                  style: GoogleFonts.outfit(
                    color: _getStatusColor(request.status),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          // Action
          Expanded(
            flex: 2,
            child: (request.status == "Pending" || request.status == "Approved")
                ? UnconstrainedBox(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () => _showReviewPopup(context, request),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Text(
                        "Review",
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Verified":
      case "Approved":
        return const Color(0xFF34D399); // Soft Emerald
      case "Rejected":
      case "Declined":
        return const Color(0xFFFB7185); // Soft Rose/Red
      case "Pending":
        return const Color(0xFFFBBF24); // Soft Amber
      default:
        return Colors.white38;
    }
  }

  Widget _buildPagination(FinanceViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: viewModel.currentPage > 1
              ? () => viewModel.previousPage()
              : null,
          icon: Icon(
            Icons.chevron_left,
            color: viewModel.currentPage > 1 ? Colors.white : Colors.white24,
          ),
        ),
        const SizedBox(width: 10),
        ...List.generate(viewModel.totalPages, (index) {
          int pageNum = index + 1;
          bool isActive = pageNum == viewModel.currentPage;
          return GestureDetector(
            onTap: () => viewModel.setPage(pageNum),
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
                  "$pageNum",
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
    );
  }
}
