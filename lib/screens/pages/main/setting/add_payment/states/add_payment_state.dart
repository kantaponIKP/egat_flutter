import 'package:egat_flutter/screens/pages/main/setting/state/setting_screen_navigation_state.dart';
import 'package:flutter/cupertino.dart';

class AddPaymentState extends ChangeNotifier {
  SettingScreenNavigationState settingScreenNavigationState;

  AddPaymentState({required this.settingScreenNavigationState});

  void setNavigationState(navigationState) {
    settingScreenNavigationState = navigationState;
  }

  void nextPage(){
    settingScreenNavigationState.setPageToCardPayment();
  }
}


