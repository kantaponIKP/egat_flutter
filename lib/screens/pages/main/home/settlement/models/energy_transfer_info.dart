import 'contract_direction.dart';

class EnergyTransferInfo {
  final TransferDirection direction;
  final EnergyTransferStatus status;
  final DateTime date;

  final String contractId;
  final List<String> targetName;

  const EnergyTransferInfo({
    required this.direction,
    required this.status,
    required this.date,
    required this.contractId,
    required this.targetName,
  });

  factory EnergyTransferInfo.fromJson(Map<String, dynamic> json) {
    assert(json['direction'] is String);
    assert(json['status'] is String);
    assert(json['date'] is String);

    var directionString = json['direction'] as String;
    var statusString = json['status'] as String;

    TransferDirection direction;
    switch (directionString.toUpperCase()) {
      case 'CHOOSE_TO_BUY':
        direction = TransferDirection.CHOOSE_TO_BUY;
        break;
      case 'OFFER_TO_SELL':
        direction = TransferDirection.OFFER_TO_SELL;
        break;
      case 'BID_TO_BUY':
        direction = TransferDirection.BID_TO_BUY;
        break;
      case 'OFFER_TO_SELL_BID':
        direction = TransferDirection.OFFER_TO_SELL_BID;
        break;
      default:
        throw Exception('Unknown direction: $directionString');
    }

    EnergyTransferStatus status;
    switch (statusString.toUpperCase()) {
      case 'SCHEDULED':
        status = EnergyTransferStatus.SCHEDULED;
        break;
      case 'COMPLETED':
        status = EnergyTransferStatus.COMPLETED;
        break;
      default:
        throw Exception('Unknown status: $statusString');
    }

    if (direction == TransferDirection.OFFER_TO_SELL &&
        status == EnergyTransferStatus.SCHEDULED) {
      return ScheduledOfferToSellEnergyTransferInfo.fromJson(json);
    }
    if (direction == TransferDirection.OFFER_TO_SELL &&
        status == EnergyTransferStatus.COMPLETED) {
      return CompletedOfferToSellEnergyTransferInfo.fromJson(json);
    }
    if (direction == TransferDirection.CHOOSE_TO_BUY &&
        status == EnergyTransferStatus.SCHEDULED) {
      return ScheduledChooseToBuyEnergyTransferInfo.fromJson(json);
    }
    if (direction == TransferDirection.CHOOSE_TO_BUY &&
        status == EnergyTransferStatus.COMPLETED) {
      return CompletedChooseToBuyEnergyTransferInfo.fromJson(json);
    }
    if (direction == TransferDirection.BID_TO_BUY &&
        status == EnergyTransferStatus.SCHEDULED) {
      return ScheduledBidToBuyEnergyTransferInfo.fromJson(json);
    }
    if (direction == TransferDirection.BID_TO_BUY &&
        status == EnergyTransferStatus.COMPLETED) {
      return CompletedBidToBuyEnergyTransferInfo.fromJson(json);
    }
    if (direction == TransferDirection.OFFER_TO_SELL_BID &&
        status == EnergyTransferStatus.SCHEDULED) {
      return ScheduledOfferToSellBidEnergyTransferInfo.fromJson(json);
    }
    if (direction == TransferDirection.OFFER_TO_SELL_BID &&
        status == EnergyTransferStatus.COMPLETED) {
      return CompletedOfferToSellBidEnergyTransferInfo.fromJson(json);
    }

    throw Exception('Unknown trade info: $json');
  }
}

enum EnergyTransferStatus {
  SCHEDULED,
  COMPLETED,
}

class CompletedBidToBuyEnergyTransferInfo extends EnergyTransferInfo {
  final double bidedAmount;
  final double energyUsed;
  final double marketClearingPrice;
  final double netBuy;
  final double netEnergyPrice;
  final double buyerImbalanceAmount;
  final double buyerImbalance;
  final double energyToBuy;
  final double energyTariff;
  final double energyPrice;
  final double wheelingChargeTariff;
  final double wheelingCharge;
  final double tradingFee;
  final double vat;

  CompletedBidToBuyEnergyTransferInfo({
    required DateTime date,
    required String contractId,
    required List<String> targetName,
    required this.bidedAmount,
    required this.energyUsed,
    required this.marketClearingPrice,
    required this.netBuy,
    required this.netEnergyPrice,
    required this.buyerImbalanceAmount,
    required this.buyerImbalance,
    required this.energyToBuy,
    required this.energyTariff,
    required this.energyPrice,
    required this.wheelingChargeTariff,
    required this.wheelingCharge,
    required this.tradingFee,
    required this.vat,
  }) : super(
          direction: TransferDirection.BID_TO_BUY,
          status: EnergyTransferStatus.COMPLETED,
          date: date,
          contractId: contractId,
          targetName: targetName,
        );

  factory CompletedBidToBuyEnergyTransferInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    assert(json['contractId'] is String);
    assert(json['targetName'] is List);
    assert(json['date'] is String);

    assert(json['bidedAmount'] is num);
    assert(json['energyUsed'] is num);
    assert(json['marketClearingPrice'] is num);
    assert(json['netBuy'] is num);
    assert(json['netEnergyPrice'] is num);
    assert(json['buyerImbalanceAmount'] is num);
    assert(json['buyerImbalance'] is num);
    assert(json['energyToBuy'] is num);
    assert(json['energyTariff'] is num);
    assert(json['energyPrice'] is num);
    assert(json['wheelingChargeTariff'] is num);
    assert(json['wheelingCharge'] is num);
    assert(json['tradingFee'] is num);
    assert(json['vat'] is num);

    return CompletedBidToBuyEnergyTransferInfo(
      contractId: json['contractId'] as String,
      targetName: (json['targetName'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      date: DateTime.parse(json['date']),
      bidedAmount: json['bidedAmount'].toDouble(),
      energyUsed: json['energyUsed'].toDouble(),
      marketClearingPrice: json['marketClearingPrice'].toDouble(),
      netBuy: json['netBuy'].toDouble(),
      netEnergyPrice: json['netEnergyPrice'].toDouble(),
      buyerImbalanceAmount: json['buyerImbalanceAmount'].toDouble(),
      buyerImbalance: json['buyerImbalance'].toDouble(),
      energyToBuy: json['energyToBuy'].toDouble(),
      energyTariff: json['energyTariff'].toDouble(),
      energyPrice: json['energyPrice'].toDouble(),
      wheelingChargeTariff: json['wheelingChargeTariff'].toDouble(),
      wheelingCharge: json['wheelingCharge'].toDouble(),
      tradingFee: json['tradingFee'].toDouble(),
      vat: json['vat'].toDouble(),
    );
  }
}

class CompletedChooseToBuyEnergyTransferInfo extends EnergyTransferInfo {
  final double commitedAmount;
  final double energyUsed;
  final double netBuy;
  final double netEnergyPrice;
  final double buyerImbalanceAmount;
  final double buyerImbalance;
  final double energyToBuy;
  final double energyTariff;
  final double energyPrice;
  final double wheelingChargeTariff;
  final double wheelingCharge;
  final double tradingFee;
  final double vat;

  CompletedChooseToBuyEnergyTransferInfo({
    required DateTime date,
    required String contractId,
    required List<String> targetName,
    required this.commitedAmount,
    required this.energyUsed,
    required this.netBuy,
    required this.netEnergyPrice,
    required this.buyerImbalanceAmount,
    required this.buyerImbalance,
    required this.energyToBuy,
    required this.energyTariff,
    required this.energyPrice,
    required this.wheelingChargeTariff,
    required this.wheelingCharge,
    required this.tradingFee,
    required this.vat,
  }) : super(
          direction: TransferDirection.CHOOSE_TO_BUY,
          status: EnergyTransferStatus.COMPLETED,
          date: date,
          contractId: contractId,
          targetName: targetName,
        );

  factory CompletedChooseToBuyEnergyTransferInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    assert(json['contractId'] is String);
    assert(json['targetName'] is List);
    assert(json['date'] is String);
    assert(json['commitedAmount'] is num);
    assert(json['energyUsed'] is num);
    assert(json['netBuy'] is num);
    assert(json['netEnergyPrice'] is num);
    assert(json['buyerImbalanceAmount'] is num);
    assert(json['buyerImbalance'] is num);
    assert(json['energyToBuy'] is num);
    assert(json['energyTariff'] is num);
    assert(json['energyPrice'] is num);
    assert(json['wheelingChargeTariff'] is num);
    assert(json['wheelingCharge'] is num);
    assert(json['tradingFee'] is num);
    assert(json['vat'] is num);

