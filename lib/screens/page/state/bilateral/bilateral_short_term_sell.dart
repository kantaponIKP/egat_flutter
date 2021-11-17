import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:flutter/cupertino.dart';

class BilateralShortTermSellModel {
  BilateralShortTermSellModel();
}

class BilateralShortTermSell extends ChangeNotifier {
  BilateralShortTermSellModel _info = BilateralShortTermSellModel();

  final PageModel parent;

  BilateralShortTermSell(this.parent);

  BilateralShortTermSellModel get info => _info;

  setInfo(BilateralShortTermSellModel info) {
    this._info = info;
    notifyListeners();
  }

  setPageBack() {
    parent.status.setStatePrevious();
  }

  setPageBilateralLongTermSell() {
    parent.status.setStateBilateralLongTermSell();
  }

  setPageBilateralTrade() {
    parent.status.setStateBilateralTrade();
  }
}
