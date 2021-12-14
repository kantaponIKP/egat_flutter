import 'dart:convert';

class PoolMarketShortTermBuyRequest {
  String date;
  double energy;
  double price;

  PoolMarketShortTermBuyRequest({
    required this.date,
    required this.energy,
    required this.price,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    jsonMap['date'] = this.date;
    jsonMap['energy'] = this.energy;
    jsonMap['price'] = this.price;

    return jsonEncode(jsonMap);
  }
}
