import 'dart:convert';

class BilateralTradeResponse {
  late List<dynamic> bilateralList;

  BilateralTradeResponse({
    required this.bilateralList,
  });

  BilateralTradeResponse.fromJSON(String jsonString) {
    List<dynamic> jsonMap = jsonDecode(jsonString);

    this.bilateralList = jsonMap;
  }
}
