import 'dart:convert';

import 'package:egat_flutter/screens/page/state/bilateral/bilateral_buy.dart';

class BilateralShortTermBuyInfoResponse {
  final List<BilateralBuyTile> bilateralList;

  BilateralShortTermBuyInfoResponse({
    required this.bilateralList,
  });

  factory BilateralShortTermBuyInfoResponse.fromJSON(String jsonString) {
    List<dynamic> jsonMap = jsonDecode(jsonString);

    final bilateralList = <BilateralBuyTile>[
      for (var item in jsonMap) BilateralBuyTile.fromJSONMap(item)
    ];

    return BilateralShortTermBuyInfoResponse(
      bilateralList: bilateralList,
    );
  }
}
