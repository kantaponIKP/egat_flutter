import 'package:egat_flutter/screens/page/api/model/AccessRequest.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketShortTermSellRequest.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketShortTermSellResponse.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketTradingFeeRequest.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketTradingFeeResponse.dart';
import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class PoolMarketShortTermSellTile {
  String? date;
  double? energyToSale;
  double? offerToSellPrice;

  PoolMarketShortTermSellTile({
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

class PoolMarketShortTermSellModel {
  List<String>? dateList;
  List<TradingFee>? tradingFee;
  PoolMarketShortTermSellModel({this.dateList, this.tradingFee});
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

  Future<void> getPoolMarketTradingFee() async {
    PoolMarketTradingFeeResponse response;
    response = await parent.api.getPoolMarketTradingFee(
        PoolMarketTradingFeeRequest(dateList: info.dateList!),
        AccessRequest(
            accessToken: parent.session.info!.accessToken,
            userId: parent.session.info!.userId));

    List<TradingFee> models = [];
    for (var i = 0; i < response.tradingFee!.length; i++) {
      models.add(TradingFee.fromJSONMap(response.tradingFee![i]));
    }
    _info.tradingFee = models;
  }

  Future<bool> poolMarketShortTermSell(
      List<PoolMarketShortTermSellTile> list) async {
    // Response response;
    // response = await parent.api.poolMarketShortTermSell(
    //   PoolMarketShortTermSellRequest(
    //     poolMarketList: list,
    //   ),
    //   AccessRequest(
    //     accessToken: parent.session.info!.accessToken,
    //     userId: parent.session.info!.userId,
    //   ),
    // );
    // print(response.statusCode);
    // if (response.statusCode < 300) {
    //   return true;
    // } else {
    //   return false;
    // }
    return false;
  }
}
