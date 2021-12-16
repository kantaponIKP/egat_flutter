import 'dart:convert';

class PoolMarketShortTermBuyInfoResponse {
  String? id;
  String? time;
  double? energyToBuy;
  double? energyTariff;
  double? energyPrice;
  double? wheelingChargeTariff;
  double? wheelingCharge;
  double? tradingFee;
  double? vat;

  PoolMarketShortTermBuyInfoResponse({
    required this.id,
    required this.time,
    required this.energyToBuy,
    required this.energyTariff,
    required this.energyPrice,
    required this.wheelingChargeTariff,
    required this.wheelingCharge,
    required this.tradingFee,
    required this.vat,
  });

  PoolMarketShortTermBuyInfoResponse.fromJSON(String jsonString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    this.id = jsonMap['id'];
    this.time = jsonMap['time'];
    this.energyToBuy = jsonMap['energyToBuy'];
    this.energyTariff = jsonMap['energyTariff'];
    this.energyPrice = jsonMap['energyPrice'];
    this.wheelingChargeTariff = jsonMap['wheelingChargeTariff'];
    this.wheelingCharge = jsonMap['wheelingCharge'];
    this.tradingFee = jsonMap['tradingFee'];
    this.vat = jsonMap['vat'];
  }
}
