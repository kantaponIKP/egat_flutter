import 'dart:convert';

class OtpForgotPasswordResponse {
  String? reference;
  String? sessionId;
  String? sessionToken;

  OtpForgotPasswordResponse({
    this.reference,
    this.sessionId,
    this.sessionToken,
  });

  OtpForgotPasswordResponse.fromJSON(String jsonString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    this.reference = jsonMap["reference"];
    this.sessionId = jsonMap["sessionId"];
    this.sessionToken = jsonMap["sessionToken"];
  }
}
