import 'dart:convert';

class LoginRequest {
  String email;
  String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    jsonMap['email'] = this.email;
    jsonMap['password'] = this.password;

    return jsonEncode(jsonMap);
  }
}
