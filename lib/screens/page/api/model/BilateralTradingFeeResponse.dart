import 'dart:convert';

class BilateralTradingFeeResponse {
  List<dynamic>? tradingFee;

  BilateralTradingFeeResponse({
    required this.tradingFee,
  });

  BilateralTradingFeeResponse.fromJSON(String jsonString) {
    List<dynamic> jsonMap = jsonDecode(jsonString);

    this.tradingFee = jsonMap;
  }
}
