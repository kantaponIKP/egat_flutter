import 'dart:convert';

import 'package:egat_flutter/Utils/http/get.dart';
import 'package:egat_flutter/Utils/http/post.dart';
import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/bilateral/apis/models/TransactionSubmitItem.dart';
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

    return BilateralShortTermBuyInfoResponse.fromJSON(jsonMap);
  }

  Future<void> bilateralShortTermBuy({
    required String id,
    required String accessToken,
  }) async {
    Response response;

    var url = Uri.parse(
      "$apiBaseUrlBilateralTrade/bilateral-app/choose-to-buy/${id}",
    );

    response = await httpPostJson(
      uri: url,
      accessToken: accessToken,
    );

    if (response.statusCode == 409) {
      throw Exception('Found duplicate offer!');
    }

    if (response.statusCode >= 300) {
      logger.log(
        Level.debug,
        'BilateralApi.bilateralShortTermBuy: Error response from server: ${response.statusCode}',
      );
      throw Exception('Failed to submit data code ${response.statusCode}');
    }
  }

  Future<BilateralLongTermSellInfoResponse> getBilateralLongTermSellInfo({
    required DateTime date,
    required String accessToken,
  }) async {
    Response response;

    var dateRequest = date.toUtc().toIso8601String();

    var url = Uri.parse(
      "$apiBaseUrlBilateralTrade/bilateral-app/offer-to-sell/longterm/listing/$dateRequest",
    );

    response = await httpGetJson(
      url: url,
      accessToken: accessToken,
    );

    final jsonMap = json.decode(response.body);

    return BilateralLongTermSellInfoResponse.fromJSON(jsonMap);
  }

  Future<Response> bilateralLongTermSell({
    required List<BilateralLongtermSellItem> submitItems,
    required String accessToken,
  }) async {
    List<Map<String, dynamic>> jsonMap = <Map<String, dynamic>>[];
    for (var bilateral in submitItems) {
      Map<String, dynamic> bilateralMap = bilateral.toJson();
      jsonMap.add(bilateralMap);
    }

    var requestJson = jsonEncode(jsonMap);

    Response response;

    var url = Uri.parse(
      "$apiBaseUrlBilateralTrade/bilateral-app/offer-to-sell/longterm",
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
        'BilateralApi.bilateralLongTermSell: Error response from server: ${response.statusCode}',
      );
      throw Exception('Failed to submit data code ${response.statusCode}');
    }

    return response;
  }

  Future<BilateralLongTermBuyInfoResponse> getBilateralLongTermBuyInfo({
    required String date,
    required int days,
    required String accessToken,
  }) async {
    Response response;

    var url = Uri.parse(
      "$apiBaseUrlBilateralTrade/bilateral-app/choose-to-buy/longterm/listing/$date",
    ).replace(queryParameters: {'days': days.toString()});

    response = await httpGetJson(
      url: url,
      accessToken: accessToken,
    );

    return BilateralLongTermBuyInfoResponse.fromJSON(response.body);
  }

  Future<Response> bilateralLongTermBuy({
    required String id,
    required String accessToken,
  }) async {
    var requestJson = {
      'id': id,
    };

    Response response;

    var url = Uri.parse(
      "$apiBaseUrlBilateralTrade/bilateral-app/choose-to-buy/longterm/$id",
    );
    response = await httpPostJson(
      uri: url,
      accessToken: accessToken,
      body: jsonEncode(requestJson),
    );

    return response;
  }
}

const bilateralApi = const BilateralApi();
