import 'package:egat_flutter/screens/pages/main/home/billing/apis/models/GetBillingSummaryResponse.dart';
import 'package:egat_flutter/screens/pages/main/home/billing/apis/models/GetPreliminaryInvoiceResponse.dart';

import 'models/GetInvoiceResponse.dart';

class BillingApi {
  Future<GetBillingSummaryResponse> fetchBillingSummary({
    required DateTime date,
    required String accessToken,
  }) async {
    // TODO: use real data
    await Future.delayed(Duration(seconds: 1));

    return GetBillingSummaryResponse(
        netEnergyTradingPayment: 1,
        gridPrice: 1,
        wheelingCharge: 1,
        estimatedNetPayment: 1);
  }

  Future<GetPreliminaryInvoiceResponse> fetchPreliminaryInvoice({
    required String accessToken,
  }) async {
    // TODO: use real data
    await Future.delayed(Duration(seconds: 1));

    return GetPreliminaryInvoiceResponse(
      electricUserName: "electricUserName",
      meterName: "meterName",
      meterId: "meterId",
      netEnergySalesUnit: 1,
      netEnergySalesBaht: 1,
      netEnergyBuyUnit: 1,
      netEnergyBuyBaht: 1,
      netImbalanceUnit: 1,
      netImbalanceBaht: 1,
      netBuyerImbalanceOverCommitUnit: 1,
      netBuyerImbalanceOverCommitBaht: 1,
      netBuyerImbalanceUnderCommitUnit: 1,
      netBuyerImbalanceUnderCommitBaht: 1,
      netSellerImbalanceOverCommitUnit: 1,
      netSellerImbalanceOverCommitBaht: 1,
      netSellerImbalanceUnderCommitUnit: 1,
      netSellerImbalanceUnderCommitBaht: 1,
      appTransactionFee: 1,
      discountAppFee: 1,
      vat: 1,
      netEnergyTradingPayment: 1,
      gridUsedUnit: 1,
      gridUsedBaht: 1,
      gridServiceCharge: 1,
      gridFt: 1,
      gridDiscount: 1,
      gridNetWheelingChargeBeforeVat: 1,
      gridNetBought: 1,
      wheelingChargeAsServiceCharge: 1,
      wheelingChargeTServiceCharge: 1,
      wheelingChargeDServiceCharge: 1,
      wheelingChargeReServiceCharge: 1,
      wheelingChargeBeforeVat: 1,
      wheelingChargeVat: 1,
      wheelingChargeNet: 1,
      estimateNetPayment: 1,
    );
  }

  Future<GetInvoiceResponse> fetchInvoice({
    required DateTime month,
    required String accessToken,
  }) async {
    var issueDate = DateTime(month.year, month.month + 1, 0);
    await Future.delayed(Duration(seconds: 1));

    return GetInvoiceResponse(
      issueDate: issueDate,
      providerName: "providerName",
      electricUserName: "electricUserName",
      meterName: "meterName",
      meterId: "meterId",
      meterCA: "123456789",
      meterInstallationSerial: "1234567891234567",
      meterInvoiceNo: "meterInvoiceNo",
      meterType: "Test1 Test1 Test1 Test1 12/14 v",
      netEnergySalesUnit: 1,
      netEnergySalesBaht: 1,
      netEnergyBuyUnit: 1,
      netEnergyBuyBaht: 1,
      netImbalanceUnit: 1,
      netImbalanceBaht: 1,
      netBuyerImbalanceOverCommitUnit: 1,
      netBuyerImbalanceOverCommitBaht: 1,
      netBuyerImbalanceUnderCommitUnit: 1,
      netBuyerImbalanceUnderCommitBaht: 1,
      netSellerImbalanceOverCommitUnit: 1,
      netSellerImbalanceOverCommitBaht: 1,
      netSellerImbalanceUnderCommitUnit: 1,
      netSellerImbalanceUnderCommitBaht: 1,
      appTransactionFee: 1,
      discountAppFee: 1,
      vat: 1,
      netEnergyTradingPayment: 1,
      gridUsedUnit: 1,
      gridUsedBaht: 1,
      gridServiceCharge: 1,
      gridFt: 1,
      gridDiscount: 1,
      gridNetWheelingChargeBeforeVat: 1,
      gridNetBought: 1,
      wheelingChargeAsServiceCharge: 1,
      wheelingChargeTServiceCharge: 1,
      wheelingChargeDServiceCharge: 1,
      wheelingChargeReServiceCharge: 1,
      wheelingChargeBeforeVat: 1,
      wheelingChargeVat: 1,
      wheelingChargeNet: 1,
      estimateNetPayment: 1,
    );
  }
}

final BillingApi billingApi = new BillingApi();
