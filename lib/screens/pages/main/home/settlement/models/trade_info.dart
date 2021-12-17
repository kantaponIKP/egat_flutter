import 'package:egat_flutter/screens/pages/main/home/settlement/models/contract_direction.dart';

import 'contract_status.dart';

class TradeInfo {
  final TransferDirection direction;
  final ContractStatus status;
  final DateTime date;

  const TradeInfo({
    required this.direction,
    required this.status,
    required this.date,
  });

  factory TradeInfo.fromJson(Map<String, dynamic> json) {
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

    ContractStatus status;
    switch (statusString.toUpperCase()) {
      case 'OPEN':
        status = ContractStatus.OPEN;
        break;
      case 'MATCHED':
        status = ContractStatus.MATCHED;
        break;
      case 'CLOSE':
        status = ContractStatus.CLOSE;
        break;
      default:
        throw Exception('Unknown status: $statusString');
    }

    if (direction == TransferDirection.OFFER_TO_SELL &&
        status == ContractStatus.OPEN) {
      return OpenOfferToSellTradeInfo.fromJson(json);
    }
    if (direction == TransferDirection.OFFER_TO_SELL &&
        status == ContractStatus.MATCHED) {
      return MatchedOfferToSellTradeInfo.fromJson(json);
    }
    if (direction == TransferDirection.CHOOSE_TO_BUY &&
        status == ContractStatus.MATCHED) {
      return MatchedChooseToBuyTradeInfo.fromJson(json);
    }
    if (direction == TransferDirection.OFFER_TO_SELL_BID &&
        status == ContractStatus.MATCHED) {
      return MatchedOfferToSellBidTradeInfo.fromJson(json);
    }
    if (direction == TransferDirection.BID_TO_BUY &&
        status == ContractStatus.MATCHED) {
      return MatchedBidToBuyTradeInfo.fromJson(json);
    }

    throw Exception('Unknown trade info: $json');
  }
}

class OpenOfferToSellTradeInfo extends TradeInfo {
  final double amount;
  final double offerToSell;
  final double tradingFee;
  final double estimatedSales;

  OpenOfferToSellTradeInfo({
    required DateTime date,
    required this.amount,
    required this.offerToSell,
    required this.tradingFee,
    required this.estimatedSales,
  }) : super(
          direction: TransferDirection.OFFER_TO_SELL,
          status: ContractStatus.OPEN,
          date: date,
        );

  factory OpenOfferToSellTradeInfo.fromJson(Map<String, dynamic> json) {
    assert(json['date'] is String);

    assert(json['amount'] is num);
    assert(json['offerToSell'] is num);
    assert(json['tradingFee'] is num);
    assert(json['estimatedSales'] is num);

    final date = DateTime.parse(json['date'] as String);

    return OpenOfferToSellTradeInfo(
      date: date,
      amount: (json['amount'] as num).toDouble(),
      offerToSell: (json['offerToSell'] as num).toDouble(),
      tradingFee: (json['tradingFee'] as num).toDouble(),
      estimatedSales: (json['estimatedSales'] as num).toDouble(),
    );
  }
}

class MatchedOfferToSellTradeInfo extends TradeInfo {
  final String contractId;
  final List<String> targetName;

  final double amount;
  final double offerToSell;
  final double tradingFee;
  final double estimatedSales;

  MatchedOfferToSellTradeInfo({
    required DateTime date,
    required this.contractId,
    required this.targetName,
    required this.amount,
    required this.offerToSell,
    required this.tradingFee,
    required this.estimatedSales,
  }) : super(
          direction: TransferDirection.OFFER_TO_SELL,
          status: ContractStatus.MATCHED,
          date: date,
        );

