import 'package:flutter/cupertino.dart';

class LoginSessionInfo {
  final String accessToken;
  final String userId;
  final String refreshToken;

  const LoginSessionInfo({
    required this.accessToken,
    required this.userId,
    required this.refreshToken,
  });
}

class LoginSession extends ChangeNotifier {
  LoginSessionInfo? info;

  setAccessToken(LoginSessionInfo info) {
    _setAccessToken(info);
  }

  setNoAccessToken() {
    _setAccessToken(null);
  }

  _setAccessToken(LoginSessionInfo? session) {
    info = session;

    notifyListeners();
  }

  ReadonlyLoginSession asReadonly() {
    return ReadonlyLoginSession(loginSession: this);
  }
}

class ReadonlyLoginSession {
  late final LoginSession _loginSession;
  LoginSessionInfo? get info => _loginSession.info;

  ReadonlyLoginSession({
    required LoginSession loginSession,
  }) {
    _loginSession = loginSession;
  }
}
