import 'dart:convert';

class LocationRequest {
  String meterId;
  String sessionId;
  String sessionToken;

  LocationRequest({
    required this.meterId,
    required this.sessionId,
    required this.sessionToken,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();

    jsonMap['meterId'] = this.meterId;
    jsonMap['sessionId'] = this.sessionId;
    jsonMap['sessionToken'] = this.sessionToken;

    return jsonEncode(jsonMap);
  }
}
