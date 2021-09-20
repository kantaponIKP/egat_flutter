import 'dart:convert';

class OtpResponse {
  String? reference;

  OtpResponse({
    this.reference,
  });

  OtpResponse.fromJSON(String jsonString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    this.reference = jsonMap["reference"];
  }
}
