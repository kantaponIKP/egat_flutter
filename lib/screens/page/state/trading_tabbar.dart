import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:egat_flutter/screens/page/state/page_status.dart';
import 'package:flutter/cupertino.dart';

class TradingTabbarModel {
  final PageState? pageStatus;

  TradingTabbarModel({
    this.pageStatus,
  });
}

class TradingTabbar extends ChangeNotifier {
  TradingTabbarModel _info = TradingTabbarModel(pageStatus: PageState.Forecast);

  final PageModel parent;

  TradingTabbar(this.parent);

  TradingTabbarModel get info => _info;

  setInfo(TradingTabbarModel info) {
    this._info = info;
    notifyListeners();
  }

  setPageForecast() {
    parent.status.setStateForecast();
  }

  setPageBilateralTrade() {
    parent.status.setStateBilateralTrade();
  }

  setPagePoolMarketTrade() {
    parent.status.setStatePoolMarketTrade();
  }
}
