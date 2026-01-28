import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/live_stream_model.dart';
import '../../utils/app_colors.dart';
import '../../view_models/live_monitor_view_model.dart';
import '../../view_models/dashboard_view_model.dart';
import '../../view_models/overview_view_model.dart';
import '../../utils/toast_helper.dart';

class LiveStreamCard extends StatelessWidget {
  final LiveStream stream;

  const LiveStreamCard({super.key, required this.stream});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary,
          width: 2,
        ), // Blue border as per selection in image
        image: DecorationImage(
          image: NetworkImage(
            stream.thumbnail.startsWith('http')
                ? stream.thumbnail
                : "https://images.unsplash.com/photo-1516280440614-6697288d5d38?q=80&w=800",
          ),
          fit: BoxFit.cover,
          onError: (exception, stackTrace) {
            debugPrint("Thumbnail loading failed: $exception");
          },
        ),
      ),
      child: Stack(
        children: [
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                14,
              ), // slightly less than parent
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.9), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),

          // Badges
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.pinkAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Live",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.visibility,
                        color: Colors.white,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        stream.views >= 1000
                            ? "${(stream.views / 1000).toStringAsFixed(1)}k"
                            : stream.views.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber, // Free badge
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Free",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Right side controls (dummy)
          Positioned(
            right: 12,
            top: 60,
            child: Column(
              children: [
                _buildIcon(
                  Icons.visibility_outlined,
                  glassColor: const Color(0xFFD946EF),
                  onTap: () => _showMonitorPopup(context),
                ),
                const SizedBox(height: 8),
                _buildIcon(
                  Icons.photo_camera_outlined,
                  glassColor: const Color(0xFFD946EF),
                  onTap: () {
                    ToastHelper.success(
                      context,
                      title: "Captured",
                      message: "Evidence captured successfully",
                    );
                  },
                ),
                const SizedBox(height: 8),
                _buildIcon(
                  stream.isFrozen
                      ? Icons
                            .play_circle_outline // Action: Resume
                      : Icons.pause_circle_outline, // Action: Freeze
                  glassColor: stream.isFrozen
                      ? const Color(0xFF6366F1).withOpacity(0.3)
                      : const Color(0xFF1F2937),
                  iconColor: stream.isFrozen
                      ? const Color(0xFF6366F1)
                      : Colors.white70,
                  onTap: () async {
                    if (stream.rawId != null) {
                      // Sync with ViewModels
                      try {
                        context.read<DashboardViewModel>().toggleStreamFreeze(
                          stream.rawId!,
                          stream.isFrozen,
                        );
                      } catch (_) {}
                      try {
                        context.read<OverviewViewModel>().toggleStreamFreeze(
                          stream.rawId!,
                          stream.isFrozen,
                        );
                      } catch (_) {}

                      final success = await context
                          .read<LiveMonitorViewModel>()
                          .toggleFreezeStream(stream.rawId!);

                      if (context.mounted) {
                        if (success) {
                          ToastHelper.success(
                            context,
                            title: "Success",
                            message: stream.isFrozen
                                ? "Stream resumed successfully"
                                : "Stream frozen successfully",
                          );
                        } else {
                          ToastHelper.error(
                            context,
                            title: "Error",
                            message: stream.isFrozen
                                ? "Failed to resume stream"
                                : "Failed to freeze stream",
                          );
                        }
                      }
                    }
                  },
                ),
                const SizedBox(height: 8),
                _buildIcon(
                  Icons.stop_circle_outlined,
                  glassColor: const Color(0xFF1F2937),
                  iconColor: Colors.red,
                  onTap: () async {
                    if (stream.rawId != null) {
                      // Also remove from dashboard view model if it's currently active in context
                      try {
                        context.read<DashboardViewModel>().removeStream(
                          stream.rawId!,
                        );
                      } catch (_) {
                        // DashboardViewModel not in context, ignore
                      }

                      final success = await context
                          .read<LiveMonitorViewModel>()
                          .stopStream(stream.rawId!);
                      if (context.mounted) {
                        if (success) {
                          ToastHelper.success(
                            context,
                            title: "Success",
                            message: "Stream stopped successfully",
                          );
                        } else {
                          ToastHelper.error(
                            context,
                            title: "Error",
                            message: "Failed to stop stream",
                          );
                        }
                      }
                    }
                  },
                ),
              ],
            ),
          ),

          // Bottom Content
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.15), // Glassy highlight
                        Colors.white.withOpacity(0.05), // Transparent fade
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(
                        0.4,
                      ), // Stronger glass border
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFD946EF), // Pink border
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(
                                stream.userAvatar.startsWith('http')
                                    ? stream.userAvatar
                                    : "https://randomuser.me/api/portraits/men/32.jpg",
                              ),
                              backgroundColor: Colors.grey[900],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stream.userName,
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                stream.description,
                                style: GoogleFonts.outfit(
                                  color: Colors.white70,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Custom Thick Progress Bar
                      Container(
                        height: 6,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.grey[800],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: stream.legitPercentage,
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF10B981), // Green
                                      Color(0xFF34D399),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    bottomLeft: Radius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: stream.shadyPercentage,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEF4444), // Red
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(4),
                                    bottomRight: Radius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Legit: ${stream.legitPercentage}%",
                            style: GoogleFonts.outfit(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "Shady: ${stream.shadyPercentage}%",
                            style: GoogleFonts.outfit(
                              color: const Color(0xFFEF4444),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),
                      Text(
                        "Stream ID: ${stream.streamId}",
                        style: GoogleFonts.outfit(
                          color: Colors.white38,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMonitorPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (context) => _LiveMonitorPopup(streamId: stream.rawId ?? ""),
    );
  }

  Widget _buildIcon(
    IconData icon, {
    Color? glassColor,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          // Ultra-light almost invisible base
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.6), // Strong white border
            width: 2,
          ),
          boxShadow: [
            // Softer white outer glow
            BoxShadow(
              color: Colors.white.withOpacity(0.15),
              blurRadius: 8,
              spreadRadius: 0,
              offset: const Offset(0, 0),
            ),
            // Subtle depth shadow
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.18), // Very subtle top
                    Colors.white.withOpacity(0.05), // Almost transparent
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: iconColor ?? Colors.white.withOpacity(0.98),
                  size: 22,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LiveMonitorPopup extends StatelessWidget {
  final String streamId;
  const _LiveMonitorPopup({required this.streamId});

  @override
  Widget build(BuildContext context) {
    return Consumer<LiveMonitorViewModel>(
      builder: (context, viewModel, child) {
        // Look up latest stream state
        final index = viewModel.liveStreams.indexWhere(
          (s) => s.rawId == streamId,
        );

        // If stream not found, don't render content or close
        if (index == -1) {
          return const SizedBox.shrink();
        }

        final stream = viewModel.liveStreams[index];

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 40,
            vertical: 24,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Main Container
              Container(
                width: 800,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A), // Dark Navy
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 10,
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
                              stream.userName,
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              stream.description,
                              style: GoogleFonts.outfit(
                                color: Colors.white60,
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

                    // Content Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Preview Image
                        Expanded(
                          flex: 3,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Stack(
                              children: [
                                Image.network(
                                  stream.thumbnail.startsWith('http')
                                      ? stream.thumbnail
                                      : "https://images.unsplash.com/photo-1516280440614-6697288d5d38?q=80&w=800",
                                  height: 300,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 300,
                                      color: Colors.black,
                                      child: const Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          color: Colors.white24,
                                          size: 50,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Positioned(
                                  top: 12,
                                  left: 12,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.pinkAccent,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      "Live",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        // Stats & Details
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      stream.userName,
                                      style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    _buildStatRow(
                                      "Current Viewers",
                                      stream.views.toString(),
                                    ),
                                    const SizedBox(height: 8),
                                    _buildStatRow("Duration", "1h 23m"),
                                    const SizedBox(height: 8),
                                    _buildStatRow("Stream Type", "Public"),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Shady/Legit bar
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 8,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.grey[900],
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 98,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF10B981),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFEF4444),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Legit: 98%",
                                          style: GoogleFonts.outfit(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          "Shady: 2%",
                                          style: GoogleFonts.outfit(
                                            color: const Color(0xFFEF4444),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // Admin Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Admin Action",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            Icons.visibility_outlined, // Changed icon
                            "View", // Changed text
                            const Color(0xFF4B68FF),
                            onTap: () {
                              ToastHelper.success(
                                context,
                                title: "Viewing Stream",
                                message: "Connecting to live feed...",
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildActionButton(
                            Icons.photo_camera_outlined,
                            "Capture Evidence",
                            const Color(0xFFEAB308),
                            onTap: () {
                              ToastHelper.success(
                                context,
                                title: "Captured",
                                message: "Evidence captured successfully",
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            stream.isFrozen
                                ? Icons.play_circle_outline
                                : Icons.pause_circle_outline,
                            stream.isFrozen ? "Resume Stream" : "Freeze Stream",
                            stream.isFrozen
                                ? const Color(0xFF6366F1)
                                : const Color(0xFF10B981),
                            onTap: () async {
                              if (stream.rawId != null) {
                                // Sync with other ViewModels immediately
                                try {
                                  context
                                      .read<DashboardViewModel>()
                                      .toggleStreamFreeze(
                                        stream.rawId!,
                                        stream.isFrozen,
                                      );
                                } catch (_) {}
                                try {
                                  context
                                      .read<OverviewViewModel>()
                                      .toggleStreamFreeze(
                                        stream.rawId!,
                                        stream.isFrozen,
                                      );
                                } catch (_) {}
                                final success = await context
                                    .read<LiveMonitorViewModel>()
                                    .toggleFreezeStream(
                                      stream.rawId!,
                                    );
                                if (context.mounted) {
                                  if (success) {
                                    ToastHelper.success(
                                      context,
                                      title: "Success",
                                      message: stream.isFrozen
                                          ? "Stream resumed successfully"
                                          : "Stream frozen successfully",
                                    );
                                  } else {
                                    ToastHelper.error(
                                      context,
                                      title: "Error",
                                      message: stream.isFrozen
                                          ? "Failed to resume stream"
                                          : "Failed to freeze stream",
                                    );
                                  }
                                }
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildActionButton(
                            Icons.stop_circle_outlined,
                            "Force Stop",
                            const Color(0xFFEF4444), // Red from image
                            onTap: () async {
                              if (stream.rawId != null) {
                                // Close popup immediately for instant feel
                                Navigator.pop(context);

                                // Also remove from dashboard view model if it's currently active in context
                                try {
                                  context
                                      .read<DashboardViewModel>()
                                      .removeStream(stream.rawId!);
                                } catch (_) {
                                  // DashboardViewModel not in context, ignore
                                }

                                final success = await context
                                    .read<LiveMonitorViewModel>()
                                    .stopStream(stream.rawId!);
                                if (context.mounted) {
                                  if (success) {
                                    ToastHelper.success(
                                      context,
                                      title: "Success",
                                      message: "Stream stopped successfully",
                                    );
                                  } else {
                                    ToastHelper.error(
                                      context,
                                      title: "Error",
                                      message: "Failed to stop stream",
                                    );
                                  }
                                }
                              }
                            },
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
      },
    );
  }
}

Widget _buildStatRow(String label, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: GoogleFonts.outfit(color: Colors.white38, fontSize: 13),
      ),
      Text(
        value,
        style: GoogleFonts.outfit(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

Widget _buildActionButton(
  IconData icon,
  String label,
  Color color, {
  VoidCallback? onTap,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 60, // Increased height as per image
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22), // Larger icon
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.w800, // Extra bold
                  fontSize: 16, // Larger font
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
