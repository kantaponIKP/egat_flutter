import 'dart:convert';

class BilateralShortTermBuyRequest {
  String id;

  BilateralShortTermBuyRequest({
    required this.id,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    jsonMap['id'] = this.id;

    return jsonEncode(jsonMap);
  }
}
