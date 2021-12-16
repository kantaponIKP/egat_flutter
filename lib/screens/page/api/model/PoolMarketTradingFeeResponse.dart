import 'dart:convert';

class PoolMarketTradingFeeResponse {
  List<dynamic>? tradingFee;

  PoolMarketTradingFeeResponse({
    required this.tradingFee,
  });

  PoolMarketTradingFeeResponse.fromJSON(String jsonString) {
    List<dynamic> jsonMap = jsonDecode(jsonString);

    this.tradingFee = jsonMap;
  }
}
