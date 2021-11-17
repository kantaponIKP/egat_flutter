import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:flutter/cupertino.dart';

class BilateralLongTermSellModel {

  BilateralLongTermSellModel();
}

class BilateralLongTermSell extends ChangeNotifier {
  BilateralLongTermSellModel _info = BilateralLongTermSellModel();

  final PageModel parent;

  BilateralLongTermSell(this.parent);

  BilateralLongTermSellModel get info => _info;

  setInfo(BilateralLongTermSellModel info) {
    this._info = info;
    notifyListeners();
  }

  setPageBilateralTrade() {
    parent.status.setStateBilateralTrade();
  }

  setPageBack(){
    parent.status.setStatePrevious();
  }
}
