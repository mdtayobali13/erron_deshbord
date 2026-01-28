import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../view_models/system_config_view_model.dart';
import '../../models/audit_log_model.dart';
import '../../utils/toast_helper.dart';

class SystemConfigScreen extends StatefulWidget {
  const SystemConfigScreen({super.key});

  @override
  State<SystemConfigScreen> createState() => _SystemConfigScreenState();
}

class _SystemConfigScreenState extends State<SystemConfigScreen> {
  final TextEditingController _tokenPricingController = TextEditingController();
  final TextEditingController _commissionController = TextEditingController();
  final TextEditingController _minWithdrawalController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tokenPricingController.dispose();
    _commissionController.dispose();
    _minWithdrawalController.dispose();
    super.dispose();
  }

  bool _isInitialized = false;

  void _syncControllers(SystemConfigViewModel viewModel) {
    if (!_isInitialized && viewModel.payoutConfig != null) {
      _tokenPricingController.text = viewModel.tokenPricing.toString();
      _commissionController.text = viewModel.platformCommission.toString();
      _minWithdrawalController.text = viewModel.minWithdrawalAmount.toString();
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SystemConfigViewModel>(context);
    _syncControllers(viewModel);

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Feature Toggles
              Expanded(
                child: _buildSectionCard(
                  title: "Feature Toggles (Emergency Switches)",
                  child: Column(
                    children: [
                      _buildToggleItem(
                        context: context,
                        icon: Icons.card_giftcard,
                        title: "Enable Gifting",
                        subtitle: "Allow users to send gifts",
                        value: viewModel.enableGifting,
                        onChanged: (value) {
                          viewModel.toggleGifting(value);
                          if (value) {
                            ToastHelper.success(
                              context,
                              title: "Enabled",
                              message: "Gifting enabled successfully",
                            );
                          } else {
                            ToastHelper.error(
                              context,
                              title: "Disabled",
                              message: "Gifting disabled successfully",
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildToggleItem(
                        context: context,
                        icon: Icons.diamond_outlined,
                        title: "Enable Paid Streams",
                        subtitle: "Allow premium content",
                        value: viewModel.enablePaidStreams,
                        onChanged: (value) {
                          viewModel.togglePaidStreams(value);
                          if (value) {
                            ToastHelper.success(
                              context,
                              title: "Enabled",
                              message: "Paid Streams enabled successfully",
                            );
                          } else {
                            ToastHelper.error(
                              context,
                              title: "Disabled",
                              message: "Paid Streams disabled successfully",
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildToggleItem(
                        context: context,
                        icon: Icons.person_add_outlined,
                        title: "New User Sign-ups",
                        subtitle: "Allow new registrations",
                        value: viewModel.newUserSignups,
                        onChanged: (value) {
                          viewModel.toggleNewUserSignups(value);
                          if (value) {
                            ToastHelper.success(
                              context,
                              title: "Enabled",
                              message: "User Sign-ups enabled successfully",
                            );
                          } else {
                            ToastHelper.error(
                              context,
                              title: "Disabled",
                              message: "User Sign-ups disabled successfully",
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              // Pricing Configuration
              Expanded(
                child: _buildSectionCard(
                  title: "Pricing Configuration",
                  subtitle: "Token pricing and platform fees",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPricingInput(
                        label: "Token Pricing (USD per Token)",
                        controller: _tokenPricingController,
                        prefix: "\$",
                      ),
                      const SizedBox(height: 24),
                      _buildPricingInput(
                        label: "Platform Commission (%)",
                        controller: _commissionController,
                        suffix: "%",
                      ),
                      const SizedBox(height: 24),
                      _buildPricingInput(
                        label: "Min Withdrawal Amount (USD)",
                        controller: _minWithdrawalController,
                        prefix: "\$",
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Example: If a host earns \$100, they receive \$${(100 - (double.tryParse(_commissionController.text) ?? 0)).toStringAsFixed(0)}.00 and platform takes \$${(double.tryParse(_commissionController.text) ?? 0).toStringAsFixed(0)}.00",
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
                          onPressed: viewModel.isLoading
                              ? null
                              : () async {
                                  // Update viewModel values from controllers
                                  viewModel.setTokenPricing(
                                    double.tryParse(
                                          _tokenPricingController.text,
                                        ) ??
                                        0,
                                  );
                                  viewModel.setPlatformCommission(
                                    double.tryParse(
                                          _commissionController.text,
                                        ) ??
                                        0,
                                  );
                                  viewModel.setMinWithdrawalAmount(
                                    double.tryParse(
                                          _minWithdrawalController.text,
                                        ) ??
                                        0,
                                  );

                                  final success = await viewModel
                                      .updatePayoutConfig();
                                  if (context.mounted) {
                                    if (success) {
                                      ToastHelper.success(
                                        context,
                                        title: "Success",
                                        message:
                                            "Pricing configuration updated successfully",
                                      );
                                    } else {
                                      ToastHelper.error(
                                        context,
                                        title: "Error",
                                        message:
                                            viewModel.errorMessage ??
                                            "Failed to update pricing",
                                      );
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            elevation: 0,
                          ),
                          child: viewModel.isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
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
    required BuildContext context,
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
    required TextEditingController controller,
    String? prefix,
    String? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(color: Colors.white38, fontSize: 12),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (val) => setState(() {}), // Refresh example calculation
          style: GoogleFonts.outfit(color: Colors.white, fontSize: 15),
          decoration: InputDecoration(
            prefixText: prefix,
            prefixStyle: GoogleFonts.outfit(color: Colors.white, fontSize: 15),
            suffixText: suffix,
            suffixStyle: GoogleFonts.outfit(color: Colors.white, fontSize: 15),
            filled: true,
            fillColor: Colors.white.withOpacity(0.02),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: const Color(0xFF2563EB)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
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
            child: Tooltip(
              message: log.id ?? "",
              child: Text(
                (log.id != null && log.id!.length > 8)
                    ? "${log.id!.substring(0, 8)}..."
                    : (log.id ?? "N/A"),
                style: GoogleFonts.outfit(color: Colors.white70, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
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
              log.action ?? "N/A",
              style: GoogleFonts.outfit(color: Colors.white70, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              log.target ?? "N/A",
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
                  color: _getSeverityColor(log.severity ?? "").withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  log.severity ?? "Unknown",
                  style: GoogleFonts.outfit(
                    color: _getSeverityColor(log.severity ?? ""),
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
              log.timestamp != null
                  ? log.timestamp!.toLocal().toString().split('.')[0]
                  : "N/A",
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
