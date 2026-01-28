class RevenueTrendModel {
  final int year;
  final double totalYearlyRevenue;
  final List<MonthlyRevenue> monthlyRevenues;

  RevenueTrendModel({
    required this.year,
    required this.totalYearlyRevenue,
    required this.monthlyRevenues,
  });

  factory RevenueTrendModel.fromJson(Map<String, dynamic> json) {
    return RevenueTrendModel(
      year: json['year'],
      totalYearlyRevenue: (json['total_yearly_revenue'] as num).toDouble(),
      monthlyRevenues: (json['monthly_revenues'] as List)
          .map((e) => MonthlyRevenue.fromJson(e))
          .toList(),
    );
  }
}

class MonthlyRevenue {
  final String month;
  final double revenueUsd;

  MonthlyRevenue({required this.month, required this.revenueUsd});

  factory MonthlyRevenue.fromJson(Map<String, dynamic> json) {
    return MonthlyRevenue(
      month: json['month'],
      revenueUsd: (json['revenue_usd'] as num).toDouble(),
    );
  }
}
