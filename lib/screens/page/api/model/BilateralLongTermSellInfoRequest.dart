import 'dart:convert';

class BilateralLongTermSellInfoRequest {
  String date;

  BilateralLongTermSellInfoRequest({
    required this.date,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    jsonMap['date'] = this.date;

    return jsonEncode(jsonMap);
  }
}
