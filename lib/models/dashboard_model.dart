import 'package:flutter/material.dart';

enum BadgeType { success, error, neutral }

class DashboardStat {
  final String title;
  final String value;
  final String subValue; // e.g. "189 Public • 58 Paid"
  final String badgeText; // e.g. "+247%"
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

class LiveStream {
  final String userName;
  final String userAvatar;
  final String streamTitle; // "Sarah Jenkins" (Name is bold)
  final String description; // "Sarah Streaming music live"
  final String thumbnail; // Asset path
  final bool isLive;
  final bool is4k;
  final bool isFree;
  final int legitPercentage; // 98
  final int shadyPercentage; // 2
  final String streamId;

  LiveStream({
    required this.userName,
    required this.userAvatar,
    required this.streamTitle,
    required this.description,
    required this.thumbnail,
    this.isLive = true,
    this.is4k = false,
    this.isFree = true,
    required this.legitPercentage,
    required this.streamId,
  }) : shadyPercentage = 100 - legitPercentage;
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
