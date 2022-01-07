import 'dart:convert';

import 'package:egat_flutter/screens/page/state/bilateral/bilateral_long_term_sell.dart';

class BilateralLongTermBuyInfoRequest {
  String date;
  int days;

  BilateralLongTermBuyInfoRequest({
    required this.date,
    required this.days
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    jsonMap['date'] = this.date;
    jsonMap['days'] = this.days;

    return jsonEncode(jsonMap);
  }
}
