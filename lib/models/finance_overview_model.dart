class FinanceOverviewModel {
  double totalTokenSalesUsd;
  double totalPayoutsUsd;
  double profitMarginUsd;
  double pendingPayoutsUsd;

  FinanceOverviewModel({
    this.totalTokenSalesUsd = 0,
    this.totalPayoutsUsd = 0,
    this.profitMarginUsd = 0,
    this.pendingPayoutsUsd = 0,
  });

  FinanceOverviewModel.fromJson(Map<String, dynamic> json)
    : totalTokenSalesUsd = (json['total_token_sales_usd'] ?? 0).toDouble(),
      totalPayoutsUsd = (json['total_payouts_usd'] ?? 0).toDouble(),
      profitMarginUsd = (json['profit_margin_usd'] ?? 0).toDouble(),
      pendingPayoutsUsd = (json['pending_payouts_usd'] ?? 0).toDouble();

  Map<String, dynamic> toJson() {
    return {
      'total_token_sales_usd': totalTokenSalesUsd,
      'total_payouts_usd': totalPayoutsUsd,
      'profit_margin_usd': profitMarginUsd,
      'pending_payouts_usd': pendingPayoutsUsd,
    };
  }
}
