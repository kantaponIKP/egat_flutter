import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:flutter/cupertino.dart';

class BilateralSellModel {

  BilateralSellModel();
}

class BilateralSell extends ChangeNotifier {
  BilateralSellModel _info = BilateralSellModel();

  final PageModel parent;

  BilateralSell(this.parent);

  BilateralSellModel get info => _info;

  setInfo(BilateralSellModel info) {
    this._info = info;
    notifyListeners();
  }

  setPageBilateralShortTermSell() {
    parent.status.setStateBilateralShortTermSell();
  }

  setPageBilateralLongTermSell() {
    parent.status.setStateBilateralLongTermSell();
  }

    setPageBack(){
    parent.status.setStatePrevious();
  }

    setPageBilateralTrade() {
    parent.status.setStateBilateralTrade();
  }
}
