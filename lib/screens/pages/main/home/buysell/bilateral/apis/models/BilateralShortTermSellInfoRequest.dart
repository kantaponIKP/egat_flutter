import 'dart:convert';

class BilateralShortTermSellInfoRequest {
  String date;

  BilateralShortTermSellInfoRequest({
    required this.date,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    jsonMap['date'] = this.date;

    return jsonEncode(jsonMap);
  }
}
