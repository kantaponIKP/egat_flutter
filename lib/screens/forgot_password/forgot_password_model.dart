import 'package:egat_flutter/screens/forgot_password/api/forgot_password_api.dart';
import 'package:egat_flutter/screens/forgot_password/api/forgot_password_api_mock.dart';
import 'package:egat_flutter/screens/forgot_password/state/email.dart';
import 'package:egat_flutter/screens/forgot_password/state/forgot_password_session.dart';
import 'package:egat_flutter/screens/forgot_password/state/forgot_password_status.dart';
import 'package:egat_flutter/screens/forgot_password/state/otp.dart';
import 'package:egat_flutter/screens/registration/api/registration_api_mock.dart';
import 'package:egat_flutter/screens/registration/state/registration_status.dart';
import 'package:flutter/widgets.dart';

import 'state/password.dart';

class ForgotPasswordModel extends ChangeNotifier {
  late final ForgotPasswordStatus status;
  late final ForgotPasswordSession session;
  late final Email email;
  late final Otp otp;
  late final Password password;

  ForgotPasswordModel() {
    status = ForgotPasswordStatus(this);
    session = ForgotPasswordSession(this);
    email = Email(this);
    otp = Otp(this);
    password = Password(this);
  }

  // TODO
  // ForgotPasswordApiMock api = ForgotPasswordApiMock();
  ForgotPasswordApi api = ForgotPasswordApi();

  Future<void> cancelRegistration() async {
    status.setStateDismiss();
  }

  void whenForgotPasswordStatusChanged() {}

  void finish() {
    if (status.state == ForgotPasswordState.Success) {
      status.setStateDismiss();
    }
  }
}
