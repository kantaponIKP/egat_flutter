import 'dart:convert';

class ChangeForgotPasswordResponse {
  String? status;

  ChangeForgotPasswordResponse({
    this.status,
  });

  ChangeForgotPasswordResponse.fromJSON(String jsonString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    this.status = jsonMap["status"];
  }
}
