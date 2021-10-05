import 'dart:convert';

import 'dart:typed_data';

class RegistrationSessionRequest {
  String email;
  String phoneNumber;
  
  RegistrationSessionRequest({
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
