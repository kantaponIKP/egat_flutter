import 'dart:convert';

class OtpSubmitRequest {
  String registrationId;
  String registrationToken;
  String otp;
  String otpReference;

  OtpSubmitRequest({
    required this.registrationId,
    required this.registrationToken,
    required this.otp,
    required this.otpReference,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();

    jsonMap['registrationId'] = this.registrationId;
    jsonMap['registrationToken'] = this.registrationToken;
    jsonMap['otp'] = this.otp;
    jsonMap['otpReference'] = this.otpReference;

    return jsonEncode(jsonMap);
  }
}
