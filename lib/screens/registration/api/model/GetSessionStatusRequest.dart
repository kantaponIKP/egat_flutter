import 'dart:convert';

import 'dart:typed_data';

class GetSessionStatusRequest {
  String registrationId;
  String registrationToken;

  GetSessionStatusRequest({
    required this.registrationId,
    required this.registrationToken,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();

    jsonMap['registrationId'] = this.registrationId;
    jsonMap['registrationToken'] = this.registrationToken;

    return jsonEncode(jsonMap);
  }
}
