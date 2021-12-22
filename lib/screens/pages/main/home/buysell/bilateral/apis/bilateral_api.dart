import 'dart:convert';

import 'package:egat_flutter/Utils/http/get.dart';
import 'package:egat_flutter/Utils/http/post.dart';
import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/bilateral/apis/models/TransactionSubmitItem.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'models/BilateralShortTermBuyInfoResponse.dart';
import 'models/BilateralShortTermSellRequest.dart';
import 'models/BilateralTradingFeeRequest.dart';
import 'models/BilateralTradingFeeResponse.dart';
import 'models/GetBilateralShortTermSellInfoResponse.dart';
import 'models/GetBilateralTradeResponse.dart';

class BilateralApi {
  const BilateralApi();

  Future<GetBilateralTradeResponse> getBilateralTrade({
    required DateTime dateTime,
    required String accessToken,
  }) async {
    Response response;

    var dateRequest = dateTime.toUtc().toIso8601String();
    var url = Uri.parse(
      "$apiBaseUrlBilateralTrade/bilateral-app/list-home/$dateRequest",
    );

    response = await httpGetJson(
      url: url,
      accessToken: accessToken,
    );

    final jsonMap = json.decode(response.body);

    // assert(
    //   jsonMap.runtimeType.toString() == "List<dynamic>",
    //   'Invalid response from server (not a list of object)',
    // );

    var result = GetBilateralTradeResponse.fromJSON(jsonMap as List<dynamic>);

    return result;
  }

  Future<BilateralShortTermSellInfoResponse> getBilateralShortTermSellInfo({
    required DateTime requestDate,
    required String accessToken,
  }) async {
    var url = Uri.parse(
      "$apiBaseUrlBilateralTrade/bilateral-app/offer-to-sell/listing/${requestDate.toUtc().toIso8601String()}",
    );

    final response = await httpGetJson(url: url, accessToken: accessToken);

    if (response.statusCode >= 300) {
      logger.log(
        Level.debug,
        'BilateralApi.getBilateralShortTermSellInfo: Error response from server: ${response.statusCode}',
      );
      throw Exception('Failed to get data');
    }

    var jsonMap = jsonDecode(response.body);

    return BilateralShortTermSellInfoResponse.fromJSON(jsonMap);
  }

  Future<BilateralTradingFeeResponse> getBilateralTradingFee({
    required List<DateTime> dateList,
    required String accessToken,
  }) async {
    var request = BilateralTradingFeeRequest(dateList: dateList);
    var requestJson = request.toJSON();

    Response response;

    var url = Uri.parse(
      "$apiBaseUrlBilateralTrade/bilateral-app/offer-to-sell/references",
    );

    response = await httpPostJson(
      uri: url,
      accessToken: accessToken,
      body: requestJson,
    );

    if (response.statusCode >= 300) {
      logger.log(
        Level.debug,
        'BilateralApi.getBilateralTradingFee: Error response from server: ${response.statusCode}',
      );
      throw Exception('Failed to get data');
    }

    return BilateralTradingFeeResponse.fromJSON(response.body);
  }

  Future<void> bilateralShortTermSell({
    required List<TransactionSubmitItem> submitItems,
    required String accessToken,
  }) async {
    var request = BilateralShortTermSellRequest(submitItems: submitItems);
    var requestJson = request.toJSON();

    Response response;

    var url = Uri.parse(
      "$apiBaseUrlBilateralTrade/bilateral-app/offer-to-sell",
    );

    response = await httpPostJson(
      uri: url,
      accessToken: accessToken,
      body: requestJson,
    );

    if (response.statusCode == 409) {
      throw Exception('Found duplicate offer!');
    }

    if (response.statusCode >= 300) {
      logger.log(
        Level.debug,
        'BilateralApi.bilateralShortTermSell: Error response from server: ${response.statusCode}',
      );
      throw Exception('Failed to submit data code ${response.statusCode}');
    }

    return;
  }

  Future<BilateralShortTermBuyInfoResponse> getBilateralShortTermBuyInfo({
    required DateTime requestDate,
    required String accessToken,
  }) async {
    Response response;

    var dateRequest = requestDate.toUtc().toIso8601String();

    var url = Uri.parse(
      "$apiBaseUrlBilateralTrade/bilateral-app/choose-to-buy/listing/$dateRequest",
    );
    response = await httpGetJson(
      url: url,
      accessToken: accessToken,
    );

    final jsonMap = json.decode(response.body);

    var result = GetBilateralTradeResponse.fromJSON(jsonMap as List<dynamic>);

    return BilateralShortTermBuyInfoResponse.fromJSON(response.body);
  }
}

const bilateralApi = const BilateralApi();
