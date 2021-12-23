import 'dart:convert';

import 'package:egat_flutter/screens/page/state/bilateral/bilateral_long_term_sell.dart';

class BilateralLongTermSellRequest {
  List<BilateralLongtermSellTile> bilateralList;

  BilateralLongTermSellRequest({
    required this.bilateralList,
  });

  String toJSON() {
    List<Map<String, dynamic>> jsonMap = <Map<String, dynamic>>[];
    for(var bilateral in this.bilateralList){
      Map<String, dynamic> bilateralMap = Map<String, dynamic>();
      bilateralMap['time'] = bilateral.time;
      bilateralMap['days'] = bilateral.days;
      bilateralMap['energy'] = bilateral.energy;
      bilateralMap['price'] = bilateral.price;
      jsonMap.add(bilateralMap);
    }

    return jsonEncode(jsonMap);
  }
}
