import 'dart:convert';

class BilateralShortTermSellResponse {
  late List<dynamic> bilateralList;

  BilateralShortTermSellResponse({
    required this.bilateralList,
  });

  BilateralShortTermSellResponse.fromJSON(String jsonString) {
    List<dynamic> jsonMap = jsonDecode(jsonString);

    this.bilateralList = jsonMap;
  }
}
