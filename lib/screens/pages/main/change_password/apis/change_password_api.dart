import 'dart:async';

import 'package:egat_flutter/Utils/http/post.dart';
import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/errors/IntlException.dart';
import 'package:egat_flutter/screens/pages/main/change_password/apis/models/AccessRequest.dart';
import 'package:egat_flutter/screens/pages/main/change_password/apis/models/ChangePasswordRequest.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ChangePasswordApi {
  const ChangePasswordApi();

  Future<Response> changePassword(
      ChangePasswordRequest request, AccessRequest access) async {
    var url = Uri.parse(
      "$apiBaseUrlProfileManage/users/${access.userId}/change-password",
    );
    var requestJson = request.toJSON();

    final httpRequest = httpPostJson(
        uri: url, body: requestJson, accessToken: access.accessToken);
    Response response;
    try {
      response = await httpRequest.timeout(Duration(seconds: 60));
    } on TimeoutException catch (_) {
      throw IntlException(
        message: "Time out",
        intlMessage: "error-timeoutError",
      );
    }

    if (response.statusCode >= 500) {
      throw IntlException(
        message: "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}",
        intlMessage: "error-connectionError",
      );
    }
    if (response.statusCode == 409) {
      throw IntlException(
        message: "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}",
        intlMessage: "error-passwordSameAsOldPassword",
      );
    }
    if (response.statusCode == 404) {
      throw IntlException(
        message: "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}",
        intlMessage: "error-incorrectPassword",
      );
    }
    if (response.statusCode == 401) {
      throw IntlException(
        message: "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}",
        intlMessage: "error-sessionExpired",
      );
    }
    if (response.statusCode >= 300) {
      throw IntlException(
        message: "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}",
        intlMessage: "error-incorrectInformationError",
      );
    }

    // var requestJson = request.toJSON();

    // var response = await http.put(
    //   url,
    //   headers: {
    //     'Content-Type': 'application/json',
    //     'Authorization': 'Bearer ${access.accessToken}'
    //   },
    //   body: requestJson,
    // );

    return response;
  }
}

const changePasswordApi = const ChangePasswordApi();
