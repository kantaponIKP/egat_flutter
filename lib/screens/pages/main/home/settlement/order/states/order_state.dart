import 'package:egat_flutter/screens/pages/main/home/settlement/models/trade_info.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/order/apis/order_api.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/cupertino.dart';

class OrderState extends ChangeNotifier {
  LoginSession? _loginSession;
  LoginSession? get loginSession => _loginSession;

  List<TradeInfo> _tradeInfos = [];
  List<TradeInfo> get tradeInfos => _tradeInfos;

  setLoginSession(LoginSession? session) {
    _loginSession = session;
  }

  Future<void> fetchOrderAtTime(DateTime selectedTime) async {
    if (loginSession == null) {
      throw new Exception("No login session provided.");
    }

    final accessToken = loginSession!.info!.accessToken;

    final response = await orderApi.fetchOrderInfos(
      date: selectedTime,
      accessToken: accessToken,
    );

    _tradeInfos = response;

    notifyListeners();
  }
}
