import 'package:egat_flutter/screens/page/api/model/AccessRequest.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketShortTermSellResponse.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketTradingFeeRequest.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketTradingFeeResponse.dart';
import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:egat_flutter/screens/page/state/pool_market/pool_market_short_term_sell.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/pool/apis/pool_api.dart';
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

  PoolMarketShortTermSell();

  PoolMarketShortTermSellModel get info => _info;

  setInfo(PoolMarketShortTermSellModel info) {
    this._info = info;
    notifyListeners();
  }

  Future<void> getPoolMarketTradingFee(String accessToken) async {
    PoolMarketTradingFeeResponse response;
    response = await poolApi.getPoolMarketTradingFee(
      PoolMarketTradingFeeRequest(dateList: info.dateList!),
      accessToken,
    );

    List<TradingFee> models = [];
    for (var i = 0; i < response.tradingFee!.length; i++) {
      models.add(TradingFee.fromJSONMap(response.tradingFee![i]));
    }
    _info.tradingFee = models;
  }

  Future<bool> poolMarketShortTermSell(
    List<PoolMarketShortTermSellTile> list,
    String accessToken,
  ) async {
    Response response;
    response = await poolApi.poolMarketShortTermSell(
      PoolMarketShortTermSellRequest(poolMarketList: list),
      accessToken,
    );
    print(response.statusCode);
    if (response.statusCode < 300) {
      return true;
    } else {
      return false;
    }
  }
}
