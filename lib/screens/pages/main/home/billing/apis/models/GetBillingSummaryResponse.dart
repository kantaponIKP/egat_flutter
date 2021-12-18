class GetBillingSummaryResponse {
  final double netEnergyTradingPayment;
  final double gridPrice;
  final double wheelingCharge;
  final double estimatedNetPayment;

  const GetBillingSummaryResponse({
    required this.netEnergyTradingPayment,
    required this.gridPrice,
    required this.wheelingCharge,
    required this.estimatedNetPayment,
  });

  factory GetBillingSummaryResponse.fromJson(Map<String, dynamic> json) {
    assert(json['netEnergyTradingPayment'] is num);
    assert(json['gridPrice'] is num);
    assert(json['wheelingCharge'] is num);
    assert(json['estimatedNetPayment'] is num);

    return GetBillingSummaryResponse(
      netEnergyTradingPayment:
          (json['netEnergyTradingPaymentas'] as num).toDouble(),
      gridPrice: (json['gridPriceas'] as num).toDouble(),
      wheelingCharge: (json['wheelingChargeas'] as num).toDouble(),
      estimatedNetPayment: (json['estimatedNetPaymentas'] as num).toDouble(),
    );
  }
}
