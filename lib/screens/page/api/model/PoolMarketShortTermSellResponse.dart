import 'dart:convert';

class PoolMarketShortTermSellResponse {
  late List<dynamic> poolMarketList;

  PoolMarketShortTermSellResponse({
    required this.poolMarketList,
  });

  PoolMarketShortTermSellResponse.fromJSON(String jsonString) {
    List<dynamic> jsonMap = jsonDecode(jsonString);

    this.poolMarketList = jsonMap;
  }
}
