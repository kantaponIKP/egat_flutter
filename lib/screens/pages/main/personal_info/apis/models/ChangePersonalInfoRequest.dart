import 'dart:convert';

class ChangePersonalInfoRequest {
  String? fullName;
  String? phoneNumber;
  String? email;

  ChangePersonalInfoRequest({
    this.fullName,
    this.phoneNumber,
    this.email,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    if(fullName != null){
      jsonMap['fullName'] = this.fullName;
    }
    if(phoneNumber != null){
      jsonMap['phoneNumber'] = this.phoneNumber;
    }
    if(email != null){
      jsonMap['email'] = this.email;
    }
    
    return jsonEncode(jsonMap);
  }

  void setFullName(String fullName){
    this.fullName = fullName;
  }

  void setPhoneNumber(String phoneNumber){
    this.phoneNumber = phoneNumber;
  }

  void setEmail(String email){
    this.email = email;
  }
}
