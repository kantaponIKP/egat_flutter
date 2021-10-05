import 'dart:convert';

class OtpSubmitRequest {
  String sessionId;
  String otp;
  String reference;

  OtpSubmitRequest({
    required this.sessionId,
    required this.otp,
    required this.reference,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();

    jsonMap['sessionId'] = this.sessionId;
    jsonMap['otp'] = this.otp;
    jsonMap['reference'] = this.reference;

    return jsonEncode(jsonMap);
  }
}
