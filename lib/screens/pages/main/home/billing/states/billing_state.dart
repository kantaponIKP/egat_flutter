import 'package:egat_flutter/screens/pages/main/home/billing/apis/billing_api.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/cupertino.dart';

import '../apis/models/GetBillingSummaryResponse.dart';

class BillingState extends ChangeNotifier {
  LoginSession? _loginSession;
  GetBillingSummaryResponse? _billingSummary;

  LoginSession? get loginSession => _loginSession;
  GetBillingSummaryResponse? get billingSummary => _billingSummary;

  Future<void> fetchBillingSummaryAtTime(DateTime selectedTime) async {
    if (loginSession == null) {
      throw new Exception("No login session provided.");
    }

    final accessToken = loginSession!.info!.accessToken;

    final response = await billingApi.fetchBillingSummary(
      date: selectedTime,
      accessToken: accessToken,
    );

    _billingSummary = response;

    notifyListeners();
  }

  setLoginSession(LoginSession? session) {
    _loginSession = session;
  }
}
