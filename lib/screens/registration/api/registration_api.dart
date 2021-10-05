import 'dart:convert';

import 'package:egat_flutter/screens/registration/api/model/GetSessionStatusRequest.dart';
import 'package:egat_flutter/screens/registration/api/model/GetSessionStatusResponse.dart';
import 'package:egat_flutter/screens/registration/api/model/LocationRequest.dart';
import 'package:egat_flutter/screens/registration/api/model/LocationResponse.dart';
import 'package:egat_flutter/screens/registration/api/model/OtpRequest.dart';
import 'package:egat_flutter/screens/registration/api/model/OtpResponse.dart';
import 'package:egat_flutter/screens/registration/api/model/OtpSubmitRequest.dart';
import 'package:egat_flutter/screens/registration/api/model/OtpSubmitResponse.dart';
import 'package:egat_flutter/screens/registration/api/model/RegistrationRequest.dart';
import 'package:egat_flutter/screens/registration/api/model/RegistrationSessionResponse.dart';

import 'model/RegistrationSessionRequest.dart';
import 'package:egat_flutter/constant.dart';

import 'package:http/http.dart' as http;

class RegistrationApi {
  Future<RegistrationResponse> createRegistrationSession(
    RegistrationSessionRequest request,
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

    logger.d(response.statusCode);

    if (response.statusCode >= 300) {
      throw "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}";
    }

    if (response.statusCode >= 409) {
      throw "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}";
    }

    return RegistrationResponse.fromJSON(response.body);
  }

  // Future<GetSessionStatusResponse> getRegistrationSession(
  //   GetSessionStatusRequest request,
  // ) async {
  //   var url = Uri.parse(
  //     "$apiBaseUrl/registration-sessions/${request.email}/token/${request.phoneNumber}",
  //   );

  //   var response = await http.get(url);

  //   if (response.statusCode == 404) {
  //     throw "ปฎิเสธเนื่องจากการลงทะเบียนไม่ถูกต้องหรือโดนยกเลิก";
  //   }

  //   if (response.statusCode == 401) {
  //     throw "ปฎิเสธเนื่องจากการลงทะเบียนไม่ถูกต้อง กรุณาเริ่มการลงทะเบียนใหม่";
  //   }

  //   if (response.statusCode >= 300) {
  //     throw "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}";
  //   }

  //   return GetSessionStatusResponse.fromJSON(response.body);
  // }

  Future<LocationResponse> getLocation(LocationRequest request) async {
    logger.d(request.sessionId);
    logger.d(request.meterId);
    var url = Uri.parse(
      "$apiBaseUrl/registration-sessions/${request.sessionId}/meter/${request.meterId}",
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
    logger.d(response.statusCode);
    // TODO :
    return LocationResponse.fromJSON(json.decode(response.body));
  }

  Future<OtpResponse> sendOtp(
    OtpRequest request,
  ) async {
    logger.d(request.sessionId);
    var url = Uri.parse(
      "$apiBaseUrl/registration-sessions/${request.sessionId}/otp-send",
    );

    var requestJson = request.toJSON();

    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: requestJson,
    );

    logger.d(response.statusCode);
    logger.d(response.body);

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
      OtpSubmitRequest otpRequest, RegistrationRequest regisRequest) async {
    logger.d("API");
    var url = Uri.parse(
      "$apiBaseUrl/registration-sessions/${otpRequest.sessionId}/otp-submit",
    );
    // logger.d(otpRequest);
    // logger.d(regisRequest);
    var requestOtpJson = otpRequest.toJSON();
    // var requestOtpJson = otpRequest;
    var requestRegisJson = regisRequest.toJSON();
    // var requestRegisJson = regisRequest;

    var requestJson = '{ "otpSubmitRequest":'+requestOtpJson+', "userInfoRequest":'+requestRegisJson+'}';

    logger.d(requestJson);

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
    return OtpSubmitResponse.fromJSON(response.body);
  }

  Future<RegistrationResponse> registration(
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

    if (response.statusCode == 404) {
      throw "ปฎิเสธเนื่องจากการลงทะเบียนไม่ถูกต้องหรือโดนยกเลิก";
    }

    if (response.statusCode == 401) {
      throw "ปฎิเสธเนื่องจากการลงทะเบียนไม่ถูกต้อง กรุณาเริ่มการลงทะเบียนใหม่";
    }

    if (response.statusCode >= 300) {
      throw "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}";
    }

    return RegistrationResponse.fromJSON(response.body);
  }
}
