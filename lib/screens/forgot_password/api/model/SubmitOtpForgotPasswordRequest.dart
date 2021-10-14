import 'dart:convert';

class SubmitOtpForgotPasswordRequest {
  String reference;
  String sessionId;
  String sessionToken;
  String otp;

  SubmitOtpForgotPasswordRequest({
    required this.reference,
    required this.sessionId,
    required this.sessionToken,
    required this.otp,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    jsonMap['reference'] = this.reference;
    jsonMap['sessionId'] = this.sessionId;
    jsonMap['sessionToken'] = this.sessionToken;
    jsonMap['otp'] = this.otp;

    return jsonEncode(jsonMap);
  }
}
