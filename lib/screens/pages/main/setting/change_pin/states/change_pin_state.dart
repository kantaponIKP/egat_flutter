import 'package:egat_flutter/screens/pages/main/setting/change_pin/states/pin_state.dart';
import 'package:flutter/cupertino.dart';

enum PinStatus {
  EnterCurrentPIN,
  EnterNewPIN,
  VerifyNewPIN,
}

class ChangePinState extends ChangeNotifier {
  PinState? _pinState;
  PinStatus _currentStatus = PinStatus.EnterCurrentPIN;
  PinStatus get currentStatus => _currentStatus;
  PinState? get pinState => _pinState;

  ChangePinState({currentState = PinStatus.EnterCurrentPIN, pinState}) {
    _currentStatus = currentState;
    _pinState = pinState;
  }

  Future<void> setCurrentStatus({required PinStatus status}) async {
    _currentStatus = status;
    await Future.delayed(Duration(milliseconds: 1));
    notifyListeners();
  }

  void setStateToEnterCurrentPIN() {
    setCurrentStatus(status: PinStatus.EnterCurrentPIN);
  }

  void setStateToEnterNewPIN() {
    setCurrentStatus(status: PinStatus.EnterNewPIN);
  }

  void setStateToVerifyNewPIN() {
    setCurrentStatus(status: PinStatus.VerifyNewPIN);
  }

  void setPin(PinState pinState) {
    if(_pinState == pinState){
      return;
    }
    _pinState = pinState;
    notifyListeners();
  }
}
