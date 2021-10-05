import 'dart:convert';

import 'dart:typed_data';

class RegistrationRequest {
  String fullName;
  String phoneNumber;
  String email;
  String password;
  String meterId;
  String meterName;
  String role;

  RegistrationRequest({
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.meterId,
    required this.meterName,
    required this.role,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();

    jsonMap['fullName'] = this.fullName;
    jsonMap['phoneNumber'] = this.phoneNumber;
    jsonMap['email'] = this.email;
    jsonMap['password'] = this.password;
    jsonMap['meterId'] = this.meterId;
    jsonMap['meterName'] = this.meterName;
    jsonMap['role'] = this.role;

    return jsonEncode(jsonMap);
  }
}
