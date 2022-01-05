import 'dart:convert';

import 'package:egat_flutter/screens/page/api/model/AccessRequest.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketReferencesRequest.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketReferencesResponse.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketShortTermBuyInfoRequest.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketShortTermBuyInfoResponse.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketShortTermBuyRequest.dart';
import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class PoolMarketReference {
  double? wheelingChargeTariff;
  double? tradingFee;

  PoolMarketReference({
    this.wheelingChargeTariff,
    this.tradingFee,
  });

  // PoolMarketReference.fromJSON(String jsonString) {
  //   Map<String, dynamic> jsonMap = jsonDecode(jsonString);
  //   this.wheelingChargeTariff =
  //       (jsonMap['wheelingChargeTariff'] as num).toDouble();
  //   this.tradingFee = (jsonMap['tradingFee'] as num).toDouble();
  // }
}

class PoolMarketShortTermBuyModel {
  PoolMarketReference? poolMarketReference;
  String? date;
  PoolMarketShortTermBuyModel({this.poolMarketReference, this.date});
}

class PoolMarketShortTermBuy extends ChangeNotifier {
  PoolMarketShortTermBuyModel _info = PoolMarketShortTermBuyModel();

  final PageModel parent;

  PoolMarketShortTermBuy(this.parent);

  PoolMarketShortTermBuyModel get info => _info;

  setInfo(PoolMarketShortTermBuyModel info) {
    this._info = info;
    notifyListeners();
  }

  Future<void> getPoolMarketReferences() async {
    PoolMarketReferencesResponse response;
    response = await parent.api.getPoolMarketReferences(
        PoolMarketReferencesRequest(date: info.date!),
        AccessRequest(
            accessToken: parent.session.info!.accessToken,
            userId: parent.session.info!.userId));

    setInfo(
      PoolMarketShortTermBuyModel(
        date: info.date!,
        poolMarketReference: PoolMarketReference(
          tradingFee: response.tradingFee,
          wheelingChargeTariff: response.wheelingChargeTariff,
        ),
      ),
    );
  }

  // Future<void> getPoolMarketShortTermBuyInfo() async {
  //   Response response;
  //   response = await parent.api.getPoolMarketShortTermBuyInfo(
  //       PoolMarketShortTermBuyInfoRequest(date: info.date!),
  //       AccessRequest(
  //           accessToken: parent.session.info!.accessToken,
  //           userId: parent.session.info!.userId));

  //   PoolMarketReference poolMarketShortTermBuyDetail =
  //       PoolMarketReference.fromJSON(response.body);
  //   setInfo(PoolMarketShortTermBuyModel(
  //       poolMarketShortTermBuyDetail: poolMarketShortTermBuyDetail,
  //       date: info.date!));
  //   print(_info.poolMarketShortTermBuyDetail);
  //   print("");
  // }

  Future<bool> poolMarketShortTermBuy(
      {required String date,
      required double energy,
      required double price}) async {
    Response response;
    response = await parent.api.poolMarketShortTermBuy(
      PoolMarketShortTermBuyRequest(date: date, energy: energy, price: price),
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

  setPageBack() {
    parent.status.setStatePrevious();
  }

  setPagePoolMarketTrade() {
    parent.status.setStatePoolMarketTrade();
  }
}
