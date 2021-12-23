import 'dart:convert';

class BilateralTradeRequest {
  String date;

  BilateralTradeRequest({
    required this.date,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    jsonMap['accessToken'] = this.date;

    return jsonEncode(jsonMap);
  }
}
