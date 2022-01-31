import 'contract_direction.dart';

enum ContractRole {
  BUYER,
  SELLER,
}

enum MarketType {
  BILATERAL,
  POOL,
}

enum SettlementResultType {
  ENERGY_SHORTFALL,
  ENERGY_EXCESS,
}

class SettlementReportInfo {
  final ContractRole role;
  final SettlementResultType resultType;
  final MarketType market;
  final DateTime date;

  final String contractId;
  final List<String> targetName;

  const SettlementReportInfo({
    required this.role,
    required this.resultType,
    required this.market,
    required this.date,
    required this.contractId,
    required this.targetName,
  });

  factory SettlementReportInfo.fromJson(Map<String, dynamic> json) {
    assert(json['role'] is String);
    assert(json['resultType'] is String);
    assert(json['market'] is String);
    assert(json['date'] is String);

    var roleString = json['role'] as String;
    var resultTypeString = json['resultType'] as String;
    var marketString = json['market'] as String;

    ContractRole role;
    switch (roleString.toUpperCase()) {
      case 'BUYER':
        role = ContractRole.BUYER;
        break;
      case 'SELLER':
        role = ContractRole.SELLER;
        break;
      default:
        throw Exception('Unknown role: $roleString');
    }

    SettlementResultType resultType;
    switch (resultTypeString.toUpperCase()) {
      case 'ENERGY_EXCESS':
        resultType = SettlementResultType.ENERGY_EXCESS;
        break;
      case 'ENERGY_SHORTFALL':
        resultType = SettlementResultType.ENERGY_SHORTFALL;
        break;
      default:
        throw Exception('Unknown resultType: $resultTypeString');
    }

    MarketType market;
    switch (marketString.toUpperCase()) {
      case 'BILATERAL':
        market = MarketType.BILATERAL;
        break;
      case 'POOL':
        market = MarketType.POOL;
        break;
      default:
        throw Exception('Unknown market: $marketString');
    }

    if (market == MarketType.BILATERAL) {
      if (role == ContractRole.BUYER) {
        if (resultType == SettlementResultType.ENERGY_SHORTFALL) {
          return BilateralBuyerEnergyShortfallSettlementReportInfo.fromJson(
              json);
        }
        if (resultType == SettlementResultType.ENERGY_EXCESS) {
          return BilateralBuyerEnergyExcessSettlementReportInfo.fromJson(json);
        }
      }
      if (role == ContractRole.SELLER) {
        if (resultType == SettlementResultType.ENERGY_SHORTFALL) {
          return BilateralSellerEnergyShortfallSettlementReportInfo.fromJson(
              json);
        }
        if (resultType == SettlementResultType.ENERGY_EXCESS) {
          return BilateralSellerEnergyExcessSettlementReportInfo.fromJson(json);
        }
      }
    }

    if (market == MarketType.POOL) {
      if (role == ContractRole.BUYER) {
        if (resultType == SettlementResultType.ENERGY_SHORTFALL) {
          return PoolBuyerEnergyShortfallSettlementReportInfo.fromJson(json);
        }
        if (resultType == SettlementResultType.ENERGY_EXCESS) {
          return PoolBuyerEnergyExcessSettlementReportInfo.fromJson(json);
        }
      }
      if (role == ContractRole.SELLER) {
        if (resultType == SettlementResultType.ENERGY_SHORTFALL) {
          return PoolSellerEnergyShortfallSettlementReportInfo.fromJson(json);
        }
        if (resultType == SettlementResultType.ENERGY_EXCESS) {
          return PoolSellerEnergyExcessSettlementReportInfo.fromJson(json);
        }
      }
    }

    throw Exception('Unknown trade info: $json');
  }
}

