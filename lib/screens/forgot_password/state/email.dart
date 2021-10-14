import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/forgot_password/forgot_password_model.dart';
import 'package:egat_flutter/screens/forgot_password/state/otp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class EmailModel {
  final String? email;

  EmailModel({
    this.email,
  });
}

class Email extends ChangeNotifier {
  EmailModel _info = EmailModel();

  final ForgotPasswordModel parent;
  String? email;

  EmailModel get info => _info;

  Email(this.parent);

  void setInfo(EmailModel info) {
    this._info = info;
    notifyListeners();
  }

  void updateInfo({
    String? email,
  }) {
    if (email == null) {
      email = info.email;
    }

    var newInfo = EmailModel(
      email: email,
    );

    setInfo(newInfo);
  }

  Future<void> sendOtp({fullName, phoneNumber, email, password}) async {
    // setInfo(UserInfoModel(fullName: fullName, phoneNumber: phoneNumber, email: email, password: password));
    var response =
        await parent.session.requestNewForgotPasswordSession(email: email);
    // if (parent.session.info == null) {
    //   throw "Unable to submit new registration session.";
    // }
    logger.d(response.sessionId);
    logger.d(response.sessionToken);

    parent.otp.setReference(response.reference!);

    parent.status.setStateOtp();
  }

  void nextPage() {
    parent.status.setStateOtp();
  }

  void backPage() {
    parent.status.setStateDismiss();
  }
}
