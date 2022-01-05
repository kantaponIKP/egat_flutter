
import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/pages/main/change_password/apis/models/AccessRequest.dart';
import 'package:egat_flutter/screens/pages/main/change_password/apis/models/ChangePasswordRequest.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ChangePasswordApi {
  const ChangePasswordApi();

  Future<Response> changePassword(
      ChangePasswordRequest request, AccessRequest access) async {
    var url = Uri.parse(
      "$apiBaseUrlProfileManage/${access.userId}/users/change-password",
    );

    var requestJson = request.toJSON();

    var response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${access.accessToken}'
      },
      body: requestJson,
    );

    return response;
  }
}

const changePasswordApi = const ChangePasswordApi();
