import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:flutter/cupertino.dart';

class PoolMarketShortTermSellModel {
  PoolMarketShortTermSellModel();
}

class PoolMarketShortTermSell extends ChangeNotifier {
  PoolMarketShortTermSellModel _info = PoolMarketShortTermSellModel();

  final PageModel parent;

  PoolMarketShortTermSell(this.parent);

  PoolMarketShortTermSellModel get info => _info;

  setInfo(PoolMarketShortTermSellModel info) {
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
