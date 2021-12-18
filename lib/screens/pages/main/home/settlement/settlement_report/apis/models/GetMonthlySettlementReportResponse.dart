class GetMonthlySettlementReportResponse {
  final double completedContracts;
  final double completedContractsShortTermBilateral;
  final double completedContractsLongTermBilateral;
  final double completedContractsPool;

  final double scheduledContracts;
  final double scheduledContractsShortTermBilateral;
  final double scheduledContractsLongTermBilateral;
  final double scheduledContractsPool;

  final double sellerEnergyCommited;
  final double sellerEnergyDelivered;

  final double buyerEnergyCommited;
  final double buyerEnergyUsed;

  final double netSell;
  final double netBuy;

  final double sellerImbalanceAmount;
  final double buyerImbalanceAmount;
  final double netImbalance;

  final double wheelingCharge;
  final double netEnergySalesPrice;
  final double netEnergyBuyPrice;

  const GetMonthlySettlementReportResponse({
    required this.completedContracts,
    required this.completedContractsShortTermBilateral,
    required this.completedContractsLongTermBilateral,
    required this.completedContractsPool,
    required this.scheduledContracts,
    required this.scheduledContractsShortTermBilateral,
    required this.scheduledContractsLongTermBilateral,
    required this.scheduledContractsPool,
    required this.sellerEnergyCommited,
    required this.sellerEnergyDelivered,
    required this.buyerEnergyCommited,
    required this.buyerEnergyUsed,
    required this.netSell,
    required this.netBuy,
    required this.sellerImbalanceAmount,
    required this.buyerImbalanceAmount,
    required this.netImbalance,
    required this.wheelingCharge,
    required this.netEnergySalesPrice,
    required this.netEnergyBuyPrice,
  });

  factory GetMonthlySettlementReportResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    assert(json['completedContracts'] is num);
    assert(json['completedContractsShortTermBilateral'] is num);
    assert(json['completedContractsLongTermBilateral'] is num);
    assert(json['completedContractsPool'] is num);
    assert(json['scheduledContracts'] is num);
    assert(json['scheduledContractsShortTermBilateral'] is num);
    assert(json['scheduledContractsLongTermBilateral'] is num);
    assert(json['scheduledContractsPool'] is num);
    assert(json['sellerEnergyCommited'] is num);
    assert(json['sellerEnergyDelivered'] is num);
    assert(json['buyerEnergyCommited'] is num);
    assert(json['buyerEnergyUsed'] is num);
    assert(json['netSell'] is num);
    assert(json['netBuy'] is num);
    assert(json['sellerImbalanceAmount'] is num);
    assert(json['buyerImbalanceAmount'] is num);
    assert(json['netImbalance'] is num);
    assert(json['wheelingCharge'] is num);
    assert(json['netEnergySalesPrice'] is num);
    assert(json['netEnergyBuyPrice'] is num);

    return GetMonthlySettlementReportResponse(
      completedContracts: (json['completedContracts'] as num).toDouble(),
      completedContractsShortTermBilateral:
          (json['completedContractsShortTermBilateral'] as num).toDouble(),
      completedContractsLongTermBilateral:
          (json['completedContractsLongTermBilateral'] as num).toDouble(),
      completedContractsPool:
          (json['completedContractsPool'] as num).toDouble(),
      scheduledContracts: (json['scheduledContracts'] as num).toDouble(),
      scheduledContractsShortTermBilateral:
          (json['scheduledContractsShortTermBilateral'] as num).toDouble(),
      scheduledContractsLongTermBilateral:
          (json['scheduledContractsLongTermBilateral'] as num).toDouble(),
      scheduledContractsPool:
          (json['scheduledContractsPool'] as num).toDouble(),
      sellerEnergyCommited: (json['sellerEnergyCommited'] as num).toDouble(),
      sellerEnergyDelivered: (json['sellerEnergyDelivered'] as num).toDouble(),
      buyerEnergyCommited: (json['buyerEnergyCommited'] as num).toDouble(),
      buyerEnergyUsed: (json['buyerEnergyUsed'] as num).toDouble(),
      netSell: (json['netSell'] as num).toDouble(),
      netBuy: (json['netBuy'] as num).toDouble(),
      sellerImbalanceAmount: (json['sellerImbalanceAmount'] as num).toDouble(),
      buyerImbalanceAmount: (json['buyerImbalanceAmount'] as num).toDouble(),
      netImbalance: (json['netImbalance'] as num).toDouble(),
      wheelingCharge: (json['wheelingCharge'] as num).toDouble(),
      netEnergySalesPrice: (json['netEnergySalesPrice'] as num).toDouble(),
      netEnergyBuyPrice: (json['netEnergyBuyPrice'] as num).toDouble(),
    );
  }
}
