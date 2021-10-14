import 'dart:convert';

class LoginRequest {
  String email;
  String password;
  bool rememberMe;

  LoginRequest({
    required this.email,
    required this.password,
    required this.rememberMe,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    jsonMap['email'] = this.email;
    jsonMap['password'] = this.password;
    jsonMap['rememberMe'] = this.rememberMe;

    return jsonEncode(jsonMap);
  }
}
