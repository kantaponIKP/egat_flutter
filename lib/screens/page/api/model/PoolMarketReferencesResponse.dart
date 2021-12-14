import 'dart:convert';

class PoolMarketReferencesResponse {
  double? tradingFee;
  double? wheelingChargeTariff;

  PoolMarketReferencesResponse({
    required this.tradingFee,
    required this.wheelingChargeTariff,
  });

  PoolMarketReferencesResponse.fromJSON(String jsonString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    this.tradingFee = jsonMap['tradingFee'];
    this.wheelingChargeTariff = jsonMap['wheelingChargeTariff'];
  }
}
