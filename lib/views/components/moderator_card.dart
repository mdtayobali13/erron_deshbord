import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../view_models/moderator_view_model.dart';
import '../../models/moderator_model.dart';
import 'moderator_detail_popup.dart';

class ModeratorCard extends StatelessWidget {
  final Moderator moderator;
  const ModeratorCard({super.key, required this.moderator});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF11141D), // Deep dark grey/black
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar with Magenta Border and Status Dot
              Stack(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFD946EF), // Magenta border
                        width: 1.5,
                      ),
                      image: DecorationImage(
                        image: NetworkImage(
                          "https://ui-avatars.com/api/?name=${moderator.fullName ?? "Mod"}&background=random",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 2,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: moderator.isActive == true
                            ? const Color(0xFF10B981)
                            : Colors.grey, // Green status dot
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF11141D),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              // Name and Username
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            moderator.fullName ?? "No Name",
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B222C), // Darker badge bg
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            moderator.isActive == true ? "Active" : "Inactive",
                            style: GoogleFonts.outfit(
                              color:
                                  (moderator.isActive == true
                                          ? const Color(0xFF10B981)
                                          : Colors.red)
                                      .withOpacity(0.6),
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      moderator.username ?? "moderator",
                      style: GoogleFonts.outfit(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.white.withOpacity(0.3),
                  size: 18,
                ),
                color: const Color(0xFF1B1E26),
                offset: const Offset(0, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.white.withOpacity(0.05)),
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    _showModeratorDetail(context, moderator);
                  } else if (value == 'delete') {
                    _showDeleteConfirmation(context);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        const Icon(
                          Icons.edit_outlined,
                          size: 18,
                          color: Colors.white70,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Edit",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: Color(0xFFEF4444),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Delete",
                          style: GoogleFonts.outfit(
                            color: const Color(0xFFEF4444),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Stats Row
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  moderator.reportedCount?.toString() ?? "0",
                  "Reports",
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatItem(
                  moderator.suspendedCount?.toString() ?? "0",
                  "Bans",
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatItem(
                  moderator.appealCount?.toString() ?? "0",
                  "Appeals",
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatItem("100%", "Accuracy", isGreen: true),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFooterItem(
                Icons.calendar_today_outlined,
                "Joined ${moderator.createdAt?.toString().split(' ')[0] ?? "Unknown"}",
              ),
              _buildFooterItem(
                Icons.history,
                moderator.isActive == true ? "Active" : "Inactive",
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1B1E26),
        title: Text(
          "Delete Moderator",
          style: GoogleFonts.outfit(color: Colors.white),
        ),
        content: Text(
          "Are you sure you want to delete ${moderator.fullName ?? "this moderator"}?",
          style: GoogleFonts.outfit(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: GoogleFonts.outfit(color: Colors.white38),
            ),
          ),
          TextButton(
            onPressed: () {
              Provider.of<ModeratorViewModel>(
                context,
                listen: false,
              ).deleteModerator(moderator.id ?? "");
              Navigator.pop(context);
            },
            child: Text(
              "Delete",
              style: GoogleFonts.outfit(color: const Color(0xFFEF4444)),
            ),
          ),
        ],
      ),
    );
  }

  void _showModeratorDetail(BuildContext context, Moderator moderator) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: ModeratorDetailPopup(moderator: moderator),
        ),
      ),
    );
  }

  Widget _buildFooterItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.white.withOpacity(0.4)),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.outfit(
            color: Colors.white.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String value, String label, {bool isGreen = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1E26), // Darker box background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.outfit(
              color: isGreen ? const Color(0xFF10B981) : Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.outfit(
              color: Colors.white.withOpacity(0.4),
              fontSize: 8,
            ),
          ),
        ],
      ),
    );
  }
}
