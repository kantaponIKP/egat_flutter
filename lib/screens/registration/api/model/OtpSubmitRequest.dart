import 'dart:convert';

class OtpSubmitRequest {
  String sessionId;
  String otp;
  String reference;
  String sessionToken;

  OtpSubmitRequest({
    required this.sessionId,
    required this.otp,
    required this.reference,
    required this.sessionToken,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();

    jsonMap['sessionId'] = this.sessionId;
    jsonMap['otp'] = this.otp;
    jsonMap['reference'] = this.reference;
    jsonMap['sessionToken'] = this.sessionToken;

    return jsonEncode(jsonMap);
  }
}
