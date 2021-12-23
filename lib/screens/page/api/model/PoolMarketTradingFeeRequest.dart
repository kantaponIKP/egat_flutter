import 'dart:convert';

class PoolMarketTradingFeeRequest {
  List<String> dateList;

  PoolMarketTradingFeeRequest({
    required this.dateList,
  });

  String toJSON() {
    return jsonEncode(this.dateList);
  }
}
