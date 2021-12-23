import 'dart:convert';

class PoolMarketReferencesRequest {
  String date;

  PoolMarketReferencesRequest({
    required this.date,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    jsonMap['date'] = this.date;

    return jsonEncode(this.date);
  }
}
