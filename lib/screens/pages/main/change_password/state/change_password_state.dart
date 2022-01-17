import 'package:egat_flutter/screens/pages/main/change_password/apis/change_password_api.dart';
import 'package:egat_flutter/screens/pages/main/change_password/apis/models/AccessRequest.dart';
import 'package:egat_flutter/screens/pages/main/change_password/apis/models/ChangePasswordRequest.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

class ChangePasswordModel {
  final bool? isErrorPasswordIncorrect;

  ChangePasswordModel({
    this.isErrorPasswordIncorrect,
  });
}

class ChangePasswordState extends ChangeNotifier {
  LoginSession? _loginSession;
  ChangePasswordModel _info =
      ChangePasswordModel(isErrorPasswordIncorrect: false);

  LoginSession? get loginSession => _loginSession;

  void setLoginSession(LoginSession state) {
    if (_loginSession == state) {
      return;
    }

    _loginSession = state;
    notifyListeners();
  }

  ChangePasswordState();

  setInfo(ChangePasswordModel info) {
    this._info = info;
    notifyListeners();
  }

  updateInfo({
    bool? isErrorPasswordIncorrect,
  }) {
    if (isErrorPasswordIncorrect == null) {
      isErrorPasswordIncorrect = info.isErrorPasswordIncorrect;
    }

    var newInfo = ChangePasswordModel(
      isErrorPasswordIncorrect: isErrorPasswordIncorrect,
    );

    setInfo(newInfo);
  }

  ChangePasswordModel get info => _info;

  Future<void> changePassword(String oldPassword, String newPassword) async {
    
    Response response;
    // try {
      response = await changePasswordApi.changePassword(
        ChangePasswordRequest(
            oldPassword: oldPassword, newPassword: newPassword),
        AccessRequest(
          accessToken: loginSession!.info!.accessToken,
          userId: loginSession!.info!.userId,
        ),
      );
  }
}
