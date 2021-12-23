import 'dart:convert';

class BilateralTradingFeeRequest {
  List<String> dateList;

  BilateralTradingFeeRequest({
    required this.dateList,
  });

  String toJSON() {
    return jsonEncode(this.dateList);
  }
}
