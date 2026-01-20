import 'package:flutter/material.dart';
import '../models/overview_model.dart';
import '../models/live_stream_model.dart';

class OverviewViewModel extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<DashboardStat> _stats = [];
  List<DashboardStat> get stats => _stats;

  List<SalesData> _revenueTrend = [];
  List<SalesData> get revenueTrend => _revenueTrend;

  List<SalesData> _newUserTrend = [];
  List<SalesData> get newUserTrend => _newUserTrend;

  // Dashboard might also want to show a preview of live streams, so we can keep a small list here
  List<LiveStream> _previewStreams = [];
  List<LiveStream> get previewStreams => _previewStreams;

  OverviewViewModel() {
    loadData();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _stats = [
      DashboardStat(
        title: "Total Active Streams",
        value: "247",
        subValue: "189 Public • 58 Paid",
        badgeText: "+247%",
        badgeType: BadgeType.success,
        icon: Icons.videocam_outlined,
      ),
      DashboardStat(
        title: "Pending Reports",
        value: "18",
        subValue: "5 High Priority",
        badgeText: "+247%",
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
        value: "247",
        subValue: "12 Awaiting Review",
        badgeText: "+247%",
        badgeType: BadgeType.success,
        icon: Icons.person_search_outlined,
      ),
    ];

    _revenueTrend = [
      SalesData("Jan", 33000),
      SalesData("Jan", 32500),
      SalesData("Jan", 35000),
      SalesData("Jan", 34500),
      SalesData("Jan", 40000),
      SalesData("Jan", 42000),
      SalesData("Jan", 38000),
    ];

    _newUserTrend = [
      SalesData("Jan", 37000),
      SalesData("Jan", 36000),
      SalesData("Jan", 39000),
      SalesData("Jan", 38000),
      SalesData("Jan", 42000),
      SalesData("Jan", 45000),
      SalesData("Jan", 41000),
    ];

    // For the dashboard preview, we can use the same data for now
    _previewStreams = [
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
    ];

    _isLoading = false;
    notifyListeners();
  }
}
