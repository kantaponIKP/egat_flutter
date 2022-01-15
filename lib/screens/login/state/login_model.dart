import 'package:egat_flutter/screens/login/api/login_api.dart';
import 'package:egat_flutter/screens/login/api/login_api_mock.dart';
import 'package:egat_flutter/screens/login/api/model/LoginRequest.dart';
import 'package:egat_flutter/screens/login/api/model/LogoutRequest.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/cupertino.dart';

class LoginModel extends ChangeNotifier {
  LoginSession loginSession;
  bool isError = false;

  LoginModel({required this.loginSession});

  setIsError(isError) {
    this.isError = isError;
    notifyListeners();
  }

  setSession(session) {
    loginSession = session;
  }

  // LoginApi api = LoginApi();
  LoginApiMock api = LoginApiMock();

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
    loginSession.setAccessToken(LoginSessionInfo(
        accessToken: response.accessToken!,
        userId: response.userId!,
        refreshToken: response.refreshToken!));

    // LoginSession session = new LoginSession();
    // session.setAccessToken(LoginSessionInfo(accessToken: response.accessToken!));
  }

  Future<void> processLogout() async {
    var response = await api.requestLogout(
      LogoutRequest(
        accessToken: loginSession.info!.accessToken,
      ),
    );
    loginSession.setAccessToken(
      LoginSessionInfo(accessToken: "", userId: "", refreshToken: ""),
    );
  }

}
