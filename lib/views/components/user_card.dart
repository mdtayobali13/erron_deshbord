import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user_model.dart';
import 'user_detail_popup.dart';

class UserCard extends StatelessWidget {
  final AppUser user;
  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showUserDetail(context, user),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A), // Darker Navy
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Background Glow/Shape
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.03),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Column(
                children: [
                  // Avatar with Pink Border & Pro Badge
                  Stack(
                    children: [
                      Container(
                        width: 90, // Slightly smaller
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFD946EF), // Bright Pink
                            width: 2.5,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(user.userAvatar),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      if (user.isPro)
                        Positioned(
                          bottom: 2,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFABF0C), // Bright Gold
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Text(
                              "Pro",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.userName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 20, // Slightly smaller
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.userId,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      color: Colors.white60,
                      fontSize: 14, // Slightly smaller
                    ),
                  ),
                  const SizedBox(height: 16), // Reduced spacing
                  // Trust Score Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Trust Score",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "${user.trustScore}%",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Custom Progress Bar
                  Container(
                    height: 8,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: user.legitPercentage,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981), // Emerald
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(5),
                                bottomLeft: const Radius.circular(5),
                                topRight: Radius.circular(
                                  user.suspiciousPercentage == 0 ? 5 : 0,
                                ),
                                bottomRight: Radius.circular(
                                  user.suspiciousPercentage == 0 ? 5 : 0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: user.suspiciousPercentage,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFD946EF), // Pink
                              borderRadius: BorderRadius.only(
                                topRight: const Radius.circular(5),
                                bottomRight: const Radius.circular(5),
                                topLeft: Radius.circular(
                                  user.legitPercentage == 0 ? 5 : 0,
                                ),
                                bottomLeft: Radius.circular(
                                  user.legitPercentage == 0 ? 5 : 0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${user.legitPercentage}% Legit",
                        style: GoogleFonts.outfit(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        "${user.suspiciousPercentage}% Suspicious",
                        style: GoogleFonts.outfit(
                          color: const Color(0xFFEF4444),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Tokens Row
                  _buildInfoRow("Tokens:", user.tokens, isBoldValue: true),
                  const SizedBox(height: 12),

                  // KYC Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "KYC:",
                        style: GoogleFonts.outfit(
                          color: Colors.white60,
                          fontSize: 14,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getKYCColor(user.kycStatus).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          user.kycStatus,
                          style: GoogleFonts.outfit(
                            color: _getKYCColor(user.kycStatus),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (user.isShadowBanned) ...[
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          "Shadow Banned",
                          style: TextStyle(
                            color: Color(0xFFEF4444),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUserDetail(BuildContext context, AppUser user) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: UserDetailPopup(user: user),
        ),
      ),
    );
  }

  Color _getKYCColor(String status) {
    switch (status) {
      case "Verified":
        return const Color(0xFF10B981);
      case "Rejected":
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFFEAB308);
    }
  }

  Widget _buildInfoRow(String label, String value, {bool isBoldValue = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(color: Colors.white60, fontSize: 14),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 18,
            fontWeight: isBoldValue ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
