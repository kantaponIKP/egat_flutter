import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/login/api/login_api.dart';
import 'package:egat_flutter/screens/login/api/model/LoginRequest.dart';
import 'package:egat_flutter/screens/login/api/model/LoginStatusState.dart';
import 'package:egat_flutter/screens/login/login.dart';
import 'package:flutter/cupertino.dart';

class LoginModel extends ChangeNotifier {
  bool isError = false;

  // LoginModel({isError});

  // LoginModel _info = LoginModel();

  // final LoginModel parent;

  // Login(this.parent);

  // LoginModel get info => _info;

  // setInfo(LoginModel info) {
  //   this._info = info;
  //   notifyListeners();
  // }

  // updateInfo({
  //   bool? isError,
  // }) {
  //   var newInfo = LoginModel();

  //   setInfo(newInfo);
  // }

  setIsError(isError) {
    this.isError = isError;
    notifyListeners();
  }

  LoginApi api = LoginApi();

  Future<void> processLogin({
    required String email,
    required String password,
  }) async {
    var response = await api.requestLogin(
      LoginRequest(
        email: email,
        password: password,
      ),
    );
    if (identical(response.status, RestLoginStatus.Success)) {
      // TODO
    } else if (identical(response.status, RestLoginStatus.RequireEmail)) {
      setIsError(true);
    } else if (identical(response.status, RestLoginStatus.RequirePassword)) {
      setIsError(true);
    }
  }
}
