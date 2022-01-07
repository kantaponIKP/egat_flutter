import 'dart:async';
import 'dart:convert';

import 'package:egat_flutter/Utils/http/get.dart';
import 'package:egat_flutter/Utils/http/post.dart';
import 'package:egat_flutter/errors/IntlException.dart';
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
import 'package:http/http.dart';

import 'model/RegistrationSessionRequest.dart';
import 'package:egat_flutter/constant.dart';

import 'package:http/http.dart' as http;

class RegistrationApi {
  Future<RegistrationResponse> createRegistrationSession(
    RegistrationSessionRequest request,
  ) async {
    var url = Uri.parse(
      "$apiBaseUrlRegister/registration-sessions",
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
        intlMessage: "error-unauthorized",
      );
    }

    if (response.statusCode == 409) {
      throw IntlException(
        message: "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}",
        intlMessage: "error-conflict",
      );
    }

    if (response.statusCode >= 300) {
      throw IntlException(
        message: "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}",
        intlMessage: "error-incorrectInformationError",
      );
    }

    

    // response = await http.post(
    //   url,
    //   headers: {'Content-Type': 'application/json'},
    //   body: requestJson,
    // );

    // logger.d(response.statusCode);

    // if (response.statusCode >= 300) {
    //   throw "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}";
    // }

    // if (response.statusCode >= 409) {
    //   throw "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}";
    // }

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
      "$apiBaseUrlRegister/registration-sessions/${request.sessionId}/meter",
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
    // TODO :
    print(utf8.decode(response.bodyBytes));
    return LocationResponse.fromJSON(utf8.decode(response.bodyBytes));
    // return LocationResponse.fromJSON(json.decode(response.body));
  }

  Future<OtpResponse> sendOtp(
    OtpRequest request,
  ) async {
    logger.d(request.sessionId);
    var url = Uri.parse(
      "$apiBaseUrlRegister/registration-sessions/${request.sessionId}/otp-send",
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

    return OtpResponse.fromJSON(response.body);
  }

  Future<OtpSubmitResponse> submitOtp(RegistrationRequest request) async {
    var url = Uri.parse(
      "$apiBaseUrlRegister/registration-sessions/${request.sessionId}/otp-submit",
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

    return OtpSubmitResponse.fromJSON(response.body);
  }

  Future<RegistrationResponse> registration(
    RegistrationRequest request,
  ) async {
    var url = Uri.parse(
      "$apiBaseUrlRegister/registration-sessions",
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
    if (response.statusCode >= 300) {
      throw IntlException(
        message: "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}",
        intlMessage: "error-incorrectInformationError",
      );
    }

    return RegistrationResponse.fromJSON(response.body);
  }
}
