import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:flutter/cupertino.dart';

class BilateralBuyModel {
  BilateralBuyModel();
}

class BilateralBuy extends ChangeNotifier {
  BilateralBuyModel _info = BilateralBuyModel();

  final PageModel parent;

  BilateralBuy(this.parent);

  BilateralBuyModel get info => _info;

  setInfo(BilateralBuyModel info) {
    this._info = info;
    notifyListeners();
  }

  setPageBilateralLongTermBuy() {
    parent.status.setStateBilateralLongTermBuy();
  }

  setPageBack() {
    parent.status.setStatePrevious();
  }

  setPageBilateralTrade() {
    parent.status.setStateBilateralTrade();
  }
}
