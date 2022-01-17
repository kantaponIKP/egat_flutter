import 'package:flutter/cupertino.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinState extends ChangeNotifier {
  String _pin = "";
  String get currentPin => _pin;

  setPin({
    pin = "",
  }) {
    this._pin = pin;
    notifyListeners();
  }


  void getPinFromStorage() async {
    final storage = new FlutterSecureStorage();
    String pin = await storage.read(key: 'pin') ?? "";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('pin');
    setPin(pin: pin);
  }

  void setPinStorage({required String pin}) async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: 'pin', value: pin);
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
