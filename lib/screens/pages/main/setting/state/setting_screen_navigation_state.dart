import 'package:flutter/cupertino.dart';

class SettingScreenNavigationState extends ChangeNotifier {
  SettingScreenNavigationPage _currentPage = SettingScreenNavigationPage.MAIN;
  SettingScreenNavigationPage get currentPage => _currentPage;

  SettingScreenNavigationState({
    currentPage = SettingScreenNavigationPage.MAIN,
  }) {
    _currentPage = currentPage;
  }

  void setCurrentPage({required SettingScreenNavigationPage page}) {
    _currentPage = page;
    notifyListeners();
  }

  void setPageToMain() {
    setCurrentPage(page: SettingScreenNavigationPage.MAIN);
  }

  void setPageToAddPayment() {
    setCurrentPage(page: SettingScreenNavigationPage.ADD_PAYMENT);
    print("set");
  }

  void setPageToCardPayment() {
    setCurrentPage(page: SettingScreenNavigationPage.CARD_PAYMENT);
  }

  void setPageToChangePin() {
   setCurrentPage(page: SettingScreenNavigationPage.CHANGE_PIN);
  }
}

enum SettingScreenNavigationPage {
  MAIN,
  ADD_PAYMENT,
  CARD_PAYMENT,
  CHANGE_PIN,
}
