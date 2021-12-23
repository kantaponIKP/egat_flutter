import 'package:egat_flutter/screens/page/api/model/AccessRequest.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketTradeRequest.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketTradeResponse.dart';
import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class PoolMarketModel {
  String? type; //offer to sell or choose to buy
  String? time;
  int? offerCount;
  int? matched;
  double? price;
  double? volume;
  String? status;
  String? isoDate;
  double? offerAmount;
  double? offerPrice;
  bool? isMatched;

  PoolMarketModel({
    this.type,
    this.time,
    this.offerCount,
    this.matched,
    this.price,
    this.volume,
    this.status,
    this.isoDate,
    this.offerAmount,
    this.offerPrice,
    this.isMatched
  });

  PoolMarketModel.fromJSONMap(Map<String, dynamic> jsonMap) {
    final isoTime = DateTime.parse(jsonMap["time"]);
  
    final startTime = isoTime.toLocal();
    final endTime = startTime.add(Duration(hours: 1));

    final timeFormat = DateFormat("HH:mm");
    final timeText =
        "${timeFormat.format(startTime)}-${timeFormat.format(endTime)}";
    this.type = jsonMap['type'];
    this.time = timeText;
    this.offerCount = (jsonMap['offerCount'] as num).toInt();
    if (jsonMap['matched'] != null) {
      this.matched = (jsonMap['matched'] as num).toInt();
    }
    if (jsonMap['price'] != null) {
      this.price = (jsonMap['price'] as num).toDouble();
    }
    if (jsonMap['volume'] != null) {
      this.volume = (jsonMap['volume'] as num).toDouble();
    }
    this.status = jsonMap['status'];
    this.isoDate = jsonMap['time'];

    if(jsonMap['offerAmount'] != null) {
      this.offerAmount = (jsonMap['offerAmount'] as num).toDouble();
    }
    if(jsonMap['offerPrice'] != null) {
      this.offerPrice = (jsonMap['offerPrice'] as num).toDouble();
    }
    this.isMatched = jsonMap['isMatched'];
  }
}

class PoolMarketTradeModel {
  List<PoolMarketModel>? poolMarketTileList;
  PoolMarketTradeModel({this.poolMarketTileList});
}

class PoolMarketTrade extends ChangeNotifier {
  PoolMarketTradeModel _info = PoolMarketTradeModel();

  final PageModel parent;

  PoolMarketTrade(this.parent);

  PoolMarketTradeModel get info => _info;

  setInfo(PoolMarketTradeModel info) {
    this._info = info;
    notifyListeners();
  }

  updateInfo() {}

  setNoInfo() {
    this._info = PoolMarketTradeModel();
    notifyListeners();
  }

  setPagePoolMarketShortTermBuy() {
    parent.status.setStatePoolMarketShortTermBuy();
  }

  setPagePoolMarketShortTermSell() {
    parent.status.setStatePoolMarketShortTermSell();
  }


    Future<void> getPoolMarket({required String date}) async {
    PoolMarketTradeResponse response;
    response = await parent.api.getPoolMarketTrade(
        PoolMarketTradeRequest(date: date),
        AccessRequest(
            accessToken: parent.session.info!.accessToken,
            userId: parent.session.info!.userId));

    List<PoolMarketModel> models = [];
    for (var i = 0; i < response.pookMarketList.length; i++) {
      models.add(PoolMarketModel.fromJSONMap(response.pookMarketList[i]));
    }

    setInfo(PoolMarketTradeModel(poolMarketTileList: models));
  }
}
