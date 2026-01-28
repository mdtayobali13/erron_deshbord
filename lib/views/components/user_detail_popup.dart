import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../view_models/user_management_view_model.dart';
import '../../utils/toast_helper.dart';

class UserDetailPopup extends StatefulWidget {
  final AppUser user;
  const UserDetailPopup({super.key, required this.user});

  @override
  State<UserDetailPopup> createState() => _UserDetailPopupState();
}

class _UserDetailPopupState extends State<UserDetailPopup> {
  bool _shadowBan = false;
  bool _deviceBan = false;

  @override
  void initState() {
    super.initState();
    _shadowBan = widget.user.isShadowBanned;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserManagementViewModel>(
      builder: (context, viewModel, child) {
        final freshUser = viewModel.users.firstWhere(
          (u) => u.id == widget.user.id,
          orElse: () => widget.user,
        );

        return Container(
          width: 700,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF0F1016),
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
          child: SingleChildScrollView(
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
                          freshUser.userName,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          freshUser.role ?? "Sarah Streaming music live",
                          style: GoogleFonts.outfit(
                            color: Colors.white38,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
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

                // User Info Section
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.02),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildPopupStat("User ID", freshUser.userId),
                          _buildPopupStat(
                            "Phone Number",
                            freshUser.phoneNumber ?? "N/A",
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _buildPopupStat("Token Balance", freshUser.tokens),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Trust Score",
                                    style: GoogleFonts.outfit(
                                      color: Colors.white38,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 86),
                                  Text(
                                    "${freshUser.trustScore}%",
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 180,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Row(
                                  children: [
                                    Flexible(
                                      flex: freshUser.legitPercentage,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF10B981),
                                          borderRadius: BorderRadius.circular(
                                            3,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: freshUser.suspiciousPercentage,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFD946EF),
                                          borderRadius: BorderRadius.circular(
                                            3,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    "${freshUser.legitPercentage}% Legit",
                                    style: const TextStyle(
                                      color: Colors.white24,
                                      fontSize: 10,
                                    ),
                                  ),
                                  const SizedBox(width: 50),
                                  Text(
                                    "${freshUser.suspiciousPercentage}% Suspicious",
                                    style: const TextStyle(
                                      color: Color(0xFFD946EF),
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                      // KYC ID Images (Only for Pending/Processing)
                      if (freshUser.kyc != null) ...[
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            Expanded(
                              child: _buildIDCard(
                                "ID Front",
                                freshUser.kyc!.idFront,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildIDCard(
                                "ID Back",
                                freshUser.kyc!.idBack,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: viewModel.isLoading
                                  ? null
                                  : () async {
                                      final success = await viewModel
                                          .updateKycStatus(
                                            freshUser.id!,
                                            "verified",
                                          );
                                      if (context.mounted) {
                                        if (success) {
                                          ToastHelper.success(
                                            context,
                                            title: "KYC Verified",
                                            message:
                                                "User KYC has been successfully verified",
                                          );
                                        } else {
                                          ToastHelper.error(
                                            context,
                                            title: "Error",
                                            message:
                                                viewModel.errorMessage ??
                                                "Failed to verify KYC",
                                          );
                                        }
                                      }
                                    },
                              child: _buildActionButton(
                                "Verify KYC",
                                const Color(0xFF2563EB),
                              ),
                            ),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: viewModel.isLoading
                                  ? null
                                  : () => _showRejectionDialog(
                                      context,
                                      viewModel,
                                      freshUser,
                                    ),
                              child: _buildActionButton(
                                "Reject",
                                const Color(0xFFEF4444),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Punishment Controls Section
                Text(
                  "Punishment Controls",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _buildControlItem(
                  "Shadow Ban",
                  "User can stream/chat, but no one sees them",
                  Switch(
                    value: _shadowBan,
                    onChanged: (v) {
                      setState(() => _shadowBan = v);
                      if (v) {
                        ToastHelper.success(
                          context,
                          title: "Shadow Ban Enabled",
                          message: "User is now shadow banned",
                        );
                      } else {
                        ToastHelper.success(
                          context,
                          title: "Shadow Ban Disabled",
                          message: "User is no longer shadow banned",
                        );
                      }
                    },
                    activeColor: const Color(0xFF2563EB),
                  ),
                ),
                _buildControlItem(
                  "Hard Ban",
                  "User cannot login",
                  (freshUser.accountStatus?.toUpperCase() == "INACTIVE")
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Text(
                            "Banned",
                            style: TextStyle(
                              color: Color(0xFFEF4444),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: viewModel.isLoading
                              ? null
                              : () async {
                                  final success = await viewModel
                                      .toggleUserStatus(
                                        freshUser.id!,
                                        "ACTIVE", // Force to set to INACTIVE
                                      );
                                  if (context.mounted) {
                                    if (success) {
                                      ToastHelper.success(
                                        context,
                                        title: "Success",
                                        message: "User has been banned",
                                      );
                                    } else {
                                      ToastHelper.error(
                                        context,
                                        title: "Error",
                                        message:
                                            viewModel.errorMessage ??
                                            "Failed to ban user. Please check your connection.",
                                      );
                                    }
                                  }
                                },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: viewModel.isLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    "Ban User",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                ),
                _buildControlItem(
                  "Device Ban",
                  "Blacklists the Device Fingerprint/IP",
                  Switch(
                    value: _deviceBan,
                    onChanged: (v) {
                      setState(() => _deviceBan = v);
                      if (v) {
                        ToastHelper.error(
                          context,
                          title: "Device Ban Enabled",
                          message: "Device IP/Fingerprint has been blacklisted",
                        );
                      } else {
                        ToastHelper.success(
                          context,
                          title: "Device Ban Disabled",
                          message: "Device has been whitelisted",
                        );
                      }
                    },
                    activeColor: const Color(0xFF2563EB),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPopupStat(String label, String value, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(color: Colors.white38, fontSize: 13),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: GoogleFonts.outfit(
            color: valueColor ?? Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildControlItem(String title, String subtitle, Widget trailing) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    color: Colors.white38,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildIDCard(String label, String? imageUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.02),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          clipBehavior: Clip.antiAlias,
          child: _buildIDImage(imageUrl),
        ),
      ],
    );
  }

  Widget _buildIDImage(String? urlRaw) {
    if (urlRaw == null || urlRaw.isEmpty) {
      return Center(
        child: Icon(Icons.image_not_supported, color: Colors.white12, size: 30),
      );
    }

    String finalUrl = urlRaw;
    if (!urlRaw.startsWith("http")) {
      // Assuming relative path from API root or public folder
      // Adjust this base URL if your images are hosted elsewhere or need /api prefix
      // Based on previous code, it seemed to expect just base domain prepended
      finalUrl = "https://erronliveapp.mtscorporate.com$urlRaw";
    }

    return Image.network(
      finalUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        print("Error loading ID image: $finalUrl, $error");
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.broken_image, color: Colors.white24, size: 30),
              SizedBox(height: 4),
              Text(
                "Failed to load",
                style: TextStyle(color: Colors.white24, fontSize: 10),
              ),
            ],
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                : null,
            strokeWidth: 2,
            color: Colors.white24,
          ),
        );
      },
    );
  }

  Widget _buildActionButton(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showRejectionDialog(
    BuildContext context,
    UserManagementViewModel viewModel,
    AppUser user,
  ) {
    final TextEditingController reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0F1016),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        title: Text(
          "Reject KYC",
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Please provide a reason for rejection:",
              style: GoogleFonts.outfit(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              style: GoogleFonts.outfit(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Rejection reason...",
                hintStyle: GoogleFonts.outfit(color: Colors.white38),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: GoogleFonts.outfit(color: Colors.white60),
            ),
          ),
          TextButton(
            onPressed: () async {
              if (user.id == null) {
                ToastHelper.error(
                  context,
                  title: "Error",
                  message: "User ID not found",
                );
                return;
              }
              Navigator.pop(context);
              final success = await viewModel.updateKycStatus(
                user.id!,
                "rejected",
                rejectionReason: reasonController.text,
              );
              if (context.mounted) {
                if (success) {
                  ToastHelper.success(
                    context,
                    title: "KYC Rejected",
                    message: "User KYC has been rejected",
                  );
                } else {
                  ToastHelper.error(
                    context,
                    title: "Error",
                    message: viewModel.errorMessage ?? "Failed to reject KYC",
                  );
                }
              }
            },
            child: Text(
              "Reject",
              style: GoogleFonts.outfit(
                color: const Color(0xFFEF4444),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
