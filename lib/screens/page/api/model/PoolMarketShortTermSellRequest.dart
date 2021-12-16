import 'dart:convert';
import 'package:egat_flutter/screens/page/state/pool_market/pool_market_short_term_sell.dart';

class PoolMarketShortTermSellRequest {
  List<PoolMarketShortTermSellTile> poolMarketList;

  PoolMarketShortTermSellRequest({
    required this.poolMarketList,
  });

  String toJSON() {
    List<Map<String, dynamic>> jsonMap = <Map<String, dynamic>>[];
    for(var poolMarket in this.poolMarketList){
      Map<String, dynamic> poolMarketMap = Map<String, dynamic>();
      poolMarketMap['date'] = poolMarket.date;
      poolMarketMap['energy'] = poolMarket.energyToSale;
      poolMarketMap['price'] = poolMarket.offerToSellPrice;
      jsonMap.add(poolMarketMap);
    }

    return jsonEncode(jsonMap);
  }
}
