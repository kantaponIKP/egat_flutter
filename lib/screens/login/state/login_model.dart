import 'dart:async';

import 'package:egat_flutter/screens/login/api/login_api.dart';
import 'package:egat_flutter/screens/login/api/login_api_mock.dart';
import 'package:egat_flutter/screens/login/api/model/LoginRequest.dart';
import 'package:egat_flutter/screens/login/api/model/LogoutRequest.dart';
import 'package:egat_flutter/screens/login/api/model/RefreshTokenRequest.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginModel extends ChangeNotifier {
  LoginSession loginSession;
  bool isError = false;
  late Timer _timer;

  LoginModel({required this.loginSession}) {
    _timer = Timer.periodic(Duration(seconds: 60), (timer) {
      if (loginSession.info != null) {
        updateRefreshToken();
      }
    });
  }

  Future<void> updateRefreshToken() async {
    var response = await api.requestRefreshToken(
      RefreshTokenRequest(
        refreshToken: loginSession.info!.refreshToken,
      ),
    );

    loginSession.setAccessToken(LoginSessionInfo(
        accessToken: response.accessToken!,
        userId: response.userId!,
        refreshToken: response.refreshToken!));
    final storage = new FlutterSecureStorage();
    await storage.write(key: 'refreshToken', value: response.refreshToken!);
  }

  setIsError(isError) {
    this.isError = isError;
    notifyListeners();
  }

  setSession(session) {
    loginSession = session;
  }

  LoginApi api = LoginApi();
  // LoginApiMock api = LoginApiMock();

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

    final storage = new FlutterSecureStorage();
    await storage.write(key: 'rememberMe', value: rememberMe.toString());
    await storage.write(key: 'refreshToken', value: response.refreshToken!);
  }

  Future<bool> getRememberMe() async {
    final storage = new FlutterSecureStorage();
    String rememberMeFromStorage =
        await storage.read(key: 'rememberMe') ?? "false";
    bool rememberMe = rememberMeFromStorage.toLowerCase() == 'true';

    if (rememberMe == true) {
      String? refreshToken = await storage.read(key: 'refreshToken');
      if (refreshToken == null) {
        throw Exception('No refresh token');
      }
      loginSession.setAccessToken(LoginSessionInfo(
          accessToken: "", userId: "", refreshToken: refreshToken));
      // updateRefreshToken();
    }
    return rememberMe;
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
    _timer.cancel(); //TODO

    final storage = new FlutterSecureStorage();
    await storage.write(key: 'rememberMe', value: "false");
  }

  @override
  void dispose() {
    _timer.cancel();

    super.dispose();
  }
}
