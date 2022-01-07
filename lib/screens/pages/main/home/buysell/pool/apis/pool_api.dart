import 'dart:convert';

import 'package:egat_flutter/Utils/http/get.dart';
import 'package:egat_flutter/Utils/http/post.dart';
import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/page/api/model/AccessRequest.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketReferencesRequest.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketReferencesResponse.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketShortTermBuyRequest.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketShortTermSellRequest.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketTradeRequest.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketTradeResponse.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketTradingFeeRequest.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketTradingFeeResponse.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/bilateral/apis/models/TransactionSubmitItem.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/pool/states/pool_market_short_term_sell.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'models/BilateralLongTermBuyInfoRequest.dart';
import 'models/BilateralLongTermBuyInfoResponse.dart';
import 'models/BilateralLongTermSellInfoRequest.dart';
import 'models/BilateralLongTermSellInfoResponse.dart';
import 'models/BilateralLongTermSellRequest.dart';
import 'models/BilateralShortTermBuyInfoResponse.dart';
import 'models/BilateralShortTermBuyRequest.dart';
import 'models/BilateralShortTermSellRequest.dart';
import 'models/BilateralTradingFeeRequest.dart';
import 'models/BilateralTradingFeeResponse.dart';
import 'models/GetBilateralShortTermSellInfoResponse.dart';
import 'models/GetBilateralTradeResponse.dart';

class PoolApi {
  const PoolApi();

  Future<PoolMarketTradeResponse> getPoolMarketTrade(
    String date,
    String accessToken,
  ) async {
    Response response;

    var url = Uri.parse(
      "$apiBaseUrlPoolMarketTrade/pool-app/list-home/$date",
    );

    response = await httpGetJson(
      url: url,
      accessToken: accessToken,
    );

    return PoolMarketTradeResponse.fromJSON(response.body);
  }

  Future<PoolMarketTradingFeeResponse> getPoolMarketTradingFee(
    PoolMarketTradingFeeRequest request,
    String accessToken,
  ) async {
    var requestJson = request.toJSON();

    Response response;

    var url = Uri.parse(
      "$apiBaseUrlPoolMarketTrade/pool-app/offer-to-sell/references",
    );

    response = await httpPostJson(
      uri: url,
      accessToken: accessToken,
      body: requestJson,
    );

    return PoolMarketTradingFeeResponse.fromJSON(response.body);
  }

  Future<Response> poolMarketShortTermSell(
    PoolMarketShortTermSellRequest request,
    String accessToken,
  ) async {
    var requestJson = request.toJSON();

    Response response;

    var url = Uri.parse(
      "$apiBaseUrlPoolMarketTrade/pool-app/offer-to-sell",
    );
    response = await httpPostJson(
      uri: url,
      accessToken: accessToken,
      body: requestJson,
    );

    return response;
  }

  Future<PoolMarketReferencesResponse> getPoolMarketReferences(
    String date,
    String accessToken,
  ) async {
    var dateReparses = DateTime.parse(date).toUtc().toIso8601String();

    Response response;

    var url = Uri.parse(
      "$apiBaseUrlPoolMarketTrade/pool-app/bid-to-buy/references/$dateReparses",
    );

    response = await httpPostJson(
      uri: url,
      accessToken: accessToken,
    );

    return PoolMarketReferencesResponse.fromJSON(response.body);
  }

  Future<Response> poolMarketShortTermBuy(
    String date,
    double energy,
    double price,
    String accessToken,
  ) async {
    var requestJson = {
      'energy': energy,
      'price': price,
      'date': date,
    };

    Response response;

    var url = Uri.parse(
      "$apiBaseUrlPoolMarketTrade/pool-app/bid-to-buy/$date",
    );
    response = await httpPostJson(
      uri: url,
      accessToken: accessToken,
      body: jsonEncode(requestJson),
    );

    return response;
  }
}

class PoolMarketShortTermSellRequest {
  List<PoolMarketShortTermSellTile> poolMarketList;

  PoolMarketShortTermSellRequest({
    required this.poolMarketList,
  });

  String toJSON() {
    List<Map<String, dynamic>> jsonMap = <Map<String, dynamic>>[];
    for (var poolMarket in this.poolMarketList) {
      Map<String, dynamic> poolMarketMap = Map<String, dynamic>();
      poolMarketMap['date'] = poolMarket.date;
      poolMarketMap['energy'] = poolMarket.energyToSale;
      poolMarketMap['price'] = poolMarket.offerToSellPrice;
      jsonMap.add(poolMarketMap);
    }

    return jsonEncode(jsonMap);
  }
}

const poolApi = const PoolApi();
