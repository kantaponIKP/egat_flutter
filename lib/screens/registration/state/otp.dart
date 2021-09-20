import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/registration/api/model/OtpRequest.dart';
import 'package:egat_flutter/screens/registration/api/model/OtpSubmitRequest.dart';
import 'package:egat_flutter/screens/registration/registration_model.dart';
import 'package:flutter/cupertino.dart';

class Otp extends ChangeNotifier {
  RegistrationModel parent;

  String? _reference;
  String? get reference => _reference;

  Otp(this.parent);

  void setReference(String reference) {
    _reference = reference;
    notifyListeners();
  }

  Future<void> submitFirstTimeOtp() async {
    // TODO
    // if (parent.session.info == null) {
    //   // This must not happened.

    //   return;
    // }

    // var result = await parent.api.sendOtp(
    //   OtpRequest(
    //     registrationId: parent.session.info!.sessionId,
    //     registrationToken: parent.session.info!.sessionToken,
    //   ),
    // );

    // setReference(result.reference ?? "ERROR: No reference returned.");
    
    // parent.status.setStateOtpPin();
    nextPage();
  }

  Future<void> sendOtp() async {
    if (parent.session.info == null) {
      // This must not happened.

      return;
    }

    var result = await parent.api.sendOtp(
      OtpRequest(
        registrationId: parent.session.info!.sessionId,
        registrationToken: parent.session.info!.sessionToken,
      ),
    );

    setReference(result.reference ?? "ERROR: No reference returned.");
  }

  Future<bool> submitOtp(String otp) async {
    if (parent.session.info == null) {
      // This must not happened.
      return false;
    }

    var result = await parent.api.submitOtp(
      OtpSubmitRequest(
        registrationId: parent.session.info!.sessionId,
        registrationToken: parent.session.info!.sessionToken,
        otp: otp,
        otpReference: reference ?? "",
      ),
    );

    if (result.valid ?? false) {
      parent.status.setStateSuccess();
      return true;
    }

    return false;
  }


  nextPage() {
    parent.status.setStateSuccess();
  }

  backPage() {
    parent.status.setStateLocation();
  }
}
