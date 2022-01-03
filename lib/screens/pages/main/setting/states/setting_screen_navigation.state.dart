import 'package:flutter/cupertino.dart';

class SettingScreenNavigationState extends ChangeNotifier {
  SettingScreenNavigationPage _currentPage = SettingScreenNavigationPage.MAIN;

  SettingScreenNavigationPage get currentPage => _currentPage;

  setCurrentPage(SettingScreenNavigationPage page) {
    _currentPage = page;
    notifyListeners();
  }
}

enum SettingScreenNavigationPage {
  MAIN,
  ADD_PAYMENT,
  CHANGE_PIN,
}
