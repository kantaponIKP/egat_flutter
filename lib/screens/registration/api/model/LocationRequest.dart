import 'dart:convert';

class LocationRequest {
  String meterId;
  String sessionId;

  LocationRequest({
    required this.meterId,
    required this.sessionId,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();

    jsonMap['meterId'] = this.meterId;
    jsonMap['sessionId'] = this.sessionId;

    return jsonEncode(jsonMap);
  }
}