  factory MatchedOfferToSellTradeInfo.fromJson(Map<String, dynamic> json) {
    assert(json['date'] is String);

    assert(json['contractId'] is String);
    assert(json['targetName'] is List);
    assert(json['amount'] is num);
    assert(json['offerToSell'] is num);
    assert(json['tradingFee'] is num);
    assert(json['estimatedSales'] is num);

    final date = DateTime.parse(json['date'] as String);

    return MatchedOfferToSellTradeInfo(
      date: date,
      contractId: json['contractId'] as String,
      targetName: json['targetName'] as List<String>,
      amount: (json['amount'] as num).toDouble(),
      offerToSell: (json['offerToSell'] as num).toDouble(),
      tradingFee: (json['tradingFee'] as num).toDouble(),
      estimatedSales: (json['estimatedSales'] as num).toDouble(),
    );
  }
}

class MatchedChooseToBuyTradeInfo extends TradeInfo {
  final String contractId;
  final List<String> targetName;

  final double amount;
  final double netBuy;
  final double netEnergyPrice;
  final double energyToBuy;
  final double energyTariff;
  final double energyPrice;
  final double wheelingChargeTariff;
  final double wheelingCharge;
  final double tradingFee;
  final double vat;

  MatchedChooseToBuyTradeInfo({
    required DateTime date,
    required this.contractId,
    required this.targetName,
    required this.amount,
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
          status: ContractStatus.MATCHED,
          date: date,
        );

  factory MatchedChooseToBuyTradeInfo.fromJson(Map<String, dynamic> json) {
    assert(json['date'] is String);

    assert(json['contractId'] is String);
    assert(json['targetName'] is List);
    assert(json['amount'] is num);
    assert(json['netBuy'] is num);
    assert(json['netEnergyPrice'] is num);
    assert(json['energyToBuy'] is num);
    assert(json['energyTariff'] is num);
    assert(json['energyPrice'] is num);
    assert(json['wheelingChargeTariff'] is num);
    assert(json['wheelingCharge'] is num);
    assert(json['tradingFee'] is num);
    assert(json['vat'] is num);

    final date = DateTime.parse(json['date'] as String);

    return MatchedChooseToBuyTradeInfo(
      date: date,
      contractId: json['contractId'] as String,
      targetName: json['targetName'] as List<String>,
      amount: (json['amount'] as num).toDouble(),
      netBuy: (json['netBuy'] as num).toDouble(),
      netEnergyPrice: (json['netEnergyPrice'] as num).toDouble(),
      energyToBuy: (json['energyToBuy'] as num).toDouble(),
      energyTariff: (json['energyTariff'] as num).toDouble(),
      energyPrice: (json['energyPrice'] as num).toDouble(),
      wheelingChargeTariff: (json['wheelingChargeTariff'] as num).toDouble(),
      wheelingCharge: (json['wheelingCharge'] as num).toDouble(),
      tradingFee: (json['tradingFee'] as num).toDouble(),
      vat: (json['vat'] as num).toDouble(),
    );
  }
}

class MatchedOfferToSellBidTradeInfo extends TradeInfo {
  final String contractId;
  final List<String> targetName;

  final double offeredAmount;
  final double matchedAmount;
  final double offerToSell;
  final double marketClearingPrice;
  final double tradingFee;
  final double estimatedSales;

  MatchedOfferToSellBidTradeInfo({
    required DateTime date,
    required this.contractId,
    required this.targetName,
    required this.offeredAmount,
    required this.matchedAmount,
    required this.offerToSell,
    required this.marketClearingPrice,
    required this.tradingFee,
    required this.estimatedSales,
  }) : super(
          direction: TransferDirection.OFFER_TO_SELL_BID,
          status: ContractStatus.MATCHED,
          date: date,
        );

