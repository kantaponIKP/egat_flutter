import 'dart:convert';

import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/page/api/model/AccessRequest.dart';
import 'package:egat_flutter/screens/page/api/model/ChangePasswordRequest.dart';
import 'package:egat_flutter/screens/page/api/model/ChangePersonalInfoRequest.dart';
import 'package:egat_flutter/screens/page/api/model/ChangePhotoRequest.dart';
import 'package:egat_flutter/screens/page/api/model/PersonalInfoResponse.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class PageApi {
  Future<PersonalInfoResponse> getPersonalInfo(AccessRequest request) async {
    var url = Uri.parse(
      "$apiBaseUrlProfileManage/users/me",
    );

    // var requestJson = request.toJSON();

    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${request.accessToken}'
      },
    );

    if (response.statusCode == 404) {
      throw "ปฎิเสธเนื่องจากการเข้าสู่ระบบไม่ถูกต้องหรือโดนยกเลิก";
    }

    if (response.statusCode == 401) {
      throw "ปฎิเสธเนื่องจากการเข้าสู่ระบบไม่ถูกต้อง กรุณาเข้าสู่ระบบอีกครั้ง";
    }

    if (response.statusCode >= 300) {
      throw "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}";
    }

    logger.d(response.body);

    return PersonalInfoResponse.fromJSON(response.body);
  }

  Future<Response> changePersonalInfo(
      ChangePersonalInfoRequest request,AccessRequest access) async {
    var url = Uri.parse(
      "$apiBaseUrlProfileManage/users/${access.userId}",
    );
    print("request*****");
    print(request.fullName);
    print(request.phoneNumber);
    print(request.email);
    print("request******");

    var requestJson = request.toJSON();

    var response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${access.accessToken}'
      },
      body: requestJson,
    );

    if (response.statusCode == 404) {
      throw "ปฎิเสธเนื่องจากการเข้าสู่ระบบไม่ถูกต้องหรือโดนยกเลิก";
    }

    if (response.statusCode == 401) {
      throw "ปฎิเสธเนื่องจากการเข้าสู่ระบบไม่ถูกต้อง กรุณาเข้าสู่ระบบอีกครั้ง";
    }

    if (response.statusCode >= 300) {
      throw "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}";
    }

    return response;
  }

  Future<Response> changePhoto(ChangePhotoRequest request,AccessRequest access) async {
    print("request");
    print(request.photo);
    var url = Uri.parse(
      "$apiBaseUrlProfileManage/users/${access.userId}/photo",
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

    print(response.statusCode);

    if (response.statusCode == 404) {
      throw "ปฎิเสธเนื่องจากการเข้าสู่ระบบไม่ถูกต้องหรือโดนยกเลิก";
    }

    if (response.statusCode == 401) {
      throw "ปฎิเสธเนื่องจากการเข้าสู่ระบบไม่ถูกต้อง กรุณาเข้าสู่ระบบอีกครั้ง";
    }

    if (response.statusCode >= 300) {
      throw "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}";
    }

    logger.d(response.body);

    return response;
  }

  Future<Response> removePhoto(AccessRequest access) async {
    var url = Uri.parse(
      "$apiBaseUrlProfileManage/users/${access.userId}/photo", //TODO
    );

    var response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${access.accessToken}'
      },
    );

    if (response.statusCode == 404) {
      throw "ปฎิเสธเนื่องจากการเข้าสู่ระบบไม่ถูกต้องหรือโดนยกเลิก";
    }

    if (response.statusCode == 401) {
      throw "ปฎิเสธเนื่องจากการเข้าสู่ระบบไม่ถูกต้อง กรุณาเข้าสู่ระบบอีกครั้ง";
    }

    if (response.statusCode >= 300) {
      throw "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}";
    }

    logger.d(response.body);

    return response;
  }

    Future<Response> changePassword(ChangePasswordRequest request,AccessRequest access) async {
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

    print(response.statusCode);

    // if (response.statusCode == 404) {
    //   throw "ปฎิเสธเนื่องจากการเข้าสู่ระบบไม่ถูกต้องหรือโดนยกเลิก";
    // }

    // if (response.statusCode == 401) {
    //   throw "ปฎิเสธเนื่องจากการเข้าสู่ระบบไม่ถูกต้อง กรุณาเข้าสู่ระบบอีกครั้ง";
    // }

    // if (response.statusCode >= 300) {
    //   throw "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}";
    // }

    return response;
  }
}
