
import 'package:egat_flutter/screens/forgot_password/api/model/ChangeForgotPasswordRequest.dart';
import 'package:egat_flutter/screens/forgot_password/api/model/ChangeForgotPasswordResponse.dart';
import 'package:egat_flutter/screens/forgot_password/api/model/OtpForgotPasswordRequest.dart';
import 'package:egat_flutter/screens/forgot_password/api/model/OtpForgotPasswordResponse.dart';
import 'package:egat_flutter/screens/forgot_password/api/model/SubmitOtpForgotPasswordRequest.dart';
import 'package:egat_flutter/screens/forgot_password/api/model/SubmitOtpForgotPasswordResponse.dart';
import 'package:flutter/services.dart';



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
