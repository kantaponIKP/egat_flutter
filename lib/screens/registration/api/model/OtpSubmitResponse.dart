import 'dart:convert';

import 'package:egat_flutter/screens/registration/api/model/RegistrationStatusState.dart';


class OtpSubmitResponse {
  String? sessionId;
  String? sessionToken;
  RestRegistrationStatus? status;
  bool? valid;

  OtpSubmitResponse({
    this.sessionId,
    this.sessionToken,
    this.status,
    this.valid,
  });

  OtpSubmitResponse.fromJSON(String jsonString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    this.sessionId = jsonMap["sessionId"];
    this.sessionToken = jsonMap["sessionToken"];
    this.status = RestRegistrationStatuses.fromText(jsonMap["status"]);
    this.valid = jsonMap["valid"];
  }
}
