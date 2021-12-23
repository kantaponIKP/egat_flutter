import 'dart:convert';

class BilateralShortTermSellInfoResponse {
  late List<dynamic> bilateralList;

  BilateralShortTermSellInfoResponse({
    required this.bilateralList,
  });

  BilateralShortTermSellInfoResponse.fromJSON(String jsonString) {
    List<dynamic> jsonMap = jsonDecode(jsonString);

    this.bilateralList = jsonMap;
  }
}
