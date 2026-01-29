class FinanceStatsModel {
  final num totalTokenSalesUsd;
  final num totalPayoutsUsd;
  final num profitMarginUsd;
  final num pendingPayoutsUsd;

  FinanceStatsModel({
    required this.totalTokenSalesUsd,
    required this.totalPayoutsUsd,
    required this.profitMarginUsd,
    required this.pendingPayoutsUsd,
  });

  factory FinanceStatsModel.fromJson(Map<String, dynamic> json) {
    return FinanceStatsModel(
      totalTokenSalesUsd: json['total_token_sales_usd'] ?? 0,
      totalPayoutsUsd: json['total_payouts_usd'] ?? 0,
      profitMarginUsd: json['profit_margin_usd'] ?? 0,
      pendingPayoutsUsd: json['pending_payouts_usd'] ?? 0,
    );
  }
}
