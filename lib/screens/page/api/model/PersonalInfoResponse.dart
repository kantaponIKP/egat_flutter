import 'dart:convert';

class PersonalInfoResponse {
  String? fullName;
  String? phoneNumber;
  String? email;
  String? photo;

  PersonalInfoResponse({
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.photo,
  });

  PersonalInfoResponse.fromJSON(String jsonString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    this.fullName = jsonMap['fullName'];
    this.phoneNumber= jsonMap['phoneNumber'];
    this.email = jsonMap['email'];
    this.photo = jsonMap['photo'];
  }
}
