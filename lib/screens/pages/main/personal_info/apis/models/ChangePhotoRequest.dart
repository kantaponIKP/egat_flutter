import 'dart:convert';

class ChangePhotoRequest {
  String photo;

  ChangePhotoRequest({
    required this.photo
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    jsonMap['photo'] = this.photo;

    return jsonEncode(jsonMap);
  }
}
