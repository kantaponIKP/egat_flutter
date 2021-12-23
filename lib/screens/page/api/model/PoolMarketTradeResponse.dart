import 'dart:convert';

class PoolMarketTradeResponse {
  late List<dynamic> pookMarketList;

  PoolMarketTradeResponse({
    required this.pookMarketList,
  });

  PoolMarketTradeResponse.fromJSON(String jsonString) {
    List<dynamic> jsonMap = jsonDecode(jsonString);

    this.pookMarketList = jsonMap;
  }
}
