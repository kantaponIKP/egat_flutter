import 'dart:convert';

class BilateralLongTermBuyRequest {
  String id;

  BilateralLongTermBuyRequest({
    required this.id,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    jsonMap['id'] = this.id;;

    return jsonEncode(jsonMap);
  }
}
