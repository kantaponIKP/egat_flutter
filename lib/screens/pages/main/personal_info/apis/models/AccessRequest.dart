import 'dart:convert';

class AccessRequest {
  String accessToken;
  String userId;

  AccessRequest({
    required this.accessToken,
    required this.userId,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    jsonMap['accessToken'] = this.accessToken;
    jsonMap['userId'] = this.userId;

    return jsonEncode(jsonMap);
  }
}
