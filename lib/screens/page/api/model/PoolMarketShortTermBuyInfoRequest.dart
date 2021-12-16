import 'dart:convert';

class PoolMarketShortTermBuyInfoRequest {
  String date;

  PoolMarketShortTermBuyInfoRequest({
    required this.date,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    jsonMap['date'] = this.date;

    return jsonEncode(jsonMap);
  }
}
