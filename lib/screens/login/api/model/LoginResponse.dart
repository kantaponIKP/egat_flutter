import 'dart:convert';

class LoginResponse {
  String? accessToken;

  LoginResponse({
    this.accessToken,
  });

  LoginResponse.fromJSON(String jsonString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    this.accessToken = jsonMap["accessToken"];
  }
}
