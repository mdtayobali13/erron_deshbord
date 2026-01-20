import 'package:flutter/material.dart';
import '../models/dashboard_model.dart';

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

    _data = DashboardData(
      stats: [
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
}
