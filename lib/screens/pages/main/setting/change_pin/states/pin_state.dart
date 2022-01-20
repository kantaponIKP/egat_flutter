import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinState extends ChangeNotifier {
  LoginSession loginSession;
  String _pin = "";
  String get currentPin => _pin;

  PinState({
    required this.loginSession,
  });

  setLoginSession(LoginSession loginSession) {
    this.loginSession = loginSession;
  }

    String _getUserId() {
    var loginInfo = loginSession.info;
    if (loginInfo == null) {
      throw Exception('No access token');
    }

    return loginInfo.userId;
  }

  setPin({
    pin = "",
  }) {
    this._pin = pin;
    notifyListeners();
  }


  void getPinFromStorage() async {
    final userId = _getUserId();
    final storage = new FlutterSecureStorage();
    // await storage.write(key: 'pin_$userId', value: "");
    String pin = await storage.read(key: 'pin_$userId') ?? "";
    setPin(pin: pin);
  }

  void setPinToStorage({required String pin}) async {
    final userId = _getUserId();
    final storage = new FlutterSecureStorage();
    await storage.write(key: 'pin_$userId', value: pin);
    setPin(pin: pin);
    notifyListeners();
  }

  bool hasPin() {
    if(this._pin == ""){
      return false;
    }else{
      return true;
    }
  }

  bool verifyPin(String pin){
    if(this._pin == pin){
      return true;
    }else{
      return false;
    }
  }

}
