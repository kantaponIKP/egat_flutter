import 'package:egat_flutter/screens/registration/registration_model.dart';
import 'package:flutter/cupertino.dart';

enum RegistrationState {
  UserInfo,
  Consent,
  Meter,
  Location,
  Otp,
  OtpPin,
  Password,
  Success,
  Dismiss,
}

class RegistrationStatus extends ChangeNotifier {
  RegistrationState previousState = RegistrationState.UserInfo;
  RegistrationState state = RegistrationState.UserInfo;
  final RegistrationModel _parent;

  RegistrationStatus(this._parent);

  setStateConsent() {
    _setState(RegistrationState.Consent);
  }

  setStateDismiss() {
    _setState(RegistrationState.Dismiss);
  }

  setStateMeter() {
    _setState(RegistrationState.Meter);
  }

  setStateLocation() {
    _setState(RegistrationState.Location);
  }

  setStateOtp() {
    _setState(RegistrationState.Otp);
  }

  setStateOtpPin() {
    _setState(RegistrationState.OtpPin);
  }

  setStatePassword() {
    _setState(RegistrationState.Password);
  }

  setStateUserInfo() {
    _setState(RegistrationState.UserInfo);
  }

  setStateSuccess() {
    _setState(RegistrationState.Success);
  }




  _setState(RegistrationState state) {
    if (this.previousState != this.state) {
      this.previousState = this.state;
      _parent.whenRegistrationStatusChanged();
    }

    this.state = state;
    notifyListeners();
  }
}
