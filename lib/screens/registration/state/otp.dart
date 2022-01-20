import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/registration/api/model/OtpRequest.dart';
import 'package:egat_flutter/screens/registration/api/model/OtpSubmitRequest.dart';
import 'package:egat_flutter/screens/registration/api/model/RegistrationRequest.dart';
import 'package:egat_flutter/screens/registration/api/model/RegistrationStatus.dart';
import 'package:egat_flutter/screens/registration/api/model/Role.dart';
import 'package:egat_flutter/screens/registration/registration_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Otp extends ChangeNotifier {
  PageModel parent;

  String? _reference;
  String? get reference => _reference;

  Otp(this.parent);

  void setReference(String reference) {
    _reference = reference;
    notifyListeners();
  }

  Future<void> sendOtp() async {
    if (parent.session.info == null) {
      // This must not happened.
      return;
    }

    var result = await parent.api.sendOtp(
      OtpRequest(
        sessionId: parent.session.info!.sessionId,
        sessionToken: parent.session.info!.sessionToken,
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
        RegistrationRequest(
          sessionId: parent.session.info!.sessionId,
          sessionToken: parent.session.info!.sessionToken,
          username: parent.userInfo.info.username!,
          phoneNumber: parent.userInfo.info.phoneNumber!,
          email: parent.userInfo.info.email!,
          password: parent.userInfo.info.password!,
          meterId: parent.meter.info.meterId!,
          meterName: parent.meter.info.meterName!,
          role: parent.meter.info.role!.text,
          otp: otp,
          reference: reference ?? "",
        ));

    logger.d(" " +
        parent.userInfo.info.username! +
        " " +
        parent.userInfo.info.phoneNumber! +
        " " +
        parent.userInfo.info.email! +
        " " +
        parent.userInfo.info.password! +
        " " +
        parent.meter.info.meterName! +
        " " +
        parent.meter.info.meterId!);
    // logger.d(Role.Aggregator.text);

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
    parent.status.setStateSuccess();
  }

  backPage() {
    parent.status.setStateLocation();
  }
}
