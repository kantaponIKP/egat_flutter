import 'dart:convert';

class RefreshTokenResponse {
  String? accessToken;
  String? refreshToken;
  String? userId;

  RefreshTokenResponse({
    this.accessToken,
    this.refreshToken,
    this.userId,
  });

  RefreshTokenResponse.fromJSON(String jsonString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    this.accessToken = jsonMap["accessToken"];
    this.refreshToken = jsonMap["refreshToken"];
    this.userId = jsonMap["userId"];
  }
}
