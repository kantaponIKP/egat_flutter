import 'dart:convert';

import 'package:egat_flutter/Utils/http/get.dart';
import 'package:egat_flutter/constant.dart';
import 'package:http/http.dart';
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
}

const bilateralApi = const BilateralApi();
