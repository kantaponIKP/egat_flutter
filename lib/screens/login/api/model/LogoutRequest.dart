import 'dart:convert';

class LogoutRequest {
  String accessToken;


  LogoutRequest({
    required this.accessToken,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    jsonMap['accessToken'] = this.accessToken;

    return jsonEncode(jsonMap);
  }
}
