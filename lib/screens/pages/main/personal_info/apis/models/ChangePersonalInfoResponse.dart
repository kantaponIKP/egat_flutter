import 'dart:convert';

class ChangePersonalInfoResponse {
  String? status;

  ChangePersonalInfoResponse({
    required this.status,
  });

  ChangePersonalInfoResponse.fromJSON(String jsonString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    this.status = jsonMap['status'];
  }
}
