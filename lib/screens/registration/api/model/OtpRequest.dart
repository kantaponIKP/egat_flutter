import 'dart:convert';

class OtpRequest {
  String sessionId;
  String sessionToken;

  OtpRequest({
    required this.sessionId,
    required this.sessionToken,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();

    jsonMap['sessionId'] = this.sessionId;
    jsonMap['sessionToken'] = this.sessionToken;

    return jsonEncode(jsonMap);
  }
}
