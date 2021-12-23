import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:flutter/cupertino.dart';

class ForecastModel {

  ForecastModel();
}

class Forecast extends ChangeNotifier {
  ForecastModel _info = ForecastModel();

  final PageModel parent;

  Forecast(this.parent);

  ForecastModel get info => _info;

  setInfo(ForecastModel info) {
    this._info = info;
    notifyListeners();
  }

  updateInfo() {

  }

  setNoInfo() {
    this._info = ForecastModel();
    notifyListeners();
  }

  setPageBilateralBuy() {
    parent.status.setStateBilateralBuy();
  }

  setPageBilateralShortTermSell() {
    parent.status.setStateBilateralShortTermSell();
  }

  setPagePoolMarketShortTermBuy() {
    parent.status.setStatePoolMarketShortTermBuy();
  }

  setPagePoolMarketShortTermSell() {
    parent.status.setStatePoolMarketShortTermSell();
  }
  
}
