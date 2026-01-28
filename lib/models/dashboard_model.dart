import 'live_stream_model.dart';
import 'package:flutter/material.dart';

enum BadgeType { success, error, neutral }

class DashboardStat {
  final String title;
  final String value;
  final String subValue;
  final String badgeText;
  final BadgeType badgeType;
  final IconData icon;

  DashboardStat({
    required this.title,
    required this.value,
    required this.subValue,
    required this.badgeText,
    required this.badgeType,
    required this.icon,
  });
}

class SalesData {
  final String month;
  final double amount;

  SalesData(this.month, this.amount);
}

class DashboardData {
  final List<DashboardStat> stats;
  final List<SalesData> revenueTrend;
  final List<SalesData> newUserTrend;
  final List<LiveStream> liveStreams;

  DashboardData({
    required this.stats,
    required this.revenueTrend,
    required this.newUserTrend,
    required this.liveStreams,
  });
}
