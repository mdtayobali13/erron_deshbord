import 'package:flutter/material.dart';
import '../models/dashboard_model.dart';
import '../services/network_caller.dart';
import '../utils/app_urls.dart';
import '../models/kyc_stats_model.dart';
import '../models/stream_stats_model.dart';
import '../models/live_stream_model.dart';

class DashboardViewModel extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  DashboardData? _data;
  DashboardData? get data => _data;

  DashboardViewModel() {
    loadData();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Fetch Real KYC Data from API
    final response = await NetworkCaller.getRequest(AppUrls.pendingKyc);
    String kycCount = "0";
    if (response.isSuccess && response.responseData != null) {
      final kycStats = KycStatsModel.fromJson(response.responseData);
      kycCount = kycStats.total?.toString() ?? "0";
    }

    // Fetch Real Pending Reports Data
    final reportResponse = await NetworkCaller.getRequest(
      AppUrls.pendingReports,
    );
    String reportCount = "0";
    String highPriorityCount = "0";
    if (reportResponse.isSuccess && reportResponse.responseData != null) {
      try {
        final reportData = reportResponse.responseData;
        reportCount = reportData['total']?.toString() ?? "0";
        highPriorityCount = reportData['high_priority']?.toString() ?? "0";
      } catch (e) {
        debugPrint("Error parsing report stats: $e");
      }
    }

    // Fetch Real Active Streams Stats
    final activeStreamsStatsResponse = await NetworkCaller.getRequest(
      AppUrls.activeStreams,
    );
    String activeStreamsCount = "0";
    String freeStreamsCount = "0";
    String paidStreamsCount = "0";
    if (activeStreamsStatsResponse.isSuccess &&
        activeStreamsStatsResponse.responseData != null) {
      final stats = StreamStatsModel.fromJson(
        activeStreamsStatsResponse.responseData,
      );
      activeStreamsCount = stats.total.toString();
      freeStreamsCount = stats.free.toString();
      paidStreamsCount = stats.paid.toString();
    }

    _data = DashboardData(
      stats: [
        DashboardStat(
          title: "Total Active Streams",
          value: activeStreamsCount,
          subValue: "$freeStreamsCount Public • $paidStreamsCount Paid",
          badgeText: activeStreamsCount == "0" ? "0%" : "+$activeStreamsCount",
          badgeType: BadgeType.success,
          icon: Icons.videocam_outlined,
        ),
        DashboardStat(
          title: "Pending Reports",
          value: reportCount,
          subValue: "$highPriorityCount High Priority",
          badgeText: reportCount == "0" ? "0%" : "+$reportCount",
          badgeType: BadgeType.error,
          icon: Icons.report_gmailerrorred_outlined,
        ),
        DashboardStat(
          title: "Total Token Sales",
          value: "\$24.5k",
          subValue: "Today: \$3.2k",
          badgeText: "+247%",
          badgeType: BadgeType.success,
          icon: Icons.monetization_on_outlined,
        ),
        DashboardStat(
          title: "Pending KYC Requests",
          value: kycCount,
          subValue: "$kycCount Awaiting Review",
          badgeText: kycCount == "0" ? "0%" : "+$kycCount",
          badgeType: BadgeType.success,
          icon: Icons.person_search_outlined,
        ),
      ],
      revenueTrend: [
        SalesData("Jan", 33000), // Starting high
        SalesData("Jan", 32500), // Dip
        SalesData("Jan", 35000), // Rise
        SalesData("Jan", 34500), // Small dip
        SalesData("Jan", 40000), // Big rise
        SalesData("Jan", 42000), // Peak
        SalesData("Jan", 38000), // End
      ],
      newUserTrend: [
        SalesData("Jan", 37000),
        SalesData("Jan", 36000),
        SalesData("Jan", 39000),
        SalesData("Jan", 38000),
        SalesData("Jan", 42000),
        SalesData("Jan", 45000),
        SalesData("Jan", 41000),
      ],
      liveStreams: [
        LiveStream(
          userName: "Sarah Jenkins",
          userAvatar: "https://randomuser.me/api/portraits/women/44.jpg",
          streamTitle: "Sarah Jenkins",
          description: "Sarah Streaming music live",
          thumbnail:
              "https://images.unsplash.com/photo-1516280440614-6697288d5d38?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80",
          legitPercentage: 98,
          streamId: "#4521",
        ),
        LiveStream(
          userName: "Isabell Reide",
          userAvatar: "https://randomuser.me/api/portraits/women/65.jpg",
          streamTitle: "Isabell Reide",
          description: "Sea beach touring",
          thumbnail:
              "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80",
          legitPercentage: 92,
          streamId: "#8832",
        ),
        LiveStream(
          userName: "Arthur Doe",
          userAvatar: "https://randomuser.me/api/portraits/men/32.jpg",
          streamTitle: "Arthur Doe",
          description: "Urban Photography",
          thumbnail:
              "https://images.unsplash.com/photo-1554048612-387768052bf7?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80",
          legitPercentage: 95,
          streamId: "#9941",
        ),
      ],
    );

    _isLoading = false;
    notifyListeners();
  }

  void removeStream(String streamId) {
    if (_data != null) {
      _data!.liveStreams.removeWhere((s) => s.rawId == streamId);
      notifyListeners();
    }
  }

  void toggleStreamFreeze(String streamId, bool isCurrentlyFrozen) {
    if (_data != null) {
      final index = _data!.liveStreams.indexWhere((s) => s.rawId == streamId);
      if (index != -1) {
        final current = _data!.liveStreams[index];
        _data!.liveStreams[index] = LiveStream(
          userName: current.userName,
          userAvatar: current.userAvatar,
          streamTitle: current.streamTitle,
          description: current.description,
          thumbnail: current.thumbnail,
          legitPercentage: current.legitPercentage,
          streamId: current.streamId,
          rawId: current.rawId,
          isFree: current.isFree,
          isFrozen: !isCurrentlyFrozen,
          isLive: current.isLive,
          is4k: current.is4k,
        );
        notifyListeners();
      }
    }
  }
}
