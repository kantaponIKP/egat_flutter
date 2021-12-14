import 'dart:convert';

class PoolMarketTradeRequest {
  String date;

  PoolMarketTradeRequest({
    required this.date,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    jsonMap['accessToken'] = this.date;

    return jsonEncode(jsonMap);
  }
}
