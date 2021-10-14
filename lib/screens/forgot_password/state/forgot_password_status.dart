import 'package:egat_flutter/screens/forgot_password/forgot_password_model.dart';
import 'package:flutter/cupertino.dart';

enum ForgotPasswordState {
  Email,
  Otp,
  Password,
  Success,
  Dismiss,
}

class ForgotPasswordStatus extends ChangeNotifier {
  ForgotPasswordState previousState = ForgotPasswordState.Email;
  ForgotPasswordState state = ForgotPasswordState.Email;
  final ForgotPasswordModel _parent;

  ForgotPasswordStatus(this._parent);

  setStateDismiss() {
    _setState(ForgotPasswordState.Dismiss);
  }

  setStateEmail() {
    _setState(ForgotPasswordState.Email);
  }

  setStateOtp() {
    _setState(ForgotPasswordState.Otp);
  }

  setStatePassword() {
    _setState(ForgotPasswordState.Password);
  }

  setStateSuccess() {
    _setState(ForgotPasswordState.Success);
  }

  _setState(ForgotPasswordState state) {
    if (this.previousState != this.state) {
      this.previousState = this.state;
      _parent.whenForgotPasswordStatusChanged();
    }

    this.state = state;
    notifyListeners();
  }
}
