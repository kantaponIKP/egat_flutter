import 'dart:convert';

import 'package:egat_flutter/screens/registration/api/model/RegistrationStatus.dart';


class OtpSubmitResponse {
  String? sessionId;
  bool? valid;

  OtpSubmitResponse({
    this.sessionId,
    this.valid,
  });

  OtpSubmitResponse.fromJSON(String jsonString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    this.sessionId = jsonMap["sessionId"];
    this.valid = jsonMap["valid"];
  }
}
