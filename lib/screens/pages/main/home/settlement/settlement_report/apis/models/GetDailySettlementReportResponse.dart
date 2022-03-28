import 'package:egat_flutter/screens/pages/main/home/settlement/models/settlement_report_info.dart';

class GetDailySettlementReportResponse {
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

  final double netSales;
  final double netBuy;
  final double imbalanceAmount;
  final double sellerImbalance;
  final double buyerImbalance;
  final double netEnergyPrice;

  final double buyFromGrid;
  final double sellToGrid;
  final double buyFromGridAmount;
  final double sellToGridAmount;

  final List<SettlementReportInfo> settlementReportInfos;

  const GetDailySettlementReportResponse({
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
    required this.netSales,
    required this.netBuy,
    required this.imbalanceAmount,
    required this.sellerImbalance,
    required this.buyerImbalance,
    required this.netEnergyPrice,
    required this.buyFromGrid,
    required this.sellToGrid,
    required this.buyFromGridAmount,
    required this.sellToGridAmount,
    required this.settlementReportInfos,
  });

  factory GetDailySettlementReportResponse.fromJson(Map<String, dynamic> json) {
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
    assert(json['netSales'] is num);
    assert(json['netBuy'] is num);
    assert(json['imbalanceAmount'] is num);
    assert(json['sellerImbalance'] is num);
    assert(json['buyerImbalance'] is num);
    assert(json['netEnergyPrice'] is num);
    assert(json['settlementReportInfos'] is List);

    return GetDailySettlementReportResponse(
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
      netSales: (json['netSales'] as num).toDouble(),
      netBuy: (json['netBuy'] as num).toDouble(),
      imbalanceAmount: (json['imbalanceAmount'] as num).toDouble(),
      sellerImbalance: (json['sellerImbalance'] as num).toDouble(),
      buyerImbalance: (json['buyerImbalance'] as num).toDouble(),
      netEnergyPrice: (json['netEnergyPrice'] as num).toDouble(),
      buyFromGrid: (json['buyFromGrid'] as num).toDouble(),
      sellToGrid: (json['sellToGrid'] as num).toDouble(),
      buyFromGridAmount: (json['buyFromGridAmount'] as num).toDouble(),
      sellToGridAmount: (json['sellToGridAmount'] as num).toDouble(),
      settlementReportInfos: (json['settlementReportInfos'] as List<dynamic>)
          .map((e) => SettlementReportInfo.fromJson(e))
          .toList(),
    );
  }
}
