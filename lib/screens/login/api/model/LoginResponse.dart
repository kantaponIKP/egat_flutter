import 'dart:convert';

class LoginResponse {
  String? status;

  LoginResponse({
    this.status,
  });

  LoginResponse.fromJSON(String jsonString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    this.status = jsonMap["status"];
  }
}
