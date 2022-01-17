import 'dart:async';
import 'package:egat_flutter/Utils/http/post.dart';
import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/errors/IntlException.dart';
import 'package:egat_flutter/screens/login/api/model/LogoutRequest.dart';
import 'package:http/http.dart';
import 'model/LoginResponse.dart';
import 'model/LoginRequest.dart';

class LoginApi {
  Future<LoginResponse> requestLogin(LoginRequest request) async {
    var url = Uri.parse(
      "$apiBaseUrlLogin/login",
    );

    var requestJson = request.toJSON();

    final httpRequest = httpPostJson(uri: url, body: requestJson);

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
    if (response.statusCode == 401) {
      throw IntlException(
        message: "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}",
        intlMessage: "error-incorrectPassword",
      );
    }
    if (response.statusCode >= 300) {
      throw IntlException(
        message: "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}",
        intlMessage: "error-incorrectInformationError",
      );
    }

    return LoginResponse.fromJSON(response.body);
  }

    Future<Response> requestLogout(LogoutRequest request) async {
    var url = Uri.parse(
      "$apiBaseUrlLogin/logout",
    );

    var requestJson = request.toJSON();

    final httpRequest = httpPostJson(uri: url, body: requestJson, accessToken: request.accessToken);

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
    if (response.statusCode == 401) {
      throw IntlException(
        message: "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}",
        intlMessage: "error-incorrectPassword",
      );
    }
    if (response.statusCode >= 300) {
      throw IntlException(
        message: "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}",
        intlMessage: "error-incorrectInformationError",
      );
    }

    return response;
  }
}
