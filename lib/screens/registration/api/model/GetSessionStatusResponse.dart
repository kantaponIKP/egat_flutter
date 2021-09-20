import 'dart:convert';
import 'package:egat_flutter/screens/registration/api/model/RegistrationStatusState.dart';


class GetSessionStatusResponse {
  String? sessionId;
  String? sessionToken;
  RestRegistrationStatus? status;
  String? mobileNo;

  GetSessionStatusResponse({
    this.sessionId,
    this.sessionToken,
    this.status,
    this.mobileNo,
  });

  GetSessionStatusResponse.fromJSON(String jsonString) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    this.sessionId = jsonMap["sessionId"];
    this.sessionToken = jsonMap["sessionToken"];
    this.status = RestRegistrationStatuses.fromText(jsonMap["status"]);
    this.mobileNo = jsonMap["mobileNo"];
  }
}
