import '../../models/energy_transfer_info.dart';

class EnergyTransferApi {
  Future<List<EnergyTransferInfo>> fetchEnergyTransferInfos({
    required DateTime date,
    required String accessToken,
  }) async {
    // TODO: use real data
    await Future.delayed(Duration(seconds: 1));

    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day);

    return <EnergyTransferInfo>[
      ScheduledOfferToSellEnergyTransferInfo(
        date: date,
        contractId: "contractId",
        targetName: ["targetName"],
        commitedAmount: 1,
        sellingPrice: 1,
        netSales: 1,
        tradingFee: 1,
        netEnergyPrice: 1,
      ),
      CompletedOfferToSellEnergyTransferInfo(
          date: date.add(Duration(hours: 1)),
          contractId: "contractId",
          targetName: ["targetName"],
          commitedAmount: 1,
          energyDelivered: 1,
          sellingPrice: 1,
          netSales: 1,
          netEnergyPrice: 1,
          sales: 1,
          sellerImbalanceAmount: 1,
          sellerImbalance: 1,
          tradingFee: 1),
      ScheduledChooseToBuyEnergyTransferInfo(
          date: date.add(Duration(hours: 2)),
          contractId: "contractId",
          targetName: ["targetName"],
          commitedAmount: 1,
          netBuy: 1,
          netEnergyPrice: 1,
          energyToBuy: 1,
          energyTariff: 1,
          energyPrice: 1,
          wheelingChargeTariff: 1,
          wheelingCharge: 1,
          tradingFee: 1,
          vat: 1),
      CompletedChooseToBuyEnergyTransferInfo(
          date: date.add(Duration(hours: 3)),
          contractId: "contractId",
          targetName: ["targetName"],
          commitedAmount: 1,
          energyUsed: 1,
          netBuy: 1,
          netEnergyPrice: 1,
          buyerImbalanceAmount: 1,
          buyerImbalance: 1,
          energyToBuy: 1,
          energyTariff: 1,
          energyPrice: 1,
          wheelingChargeTariff: 1,
          wheelingCharge: 1,
          tradingFee: 1,
          vat: 1),
      ScheduledOfferToSellBidEnergyTransferInfo(
          date: date.add(Duration(hours: 4)),
          contractId: "contractId",
          targetName: ["targetName"],
          offeredAmount: 1,
          marketClearingPrice: 1,
          netSales: 1,
          netEnergyPrice: 1,
          tradingFee: 1),
      CompletedOfferToSellBidEnergyTransferInfo(
          date: date.add(Duration(hours: 5)),
          contractId: "contractId",
          targetName: ["targetName"],
          offeredAmount: 1,
          energyDelivered: 1,
          marketClearingPrice: 1,
          netSales: 1,
          netEnergyPrice: 1,
          sales: 1,
          sellerImbalanceAmount: 1,
          sellerImbalance: 1,
          tradingFee: 1),
      ScheduledBidToBuyEnergyTransferInfo(
          date: date.add(Duration(hours: 6)),
          contractId: "contractId",
          targetName: ["targetName"],
          bidedAmount: 1,
          marketClearingPrice: 1,
          netBuy: 1,
          netEnergyPrice: 1,
          energyToBuy: 1,
          energyTariff: 1,
          energyPrice: 1,
          wheelingChargeTariff: 1,
          wheelingCharge: 1,
          tradingFee: 1,
          vat: 1),
      CompletedBidToBuyEnergyTransferInfo(
          date: date.add(Duration(hours: 7)),
          contractId: "contractId",
          targetName: ["targetName"],
          bidedAmount: 1,
          energyUsed: 1,
          marketClearingPrice: 1,
          netBuy: 1,
          netEnergyPrice: 1,
          buyerImbalanceAmount: 1,
          buyerImbalance: 1,
          energyToBuy: 1,
          energyTariff: 1,
          energyPrice: 1,
          wheelingChargeTariff: 1,
          wheelingCharge: 1,
          tradingFee: 1,
          vat: 1),
    ];
  }
}

final EnergyTransferApi energyTransferApi = new EnergyTransferApi();
