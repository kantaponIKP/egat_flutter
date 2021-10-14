import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/login/api/login_api.dart';
import 'package:egat_flutter/screens/login/api/model/LoginRequest.dart';
import 'package:egat_flutter/screens/login/api/model/LoginStatusState.dart';
import 'package:egat_flutter/screens/login/login.dart';
import 'package:flutter/cupertino.dart';

class LoginModel extends ChangeNotifier {
  bool isError = false;

  setIsError(isError) {
    this.isError = isError;
    notifyListeners();
  }

  LoginApi api = LoginApi();

  Future<void> processLogin({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    var response = await api.requestLogin(
      LoginRequest(
        email: email,
        password: password,
        rememberMe: rememberMe,
      ),
    );
  }
}
