import 'dart:convert';

class NewsBulletResponse {
  late List<dynamic> newsList;

  NewsBulletResponse({
    required this.newsList,
  });

  NewsBulletResponse.fromJSON(String jsonString) {
    List<dynamic> jsonMap = jsonDecode(jsonString);

    this.newsList = jsonMap;
  }
}
