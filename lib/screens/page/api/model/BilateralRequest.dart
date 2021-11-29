import 'dart:convert';

class Bilateral {
  String accessToken;

  Bilateral({
    required this.accessToken,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    jsonMap['accessToken'] = this.accessToken;

    return jsonEncode(jsonMap);
  }
}
