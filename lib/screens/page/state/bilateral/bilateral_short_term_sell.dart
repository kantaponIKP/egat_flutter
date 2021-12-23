import 'package:egat_flutter/screens/page/api/model/AccessRequest.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralShortTermSellRequest.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralShortTermSellResponse.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralTradingFeeRequest.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralTradingFeeResponse.dart';
import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class BilateralOfferToSellTile {
  String? date;
  double? energyToSale;
  double? offerToSellPrice;

  BilateralOfferToSellTile({
    this.date,
    this.energyToSale,
    this.offerToSellPrice,
  });
}

class TradingFee {
  double? tradingFee;

  TradingFee({
    this.tradingFee,
  });

  TradingFee.fromJSONMap(Map<String, dynamic> jsonMap) {
    this.tradingFee = (jsonMap['tradingFee'] as num).toDouble();
  }
}

class BilateralShortTermSellModel {
  // List<BilateralSellTile>? bilateralTileList;
  List<String>? dateList;
  List<TradingFee>? tradingFee;
  BilateralShortTermSellModel({this.dateList, this.tradingFee});
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

  Future<bool> bilateralShortTermSell(
      List<BilateralOfferToSellTile> list) async {
    Response response;
    response = await parent.api.bilateralShortTermSell(
      BilateralShortTermSellRequest(
        bilateralList: list,
      ),
      AccessRequest(
        accessToken: parent.session.info!.accessToken,
        userId: parent.session.info!.userId,
      ),
    );
    print(response.statusCode);
    if (response.statusCode < 300) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> getBilateralTradingFee() async {
    BilateralTradingFeeResponse response;
    response = await parent.api.getBilateralTradingFee(
        BilateralTradingFeeRequest(dateList: info.dateList!),
        AccessRequest(
            accessToken: parent.session.info!.accessToken,
            userId: parent.session.info!.userId));

    List<TradingFee> models = [];
     for (var i = 0; i < response.tradingFee!.length; i++) {
      models.add(TradingFee.fromJSONMap(response.tradingFee![i]));
    }
    _info.tradingFee = models;
  }
}
