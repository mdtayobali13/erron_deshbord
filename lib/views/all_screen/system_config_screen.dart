import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../view_models/system_config_view_model.dart';
import '../../models/audit_log_model.dart';

class SystemConfigScreen extends StatelessWidget {
  const SystemConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SystemConfigViewModel>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            "System Configuration",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Manage platform settings and security audits",
            style: GoogleFonts.outfit(color: Colors.white38, fontSize: 16),
          ),
          const SizedBox(height: 40),

          // First Row: Toggles and Pricing
          // First Row: Toggles and Pricing
          // First Row: Toggles and Pricing
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Feature Toggles
              Expanded(
                flex: 1,
                child: _buildSectionCard(
                  title: "Feature Toggles (Emergency Switches)",
                  child: Column(
                    children: [
                      _buildToggleItem(
                        icon: Icons.card_giftcard,
                        title: "Enable Gifting",
                        subtitle: "Allow users to send gifts",
                        value: viewModel.enableGifting,
                        onChanged: viewModel.toggleGifting,
                      ),
                      const SizedBox(height: 16),
                      _buildToggleItem(
                        icon: Icons.diamond_outlined,
                        title: "Enable Paid Streams",
                        subtitle: "Allow premium content",
                        value: viewModel.enablePaidStreams,
                        onChanged: viewModel.togglePaidStreams,
                      ),
                      const SizedBox(height: 16),
                      _buildToggleItem(
                        icon: Icons.person_add_outlined,
                        title: "New User Sign-ups",
                        subtitle: "Allow new registrations",
                        value: viewModel.newUserSignups,
                        onChanged: viewModel.toggleNewUserSignups,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              // Pricing Configuration
              Expanded(
                flex: 1,
                child: _buildSectionCard(
                  title: "Pricing Configuration",
                  subtitle: "Token pricing and platform fees",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPricingInput(
                        label: "Token Pricing (USD per Token)",
                        value: "\$${viewModel.tokenPricing}",
                        onTap: () {},
                      ),
                      const SizedBox(height: 24),
                      _buildPricingInput(
                        label: "Platform Commission (%)",
                        value: "${viewModel.platformCommission}%",
                        onTap: () {},
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Example: If a host earns \$100, they receive \$${100 - viewModel.platformCommission}.00 and platform takes \$${viewModel.platformCommission}.00",
                        style: GoogleFonts.outfit(
                          color: Colors.white38,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            "Save Configuration",
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 60),

          // Security Audit Log section
          Text(
            "Security Audit Log",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          // Security Audit Log section
          Container(
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
                      Expanded(flex: 2, child: _headerCell("Log ID")),
                      Expanded(flex: 3, child: _headerCell("Moderator")),
                      Expanded(flex: 3, child: _headerCell("Action")),
                      Expanded(flex: 3, child: _headerCell("Target")),
                      Expanded(flex: 2, child: _headerCell("Severity")),
                      Expanded(flex: 2, child: _headerCell("Timestamp")),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Colors.white10),
                // Table Rows
                ...viewModel.displayedLogs.map((log) => _buildLogRow(log)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          _buildPagination(viewModel),
        ],
      ),
    );
  }

  Widget _buildPagination(SystemConfigViewModel viewModel) {
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

  Widget _buildSectionCard({
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF11141D),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.outfit(color: Colors.white38, fontSize: 13),
            ),
          ],
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }

  Widget _buildToggleItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white70, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    color: Colors.white38,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF2563EB),
            activeTrackColor: const Color(0xFF2563EB).withOpacity(0.5),
            inactiveThumbColor: Colors.white54,
            inactiveTrackColor: Colors.white12,
          ),
        ],
      ),
    );
  }

  Widget _buildPricingInput({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(color: Colors.white38, fontSize: 12),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: GoogleFonts.outfit(color: Colors.white, fontSize: 15),
                ),
                const Icon(Icons.unfold_more, color: Colors.white38, size: 20),
              ],
            ),
          ),
        ),
      ],
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

  Widget _buildLogRow(AuditLog log) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              log.id,
              style: GoogleFonts.outfit(color: Colors.white70, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              log.moderator,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              log.action,
              style: GoogleFonts.outfit(color: Colors.white70, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              log.target,
              style: GoogleFonts.outfit(color: Colors.white38, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 2,
            child: UnconstrainedBox(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _getSeverityColor(log.severity).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  log.severity,
                  style: GoogleFonts.outfit(
                    color: _getSeverityColor(log.severity),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              log.timestamp,
              style: GoogleFonts.outfit(color: Colors.white38, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case "High":
        return const Color(0xFFFB7185);
      case "Medium":
        return const Color(0xFFFBBF24);
      case "Low":
        return const Color(0xFF34D399);
      default:
        return Colors.white38;
    }
  }
}
