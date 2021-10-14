import 'dart:convert';

class SubmitOtpForgotPasswordResponse {
  String? sessionId;
  String? sessionToken;
  bool? valid;

  SubmitOtpForgotPasswordResponse({
    this.sessionId,
    this.sessionToken,
    this.valid,
  });

  SubmitOtpForgotPasswordResponse.fromJSON(String jsonString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    this.sessionId = jsonMap["sessionId"];
    this.sessionToken = jsonMap["sessionToken"];
    this.valid = jsonMap["valid"];
  }
}
