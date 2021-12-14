import 'dart:convert';

class PoolMarketShortTermSellInfoRequest {
  String date;

  PoolMarketShortTermSellInfoRequest({
    required this.date,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    jsonMap['date'] = this.date;

    return jsonEncode(jsonMap);
  }
}
