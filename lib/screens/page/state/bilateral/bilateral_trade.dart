import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:flutter/cupertino.dart';

class BilateralTradeModel {

  BilateralTradeModel();
}

class BilateralTrade extends ChangeNotifier {
  BilateralTradeModel _info = BilateralTradeModel();

  final PageModel parent;

  BilateralTrade(this.parent);

  BilateralTradeModel get info => _info;

  setInfo(BilateralTradeModel info) {
    this._info = info;
    notifyListeners();
  }

  updateInfo() {
  }

  setNoInfo() {
    this._info = BilateralTradeModel();
    notifyListeners();
  }

  setPageBilateralBuy() {
    parent.status.setStateBilateralBuy();
  }

  setPageBilateralSell() {
    parent.status.setStateBilateralSell();
  }

//  Future<bool> resetPassword(String password) async {
//     if (parent.session.info == null) {
//       // This must not happened.
//       return false;
//     }

//     var result = await parent.api.changeForgotPassword(
//         ChangeForgotPasswordRequest(
//           sessionId: parent.session.info!.sessionId,
//           sessionToken: parent.session.info!.sessionToken,
//           email: parent.email.info.email!,
//           password: password,
//         ));

//     nextPage();

//     return false;
//   }
}
