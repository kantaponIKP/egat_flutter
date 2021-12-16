import 'dart:convert';

class BilateralLongTermBuyInfoResponse {
  late List<dynamic> bilateralList;

  BilateralLongTermBuyInfoResponse({
    required this.bilateralList,
  });

  BilateralLongTermBuyInfoResponse.fromJSON(String jsonString) {
    List<dynamic> jsonMap = jsonDecode(jsonString);

    this.bilateralList = jsonMap;
  }
}