class BilateralBuyerEnergyShortfallSettlementReportInfo
    extends SettlementReportInfo {
  final double energyCommitted;
  final double energyUsed;
  final double netBuy;
  final double buyerImbalanceAmount;
  final double buyerImbalance;
  final double wheelingChargeTariff;
  final double wheelingCharge;
  final double netEnergyPrice;

  const BilateralBuyerEnergyShortfallSettlementReportInfo({
    required this.energyCommitted,
    required this.energyUsed,
    required this.netBuy,
    required this.buyerImbalanceAmount,
    required this.buyerImbalance,
    required this.wheelingChargeTariff,
    required this.wheelingCharge,
    required this.netEnergyPrice,
    required String contractId,
    required List<String> targetName,
    required DateTime date,
  }) : super(
          contractId: contractId,
          targetName: targetName,
          date: date,
          resultType: SettlementResultType.ENERGY_SHORTFALL,
          market: MarketType.BILATERAL,
          role: ContractRole.BUYER,
        );

  factory BilateralBuyerEnergyShortfallSettlementReportInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    assert(json['contractId'] is String);
    assert(json['targetName'] is List);
    assert(json['date'] is String);

    assert(json['energyCommitted'] is num);
    assert(json['energyUsed'] is num);
    assert(json['netBuy'] is num);
    assert(json['buyerImbalanceAmount'] is num);
    assert(json['buyerImbalance'] is num);
    assert(json['wheelingChargeTariff'] is num);
    assert(json['wheelingCharge'] is num);
    assert(json['netEnergyPrice'] is num);

    return BilateralBuyerEnergyShortfallSettlementReportInfo(
      energyCommitted: (json['energyCommitted'] as num).toDouble(),
      energyUsed: (json['energyUsed'] as num).toDouble(),
      netBuy: (json['netBuy'] as num).toDouble(),
      buyerImbalanceAmount: (json['buyerImbalanceAmount'] as num).toDouble(),
      buyerImbalance: (json['buyerImbalance'] as num).toDouble(),
      wheelingChargeTariff: (json['wheelingChargeTariff'] as num).toDouble(),
      wheelingCharge: (json['wheelingCharge'] as num).toDouble(),
      // wheelingCharge: 0,
      netEnergyPrice: (json['netEnergyPrice'] as num).toDouble(),
      // netEnergyPrice: 0,
      contractId: json['contractId'] as String,
      targetName: (json['targetName'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      date: DateTime.parse(json['date'] as String),
    );
  }
}

class PoolBuyerEnergyShortfallSettlementReportInfo
    extends SettlementReportInfo {
  final double energyCommitted;
  final double energyUsed;
  final double netBuy;
  final double buyerImbalanceAmount;
  final double buyerImbalance;
  final double wheelingChargeTariff;
  final double wheelingCharge;
  final double netEnergyPrice;

  const PoolBuyerEnergyShortfallSettlementReportInfo({
    required this.energyCommitted,
    required this.energyUsed,
    required this.netBuy,
    required this.buyerImbalanceAmount,
    required this.buyerImbalance,
    required this.wheelingChargeTariff,
    required this.wheelingCharge,
    required this.netEnergyPrice,
    required String contractId,
    required List<String> targetName,
    required DateTime date,
  }) : super(
          contractId: contractId,
          targetName: targetName,
          date: date,
          resultType: SettlementResultType.ENERGY_SHORTFALL,
          market: MarketType.POOL,
          role: ContractRole.BUYER,
        );

  factory PoolBuyerEnergyShortfallSettlementReportInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    assert(json['contractId'] is String);
    assert(json['targetName'] is List);
    assert(json['date'] is String);

    assert(json['energyCommitted'] is num);
    assert(json['energyUsed'] is num);
    assert(json['netBuy'] is num);
    assert(json['buyerImbalanceAmount'] is num);
    assert(json['buyerImbalance'] is num);
    assert(json['wheelingChargeTariff'] is num);
    assert(json['wheelingCharge'] is num);
    assert(json['netEnergyPrice'] is num);

    return PoolBuyerEnergyShortfallSettlementReportInfo(
      energyCommitted: (json['energyCommitted'] as num).toDouble(),
      energyUsed: (json['energyUsed'] as num).toDouble(),
      netBuy: (json['netBuy'] as num).toDouble(),
      buyerImbalanceAmount: (json['buyerImbalanceAmount'] as num).toDouble(),
      buyerImbalance: (json['buyerImbalance'] as num).toDouble(),
      wheelingChargeTariff: (json['wheelingChargeTariff'] as num).toDouble(),
      wheelingCharge: (json['wheelingCharge'] as num).toDouble(),
      netEnergyPrice: (json['netEnergyPrice'] as num).toDouble(),
      contractId: json['contractId'] as String,
      targetName: (json['targetName'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      date: DateTime.parse(json['date'] as String),
    );
  }
}

class BilateralBuyerEnergyExcessSettlementReportInfo
    extends SettlementReportInfo {
  final double energyCommitted;
  final double energyDelivered;
  final double sellerImbalanceAmount;
  final double sellerImbalance;

  const BilateralBuyerEnergyExcessSettlementReportInfo({
    required this.energyCommitted,
    required this.energyDelivered,
    required this.sellerImbalanceAmount,
    required this.sellerImbalance,
    required String contractId,
    required List<String> targetName,
    required DateTime date,
  }) : super(
          contractId: contractId,
          targetName: targetName,
          date: date,
          resultType: SettlementResultType.ENERGY_EXCESS,
          market: MarketType.BILATERAL,
          role: ContractRole.BUYER,
        );

  factory BilateralBuyerEnergyExcessSettlementReportInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    assert(json['contractId'] is String);
    assert(json['targetName'] is List);
    assert(json['date'] is String);

    assert(json['energyCommitted'] is num);
    assert(json['energyDelivered'] is num);
    assert(json['sellerImbalanceAmount'] is num);
    assert(json['sellerImbalance'] is num);

    return BilateralBuyerEnergyExcessSettlementReportInfo(
      energyCommitted: (json['energyCommitted'] as num).toDouble(),
      energyDelivered: (json['energyDelivered'] as num).toDouble(),
      sellerImbalanceAmount: (json['sellerImbalanceAmount'] as num).toDouble(),
      sellerImbalance: (json['sellerImbalance'] as num).toDouble(),
      contractId: json['contractId'] as String,
      targetName: (json['targetName'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      date: DateTime.parse(json['date'] as String),
    );
  }
}

class PoolBuyerEnergyExcessSettlementReportInfo extends SettlementReportInfo {
  final double energyCommitted;
  final double energyUsed;
  final double sellerImbalanceAmount;
  final double sellerImbalance;

  const PoolBuyerEnergyExcessSettlementReportInfo({
    required this.energyCommitted,
    required this.energyUsed,
    required this.sellerImbalanceAmount,
    required this.sellerImbalance,
    required String contractId,
    required List<String> targetName,
    required DateTime date,
  }) : super(
          contractId: contractId,
          targetName: targetName,
          date: date,
          resultType: SettlementResultType.ENERGY_EXCESS,
          market: MarketType.BILATERAL,
          role: ContractRole.BUYER,
        );

  factory PoolBuyerEnergyExcessSettlementReportInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    assert(json['contractId'] is String);
    assert(json['targetName'] is List);
    assert(json['date'] is String);

    assert(json['energyCommitted'] is num);
    assert(json['energyUsed'] is num);
    assert(json['sellerImbalanceAmount'] is num);
    assert(json['sellerImbalance'] is num);

    return PoolBuyerEnergyExcessSettlementReportInfo(
      energyCommitted: (json['energyCommitted'] as num).toDouble(),
      energyUsed: (json['energyUsed'] as num).toDouble(),
      sellerImbalanceAmount: (json['sellerImbalanceAmount'] as num).toDouble(),
      sellerImbalance: (json['sellerImbalance'] as num).toDouble(),
      contractId: json['contractId'] as String,
      targetName: (json['targetName'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      date: DateTime.parse(json['date'] as String),
    );
  }
}

class BilateralSellerEnergyShortfallSettlementReportInfo
    extends SettlementReportInfo {
  final double energyCommitted;
  final double energyDelivered;
  final double netSales;
  final double sellerImbalanceAmount;
  final double sellerImbalance;
  final double netEnergyPrice;

  const BilateralSellerEnergyShortfallSettlementReportInfo({
    required this.energyCommitted,
    required this.energyDelivered,
    required this.netSales,
    required this.sellerImbalanceAmount,
    required this.sellerImbalance,
    required this.netEnergyPrice,
    required String contractId,
    required List<String> targetName,
    required DateTime date,
  }) : super(
          contractId: contractId,
          targetName: targetName,
          date: date,
          resultType: SettlementResultType.ENERGY_SHORTFALL,
          market: MarketType.BILATERAL,
          role: ContractRole.SELLER,
        );

  factory BilateralSellerEnergyShortfallSettlementReportInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    assert(json['contractId'] is String);
    assert(json['targetName'] is List);
    assert(json['date'] is String);

    assert(json['energyCommitted'] is num);
    assert(json['energyDelivered'] is num);
    assert(json['netSales'] is num);
    assert(json['sellerImbalanceAmount'] is num);
    assert(json['sellerImbalance'] is num);
    assert(json['netEnergyPrice'] is num);

    return BilateralSellerEnergyShortfallSettlementReportInfo(
      energyCommitted: (json['energyCommitted'] as num).toDouble(),
      energyDelivered: (json['energyDelivered'] as num).toDouble(),
      netSales: (json['netSales'] as num).toDouble(),
      sellerImbalanceAmount: (json['sellerImbalanceAmount'] as num).toDouble(),
      sellerImbalance: (json['sellerImbalance'] as num).toDouble(),
      netEnergyPrice: (json['netEnergyPrice'] as num).toDouble(),
      // netEnergyPrice: 0,
      contractId: json['contractId'] as String,
      targetName: (json['targetName'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      date: DateTime.parse(json['date'] as String),
    );
  }
}

class BilateralSellerEnergyExcessSettlementReportInfo
    extends SettlementReportInfo {
  final double energyCommitted;
  final double energyDelivered;
  final double netSales;
  final double sellerImbalanceAmount;
  final double sellerImbalance;
  final double netEnergyPrice;

  const BilateralSellerEnergyExcessSettlementReportInfo({
    required this.energyCommitted,
    required this.energyDelivered,
    required this.netSales,
    required this.sellerImbalanceAmount,
    required this.sellerImbalance,
    required this.netEnergyPrice,
    required String contractId,
    required List<String> targetName,
    required DateTime date,
  }) : super(
          contractId: contractId,
          targetName: targetName,
          date: date,
          resultType: SettlementResultType.ENERGY_EXCESS,
          market: MarketType.BILATERAL,
          role: ContractRole.SELLER,
        );

  factory BilateralSellerEnergyExcessSettlementReportInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    assert(json['contractId'] is String);
    assert(json['targetName'] is List);
    assert(json['date'] is String);

    assert(json['energyCommitted'] is num);
    assert(json['energyDelivered'] is num);
    assert(json['netSales'] is num);
    assert(json['sellerImbalanceAmount'] is num);
    assert(json['sellerImbalance'] is num);
    assert(json['netEnergyPrice'] is num);

    return BilateralSellerEnergyExcessSettlementReportInfo(
      energyCommitted: (json['energyCommitted'] as num).toDouble(),
      energyDelivered: (json['energyDelivered'] as num).toDouble(),
      netSales: (json['netSales'] as num).toDouble(),
      sellerImbalanceAmount: (json['sellerImbalanceAmount'] as num).toDouble(),
      sellerImbalance: (json['sellerImbalance'] as num).toDouble(),
      netEnergyPrice: (json['netEnergyPrice'] as num).toDouble(),
      contractId: json['contractId'] as String,
      targetName: (json['targetName'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      date: DateTime.parse(json['date'] as String),
    );
  }
}

class PoolSellerEnergyShortfallSettlementReportInfo
    extends SettlementReportInfo {
  final double energyMatched;
  final double energyDelivered;
  final double sellerImbalanceAmount;
  final double sellerImbalance;

  const PoolSellerEnergyShortfallSettlementReportInfo({
    required this.energyMatched,
    required this.energyDelivered,
    required this.sellerImbalanceAmount,
    required this.sellerImbalance,
    required String contractId,
    required List<String> targetName,
    required DateTime date,
  }) : super(
          contractId: contractId,
          targetName: targetName,
          date: date,
          resultType: SettlementResultType.ENERGY_SHORTFALL,
          market: MarketType.POOL,
          role: ContractRole.SELLER,
        );

  factory PoolSellerEnergyShortfallSettlementReportInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    assert(json['contractId'] is String);
    assert(json['targetName'] is List);
    assert(json['date'] is String);

    assert(json['energyMatched'] is num);
    assert(json['energyDelivered'] is num);
    assert(json['sellerImbalanceAmount'] is num);
    assert(json['sellerImbalance'] is num);

    return PoolSellerEnergyShortfallSettlementReportInfo(
      energyMatched: (json['energyMatched'] as num).toDouble(),
      energyDelivered: (json['energyDelivered'] as num).toDouble(),
      sellerImbalanceAmount: (json['sellerImbalanceAmount'] as num).toDouble(),
      sellerImbalance: (json['sellerImbalance'] as num).toDouble(),
      contractId: json['contractId'] as String,
      targetName: (json['targetName'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      date: DateTime.parse(json['date'] as String),
    );
  }
}

class PoolSellerEnergyExcessSettlementReportInfo extends SettlementReportInfo {
  final double energyMatched;
  final double energyDelivered;
  final double sellerImbalanceAmount;
  final double sellerImbalance;

  const PoolSellerEnergyExcessSettlementReportInfo({
    required this.energyMatched,
    required this.energyDelivered,
    required this.sellerImbalanceAmount,
    required this.sellerImbalance,
    required String contractId,
    required List<String> targetName,
    required DateTime date,
  }) : super(
          contractId: contractId,
          targetName: targetName,
          date: date,
          resultType: SettlementResultType.ENERGY_EXCESS,
          market: MarketType.POOL,
          role: ContractRole.SELLER,
        );

  factory PoolSellerEnergyExcessSettlementReportInfo.fromJson(
    Map<String, dynamic> json,
  ) {
    assert(json['contractId'] is String);
    assert(json['targetName'] is List);
    assert(json['date'] is String);

    assert(json['energyMatched'] is num);
    assert(json['energyDelivered'] is num);
    assert(json['sellerImbalanceAmount'] is num);
    assert(json['sellerImbalance'] is num);

    return PoolSellerEnergyExcessSettlementReportInfo(
      energyMatched: (json['energyMatched'] as num).toDouble(),
      energyDelivered: (json['energyDelivered'] as num).toDouble(),
      sellerImbalanceAmount: (json['sellerImbalanceAmount'] as num).toDouble(),
      sellerImbalance: (json['sellerImbalance'] as num).toDouble(),
      contractId: json['contractId'] as String,
      targetName: (json['targetName'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      date: DateTime.parse(json['date'] as String),
    );
  }
}
