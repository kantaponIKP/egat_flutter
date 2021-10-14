import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/forgot_password/api/model/ChangeForgotPasswordRequest.dart';
import 'package:egat_flutter/screens/forgot_password/forgot_password_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Password extends ChangeNotifier {
  ForgotPasswordModel parent;

  String? _reference;
  String? get reference => _reference;

  Password(this.parent);

  void setReference(String reference) {
    _reference = reference;
    notifyListeners();
  }

  nextPage() {
    parent.status.setStateSuccess();
  }

  backPage() {
    parent.status.setStateOtp();
  }

  Future<bool> resetPassword(String password) async {
    if (parent.session.info == null) {
      // This must not happened.
      return false;
    }

    var result = await parent.api.changeForgotPassword(
        ChangeForgotPasswordRequest(
          sessionId: parent.session.info!.sessionId,
          sessionToken: parent.session.info!.sessionToken,
          email: parent.email.info.email!,
          password: password,
        ));

    // logger.d(" " +
    //     parent.session.info!.sessionId +
    //     " " +
    //     parent.session.info!.sessionToken +
    //     " " +
    //     parent.email.info.email! +
    //     " " +
    //     password
    // );

    nextPage();

    return false;
  }
}
