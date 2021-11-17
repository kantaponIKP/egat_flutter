import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:flutter/cupertino.dart';

class PoolMarketShortTermBuyModel {
  PoolMarketShortTermBuyModel();
}

class PoolMarketShortTermBuy extends ChangeNotifier {
  PoolMarketShortTermBuyModel _info = PoolMarketShortTermBuyModel();

  final PageModel parent;

  PoolMarketShortTermBuy(this.parent);

  PoolMarketShortTermBuyModel get info => _info;

  setInfo(PoolMarketShortTermBuyModel info) {
    this._info = info;
    notifyListeners();
  }

  setPageBack() {
    parent.status.setStatePrevious();
  }

  setPagePoolMarketTrade() {
    parent.status.setStatePoolMarketTrade();
  }
}
