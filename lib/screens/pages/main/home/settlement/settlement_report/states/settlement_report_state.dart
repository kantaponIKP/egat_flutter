import 'package:egat_flutter/screens/pages/main/home/settlement/models/energy_transfer_info.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/settlement_report/apis/models/GetDailySettlementReportResponse.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/settlement_report/apis/models/GetMonthlySettlementReportResponse.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/cupertino.dart';

import '../apis/settlement_report_api.dart';

class SettlementReportState extends ChangeNotifier {
  LoginSession? _loginSession;

  GetDailySettlementReportResponse? _dailyReport = null;
  GetDailySettlementReportResponse? get dailyReport => _dailyReport;

  GetMonthlySettlementReportResponse? _monthlyReport = null;
  GetMonthlySettlementReportResponse? get monthlyReport => _monthlyReport;

  LoginSession? get loginSession => _loginSession;

  Future<void> fetchOrderAtTime(DateTime selectedTime, bool isDaily) async {
    if (loginSession == null) {
      throw new Exception("No login session provided.");
    }

    final accessToken = loginSession!.info!.accessToken;

    if (isDaily) {
      final data = await settlementReportApi.fetchDailySettlementReport(
        date: selectedTime,
        accessToken: accessToken,
      );

      _dailyReport = data;
    } else {
      final data = await settlementReportApi.fetchMonthlySettlementReport(
        date: selectedTime,
        accessToken: accessToken,
      );

      _monthlyReport = data;
    }

    notifyListeners();
  }

  setLoginSession(LoginSession? session) {
    _loginSession = session;
  }
}
