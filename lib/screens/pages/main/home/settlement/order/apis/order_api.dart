import 'dart:convert';

import 'package:egat_flutter/Utils/http/get.dart';
import 'package:egat_flutter/constant.dart';
import 'package:http/http.dart';

import '../../models/trade_info.dart';

class OrderApi {
  Future<List<TradeInfo>> fetchOrderInfos({
    required DateTime date,
    required String accessToken,
  }) async {
    Response response;

    var dateRequest = date.toUtc().toIso8601String();

    var url = Uri.parse(
      "$apiBaseUrlReport/report/order/$dateRequest",
    );

    response = await httpGetJson(
      url: url,
      accessToken: accessToken,
    ).timeout(Duration(seconds: 10));

    final jsonMap = json.decode(response.body);

    return [
      for (var item in jsonMap) TradeInfo.fromJson(item),
    ];

    // TODO: use real data
    await Future.delayed(Duration(seconds: 1));

    return <TradeInfo>[
      OpenOfferToSellTradeInfo(
        date: DateTime.now(),
        amount: 1,
        offerToSell: 1,
        tradingFee: 1,
        estimatedSales: 1,
      ),
      MatchedOfferToSellTradeInfo(
        date: DateTime.now(),
        contractId: "1234",
        targetName: ["Target1", "Target2"],
        amount: 1,
        offerToSell: 1,
        tradingFee: 1,
        estimatedSales: 1,
      ),
      MatchedChooseToBuyTradeInfo(
        date: DateTime.now(),
        contractId: "contractId",
        targetName: ["targetName"],
        amount: 1,
        netBuy: 1,
        netEnergyPrice: 1,
        energyToBuy: 1,
        energyTariff: 1,
        energyPrice: 1,
        wheelingChargeTariff: 1,
        wheelingCharge: 1,
        tradingFee: 1,
        vat: 1,
      ),
      MatchedOfferToSellBidTradeInfo(
        date: DateTime.now(),
        contractId: "contractId",
        targetName: ["targetName"],
        offeredAmount: 1,
        matchedAmount: 1,
        offerToSell: 1,
        marketClearingPrice: 1,
        tradingFee: 1,
        estimatedSales: 1,
      ),
      MatchedBidToBuyTradeInfo(
        date: DateTime.now(),
        contractId: "contractId",
        targetName: ["targetName"],
        biddedAmount: 1,
        matchedAmount: 1,
        bidToBuy: 1,
        marketClearingPrice: 1,
        estimatedBuy: 1,
        netEstimatedEnergyPrice: 1,
        energyToBuy: 1,
        energyTariff: 1,
        energyPrice: 1,
        wheelingChargeTariff: 1,
        wheelingCharge: 1,
        tradingFee: 1,
        vat: 1,
      ),
    ];
  }
}

final OrderApi orderApi = new OrderApi();