    return CompletedChooseToBuyEnergyTransferInfo(
      contractId: json['contractId'] as String,
      targetName: (json['targetName'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      date: DateTime.parse(json['date']),
      commitedAmount: json['commitedAmount'].toDouble(),
      energyUsed: json['energyUsed'].toDouble(),
      netBuy: json['netBuy'].toDouble(),
      netEnergyPrice: json['netEnergyPrice'].toDouble(),
      buyerImbalanceAmount: json['buyerImbalanceAmount'].toDouble(),
      buyerImbalance: json['buyerImbalance'].toDouble(),
      energyToBuy: json['energyToBuy'].toDouble(),
      energyTariff: json['energyTariff'].toDouble(),
      energyPrice: json['energyPrice'].toDouble(),
      wheelingChargeTariff: json['wheelingChargeTariff'].toDouble(),
      wheelingCharge: json['wheelingCharge'].toDouble(),
      tradingFee: json['tradingFee'].toDouble(),
      vat: json['vat'].toDouble(),
    );
  }
}

class CompletedOfferToSellBidEnergyTransferInfo extends EnergyTransferInfo {
  final double offeredAmount;
  final double energyDelivered;
  final double marketClearingPrice;
  final double netSales;
  final double netEnergyPrice;
  final double sales;
  final double sellerImbalanceAmount;
  final double sellerImbalance;
  final double tradingFee;

  CompletedOfferToSellBidEnergyTransferInfo({
    required DateTime date,
    required String contractId,
    required List<String> targetName,
    required this.offeredAmount,
    required this.energyDelivered,
    required this.marketClearingPrice,
    required this.netSales,
    required this.netEnergyPrice,
    required this.sales,
    required this.sellerImbalanceAmount,
    required this.sellerImbalance,
    required this.tradingFee,
  }) : super(
          direction: TransferDirection.OFFER_TO_SELL_BID,
          status: EnergyTransferStatus.COMPLETED,
          date: date,
          contractId: contractId,
          targetName: targetName,
        );

  factory CompletedOfferToSellBidEnergyTransferInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    assert(json['contractId'] is String);
    assert(json['targetName'] is List);
    assert(json['date'] is String);

    assert(json['offeredAmount'] is num);
    assert(json['energyDelivered'] is num);
    assert(json['marketClearingPrice'] is num);
    assert(json['netSales'] is num);
    assert(json['netEnergyPrice'] is num);
    assert(json['sales'] is num);
    assert(json['sellerImbalanceAmount'] is num);
    assert(json['sellerImbalance'] is num);
    assert(json['tradingFee'] is num);

    return CompletedOfferToSellBidEnergyTransferInfo(
      contractId: json['contractId'] as String,
      targetName: (json['targetName'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      date: DateTime.parse(json['date']),
      offeredAmount: json['offeredAmount'].toDouble(),
      energyDelivered: json['energyDelivered'].toDouble(),
      marketClearingPrice: json['marketClearingPrice'].toDouble(),
      netSales: json['netSales'].toDouble(),
      netEnergyPrice: json['netEnergyPrice'].toDouble(),
      sales: json['sales'].toDouble(),
      sellerImbalanceAmount: json['sellerImbalanceAmount'].toDouble(),
      sellerImbalance: json['sellerImbalance'].toDouble(),
      tradingFee: json['tradingFee'].toDouble(),
    );
  }
}

class CompletedOfferToSellEnergyTransferInfo extends EnergyTransferInfo {
  final double commitedAmount;
  final double energyDelivered;
  final double sellingPrice;
  final double netSales;
  final double netEnergyPrice;
  final double sales;
  final double sellerImbalanceAmount;
  final double sellerImbalance;
  final double tradingFee;

  CompletedOfferToSellEnergyTransferInfo({
    required DateTime date,
    required String contractId,
    required List<String> targetName,
    required this.commitedAmount,
    required this.energyDelivered,
    required this.sellingPrice,
    required this.netSales,
    required this.netEnergyPrice,
    required this.sales,
    required this.sellerImbalanceAmount,
    required this.sellerImbalance,
    required this.tradingFee,
  }) : super(
          direction: TransferDirection.OFFER_TO_SELL,
          status: EnergyTransferStatus.COMPLETED,
          date: date,
          contractId: contractId,
          targetName: targetName,
        );

  factory CompletedOfferToSellEnergyTransferInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    assert(json['contractId'] is String);
    assert(json['targetName'] is List);
    assert(json['date'] is String);
    assert(json['commitedAmount'] is num);
    assert(json['energyDelivered'] is num);
    assert(json['sellingPrice'] is num);
    assert(json['netSales'] is num);
    assert(json['netEnergyPrice'] is num);
    assert(json['sales'] is num);
    assert(json['sellerImbalanceAmount'] is num);
    assert(json['sellerImbalance'] is num);
    assert(json['tradingFee'] is num);

