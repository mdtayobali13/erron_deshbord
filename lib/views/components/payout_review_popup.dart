import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/payout_model.dart';
import '../../view_models/finance_view_model.dart';
import '../../utils/toast_helper.dart';

class PayoutReviewPopup extends StatelessWidget {
  final PayoutRequest request;
  const PayoutReviewPopup({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 650,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1219),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
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
                    request.hostName,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Payout Request: PAY-00${request.id}",
                    style: GoogleFonts.outfit(
                      color: Colors.white38,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Divider(color: Colors.white10),
          const SizedBox(height: 32),

          // Detail Content
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // KYC & Destination Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "KYC Status",
                          style: GoogleFonts.outfit(
                            color: Colors.white38,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              request.kycStatus,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            request.kycStatus,
                            style: GoogleFonts.outfit(
                              color: _getStatusColor(request.kycStatus),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Destination",
                          style: GoogleFonts.outfit(
                            color: Colors.white38,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          request.destination,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Values Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.03)),
                  ),
                  child: Column(
                    children: [
                      _buildValueRow("Token Amount", request.tokens.toString()),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Icon(
                          Icons.arrow_downward,
                          color: Colors.white.withOpacity(0.2),
                          size: 20,
                        ),
                      ),
                      _buildValueRow("Fiat value (USD)", "\$${request.amount}"),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                // Submitted Info
                Row(
                  children: [
                    Text(
                      "Submitted: ",
                      style: GoogleFonts.outfit(
                        color: Colors.white38,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      request.timeAgo,
                      style: GoogleFonts.outfit(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Action Buttons
          Consumer<FinanceViewModel>(
            builder: (context, viewModel, child) {
              return Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: viewModel.isLoading
                          ? null
                          : () async {
                              if (request.id != null) {
                                final success = await viewModel
                                    .updatePayoutStatus(request.id!, "decline");
                                if (context.mounted) {
                                  if (success) {
                                    ToastHelper.success(
                                      context,
                                      title: "Declined",
                                      message:
                                          "Payout request has been declined.",
                                    );
                                    Navigator.pop(context);
                                  } else {
                                    ToastHelper.error(
                                      context,
                                      title: "Error",
                                      message:
                                          viewModel.errorMessage ??
                                          "Failed to decline payout",
                                    );
                                  }
                                }
                              }
                            },
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
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
                                  "Decline",
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: viewModel.isLoading
                          ? null
                          : () async {
                              if (request.id != null) {
                                final success = await viewModel
                                    .updatePayoutStatus(request.id!, "approve");
                                if (context.mounted) {
                                  if (success) {
                                    ToastHelper.success(
                                      context,
                                      title: "Approved",
                                      message:
                                          "Payout request approved and tokens deducted.",
                                    );
                                    Navigator.pop(context);
                                  } else {
                                    ToastHelper.error(
                                      context,
                                      title: "Error",
                                      message:
                                          viewModel.errorMessage ??
                                          "Failed to approve payout",
                                    );
                                  }
                                }
                              }
                            },
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
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
                                  "Approve Transfer",
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildValueRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Verified":
        return const Color(0xFF34D399);
      case "Rejected":
        return const Color(0xFFFB7185);
      case "Pending":
        return const Color(0xFFFBBF24);
      default:
        return Colors.white38;
    }
  }
}
