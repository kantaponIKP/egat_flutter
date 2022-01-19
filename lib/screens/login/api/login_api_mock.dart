import 'package:egat_flutter/errors/IntlException.dart';
import 'package:egat_flutter/screens/login/api/model/LogoutRequest.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'model/LoginResponse.dart';
import 'model/LoginRequest.dart';

class LoginApiMock {
  Future<LoginResponse> requestLogin(LoginRequest request) async {
    Response response = Response("", 200);

    if (response.statusCode >= 500) {
      throw IntlException(
        message: "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}",
        intlMessage: "error-connectionError",
      );
    }
    if (response.statusCode >= 300) {
      throw IntlException(
        message: "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}",
        intlMessage: "error-incorrectInformationError",
      );
    }

    return LoginResponse.fromJSON(
        await rootBundle.loadString('assets/mockdata/login/login.json'));
  }

    Future<Response> requestLogout(LogoutRequest request) async {
    Response response = Response("", 200);

    if (response.statusCode >= 500) {
      throw IntlException(
        message: "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}",
        intlMessage: "error-connectionError",
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
