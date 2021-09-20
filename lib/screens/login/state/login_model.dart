import 'package:egat_flutter/screens/login/api/login_api.dart';
import 'package:egat_flutter/screens/login/api/model/LoginRequest.dart';
import 'package:egat_flutter/screens/login/api/model/LoginStatusState.dart';
import 'package:egat_flutter/screens/login/login.dart';
import 'package:flutter/cupertino.dart';

class LoginModel extends ChangeNotifier {
  String? email;
  String? password;
  bool? isError;

  LoginModel({email, password, isError});

  LoginModel _info = LoginModel();

  // final LoginModel parent;

  // Login(this.parent);

  LoginModel get info => _info;

  setInfo(LoginModel info) {
    this._info = info;
    notifyListeners();
  }

  updateInfo({
    String? email,
    String? password,
  }) {
    if (email == null) {
      this.email = email;
    }

    if (password == null) {
      this.password = password;
    }

    var newInfo = LoginModel(
      email: email,
      password: password,
    );

    setInfo(newInfo);
  }

  setIsError(isError){
    this.isError = isError;
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

    if (response.status != RestLoginStatus.Success) {
      // TODO
    }
    else if (response.status != RestLoginStatus.RequireEmail) {
      // TODO
      setIsError(true);
    }
    else if (response.status != RestLoginStatus.RequirePassword) {
      // TODO
      setIsError(true);
    }
  }
}
