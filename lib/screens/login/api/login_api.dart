import 'dart:convert';

import 'package:egat_flutter/constant.dart';
import 'model/LoginResponse.dart';
import 'model/LoginRequest.dart';

import 'package:http/http.dart' as http;

class LoginApi {
  Future<LoginResponse> requestLogin(LoginRequest request) async {
    var url = Uri.parse(
      "$apiBaseUrlLogin/login",
    );

    var requestJson = request.toJSON();

    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
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

    logger.d(response.body);

    return LoginResponse.fromJSON(response.body);
  }
}
