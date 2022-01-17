import 'package:egat_flutter/screens/pages/main/home/main/apis/main_api.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/cupertino.dart';

class MainHomeState extends ChangeNotifier {
  GetHomeResponse _value = const GetHomeResponse(
    batteryInTotal: 0,
    batteryOutTotal: 0,
    pvTotal: 0,
    gridOutTotal: 0,
    gridInTotal: 0,
    totalSaleForecastUnit: 0,
    totalSales: 0,
    totalBuys: 0,
    totalRec: 0,
    energyConsumption: 0,
    summaryNet: 0,
    accumulatedRec: 0,
    totalBuyFromGrid: 0,
    batteryIns: [0],
    batteryOuts: [0],
    pvs: [0],
    gridIns: [0],
    gridOuts: [0],
    sales: [0],
    buys: [0],
    buyFromGrids: [0],
  );

  LoginSession? _loginSession;
  setLoginSession(LoginSession loginSession) {
    _loginSession = loginSession;
  }

  GetHomeResponse get value => _value;

  fetch(DateTime date, bool isDaily) async {
    if (_loginSession == null) {
      return;
    }

    if (isDaily) {
      final result = await mainHomeApi.getHomeDaily(
        date: date,
        accessToken: _loginSession?.info?.accessToken ?? '',
      );

      _setValue(result);
    } else {
      final result = await mainHomeApi.getHomeMonthly(
        date: date,
        accessToken: _loginSession?.info?.accessToken ?? '',
      );

      _setValue(result);
    }
  }

  _setValue(GetHomeResponse value) {
    _value = value;
    notifyListeners();
  }
}
