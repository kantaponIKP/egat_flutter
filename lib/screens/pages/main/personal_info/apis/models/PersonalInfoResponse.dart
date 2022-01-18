import 'dart:convert';

class PersonalInfoResponse {
  String? username;
  String? phoneNumber;
  String? email;
  String? photo;

  PersonalInfoResponse({
    required this.username,
    required this.phoneNumber,
    required this.email,
    required this.photo,
  });

  PersonalInfoResponse.fromJSON(String jsonString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    this.username = jsonMap['username'];
    this.phoneNumber= jsonMap['phoneNumber'];
    this.email = jsonMap['email'];
    this.photo = jsonMap['photo'];
  }
}
