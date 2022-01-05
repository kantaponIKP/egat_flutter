import 'dart:async';
import 'dart:convert';

import 'package:egat_flutter/Utils/http/delete.dart';
import 'package:egat_flutter/Utils/http/get.dart';
import 'package:egat_flutter/Utils/http/put.dart';
import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/errors/IntlException.dart';
import 'package:egat_flutter/screens/page/api/model/AccessRequest.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralLongTermBuyInfoRequest.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralLongTermBuyInfoResponse.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralLongTermBuyRequest.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralLongTermSellInfoRequest.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralLongTermSellInfoResponse.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralLongTermSellRequest.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralShortTermBuyInfoRequest.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralShortTermBuyInfoResponse.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralShortTermBuyRequest.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralShortTermSellInfoRequest.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralShortTermSellInfoResponse.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralShortTermSellRequest.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralShortTermSellResponse.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralTradeRequest.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralTradeResponse.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralTradingFeeRequest.dart';
import 'package:egat_flutter/screens/page/api/model/BilateralTradingFeeResponse.dart';
import 'package:egat_flutter/screens/page/api/model/ChangePasswordRequest.dart';
import 'package:egat_flutter/screens/page/api/model/ChangePersonalInfoRequest.dart';
import 'package:egat_flutter/screens/page/api/model/ChangePhotoRequest.dart';
import 'package:egat_flutter/screens/page/api/model/PersonalInfoResponse.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketReferencesRequest.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketReferencesResponse.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketShortTermBuyInfoRequest.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketShortTermBuyInfoResponse.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketShortTermBuyRequest.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketShortTermSellRequest.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketTradeRequest.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketTradeResponse.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketTradingFeeRequest.dart';
import 'package:egat_flutter/screens/page/api/model/PoolMarketTradingFeeResponse.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class PageApi {
  Future<PersonalInfoResponse> getPersonalInfo(AccessRequest request) async {
    var url = Uri.parse(
      "$apiBaseUrlProfileManage/users/me",
    );

    final httpRequest = httpGetJson(url: url, accessToken: request.accessToken);

    Response response;
    try {
      response = await httpRequest.timeout(Duration(seconds: 60));
    } on TimeoutException catch (_) {
      throw IntlException(
        message: "Time out",
        intlMessage: "error-timeoutError",
      );
    }

    if (response.statusCode >= 500) {
      throw IntlException(
        message: "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}",
        intlMessage: "error-connectionError",
      );
    }
    if (response.statusCode >= 300) {
      throw IntlException(
        message: "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}",
        intlMessage: "error-incorrectInformationError",
      );
    }

    return PersonalInfoResponse.fromJSON(response.body);
  }

  Future<Response> changePersonalInfo(
      ChangePersonalInfoRequest request, AccessRequest access) async {
    var url = Uri.parse(
      "$apiBaseUrlProfileManage/users/${access.userId}",
    );

    var requestJson = request.toJSON();

    final httpRequest = httpPutJson(
        uri: url, body: requestJson, accessToken: access.accessToken);

    Response response;
    try {
      response = await httpRequest.timeout(Duration(seconds: 60));
    } on TimeoutException catch (_) {
      throw IntlException(
        message: "Time out",
        intlMessage: "error-timeoutError",
      );
    }

    if (response.statusCode >= 500) {
      throw IntlException(
        message: "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}",
        intlMessage: "error-connectionError",
      );
    }
    if (response.statusCode >= 300) {
      throw IntlException(
        message: "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}",
        intlMessage: "error-incorrectInformationError",
      );
    }

    return response;
  }

  Future<Response> changePhoto(
      ChangePhotoRequest request, AccessRequest access) async {
    print("request");
    print(request.photo);
    var url = Uri.parse(
      "$apiBaseUrlProfileManage/users/${access.userId}/photo",
    );

    var requestJson = request.toJSON();

    final httpRequest = httpPutJson(
        uri: url, body: requestJson, accessToken: access.accessToken);

    Response response;
    try {
      response = await httpRequest.timeout(Duration(seconds: 60));
    } on TimeoutException catch (_) {
      throw IntlException(
        message: "Time out",
        intlMessage: "error-timeoutError",
      );
    }

    if (response.statusCode >= 500) {
      throw IntlException(
        message: "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}",
        intlMessage: "error-connectionError",
      );
    }
    if (response.statusCode >= 300) {
      throw IntlException(
        message: "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}",
        intlMessage: "error-incorrectInformationError",
      );
    }

    return response;
  }

  Future<Response> removePhoto(AccessRequest access) async {
    var url = Uri.parse(
      "$apiBaseUrlProfileManage/users/${access.userId}/photo", //TODO
    );

    final httpRequest =
        httpDeleteJson(url: url, accessToken: access.accessToken);

    Response response;
    try {
      response = await httpRequest.timeout(Duration(seconds: 60));
    } on TimeoutException catch (_) {
      throw IntlException(
        message: "Time out",
        intlMessage: "error-timeoutError",
      );
    }

    if (response.statusCode >= 500) {
      throw IntlException(
        message: "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}",
        intlMessage: "error-connectionError",
      );
    }
    if (response.statusCode >= 300) {
      throw IntlException(
        message: "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}",
        intlMessage: "error-incorrectInformationError",
      );
    }

    return response;
  }

  Future<Response> changePassword(
      ChangePasswordRequest request, AccessRequest access) async {
    var url = Uri.parse(
      "$apiBaseUrlProfileManage/${access.userId}/users/change-password",
    );

    var requestJson = request.toJSON();

    final httpRequest = httpPutJson(
        uri: url, body: requestJson, accessToken: access.accessToken);

    Response response;
    try {
      response = await httpRequest.timeout(Duration(seconds: 60));
    } on TimeoutException catch (_) {
      throw IntlException(
        message: "Time out",
        intlMessage: "error-timeoutError",
      );
    }

    if (response.statusCode >= 500) {
      throw IntlException(
        message: "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}",
        intlMessage: "error-connectionError",
      );
    }
    if (response.statusCode >= 300) {
      throw IntlException(
        message: "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}",
        intlMessage: "error-incorrectInformationError",
      );
    }

    return response;
  }

  Future<BilateralTradeResponse> getBilateralTrade(
      BilateralTradeRequest request, AccessRequest access) async {
    Response response;
    var url = Uri.parse(
      "$apiBaseUrlBilateralTrade/bilateral-app/list-home/${request.date}",
    );
    response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${access.accessToken}'
      },
    );
    return BilateralTradeResponse.fromJSON(response.body);
  }

  Future<BilateralShortTermBuyInfoResponse> getBilateralShortTermBuyInfo(
      BilateralShortTermBuyInfoRequest request, AccessRequest access) async {
    Response response;

    var url = Uri.parse(
      "$apiBaseUrlBilateralTrade/bilateral-app/choose-to-buy/listing/${request.date}",
    );
    response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${access.accessToken}'
      },
    );
    return BilateralShortTermBuyInfoResponse.fromJSON(response.body);
  }

  Future<BilateralShortTermSellInfoResponse> getBilateralShortTermSellInfo(
    BilateralShortTermSellInfoRequest request,
    AccessRequest access,
  ) async {
    Response response;

    var url = Uri.parse(
      "$apiBaseUrlBilateralTrade/bilateral-app/offer-to-sell/listing/${request.date}",
    );
    response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${access.accessToken}'
      },
    );
    return BilateralShortTermSellInfoResponse.fromJSON(response.body);
  }

  Future<Response> bilateralShortTermSell(
    BilateralShortTermSellRequest request,
    AccessRequest access,
  ) async {
    var requestJson = request.toJSON();

    Response response;

    var url = Uri.parse(
      "$apiBaseUrlBilateralTrade/bilateral-app/offer-to-sell",
    );
    response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${access.accessToken}'
      },
      body: requestJson,
    );

    return response;
  }

  Future<Response> bilateralShortTermBuy(
    BilateralShortTermBuyRequest request,
    AccessRequest access,
  ) async {
    Response response;

    var url = Uri.parse(
      "$apiBaseUrlBilateralTrade/bilateral-app/choose-to-buy/${request.id}",
    );
    response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${access.accessToken}'
      },
    );

    return response;
  }

  Future<BilateralLongTermSellInfoResponse> getBilateralLongTermSellInfo(
    BilateralLongTermSellInfoRequest request,
    AccessRequest access,
  ) async {
    Response response;

    var url = Uri.parse(
      "$apiBaseUrlBilateralTrade/bilateral-app/offer-to-sell/longterm/listing/${request.date}",
    );
    response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${access.accessToken}'
      },
    );
    return BilateralLongTermSellInfoResponse.fromJSON(response.body);
  }

  Future<Response> bilateralLongTermSell(
    BilateralLongTermSellRequest request,
    AccessRequest access,
  ) async {
    var requestJson = request.toJSON();

    Response response;

    var url = Uri.parse(
      "$apiBaseUrlBilateralTrade/bilateral-app/offer-to-sell/longterm",
    );
    response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${access.accessToken}'
      },
      body: requestJson,
    );

    return response;
  }

  Future<BilateralLongTermBuyInfoResponse> getBilateralLongTermBuyInfo(
    BilateralLongTermBuyInfoRequest request,
    AccessRequest access,
  ) async {
    Response response;

    var url = Uri.parse(
      "$apiBaseUrlBilateralTrade/bilateral-app/choose-to-buy/longterm/listing/${request.date}",
    ).replace(queryParameters: {'days': request.days.toString()});
    response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${access.accessToken}'
      },
    );

    return BilateralLongTermBuyInfoResponse.fromJSON(response.body);
  }

  Future<Response> bilateralLongTermBuy(
    BilateralLongTermBuyRequest request,
    AccessRequest access,
  ) async {
    var requestJson = request.toJSON();

    Response response;

    var url = Uri.parse(
      "$apiBaseUrlBilateralTrade/bilateral-app/choose-to-buy/longterm/${request.id}",
    );
    response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${access.accessToken}'
      },
      body: requestJson,
    );

    return response;
  }

  Future<BilateralTradingFeeResponse> getBilateralTradingFee(
    BilateralTradingFeeRequest request,
    AccessRequest access,
  ) async {
    var requestJson = request.toJSON();

    Response response;

    var url = Uri.parse(
      "$apiBaseUrlBilateralTrade/bilateral-app/offer-to-sell/references",
    );
    response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${access.accessToken}'
      },
      body: requestJson,
    );

    return BilateralTradingFeeResponse.fromJSON(response.body);
  }

  Future<PoolMarketTradeResponse> getPoolMarketTrade(
      PoolMarketTradeRequest request, AccessRequest access) async {
    Response response;
    var url = Uri.parse(
      "$apiBaseUrlPoolMarketTrade/pool-app/list-home/${request.date}",
    );

    response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${access.accessToken}'
      },
    );
    return PoolMarketTradeResponse.fromJSON(response.body);
  }

  Future<Response> getPoolMarketShortTermBuyInfo(
      PoolMarketShortTermBuyInfoRequest request, AccessRequest access) async {
    var url = Uri.parse(
      "$apiBaseUrlPoolMarketTrade/pool-app/bid-to-buy/${request.date}",
    );

    Response response;
    response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${access.accessToken}'
      },
    );

    return response;
  }

  Future<Response> poolMarketShortTermBuy(
    PoolMarketShortTermBuyRequest request,
    AccessRequest access,
  ) async {
    var requestJson = request.toJSON();

    Response response;

    var url = Uri.parse(
      "$apiBaseUrlPoolMarketTrade/pool-app/bid-to-buy/${request.date}",
    );
    response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${access.accessToken}'
      },
      body: requestJson,
    );

    return response;
  }

  Future<PoolMarketTradingFeeResponse> getPoolMarketTradingFee(
    PoolMarketTradingFeeRequest request,
    AccessRequest access,
  ) async {
    var requestJson = request.toJSON();

    Response response;

    var url = Uri.parse(
      "$apiBaseUrlPoolMarketTrade/pool-app/offer-to-sell/references",
    );
    response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${access.accessToken}'
      },
      body: requestJson,
    );

    return PoolMarketTradingFeeResponse.fromJSON(response.body);
  }

  Future<PoolMarketShortTermBuyInfoResponse> getPoolMarketShortTermSellInfo(
      PoolMarketShortTermBuyInfoRequest request, AccessRequest access) async {
    var url = Uri.parse(
      "$apiBaseUrlPoolMarketTrade/pool-app/offer-to-sell/${request.date}",
    );

    Response response;
    response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${access.accessToken}'
      },
    );

    return PoolMarketShortTermBuyInfoResponse.fromJSON(response.body);
  }

  Future<Response> poolMarketShortTermSell(
    PoolMarketShortTermSellRequest request,
    AccessRequest access,
  ) async {
    var requestJson = request.toJSON();

    Response response;

    var url = Uri.parse(
      "$apiBaseUrlPoolMarketTrade/pool-app/offer-to-sell",
    );
    response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${access.accessToken}'
      },
      body: requestJson,
    );

    return response;
  }

  Future<PoolMarketReferencesResponse> getPoolMarketReferences(
    PoolMarketReferencesRequest request,
    AccessRequest access,
  ) async {
    var requestJson = request.toJSON();

    Response response;

    var url = Uri.parse(
      "$apiBaseUrlPoolMarketTrade/pool-app/bid-to-buy/references/${request.date}",
    );
    response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${access.accessToken}'
      },
      body: requestJson,
    );

    return PoolMarketReferencesResponse.fromJSON(response.body);
  }
}
