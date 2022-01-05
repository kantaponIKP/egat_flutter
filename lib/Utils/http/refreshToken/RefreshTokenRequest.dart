import 'dart:convert';

class RefreshTokenRequest {
  String accessToken;
  String refreshToken;

  RefreshTokenRequest({
    required this.accessToken,
    required this.refreshToken,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    jsonMap['accessToken'] = this.accessToken;
    jsonMap['refreshToken'] = this.refreshToken;

    return jsonEncode(jsonMap);
  }
}
