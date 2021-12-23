import 'dart:convert';

class BilateralTradingFeeResponse {
  List<BilateralTradingFeeItem> tradingFees;

  BilateralTradingFeeResponse({
    required this.tradingFees,
  });

  factory BilateralTradingFeeResponse.fromJSON(String jsonString) {
    List<dynamic> jsonMap = jsonDecode(jsonString);

    assert(jsonMap is List);

    List<BilateralTradingFeeItem> tradingFees = [];
    for (dynamic json in jsonMap) {
      assert(json is Map);
      tradingFees.add(BilateralTradingFeeItem.fromJSON(json));
    }

    return BilateralTradingFeeResponse(
      tradingFees: tradingFees,
    );
  }
}

class BilateralTradingFeeItem {
  final DateTime settlementTime;
  final double tradingFee;

  BilateralTradingFeeItem({
    required this.settlementTime,
    required this.tradingFee,
  });

  factory BilateralTradingFeeItem.fromJSON(Map<String, dynamic> jsonMap) {
    assert(jsonMap['settlementTime'] is String);
    assert(jsonMap['tradingFee'] is num);

    return BilateralTradingFeeItem(
      settlementTime: DateTime.parse(jsonMap['settlementTime']).toLocal(),
      tradingFee: (jsonMap['tradingFee'] as num).toDouble(),
    );
  }
}
