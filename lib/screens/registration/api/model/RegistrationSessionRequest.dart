import 'dart:convert';

import 'dart:typed_data';

class RegistrationSessionRequest {
  String email;
  String phoneNumber;
  String password;
  
  RegistrationSessionRequest({
    required this.email,
    required this.phoneNumber,
    required this.password
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();

    jsonMap['email'] = this.email;
    jsonMap['phoneNumber'] = this.phoneNumber;
    jsonMap['password'] = this.password;
    
    return jsonEncode(jsonMap);
  }
}
