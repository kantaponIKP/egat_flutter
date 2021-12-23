import 'dart:collection';

import 'package:egat_flutter/screens/pages/main/home/buysell/bilateral/apis/bilateral_api.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/bilateral/models/bilateral_model.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/cupertino.dart';

class BilateralState extends ChangeNotifier {
  List<BilateralTradeItemModel> _tradeItems = [];
  List<BilateralTradeItemModel> get tradeItems =>
      UnmodifiableListView(_tradeItems);

  LoginSession? _loginSession;
  LoginSession? get loginSession => _loginSession;

  void setLoginSession(LoginSession state) {
    if (_loginSession == state) {
      return;
    }

    _loginSession = state;
    notifyListeners();
  }

  void _setTradeItems(List<BilateralTradeItemModel> items) {
    _tradeItems = items;
    notifyListeners();
  }

  Future<void> fetchTradeAtTime(DateTime dateTime) async {
    if (_loginSession == null) {
      throw new Exception("Login session is not provided");
    }

    var accessToken = _loginSession?.info?.accessToken;

    assert(accessToken != null, "Access token is not provided");

    final response = await bilateralApi.getBilateralTrade(
        dateTime: dateTime, accessToken: accessToken!);

    _setTradeItems(response.items);
  }
}
