class GetInvoiceResponse {
  final DateTime issueDate;

  final String providerName;
  final String electricUserName;
  final String meterName;
  final String meterId;

  final String meterCA;
  final String meterInstallationSerial;
  final String meterInvoiceNo;
  final String meterType;

  final double netEnergySalesUnit;
  final double netEnergySalesBaht;

  final double netEnergyBuyUnit;
  final double netEnergyBuyBaht;

  final double netImbalanceUnit;
  final double netImbalanceBaht;

  final double netBuyerImbalanceOverCommitUnit;
  final double netBuyerImbalanceOverCommitBaht;

  final double netBuyerImbalanceUnderCommitUnit;
  final double netBuyerImbalanceUnderCommitBaht;

  final double netSellerImbalanceOverCommitUnit;
  final double netSellerImbalanceOverCommitBaht;

  final double netSellerImbalanceUnderCommitUnit;
  final double netSellerImbalanceUnderCommitBaht;

  final double appTransactionFee;
  final double discountAppFee;
  final double vat;
  final double netEnergyTradingPayment;

  final double gridUsedUnit;
  final double gridUsedBaht;

  final double gridServiceCharge;
  final double gridFt;
  final double gridDiscount;
  final double gridNetWheelingChargeBeforeVat;
  final double gridNetBought;

  final double wheelingChargeAsServiceCharge;
  final double wheelingChargeTServiceCharge;
  final double wheelingChargeDServiceCharge;
  final double wheelingChargeReServiceCharge;
  final double wheelingChargeBeforeVat;
  final double wheelingChargeVat;
  final double wheelingChargeNet;

  final double estimateNetPayment;

  const GetInvoiceResponse({
    required this.issueDate,
    required this.providerName,
    required this.electricUserName,
    required this.meterName,
    required this.meterId,
    required this.meterCA,
    required this.meterInstallationSerial,
    required this.meterInvoiceNo,
    required this.meterType,
    required this.netEnergySalesUnit,
    required this.netEnergySalesBaht,
    required this.netEnergyBuyUnit,
    required this.netEnergyBuyBaht,
    required this.netImbalanceUnit,
    required this.netImbalanceBaht,
    required this.netBuyerImbalanceOverCommitUnit,
    required this.netBuyerImbalanceOverCommitBaht,
    required this.netBuyerImbalanceUnderCommitUnit,
    required this.netBuyerImbalanceUnderCommitBaht,
    required this.netSellerImbalanceOverCommitUnit,
    required this.netSellerImbalanceOverCommitBaht,
    required this.netSellerImbalanceUnderCommitUnit,
    required this.netSellerImbalanceUnderCommitBaht,
    required this.appTransactionFee,
    required this.discountAppFee,
    required this.vat,
    required this.netEnergyTradingPayment,
    required this.gridUsedUnit,
    required this.gridUsedBaht,
    required this.gridServiceCharge,
    required this.gridFt,
    required this.gridDiscount,
    required this.gridNetWheelingChargeBeforeVat,
    required this.gridNetBought,
    required this.wheelingChargeAsServiceCharge,
    required this.wheelingChargeTServiceCharge,
    required this.wheelingChargeDServiceCharge,
    required this.wheelingChargeReServiceCharge,
    required this.wheelingChargeBeforeVat,
    required this.wheelingChargeVat,
    required this.wheelingChargeNet,
    required this.estimateNetPayment,
  });

