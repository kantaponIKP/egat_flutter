import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:flutter/cupertino.dart';

class BilateralTradeModel {

  BilateralTradeModel();
}

class BilateralTrade extends ChangeNotifier {
  BilateralTradeModel _info = BilateralTradeModel();

  final PageModel parent;

  BilateralTrade(this.parent);

  BilateralTradeModel get info => _info;

  setInfo(BilateralTradeModel info) {
    this._info = info;
    notifyListeners();
  }

  updateInfo() {
  }

  setNoInfo() {
    this._info = BilateralTradeModel();
    notifyListeners();
  }
}
