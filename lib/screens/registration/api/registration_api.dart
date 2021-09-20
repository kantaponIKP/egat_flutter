import 'dart:convert';

import 'package:egat_flutter/screens/registration/api/model/GetSessionStatusRequest.dart';
import 'package:egat_flutter/screens/registration/api/model/GetSessionStatusResponse.dart';
import 'package:egat_flutter/screens/registration/api/model/OtpRequest.dart';
import 'package:egat_flutter/screens/registration/api/model/OtpResponse.dart';
import 'package:egat_flutter/screens/registration/api/model/OtpSubmitRequest.dart';
import 'package:egat_flutter/screens/registration/api/model/OtpSubmitResponse.dart';
import 'package:egat_flutter/screens/registration/api/model/RegistrationResponse.dart';

import 'model/RegistrationRequest.dart';
import 'package:egat_flutter/constant.dart';

import 'package:http/http.dart' as http;

class RegistrationApi {

  Future<RegistrationResponse> createRegistrationSession(
    RegistrationRequest request,
  ) async {
    var url = Uri.parse(
      "$apiBaseUrl/registration-sessions",
    );

    var requestJson = request.toJSON();

    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: requestJson,
    );

    if (response.statusCode >= 300) {
      throw "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}";
    }

    return RegistrationResponse.fromJSON(response.body);
  }

  Future<GetSessionStatusResponse> getRegistrationSession(
    GetSessionStatusRequest request,
  ) async {
    var url = Uri.parse(
      "$apiBaseUrl/registration-sessions/${request.registrationId}/token/${request.registrationToken}",
    );

    var response = await http.get(url);

    if (response.statusCode == 404) {
      throw "ปฎิเสธเนื่องจากการลงทะเบียนไม่ถูกต้องหรือโดนยกเลิก";
    }

    if (response.statusCode == 401) {
      throw "ปฎิเสธเนื่องจากการลงทะเบียนไม่ถูกต้อง กรุณาเริ่มการลงทะเบียนใหม่";
    }

    if (response.statusCode >= 300) {
      throw "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}";
    }

    return GetSessionStatusResponse.fromJSON(response.body);
  }

  Future<OtpResponse> sendOtp(
    OtpRequest request,
  ) async {
    var url = Uri.parse(
      "$apiBaseUrl/registration-sessions/${request.registrationId}/otp-send",
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

    return OtpResponse.fromJSON(response.body);
  }

  Future<OtpSubmitResponse> submitOtp(
    OtpSubmitRequest request,
  ) async {
    var url = Uri.parse(
      "$apiBaseUrl/registration-sessions/${request.registrationId}/otp-submit",
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

    return OtpSubmitResponse.fromJSON(response.body);
  }
}
