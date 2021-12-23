import 'package:egat_flutter/screens/login/api/model/LoginRequest.dart';
import 'package:egat_flutter/screens/login/state/login_model.dart';
import 'package:flutter/cupertino.dart';

class LoginSessionInfo {
  final String accessToken;


  const LoginSessionInfo({
    required this.accessToken,
  });
}

class LoginSession extends ChangeNotifier {
  LoginSessionInfo? info;
  LoginModel parent;

  LoginSession(this.parent);

  setAccessToken(LoginSessionInfo accessToken) {
    _setAccessToken(accessToken);
  }

  setNoAccessToken() {
    _setAccessToken(null);
  }

  Future<void> requestLoginSession({required String email, required String password, required bool rememberMe}) async {
    var response = await parent.api.requestLogin(
      LoginRequest(
        email: email,
        password: password,
        rememberMe: rememberMe,
      ),
    );

    setAccessToken(
      LoginSessionInfo(
        accessToken: response.accessToken ?? "",
      ),
    );
  }

  _setAccessToken(LoginSessionInfo? session) {
    info = session;

    notifyListeners();
  }
}