  factory MatchedOfferToSellBidTradeInfo.fromJson(Map<String, dynamic> json) {
    assert(json['date'] is String);

    assert(json['contractId'] is String);
    assert(json['targetName'] is List);
    assert(json['offeredAmount'] is num);
    assert(json['matchedAmount'] is num);
    assert(json['offerToSell'] is num);
    assert(json['marketClearingPrice'] is num);
    assert(json['tradingFee'] is num);
    assert(json['estimatedSales'] is num);

    final date = DateTime.parse(json['date'] as String);

    return MatchedOfferToSellBidTradeInfo(
      date: date,
      contractId: json['contractId'] as String,
      targetName: json['targetName'] as List<String>,
      offeredAmount: (json['offeredAmount'] as num).toDouble(),
      matchedAmount: (json['matchedAmount'] as num).toDouble(),
      offerToSell: (json['offerToSell'] as num).toDouble(),
      marketClearingPrice: (json['marketClearingPrice'] as num).toDouble(),
      tradingFee: (json['tradingFee'] as num).toDouble(),
      estimatedSales: (json['estimatedSales'] as num).toDouble(),
    );
  }
}

class MatchedBidToBuyTradeInfo extends TradeInfo {
  final String contractId;
  final List<String> targetName;

  final double biddedAmount;
  final double matchedAmount;
  final double bidToBuy;
  final double marketClearingPrice;
  final double estimatedBuy;
  final double netEstimatedEnergyPrice;
  final double energyToBuy;
  final double energyTariff;
  final double energyPrice;
  final double wheelingChargeTariff;
  final double wheelingCharge;
  final double tradingFee;
  final double vat;

  MatchedBidToBuyTradeInfo({
    required DateTime date,
    required this.contractId,
    required this.targetName,
    required this.biddedAmount,
    required this.matchedAmount,
    required this.bidToBuy,
    required this.marketClearingPrice,
    required this.estimatedBuy,
    required this.netEstimatedEnergyPrice,
    required this.energyToBuy,
    required this.energyTariff,
    required this.energyPrice,
    required this.wheelingChargeTariff,
    required this.wheelingCharge,
    required this.tradingFee,
    required this.vat,
  }) : super(
          direction: TransferDirection.BID_TO_BUY,
          status: ContractStatus.MATCHED,
          date: date,
        );

  factory MatchedBidToBuyTradeInfo.fromJson(Map<String, dynamic> json) {
    assert(json['date'] is String);

    assert(json['contractId'] is String);
    assert(json['targetName'] is List);
    assert(json['biddedAmount'] is num);
    assert(json['matchedAmount'] is num);
    assert(json['bidToBuy'] is num);
    assert(json['marketClearingPrice'] is num);
    assert(json['estimatedBuy'] is num);
    assert(json['netEstimatedEnergyPrice'] is num);
    assert(json['energyToBuy'] is num);
    assert(json['energyTariff'] is num);
    assert(json['energyPrice'] is num);
    assert(json['wheelingChargeTariff'] is num);
    assert(json['wheelingCharge'] is num);
    assert(json['tradingFee'] is num);
    assert(json['vat'] is num);

    final date = DateTime.parse(json['date'] as String);

    return MatchedBidToBuyTradeInfo(
      date: date,
      contractId: json['contractId'] as String,
      targetName: json['targetName'] as List<String>,
      biddedAmount: (json['biddedAmount'] as num).toDouble(),
      matchedAmount: (json['matchedAmount'] as num).toDouble(),
      bidToBuy: (json['bidToBuy'] as num).toDouble(),
      marketClearingPrice: (json['marketClearingPrice'] as num).toDouble(),
      estimatedBuy: (json['estimatedBuy'] as num).toDouble(),
      netEstimatedEnergyPrice:
          (json['netEstimatedEnergyPrice'] as num).toDouble(),
      energyToBuy: (json['energyToBuy'] as num).toDouble(),
      energyTariff: (json['energyTariff'] as num).toDouble(),
      energyPrice: (json['energyPrice'] as num).toDouble(),
      wheelingChargeTariff: (json['wheelingChargeTariff'] as num).toDouble(),
      wheelingCharge: (json['wheelingCharge'] as num).toDouble(),
      tradingFee: (json['tradingFee'] as num).toDouble(),
      vat: (json['vat'] as num).toDouble(),
    );
  }
}
