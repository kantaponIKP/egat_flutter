import 'dart:convert';

import 'package:egat_flutter/constant.dart';
import 'package:flutter/services.dart';
import 'model/LoginResponse.dart';
import 'model/LoginRequest.dart';

import 'package:http/http.dart' as http;

class LoginApiMock {
  Future<LoginResponse> requestLogin(LoginRequest request) async {
    return LoginResponse.fromJSON(
        await rootBundle.loadString('assets/mockdata/login/login.json'));
  }
}