    return CompletedOfferToSellEnergyTransferInfo(
      contractId: json['contractId'] as String,
      targetName: (json['targetName'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      date: DateTime.parse(json['date']),
      commitedAmount: json['commitedAmount'].toDouble(),
      energyDelivered: json['energyDelivered'].toDouble(),
      sellingPrice: json['sellingPrice'].toDouble(),
      netSales: json['netSales'].toDouble(),
      netEnergyPrice: json['netEnergyPrice'].toDouble(),
      sales: json['sales'].toDouble(),
      sellerImbalanceAmount: json['sellerImbalanceAmount'].toDouble(),
      sellerImbalance: json['sellerImbalance'].toDouble(),
      tradingFee: json['tradingFee'].toDouble(),
    );
  }
}

class ScheduledBidToBuyEnergyTransferInfo extends EnergyTransferInfo {
  final double bidedAmount;
  final double marketClearingPrice;
  final double netBuy;
  final double netEnergyPrice;
  final double energyToBuy;
  final double energyTariff;
  final double energyPrice;
  final double wheelingChargeTariff;
  final double wheelingCharge;
  final double tradingFee;
  final double vat;

  ScheduledBidToBuyEnergyTransferInfo({
    required DateTime date,
    required String contractId,
    required List<String> targetName,
    required this.bidedAmount,
    required this.marketClearingPrice,
    required this.netBuy,
    required this.netEnergyPrice,
    required this.energyToBuy,
    required this.energyTariff,
    required this.energyPrice,
    required this.wheelingChargeTariff,
    required this.wheelingCharge,
    required this.tradingFee,
    required this.vat,
  }) : super(
          direction: TransferDirection.BID_TO_BUY,
          status: EnergyTransferStatus.SCHEDULED,
          date: date,
          contractId: contractId,
          targetName: targetName,
        );

  factory ScheduledBidToBuyEnergyTransferInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    assert(json['contractId'] is String);
    assert(json['targetName'] is List);
    assert(json['date'] is String);

    assert(json['bidedAmount'] is num);
    // assert(json['energyUsed'] is num);
    assert(json['marketClearingPrice'] is num);
    assert(json['netBuy'] is num);
    assert(json['netEnergyPrice'] is num);
    // assert(json['buyerImbalanceAmount'] is num);
    // assert(json['buyerImbalance'] is num);
    assert(json['energyToBuy'] is num);
    assert(json['energyTariff'] is num);
    assert(json['energyPrice'] is num);
    assert(json['wheelingChargeTariff'] is num);
    assert(json['wheelingCharge'] is num);
    assert(json['tradingFee'] is num);
    assert(json['vat'] is num);

    return ScheduledBidToBuyEnergyTransferInfo(
      contractId: json['contractId'] as String,
      targetName: (json['targetName'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      date: DateTime.parse(json['date']),
      bidedAmount: json['bidedAmount'].toDouble(),
      marketClearingPrice: json['marketClearingPrice'].toDouble(),
      netBuy: json['netBuy'].toDouble(),
      netEnergyPrice: json['netEnergyPrice'].toDouble(),
      energyToBuy: json['energyToBuy'].toDouble(),
      energyTariff: json['energyTariff'].toDouble(),
      energyPrice: json['energyPrice'].toDouble(),
      wheelingChargeTariff: json['wheelingChargeTariff'].toDouble(),
      wheelingCharge: json['wheelingCharge'].toDouble(),
      tradingFee: json['tradingFee'].toDouble(),
      vat: json['vat'].toDouble(),
    );
  }
}

class ScheduledChooseToBuyEnergyTransferInfo extends EnergyTransferInfo {
  final double commitedAmount;
  final double netBuy;
  final double netEnergyPrice;
  final double energyToBuy;
  final double energyTariff;
  final double energyPrice;
  final double wheelingChargeTariff;
  final double wheelingCharge;
  final double tradingFee;
  final double vat;

  ScheduledChooseToBuyEnergyTransferInfo({
    required DateTime date,
    required String contractId,
    required List<String> targetName,
    required this.commitedAmount,
    required this.netBuy,
    required this.netEnergyPrice,
    required this.energyToBuy,
    required this.energyTariff,
    required this.energyPrice,
    required this.wheelingChargeTariff,
    required this.wheelingCharge,
    required this.tradingFee,
    required this.vat,
  }) : super(
          direction: TransferDirection.CHOOSE_TO_BUY,
          status: EnergyTransferStatus.SCHEDULED,
          date: date,
          contractId: contractId,
          targetName: targetName,
        );

