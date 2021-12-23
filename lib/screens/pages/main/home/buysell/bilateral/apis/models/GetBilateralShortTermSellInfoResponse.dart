import 'dart:convert';

import 'BilateralSellItem.dart';

class BilateralShortTermSellInfoResponse {
  late List<BilateralSellItem> bilateralList;

  BilateralShortTermSellInfoResponse({
    required this.bilateralList,
  });

  BilateralShortTermSellInfoResponse.fromJSON(
    List<dynamic> jsonMap,
  ) {
    this.bilateralList =
        jsonMap.map((item) => BilateralSellItem.fromJSON(item)).toList();
  }
}
