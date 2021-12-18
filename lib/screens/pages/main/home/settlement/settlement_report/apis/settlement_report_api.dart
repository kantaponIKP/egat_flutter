import '../../models/settlement_report_info.dart';
import 'models/GetDailySettlementReportResponse.dart';
import 'models/GetMonthlySettlementReportResponse.dart';

final SettlementReportApi settlementReportApi = new SettlementReportApi();

class SettlementReportApi {
  Future<GetMonthlySettlementReportResponse> fetchMonthlySettlementReport({
    required DateTime date,
    required String accessToken,
  }) async {
    return GetMonthlySettlementReportResponse(
      completedContracts: 1,
      completedContractsShortTermBilateral: 1,
      completedContractsLongTermBilateral: 1,
      completedContractsPool: 1,
      scheduledContracts: 1,
      scheduledContractsShortTermBilateral: 1,
      scheduledContractsLongTermBilateral: 1,
      scheduledContractsPool: 1,
      sellerEnergyCommited: 1,
      sellerEnergyDelivered: 1,
      buyerEnergyCommited: 1,
      buyerEnergyUsed: 1,
      netSell: 1,
      netBuy: 1,
      sellerImbalanceAmount: 1,
      buyerImbalanceAmount: 1,
      netImbalance: 1,
      wheelingCharge: 1,
      netEnergySalesPrice: 1,
      netEnergyBuyPrice: 1,
    );
  }

  Future<GetDailySettlementReportResponse> fetchDailySettlementReport({
    required DateTime date,
    required String accessToken,
  }) async {
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day);

    return GetDailySettlementReportResponse(
      completedContracts: 1,
      completedContractsShortTermBilateral: 1,
      completedContractsLongTermBilateral: 1,
      completedContractsPool: 1,
      scheduledContracts: 1,
      scheduledContractsShortTermBilateral: 1,
      scheduledContractsLongTermBilateral: 1,
      scheduledContractsPool: 1,
      sellerEnergyCommited: 1,
      sellerEnergyDelivered: 1,
      buyerEnergyCommited: 1,
      buyerEnergyUsed: 1,
      netSales: 1,
      imbalanceAmount: 1,
      sellerImbalance: 1,
      netEnergyPrice: 1,
      settlementReportInfos: [
        BilateralBuyerEnergyShortfallSettlementReportInfo(
          energyCommitted: 1,
          energyUsed: 1,
          netBuy: 1,
          buyerImbalanceAmount: 1,
          buyerImbalance: 1,
          wheelingChargeTariff: 1,
          wheelingCharge: 1,
          netEnergyPrice: 1,
          contractId: "contractId",
          targetName: ["targetName"],
          date: date,
        ),
        PoolBuyerEnergyShortfallSettlementReportInfo(
          energyCommitted: 1,
          energyUsed: 1,
          netBuy: 1,
          buyerImbalanceAmount: 1,
          buyerImbalance: 1,
          wheelingChargeTariff: 1,
          wheelingCharge: 1,
          netEnergyPrice: 1,
          contractId: "contractId",
          targetName: ["targetName"],
          date: date.add(Duration(hours: 1)),
        ),
        BilateralBuyerEnergyExcessSettlementReportInfo(
          energyCommitted: 1,
          energyDelivered: 1,
          sellerImbalanceAmount: 1,
          sellerImbalance: 1,
          contractId: "contractId",
          targetName: ["targetName"],
          date: date.add(Duration(hours: 2)),
        ),
        PoolBuyerEnergyExcessSettlementReportInfo(
          energyCommitted: 1,
          energyUsed: 1,
          sellerImbalanceAmount: 1,
          sellerImbalance: 1,
          contractId: "contractId",
          targetName: ["targetName"],
          date: date.add(Duration(hours: 3)),
        ),
        BilateralSellerEnergyShortfallSettlementReportInfo(
          energyCommitted: 1,
          energyDelivered: 1,
          netSales: 1,
          sellerImbalanceAmount: 1,
          sellerImbalance: 1,
          netEnergyPrice: 1,
          contractId: "contractId",
          targetName: ["targetName"],
          date: date.add(Duration(hours: 4)),
        ),
        BilateralSellerEnergyExcessSettlementReportInfo(
          energyCommitted: 1,
          energyDelivered: 1,
          netSales: 1,
          sellerImbalanceAmount: 1,
          sellerImbalance: 1,
          netEnergyPrice: 1,
          contractId: "contractId",
          targetName: ["targetName"],
          date: date.add(Duration(hours: 5)),
        ),
        PoolSellerEnergyShortfallSettlementReportInfo(
          energyMatched: 1,
          energyDelivered: 1,
          sellerImbalanceAmount: 1,
          sellerImbalance: 1,
          contractId: "contractId",
          targetName: ["targetName"],
          date: date.add(Duration(hours: 6)),
        ),
        PoolSellerEnergyExcessSettlementReportInfo(
          energyMatched: 1,
          energyDelivered: 1,
          sellerImbalanceAmount: 1,
          sellerImbalance: 1,
          contractId: "contractId",
          targetName: ["targetName"],
          date: date.add(Duration(hours: 7)),
        ),
      ],
    );
  }
}
