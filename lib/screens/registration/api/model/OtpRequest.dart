import 'dart:convert';

class OtpRequest {
  String registrationId;
  String registrationToken;

  OtpRequest({
    required this.registrationId,
    required this.registrationToken,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();

    jsonMap['registrationId'] = this.registrationId;
    jsonMap['registrationToken'] = this.registrationToken;

    return jsonEncode(jsonMap);
  }
}
