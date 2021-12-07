import 'dart:convert';

class BilateralShortTermBuyInfoResponse {
  late List<dynamic> bilateralList;

  BilateralShortTermBuyInfoResponse({
    required this.bilateralList,
  });

  BilateralShortTermBuyInfoResponse.fromJSON(String jsonString) {
    List<dynamic> jsonMap = jsonDecode(jsonString);

    this.bilateralList = jsonMap;
  }
}
