import 'dart:convert';

class LoginResponse {
  String? accessToken;
  String? refreshToken;
  String? userId;

  LoginResponse({
    this.accessToken,
    this.refreshToken,
    this.userId,
  });

  LoginResponse.fromJSON(String jsonString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    this.accessToken = jsonMap["accessToken"];
    this.refreshToken = jsonMap["refreshToken"];
    this.userId = jsonMap["userId"];
  }
}
