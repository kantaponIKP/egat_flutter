import 'package:flutter/cupertino.dart';

class LoginSessionInfo {
  final String accessToken;


  const LoginSessionInfo({
    required this.accessToken,
  });
}

class LoginSession extends ChangeNotifier {
  LoginSessionInfo? info;

  setAccessToken(LoginSessionInfo accessToken) {
    _setAccessToken(accessToken);
  }

  setNoAccessToken() {
    _setAccessToken(null);
  }

  _setAccessToken(LoginSessionInfo? session) {
    info = session;

    notifyListeners();
  }
}
