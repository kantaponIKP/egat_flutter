import 'package:egat_flutter/screens/forgot_password/api/model/ChangeForgotPasswordRequest.dart';
import 'package:egat_flutter/screens/forgot_password/api/model/OtpForgotPasswordRequest.dart';
import 'package:egat_flutter/screens/forgot_password/api/model/SubmitOtpForgotPasswordRequest.dart';
import 'package:egat_flutter/screens/forgot_password/forgot_password_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Otp extends ChangeNotifier {
  ForgotPasswordModel parent;


  String? _reference;
  String? get reference => _reference;

  Otp(this.parent);

  void setReference(String reference) {
    _reference = reference;
    notifyListeners();
  }


  Future<void> sendOtp() async {
    // if (parent.session.info == null) {
    //   // This must not happened.

    //   return;
    // }

    // var result = await parent.api.sendOtp(
    //   OtpForgotPasswordRequest(
    //     email: parent.email.info.email!,
    //   ),
    // );

    // setReference(result.reference ?? "ERROR: No reference returned.");
  }

  Future<bool> submitOtp(String otp) async {
    if (parent.session.info == null) {
      // This must not happened.
      return false;
    } 

    var result = await parent.api.submitOtp(
        SubmitOtpForgotPasswordRequest(
          sessionId: parent.session.info!.sessionId,
          sessionToken: parent.session.info!.sessionToken,
          reference: parent.otp.reference!,
          otp: otp,
        ),
    );
    

    nextPage();
    // .meter.info.role
    // if (result.valid ?? false) {
    //   var registrationResult = await parent.api.registration(
    //   RegistrationRequest(
    //     sessionId: parent.session.info!.sessionId,
    //     fullName: parent.userInfo.info.fullName!,
    //     phoneNumber: parent.userInfo.info.phoneNumber!,
    //     email: parent.userInfo.info.email!,
    //     password: parent.userInfo.info.password!,
    //   ));

    //   if(registrationResult.status == RestRegistrationStatus.Success){
    //      parent.status.setStateSuccess();
    //     return true;
    //   }

    // }

    return false;
  }

  nextPage() {
    parent.status.setStatePassword();
  }

  backPage() {
    parent.status.setStateEmail();
  }
}
