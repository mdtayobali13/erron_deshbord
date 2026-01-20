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
