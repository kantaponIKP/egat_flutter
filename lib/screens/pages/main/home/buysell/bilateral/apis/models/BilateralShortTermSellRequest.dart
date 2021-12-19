import 'dart:convert';

import 'package:egat_flutter/screens/page/state/bilateral/bilateral_short_term_sell.dart';

import 'TransactionSubmitItem.dart';

class BilateralShortTermSellRequest {
  List<TransactionSubmitItem> submitItems;

  BilateralShortTermSellRequest({
    required this.submitItems,
  });

  String toJSON() {
    List<Map<String, dynamic>> jsonMap = <Map<String, dynamic>>[];
    for (var bilateral in this.submitItems) {
      Map<String, dynamic> bilateralMap = Map<String, dynamic>();
      bilateralMap['date'] = bilateral.date.toUtc().toIso8601String();
      bilateralMap['energy'] = bilateral.amount;
      bilateralMap['price'] = bilateral.price;
      jsonMap.add(bilateralMap);
    }

    return jsonEncode(jsonMap);
  }
}
