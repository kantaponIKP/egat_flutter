import 'dart:convert';

class OtpForgotPasswordRequest {
  String email;

  OtpForgotPasswordRequest({
    required this.email,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    jsonMap['email'] = this.email;

    return jsonEncode(jsonMap);
  }
}
