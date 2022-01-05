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
  final userId = "";

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

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    final accessToken = loginSession!.info!.accessToken;
    Response response;
    // try {
      response = await changePasswordApi.changePassword(
        ChangePasswordRequest(
            oldPassword: oldPassword, newPassword: newPassword),
        AccessRequest(
          accessToken: accessToken,
          userId: userId,
        ),
      );
      if (response.statusCode == 404) { //TODO
       print("404!");
        updateInfo(isErrorPasswordIncorrect: true);
        return false;
      }
      else if(response.statusCode == 409){
        print("409!");
        throw "Your new password cannot be the same as your current password";
      }else if(response.statusCode == 204){
        return true;
      }else{
        throw "ปฎิเสธ server ตอบกลับด้วยสถานะ ${response.statusCode}";
      }
    // return false;
  }

  //   void goToHomePage() {


  //   parent.status.setStateHome();
  // }
}
