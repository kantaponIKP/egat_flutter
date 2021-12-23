import 'dart:convert';

class ChangePasswordRequest {
  String oldPassword;
  String newPassword;

  ChangePasswordRequest({
    required this.oldPassword,
    required this.newPassword,
  });

  String toJSON() {
    Map<String, dynamic> jsonMap = Map<String, dynamic>();
    jsonMap['oldPassword'] = this.oldPassword;
    jsonMap['newPassword'] = this.newPassword;

    return jsonEncode(jsonMap);
  }
}
