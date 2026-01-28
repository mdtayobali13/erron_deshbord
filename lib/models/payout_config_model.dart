class PayoutConfig {
  double? tokenRateUsd;
  double? platformFeePercent;
  double? minWithdrawalAmount;

  PayoutConfig({
    this.tokenRateUsd,
    this.platformFeePercent,
    this.minWithdrawalAmount,
  });

  factory PayoutConfig.fromJson(Map<String, dynamic> json) {
    return PayoutConfig(
      tokenRateUsd: (json['token_rate_usd'] as num?)?.toDouble(),
      platformFeePercent: (json['platform_fee_percent'] as num?)?.toDouble(),
      minWithdrawalAmount: (json['min_withdrawal_amount'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token_rate_usd': tokenRateUsd,
      'platform_fee_percent': platformFeePercent,
      'min_withdrawal_amount': minWithdrawalAmount,
    };
  }
}
