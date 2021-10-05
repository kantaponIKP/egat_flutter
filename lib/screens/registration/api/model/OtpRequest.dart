import 'dart:convert';

class OtpRequest {
  String sessionId;

  OtpRequest({
    required this.sessionId,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();

    jsonMap['sessionId'] = this.sessionId;

    return jsonEncode(jsonMap);
  }
}
