import 'dart:convert';

import 'package:egat_flutter/screens/page/state/bilateral/bilateral_long_term_sell.dart';

class BilateralLongTermSellRequest {
  List<BilateralLongtermSellItem> bilateralList;

  BilateralLongTermSellRequest({
    required this.bilateralList,
  });

  String toJSON() {
    List<Map<String, dynamic>> jsonMap = <Map<String, dynamic>>[];
    for (var bilateral in this.bilateralList) {
      Map<String, dynamic> bilateralMap = bilateral.toJson();
      jsonMap.add(bilateralMap);
    }

    return jsonEncode(jsonMap);
  }
}

class BilateralLongtermSellItem {
  final DateTime time;
  final int days;
  final double energy;
  final double price;

  BilateralLongtermSellItem({
    required this.time,
    required this.days,
    required this.energy,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'time': time.toUtc().toIso8601String(),
      'days': days,
      'energy': energy,
      'price': price,
    };
  }
}
