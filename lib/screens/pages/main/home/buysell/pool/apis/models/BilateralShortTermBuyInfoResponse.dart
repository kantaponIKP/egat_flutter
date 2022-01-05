import 'dart:convert';

import 'BilateralBuyItem.dart';

class BilateralShortTermBuyInfoResponse {
  final List<BilateralBuyItem> bilateralList;

  BilateralShortTermBuyInfoResponse({
    required this.bilateralList,
  });

  factory BilateralShortTermBuyInfoResponse.fromJSON(List<dynamic> jsonMap) {
    final bilateralList = <BilateralBuyItem>[
      for (var item in jsonMap) BilateralBuyItem.fromJSON(item)
    ];

    return BilateralShortTermBuyInfoResponse(
      bilateralList: bilateralList,
    );
  }
}
