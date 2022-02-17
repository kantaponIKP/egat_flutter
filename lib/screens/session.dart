import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

class GlobalLoginSession {
  LoginSessionInfo? info;

  GlobalLoginSession() {
    info = null;
  }

  setAccessToken(LoginSessionInfo info) {
    _setAccessToken(info);
  }

  setNoAccessToken() {
    _setAccessToken(null);
  }

  _setAccessToken(LoginSessionInfo? session) {
    info = session;
  }
}

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
  GlobalLoginSession _globalLoginSession = GlobalLoginSession();
  LoginSession() {
    _globalLoginSession = getIt.get<GlobalLoginSession>();
  }

  LoginSessionInfo? get info => _globalLoginSession.info;

  setAccessToken(LoginSessionInfo info) {
    _setAccessToken(info);
  }

  setNoAccessToken() {
    _setAccessToken(null);
  }

  _setAccessToken(LoginSessionInfo? session) {
    if (session == null) {
      _globalLoginSession.setNoAccessToken();
    } else {
      _globalLoginSession.setAccessToken(session);
    }

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
