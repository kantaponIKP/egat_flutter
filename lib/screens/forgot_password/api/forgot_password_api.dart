import 'dart:async';
import 'package:egat_flutter/Utils/http/post.dart';
import 'package:egat_flutter/errors/IntlException.dart';
import 'package:egat_flutter/screens/forgot_password/api/model/ChangeForgotPasswordRequest.dart';
import 'package:egat_flutter/screens/forgot_password/api/model/ChangeForgotPasswordResponse.dart';
import 'package:egat_flutter/screens/forgot_password/api/model/OtpForgotPasswordRequest.dart';
import 'package:egat_flutter/screens/forgot_password/api/model/OtpForgotPasswordResponse.dart';
import 'package:egat_flutter/screens/forgot_password/api/model/SubmitOtpForgotPasswordRequest.dart';
import 'package:egat_flutter/screens/forgot_password/api/model/SubmitOtpForgotPasswordResponse.dart';

import 'package:egat_flutter/constant.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ForgotPasswordApi {
  Future<OtpForgotPasswordResponse> sendOtp(
    OtpForgotPasswordRequest request,
  ) async {
    var url = Uri.parse(
      "$apiBaseUrlLogin/forgotpassword-sessions/otp-send",
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
        intlMessage: "error-sessionExpired",
      );
    }

    if (response.statusCode >= 300) {
      throw IntlException(
        message: "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}",
        intlMessage: "error-incorrectInformationError",
      );
    }

    return OtpForgotPasswordResponse.fromJSON(response.body);
  }

  Future<SubmitOtpForgotPasswordResponse> submitOtp(
      SubmitOtpForgotPasswordRequest request) async {
    var url = Uri.parse(
      "$apiBaseUrlLogin/forgotpassword-sessions/${request.sessionId}/otp-submit",
    );
    var requestJson = request.toJSON();

    final httpRequest = httpPostJson(uri: url, body: requestJson);
    
    Response response;

    try {
      response = await httpRequest.timeout(Duration(seconds: 60));
      print(response.statusCode);
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
        intlMessage: "error-sessionExpired",
      );
    }
    if (response.statusCode >= 300) {
      throw IntlException(
        message: "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}",
        intlMessage: "error-incorrectInformationError",
      );
    }

    return SubmitOtpForgotPasswordResponse.fromJSON(response.body);
  }

  Future<Response> changeForgotPassword(
      ChangeForgotPasswordRequest request) async {
    var url = Uri.parse(
      "$apiBaseUrlLogin/forgotpassword-sessions/${request.sessionId}/forgotpassword",
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
        intlMessage: "error-sessionExpired",
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
