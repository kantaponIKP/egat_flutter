import 'dart:convert';

class BilateralLongTermSellInfoResponse {
  late List<dynamic> bilateralList;

  BilateralLongTermSellInfoResponse({
    required this.bilateralList,
  });

  BilateralLongTermSellInfoResponse.fromJSON(String jsonString) {
    List<dynamic> jsonMap = jsonDecode(jsonString);

    this.bilateralList = jsonMap;
  }
}
