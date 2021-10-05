import 'dart:convert';
import 'package:egat_flutter/screens/registration/api/model/RegistrationStatus.dart';


class RegistrationResponse {
  // String? sessionId;
  // String? sessionToken;
  RestRegistrationStatus? status;

  RegistrationResponse({
    this.status,
  });

  RegistrationResponse.fromJSON(String jsonString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    this.status = RestRegistrationStatuses.fromText(jsonMap["status"]);
  }
}
