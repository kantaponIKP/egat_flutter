import 'dart:async';

import 'package:egat_flutter/Utils/http/delete.dart';
import 'package:egat_flutter/Utils/http/get.dart';
import 'package:egat_flutter/Utils/http/post.dart';
import 'package:egat_flutter/Utils/http/put.dart';
import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/errors/IntlException.dart';
import 'package:egat_flutter/screens/page/api/model/PersonalInfoResponse.dart';
import 'package:egat_flutter/screens/pages/main/personal_info/apis/models/AccessRequest.dart';
import 'package:egat_flutter/screens/pages/main/personal_info/apis/models/ChangePersonalInfoRequest.dart';
import 'package:egat_flutter/screens/pages/main/personal_info/apis/models/ChangePhotoRequest.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class PersonalInfoApi {
  const PersonalInfoApi();

  Future<PersonalInfoResponse> getPersonalInfo(AccessRequest request) async {
    var url = Uri.parse(
      "$apiBaseUrlProfileManage/users/me",
    );

    final httpRequest = httpGetJson(url: url, accessToken: request.accessToken);

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

    return PersonalInfoResponse.fromJSON(response.body);
  }

  Future<Response> changePersonalInfo(
      ChangePersonalInfoRequest request, AccessRequest access) async {
    var url = Uri.parse(
      "$apiBaseUrlProfileManage/users/${access.userId}",
    );

    var requestJson = request.toJSON();

    final httpRequest = httpPostJson(
        uri: url, body: requestJson, accessToken: access.accessToken);

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

  Future<Response> changePhoto(
      ChangePhotoRequest request, AccessRequest access) async {
    print("request");
    print(request.photo);
    var url = Uri.parse(
      "$apiBaseUrlProfileManage/users/${access.userId}/photo",
    );

    var requestJson = request.toJSON();

    final httpRequest = httpPostJson(
        uri: url, body: requestJson, accessToken: access.accessToken);

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

  Future<Response> removePhoto(AccessRequest access) async {
    var url = Uri.parse(
      "$apiBaseUrlProfileManage/users/${access.userId}/photo/delete",
    );

    final httpRequest = httpPostJson(uri: url, accessToken: access.accessToken);

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

class PersonalInfoMockApi {
  const PersonalInfoMockApi();

  Future<PersonalInfoResponse> getPersonalInfo(AccessRequest request) async {
    return PersonalInfoResponse.fromJSON(
        await rootBundle.loadString('assets/mockdata/page/personal_info.json'));
  }

  Future<PersonalInfoResponse> changePersonalInfo(
      ChangePersonalInfoRequest request, AccessRequest accessToken) async {
    return PersonalInfoResponse.fromJSON(await rootBundle
        .loadString('assets/mockdata/page/change_personal_info.json'));
  }

  Future<Response> changePhoto(
      ChangePhotoRequest request, AccessRequest accessToken) async {
    Response response = Response("", 200);
    return response;
  }

  Future<Response> removePhoto(AccessRequest request) async {
    Response response = Response("", 200);
    return response;
  }
}

// const personalInfoApi = const PersonalInfoMockApi();
const personalInfoApi = const PersonalInfoApi();
