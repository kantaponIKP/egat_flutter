import 'package:egat_flutter/screens/page/api/model/AccessRequest.dart';
import 'package:egat_flutter/screens/page/api/model/ChangePasswordRequest.dart';
import 'package:egat_flutter/screens/page/api/model/ChangePersonalInfoRequest.dart';
import 'package:egat_flutter/screens/page/api/model/ChangePhotoRequest.dart';
import 'package:egat_flutter/screens/page/api/model/PersonalInfoResponse.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

class PageApiMock {
  Future<PersonalInfoResponse> getPersonalInfo(AccessRequest request) async {
    return PersonalInfoResponse.fromJSON(
        await rootBundle.loadString('assets/mockdata/page/personal_info.json'));
  }

  Future<PersonalInfoResponse> changePersonalInfo(
      ChangePersonalInfoRequest request, AccessRequest accessToken) async {
    print(request.fullName);
    print(request.email);
    print(request.phoneNumber);
    return PersonalInfoResponse.fromJSON(await rootBundle
        .loadString('assets/mockdata/page/change_personal_info.json'));
  }

  Future<Response> changePhoto(ChangePhotoRequest request, AccessRequest accessToken) async {
    Response response = Response("", 200);
    return response;
  }

  Future<Response> removePhoto(AccessRequest request) async {
    Response response = Response("", 200);
    return response;
  }

  Future<Response> changePassword(ChangePasswordRequest request,AccessRequest accessToken) async {
    Response response = Response("", 200);
    return response;
  }
}
