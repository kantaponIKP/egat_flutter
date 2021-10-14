import 'dart:convert';

import 'package:egat_flutter/screens/forgot_password/api/model/ChangeForgotPasswordRequest.dart';
import 'package:egat_flutter/screens/forgot_password/api/model/ChangeForgotPasswordResponse.dart';
import 'package:egat_flutter/screens/forgot_password/api/model/OtpForgotPasswordRequest.dart';
import 'package:egat_flutter/screens/forgot_password/api/model/OtpForgotPasswordResponse.dart';
import 'package:egat_flutter/screens/forgot_password/api/model/SubmitOtpForgotPasswordRequest.dart';
import 'package:egat_flutter/screens/forgot_password/api/model/SubmitOtpForgotPasswordResponse.dart';
import 'package:egat_flutter/screens/registration/api/model/LocationRequest.dart';
import 'package:egat_flutter/screens/registration/api/model/LocationResponse.dart';
import 'package:egat_flutter/screens/registration/api/model/OtpRequest.dart';
import 'package:egat_flutter/screens/registration/api/model/OtpResponse.dart';
import 'package:egat_flutter/screens/registration/api/model/OtpSubmitRequest.dart';
import 'package:egat_flutter/screens/registration/api/model/OtpSubmitResponse.dart';
import 'package:egat_flutter/screens/registration/api/model/RegistrationRequest.dart';
import 'package:egat_flutter/screens/registration/api/model/RegistrationSessionResponse.dart';
import 'package:flutter/services.dart';

import 'package:egat_flutter/constant.dart';

import 'package:http/http.dart' as http;

class ForgotPasswordApiMock {
  Future<OtpForgotPasswordResponse> sendOtp(
    OtpForgotPasswordRequest request,
  ) async {
    return OtpForgotPasswordResponse.fromJSON(await rootBundle
        .loadString('assets/mockdata/forgot_password/session.json'));
  }

  Future<ChangeForgotPasswordResponse> changeForgotPassword(
    ChangeForgotPasswordRequest request,
  ) async {
    return ChangeForgotPasswordResponse.fromJSON(await rootBundle
        .loadString('assets/mockdata/forgot_password/otp.json'));
  }

    Future<SubmitOtpForgotPasswordResponse> submitOtp(
    SubmitOtpForgotPasswordRequest request,
  ) async {
    return SubmitOtpForgotPasswordResponse.fromJSON(await rootBundle
        .loadString('assets/mockdata/forgot_password/change_password.json'));
  }
}
