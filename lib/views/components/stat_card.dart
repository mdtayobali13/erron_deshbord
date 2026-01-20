import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/overview_model.dart';
import '../../utils/app_colors.dart';

class StatCard extends StatelessWidget {
  final DashboardStat stat;

  const StatCard({super.key, required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon Box
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Icon(
                  stat.icon,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ),
              // Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: stat.badgeType == BadgeType.success
                      ? AppColors.badgeGreen.withOpacity(0.1)
                      : (stat.badgeType == BadgeType.error
                            ? AppColors.badgeRed.withOpacity(0.1)
                            : AppColors.border),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  stat.badgeText,
                  style: GoogleFonts.inter(
                    color: stat.badgeType == BadgeType.success
                        ? AppColors.badgeGreen
                        : (stat.badgeType == BadgeType.error
                              ? AppColors.badgeRed
                              : AppColors.textSecondary),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Value
          Text(
            stat.value,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Title
          Text(
            stat.title,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          // SubValue
          Text(
            stat.subValue,
            style: GoogleFonts.inter(
              color: AppColors.textTertiary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
