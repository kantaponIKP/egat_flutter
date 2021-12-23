import 'dart:convert';

class BilateralShortTermBuyInfoRequest {
  String date;

  BilateralShortTermBuyInfoRequest({
    required this.date,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    jsonMap['date'] = this.date;

    return jsonEncode(jsonMap);
  }
}