  factory GetInvoiceResponse.fromJson(Map<String, dynamic> json) {
    assert(json['issueDate'] is String);

    assert(json['providerName'] is String);
    assert(json['electricUserName'] is String);
    assert(json['meterName'] is String);
    assert(json['meterId'] is String);

    assert(json['meterCA'] is String);
    assert(json['meterInstallationSerial'] is String);
    assert(json['meterInvoiceNo'] is String);
    assert(json['meterType'] is String);

    assert(json['netEnergySalesUnit'] is double);
    assert(json['netEnergySalesBaht'] is double);

    assert(json['netEnergyBuyUnit'] is double);
    assert(json['netEnergyBuyBaht'] is double);

    assert(json['netImbalanceUnit'] is double);
    assert(json['netImbalanceBaht'] is double);

    assert(json['netBuyerImbalanceOverCommitUnit'] is double);
    assert(json['netBuyerImbalanceOverCommitBaht'] is double);

    assert(json['netBuyerImbalanceUnderCommitUnit'] is double);
    assert(json['netBuyerImbalanceUnderCommitBaht'] is double);

    assert(json['netSellerImbalanceOverCommitUnit'] is double);
    assert(json['netSellerImbalanceOverCommitBaht'] is double);

    assert(json['netSellerImbalanceUnderCommitUnit'] is double);
    assert(json['netSellerImbalanceUnderCommitBaht'] is double);

    assert(json['appTransactionFee'] is double);
    assert(json['discountAppFee'] is double);
    assert(json['vat'] is double);
    assert(json['netEnergyTradingPayment'] is double);

    assert(json['gridUsedUnit'] is double);
    assert(json['gridUsedBaht'] is double);

    assert(json['gridServiceCharge'] is double);
    assert(json['gridFt'] is double);
    assert(json['gridDiscount'] is double);
    assert(json['gridNetWheelingChargeBeforeVat'] is double);
    assert(json['gridNetBought'] is double);

    assert(json['wheelingChargeAsServiceCharge'] is double);
    assert(json['wheelingChargeTServiceCharge'] is double);
    assert(json['wheelingChargeDServiceCharge'] is double);
    assert(json['wheelingChargeReServiceCharge'] is double);
    assert(json['wheelingChargeBeforeVat'] is double);
    assert(json['wheelingChargeVat'] is double);
    assert(json['wheelingChargeNet'] is double);

    assert(json['estimateNetPayment'] is double);

    return GetInvoiceResponse(
      issueDate: DateTime.parse(json['issueDate']),
      providerName: json['providerName'],
      electricUserName: json['electricUserName'],
      meterName: json['meterName'],
      meterId: json['meterId'],
      meterCA: json['meterCA'],
      meterInstallationSerial: json['meterInstallationSerial'],
      meterInvoiceNo: json['meterInvoiceNo'],
      meterType: json['meterType'],
      netEnergySalesUnit: (json['netEnergySalesUnit'] as num).toDouble(),
      netEnergySalesBaht: (json['netEnergySalesBaht'] as num).toDouble(),
      netEnergyBuyUnit: (json['netEnergyBuyUnit'] as num).toDouble(),
      netEnergyBuyBaht: (json['netEnergyBuyBaht'] as num).toDouble(),
      netImbalanceUnit: (json['netImbalanceUnit'] as num).toDouble(),
      netImbalanceBaht: (json['netImbalanceBaht'] as num).toDouble(),
      netBuyerImbalanceOverCommitUnit:
          (json['netBuyerImbalanceOverCommitUnit'] as num).toDouble(),
      netBuyerImbalanceOverCommitBaht:
          (json['netBuyerImbalanceOverCommitBaht'] as num).toDouble(),
      netBuyerImbalanceUnderCommitUnit:
          (json['netBuyerImbalanceUnderCommitUnit'] as num).toDouble(),
      netBuyerImbalanceUnderCommitBaht:
          (json['netBuyerImbalanceUnderCommitBaht'] as num).toDouble(),
      netSellerImbalanceOverCommitUnit:
          (json['netSellerImbalanceOverCommitUnit'] as num).toDouble(),
      netSellerImbalanceOverCommitBaht:
          (json['netSellerImbalanceOverCommitBaht'] as num).toDouble(),
      netSellerImbalanceUnderCommitUnit:
          (json['netSellerImbalanceUnderCommitUnit'] as num).toDouble(),
      netSellerImbalanceUnderCommitBaht:
          (json['netSellerImbalanceUnderCommitBaht'] as num).toDouble(),
      appTransactionFee: (json['appTransactionFee'] as num).toDouble(),
      discountAppFee: (json['discountAppFee'] as num).toDouble(),
      vat: (json['vat'] as num).toDouble(),
      netEnergyTradingPayment:
          (json['netEnergyTradingPayment'] as num).toDouble(),
      gridUsedUnit: (json['gridUsedUnit'] as num).toDouble(),
      gridUsedBaht: (json['gridUsedBaht'] as num).toDouble(),
      gridServiceCharge: (json['gridServiceCharge'] as num).toDouble(),
      gridFt: (json['gridFt'] as num).toDouble(),
      gridDiscount: (json['gridDiscount'] as num).toDouble(),
      gridNetWheelingChargeBeforeVat:
          (json['gridNetWheelingChargeBeforeVat'] as num).toDouble(),
      gridNetBought: (json['gridNetBought'] as num).toDouble(),
      wheelingChargeAsServiceCharge:
          (json['wheelingChargeAsServiceCharge'] as num).toDouble(),
      wheelingChargeTServiceCharge:
          (json['wheelingChargeTServiceCharge'] as num).toDouble(),
      wheelingChargeDServiceCharge:
          (json['wheelingChargeDServiceCharge'] as num).toDouble(),
      wheelingChargeReServiceCharge:
          (json['wheelingChargeReServiceCharge'] as num).toDouble(),
      wheelingChargeBeforeVat:
          (json['wheelingChargeBeforeVat'] as num).toDouble(),
      wheelingChargeVat: (json['wheelingChargeVat'] as num).toDouble(),
      wheelingChargeNet: (json['wheelingChargeNet'] as num).toDouble(),
      estimateNetPayment: (json['estimateNetPayment'] as num).toDouble(),
    );
  }
}
