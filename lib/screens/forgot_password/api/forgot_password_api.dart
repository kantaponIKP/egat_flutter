import 'dart:convert';
import 'package:egat_flutter/screens/forgot_password/api/model/ChangeForgotPasswordRequest.dart';
import 'package:egat_flutter/screens/forgot_password/api/model/ChangeForgotPasswordResponse.dart';
import 'package:egat_flutter/screens/forgot_password/api/model/OtpForgotPasswordRequest.dart';
import 'package:egat_flutter/screens/forgot_password/api/model/OtpForgotPasswordResponse.dart';
import 'package:egat_flutter/screens/forgot_password/api/model/SubmitOtpForgotPasswordRequest.dart';
import 'package:egat_flutter/screens/forgot_password/api/model/SubmitOtpForgotPasswordResponse.dart';
import 'package:egat_flutter/screens/registration/api/model/LocationResponse.dart';



import 'package:egat_flutter/constant.dart';

import 'package:http/http.dart' as http;

class ForgotPasswordApi {
  Future<OtpForgotPasswordResponse> sendOtp(
    OtpForgotPasswordRequest request,
  ) async {
    logger.d("Send OTP");
    logger.d(request.email);
    var url = Uri.parse(
      "$apiBaseUrlLogin/forgotpassword-sessions/otp-send",
    );

    var requestJson = request.toJSON();

    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: requestJson,
    );

    logger.d(response.statusCode);

    if (response.statusCode >= 300) {
      throw "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}";
    }

    if (response.statusCode >= 409) {
      throw "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}";
    }

    return OtpForgotPasswordResponse.fromJSON(response.body);
  }

    Future<SubmitOtpForgotPasswordResponse> submitOtp(
      SubmitOtpForgotPasswordRequest request) async {
        logger.d("Submit OTP");
    logger.d(request.otp);
    logger.d(request.reference);
    logger.d(request.sessionId);
    logger.d(request.sessionToken);
    var url = Uri.parse(
      "$apiBaseUrlLogin/forgotpassword-sessions/${request.sessionId}/otp-submit",
    );
    var requestJson = request.toJSON();

    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: requestJson,
    );
    logger.d(response.statusCode);

    if (response.statusCode == 404) {
      throw "ปฎิเสธเนื่องจากการลงทะเบียนไม่ถูกต้องหรือโดนยกเลิก";
    }

    if (response.statusCode == 401) {
      throw "ปฎิเสธเนื่องจากการลงทะเบียนไม่ถูกต้อง กรุณาเริ่มการลงทะเบียนใหม่";
    }

    if (response.statusCode >= 300) {
      throw "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}";
    }
    logger.d(response.statusCode);
    return SubmitOtpForgotPasswordResponse.fromJSON(response.body);
  }

  Future<ChangeForgotPasswordResponse> changeForgotPassword(
      ChangeForgotPasswordRequest request) async {
    var url = Uri.parse(
      "$apiBaseUrlLogin/forgotpassword-sessions/${request.sessionId}/forgotpassword",
    );

    var requestJson = request.toJSON();

    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: requestJson,
    );

    if (response.statusCode == 404) {
      throw "ปฎิเสธเนื่องจากการลงทะเบียนไม่ถูกต้องหรือโดนยกเลิก";
    }

    if (response.statusCode == 401) {
      throw "ปฎิเสธเนื่องจากการลงทะเบียนไม่ถูกต้อง กรุณาเริ่มการลงทะเบียนใหม่";
    }

    if (response.statusCode >= 300) {
      throw "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}";
    }
    logger.d(response.statusCode);
    // TODO :
    return ChangeForgotPasswordResponse.fromJSON(response.body);
  }
}
