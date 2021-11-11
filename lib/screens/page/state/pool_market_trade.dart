import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:flutter/cupertino.dart';

class PoolMarketTradeModel {

  PoolMarketTradeModel();
}

class PoolMarketTrade extends ChangeNotifier {
  PoolMarketTradeModel _info = PoolMarketTradeModel();

  final PageModel parent;

  PoolMarketTrade(this.parent);

  PoolMarketTradeModel get info => _info;

  setInfo(PoolMarketTradeModel info) {
    this._info = info;
    notifyListeners();
  }

  updateInfo() {

  }

  setNoInfo() {
    this._info = PoolMarketTradeModel();
    notifyListeners();
  }
}
