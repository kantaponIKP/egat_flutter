// import 'package:egat_flutter/screens/login/login_model.dart';
// import 'package:flutter/cupertino.dart';

// enum LoginState {
//   Login,
//   Success,
//   Fail,
//   Invalid,
// }

// class LoginStatus extends ChangeNotifier {
//   LoginState state = LoginState.Login;
//   final LoginModel _parent;

//   LoginStatus(this._parent);

//   setStateSuccess() {
//     _setState(LoginState.Success);
//   }

//   setStateFail() {
//     _setState(LoginState.Fail);
//   }

//   setStateInvalid() {
//     _setState(LoginState.Invalid);
//   }

//   _setState(LoginState state) {
//     // if (this.previousState != this.state) {
//     //   this.previousState = this.state;
//     //   _parent.whenRegistrationStatusChanged();
//     // }
//     // _parent.whenLoginStatusChanged();
//     this.state = state;
//     notifyListeners();
//   }
// }