  factory ScheduledChooseToBuyEnergyTransferInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    assert(json['contractId'] is String);
    assert(json['targetName'] is List);
    assert(json['date'] is String);
    assert(json['commitedAmount'] is num);
    assert(json['netBuy'] is num);
    assert(json['netEnergyPrice'] is num);
    assert(json['energyToBuy'] is num);
    assert(json['energyTariff'] is num);
    assert(json['energyPrice'] is num);
    assert(json['wheelingChargeTariff'] is num);
    assert(json['wheelingCharge'] is num);
    assert(json['tradingFee'] is num);
    assert(json['vat'] is num);

    return ScheduledChooseToBuyEnergyTransferInfo(
      contractId: json['contractId'] as String,
      targetName: (json['targetName'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      date: DateTime.parse(json['date']),
      commitedAmount: json['commitedAmount'].toDouble(),
      netBuy: json['netBuy'].toDouble(),
      netEnergyPrice: json['netEnergyPrice'].toDouble(),
      energyToBuy: json['energyToBuy'].toDouble(),
      energyTariff: json['energyTariff'].toDouble(),
      energyPrice: json['energyPrice'].toDouble(),
      wheelingChargeTariff: json['wheelingChargeTariff'].toDouble(),
      wheelingCharge: json['wheelingCharge'].toDouble(),
      tradingFee: json['tradingFee'].toDouble(),
      vat: json['vat'].toDouble(),
    );
  }
}

class ScheduledOfferToSellBidEnergyTransferInfo extends EnergyTransferInfo {
  final double offeredAmount;
  final double marketClearingPrice;
  final double netSales;
  final double netEnergyPrice;
  final double tradingFee;

  ScheduledOfferToSellBidEnergyTransferInfo({
    required DateTime date,
    required String contractId,
    required List<String> targetName,
    required this.offeredAmount,
    required this.marketClearingPrice,
    required this.netSales,
    required this.netEnergyPrice,
    required this.tradingFee,
  }) : super(
          direction: TransferDirection.OFFER_TO_SELL_BID,
          status: EnergyTransferStatus.SCHEDULED,
          date: date,
          contractId: contractId,
          targetName: targetName,
        );

  factory ScheduledOfferToSellBidEnergyTransferInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    assert(json['contractId'] is String);
    assert(json['targetName'] is List);
    assert(json['date'] is String);

    assert(json['offeredAmount'] is num);
    assert(json['marketClearingPrice'] is num);
    assert(json['netSales'] is num);
    assert(json['netEnergyPrice'] is num);
    assert(json['tradingFee'] is num);

    return ScheduledOfferToSellBidEnergyTransferInfo(
      contractId: json['contractId'] as String,
      targetName: (json['targetName'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      date: DateTime.parse(json['date']),
      offeredAmount: json['offeredAmount'].toDouble(),
      marketClearingPrice: json['marketClearingPrice'].toDouble(),
      netSales: json['netSales'].toDouble(),
      netEnergyPrice: json['netEnergyPrice'].toDouble(),
      tradingFee: json['tradingFee'].toDouble(),
    );
  }
}

class ScheduledOfferToSellEnergyTransferInfo extends EnergyTransferInfo {
  final double commitedAmount;
  final double sellingPrice;
  final double netSales;
  final double tradingFee;
  final double netEnergyPrice;

  ScheduledOfferToSellEnergyTransferInfo({
    required DateTime date,
    required String contractId,
    required List<String> targetName,
    required this.commitedAmount,
    required this.sellingPrice,
    required this.netSales,
    required this.tradingFee,
    required this.netEnergyPrice,
  }) : super(
          direction: TransferDirection.OFFER_TO_SELL,
          status: EnergyTransferStatus.SCHEDULED,
          date: date,
          contractId: contractId,
          targetName: targetName,
        );

  factory ScheduledOfferToSellEnergyTransferInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    assert(json['contractId'] is String);
    assert(json['targetName'] is List);
    assert(json['date'] is String);
    assert(json['commitedAmount'] is num);
    assert(json['sellingPrice'] is num);
    assert(json['netSales'] is num);
    assert(json['tradingFee'] is num);
    assert(json['netEnergyPrice'] is num);

    return ScheduledOfferToSellEnergyTransferInfo(
      contractId: json['contractId'] as String,
      targetName: (json['targetName'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      date: DateTime.parse(json['date']),
      commitedAmount: json['commitedAmount'].toDouble(),
      sellingPrice: json['sellingPrice'].toDouble(),
      netSales: json['netSales'].toDouble(),
      tradingFee: json['tradingFee'].toDouble(),
      netEnergyPrice: json['netEnergyPrice'].toDouble(),
    );
  }
}
