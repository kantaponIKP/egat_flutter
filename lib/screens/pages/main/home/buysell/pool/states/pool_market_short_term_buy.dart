import 'dart:convert';

import 'package:egat_flutter/screens/page/api/model/AccessRequest.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketReferencesRequest.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketReferencesResponse.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketShortTermBuyInfoRequest.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketShortTermBuyInfoResponse.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketShortTermBuyRequest.dart';
import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/pool/apis/pool_api.dart';
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

  PoolMarketShortTermBuy();

  PoolMarketShortTermBuyModel get info => _info;

  setInfo(PoolMarketShortTermBuyModel info, {bool notify = true}) {
    this._info = info;

    if (notify) {
      notifyListeners();
    }
  }

  Future<void> getPoolMarketReferences(String accessToken,
      {bool notify = true}) async {
    PoolMarketReferencesResponse response;
    response = await poolApi.getPoolMarketReferences(info.date!, accessToken);

    setInfo(
      PoolMarketShortTermBuyModel(
        date: info.date!,
        poolMarketReference: PoolMarketReference(
          tradingFee: response.tradingFee,
          wheelingChargeTariff: response.wheelingChargeTariff,
        ),
      ),
      notify: false,
    );
  }

  Future<bool> poolMarketShortTermBuy({
    required String date,
    required double energy,
    required double price,
    required String accessToken,
  }) async {
    Response response;
    response =
        await poolApi.poolMarketShortTermBuy(date, energy, price, accessToken);

    print(response.statusCode);
    if (response.statusCode < 300) {
      return true;
    } else {
      return false;
    }
  }
}
