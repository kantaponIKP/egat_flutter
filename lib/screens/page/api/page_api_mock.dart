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
import 'package:flutter/services.dart';
import 'package:http/http.dart';

class PageApiMock {
  Future<PersonalInfoResponse> getPersonalInfo(AccessRequest request) async {
    return PersonalInfoResponse.fromJSON(
        await rootBundle.loadString('assets/mockdata/page/personal_info.json'));
  }

  Future<PersonalInfoResponse> changePersonalInfo(
      ChangePersonalInfoRequest request, AccessRequest accessToken) async {
    print(request.fullName);
    print(request.email);
    print(request.phoneNumber);
    return PersonalInfoResponse.fromJSON(await rootBundle
        .loadString('assets/mockdata/page/change_personal_info.json'));
  }

  Future<Response> changePhoto(
      ChangePhotoRequest request, AccessRequest accessToken) async {
    Response response = Response("", 200);
    return response;
  }

  Future<Response> removePhoto(AccessRequest request) async {
    Response response = Response("", 200);
    return response;
  }

  Future<Response> changePassword(
      ChangePasswordRequest request, AccessRequest accessToken) async {
    Response response = Response("", 200);
    return response;
  }

  Future<Response> buyLongTermBilateral(
      BilateralLongTermBuyRequest request, AccessRequest accessToken) async {
    Response response = Response("", 200);
    return response;
  }

  Future<Response> buyShortTermBilateral(
      BilateralShortTermBuyRequest request, AccessRequest accessToken) async {
    Response response = Response("", 200);
    return response;
  }

  Future<Response> sellLongTermBilateral(
      BilateralLongTermSellRequest request, AccessRequest accessToken) async {
    Response response = Response("", 200);
    return response;
  }

  Future<Response> sellShortTermBilateral(
      BilateralShortTermSellRequest request, AccessRequest accessToken) async {
    Response response = Response("", 200);
    return response;
  }

  Future<BilateralTradeResponse> getBilateralTrade(
      BilateralTradeRequest request, AccessRequest accessToken) async {
    // Response response = Response("", 200);

    return BilateralTradeResponse.fromJSON(await rootBundle
        .loadString('assets/mockdata/page/trade/bilateral_trade.json'));
  }

  Future<BilateralShortTermBuyInfoResponse> getBilateralShortTermBuyInfo(
      BilateralShortTermBuyInfoRequest request,
      AccessRequest accessToken) async {
    // Response response = Response("", 200);

    //TODO:
    return BilateralShortTermBuyInfoResponse.fromJSON(await rootBundle
        .loadString('assets/mockdata/page/trade/bilateral_buy.json'));
  }

  Future<BilateralShortTermSellInfoResponse> getBilateralShortTermSellInfo(
      BilateralShortTermSellInfoRequest request,
      AccessRequest accessToken) async {
    // Response response = Response("", 200);

    //TODO:
    return BilateralShortTermSellInfoResponse.fromJSON(await rootBundle
        .loadString('assets/mockdata/page/trade/bilateral_sell.json'));
  }

  Future<Response> bilateralShortTermSell(
      BilateralShortTermSellRequest request, AccessRequest access) async {
    //TODO:
    Response response = Response("", 200);
    return response;
  }

  Future<Response> bilateralShortTermBuy(
      BilateralShortTermBuyRequest request, AccessRequest access) async {
    //TODO:
    Response response = Response("", 200);
    return response;
  }

  Future<Response> bilateralLongTermSell(
      BilateralLongTermSellRequest request, AccessRequest access) async {
    //TODO:
    Response response = Response("", 200);
    return response;
  }

  Future<BilateralLongTermSellInfoResponse> getBilateralLongTermSellInfo(
      BilateralLongTermSellInfoRequest request, AccessRequest access) async {
    //TODO:
    return BilateralLongTermSellInfoResponse.fromJSON(await rootBundle
        .loadString('assets/mockdata/page/trade/bilateral_longterm_sell.json'));
  }

  Future<BilateralLongTermBuyInfoResponse> getBilateralLongTermBuyInfo(
      BilateralLongTermBuyInfoRequest request, AccessRequest access) async {
    //TODO:
    return BilateralLongTermBuyInfoResponse.fromJSON(await rootBundle
        .loadString('assets/mockdata/page/trade/bilateral_longterm_buy.json'));
  }

  Future<Response> bilateralLongTermBuy(
      BilateralLongTermBuyRequest request, AccessRequest access) async {
    //TODO:
    Response response = Response("", 200);
    return response;
  }

  Future<BilateralTradingFeeResponse> getBilateralTradingFee(
    BilateralTradingFeeRequest request,
    AccessRequest access,
  ) async {
    return BilateralTradingFeeResponse.fromJSON(await rootBundle
        .loadString('assets/mockdata/page/trade/bilateral_trading_fee.json'));
  }

  Future<PoolMarketTradeResponse> getPoolMarketTrade(
      PoolMarketTradeRequest request, AccessRequest access) async {
    return PoolMarketTradeResponse.fromJSON(await rootBundle
        .loadString('assets/mockdata/page/trade/pool_market_trade.json'));
  }

  Future<Response> getPoolMarketShortTermBuyInfo(
      PoolMarketShortTermBuyInfoRequest request, AccessRequest access) async {
    String responseBody = await rootBundle.loadString(
        'assets/mockdata/page/trade/pool_market_shortterm_buy.json');
    Response response = Response(responseBody, 200);
    return response;
  }

  Future<Response> poolMarketShortTermBuy(
    PoolMarketShortTermBuyRequest request,
    AccessRequest access,
  ) async {
    Response response = Response("", 200);
    return response;
  }

  Future<PoolMarketTradingFeeResponse> getPoolMarketTradingFee(
    PoolMarketTradingFeeRequest request,
    AccessRequest access,
  ) async {
    return PoolMarketTradingFeeResponse.fromJSON(await rootBundle
        .loadString('assets/mockdata/page/trade/pool_market_trading_fee.json'));
  }

  Future<PoolMarketShortTermBuyInfoResponse> getPoolMarketShortTermSellInfo(
      PoolMarketShortTermBuyInfoRequest request, AccessRequest access) async {
    return PoolMarketShortTermBuyInfoResponse.fromJSON(
        await rootBundle.loadString(
            'assets/mockdata/page/trade/pool_market_shortterm_sell.json'));
  }

  Future<Response> poolMarketShortTermSell(
    PoolMarketShortTermSellRequest request,
    AccessRequest access,
  ) async {
    Response response = Response("", 200);
    return response;
  }

  Future<PoolMarketReferencesResponse> getPoolMarketReferences(
    PoolMarketReferencesRequest request,
    AccessRequest access,
  ) async {
    return PoolMarketReferencesResponse.fromJSON(await rootBundle
        .loadString('assets/mockdata/page/trade/pool_market_references.json'));
  }
}
