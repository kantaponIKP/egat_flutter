import 'dart:convert';

import 'dart:typed_data';

class GetSessionStatusRequest {
  String email;
  String phoneNumber;

  GetSessionStatusRequest({
    required this.email,
    required this.phoneNumber,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();

    jsonMap['email'] = this.email;
    jsonMap['phoneNumber'] = this.phoneNumber;

    return jsonEncode(jsonMap);
  }
}
