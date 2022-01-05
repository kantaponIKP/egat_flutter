import 'dart:convert';

class BilateralTradingFeeRequest {
  List<DateTime> dateList;

  BilateralTradingFeeRequest({
    required this.dateList,
  });

  String toJSON() {
    var dateList =
        this.dateList.map((e) => e.toUtc().toIso8601String()).toList();

    return jsonEncode(dateList);
  }
}
