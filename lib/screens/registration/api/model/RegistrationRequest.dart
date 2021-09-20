import 'dart:convert';

import 'dart:typed_data';

class RegistrationRequest {
  String clientInfo;
  String address;
  String mobileNo;
  String email;

  RegistrationRequest({
    required this.clientInfo,
    required this.address,
    required this.mobileNo,
    required this.email,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();

    jsonMap['clientInfo'] = this.clientInfo;
    jsonMap['address'] = this.address;
    jsonMap['mobileNo'] = this.mobileNo;
    jsonMap['email'] = this.email;

    return jsonEncode(jsonMap);
  }
}
