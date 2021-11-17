import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:flutter/cupertino.dart';

class BilateralLongTermBuyModel {

  BilateralLongTermBuyModel();
}

class BilateralLongTermBuy extends ChangeNotifier {
  BilateralLongTermBuyModel _info = BilateralLongTermBuyModel();

  final PageModel parent;

  BilateralLongTermBuy(this.parent);

  BilateralLongTermBuyModel get info => _info;

  setInfo(BilateralLongTermBuyModel info) {
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
