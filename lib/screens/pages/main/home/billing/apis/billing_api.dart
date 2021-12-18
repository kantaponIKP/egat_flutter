import 'package:egat_flutter/screens/pages/main/home/billing/apis/models/GetBillingSummaryResponse.dart';

class BillingApi {
  Future<GetBillingSummaryResponse> fetchBillingSummary({
    required DateTime date,
    required String accessToken,
  }) async {
    return GetBillingSummaryResponse(
        netEnergyTradingPayment: 1,
        gridPrice: 1,
        wheelingCharge: 1,
        estimatedNetPayment: 1);
  }
}

final BillingApi billingApi = new BillingApi();
