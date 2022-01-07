import 'dart:convert';

class ChangeForgotPasswordRequest {
  String sessionId;
  String sessionToken;
  String email;
  String password;

  ChangeForgotPasswordRequest({
    required this.sessionId,
    required this.sessionToken,
    required this.email,
    required this.password,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    jsonMap['sessionId'] = this.sessionId;
    jsonMap['email'] = this.email;
    jsonMap['password'] = this.password;
    jsonMap['sessionToken'] = this.sessionToken;

    return jsonEncode(jsonMap);
  }
}
