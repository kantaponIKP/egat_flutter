import 'dart:convert';

import 'package:egat_flutter/screens/page/state/bilateral/bilateral_short_term_sell.dart';

class BilateralShortTermSellRequest {
  List<BilateralOfferToSellTile> bilateralList;

  BilateralShortTermSellRequest({
    required this.bilateralList,
  });

  String toJSON() {
    List<Map<String, dynamic>> jsonMap = <Map<String, dynamic>>[];
    for(var bilateral in this.bilateralList){
      Map<String, dynamic> bilateralMap = Map<String, dynamic>();
      bilateralMap['date'] = bilateral.date;
      bilateralMap['energy'] = bilateral.energyToSale;
      bilateralMap['price'] = bilateral.offerToSellPrice;
      jsonMap.add(bilateralMap);
    }

    return jsonEncode(jsonMap);
  }
}
