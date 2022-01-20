import 'dart:convert';

class RefreshTokenRequest {
  String refreshToken;

  RefreshTokenRequest({
    required this.refreshToken,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    jsonMap['refreshToken'] = this.refreshToken;

    return jsonEncode(jsonMap);
  }
}
