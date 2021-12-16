import 'dart:convert';

class BilateralShortTermBuyResponse {
  late List<dynamic> bilateralList;

  BilateralShortTermBuyResponse({
    required this.bilateralList,
  });

  BilateralShortTermBuyResponse.fromJSON(String jsonString) {
    List<dynamic> jsonMap = jsonDecode(jsonString);

    this.bilateralList = jsonMap;
  }
}
