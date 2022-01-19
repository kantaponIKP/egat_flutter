import 'dart:convert';

class ChangePersonalInfoRequest {
  String? username;
  String? phoneNumber;
  String? email;

  ChangePersonalInfoRequest({
    this.username,
    this.phoneNumber,
    this.email,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    if(username != null){
      jsonMap['username'] = this.username;
    }
    if(phoneNumber != null){
      jsonMap['phoneNumber'] = this.phoneNumber;
    }
    if(email != null){
      jsonMap['email'] = this.email;
    }
    
    return jsonEncode(jsonMap);
  }

  void setUsername(String username){
    this.username = username;
  }

  void setPhoneNumber(String phoneNumber){
    this.phoneNumber = phoneNumber;
  }

  void setEmail(String email){
    this.email = email;
  }
}
