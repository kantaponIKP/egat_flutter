import 'package:flutter/cupertino.dart';

class MainScreenNavigationState extends ChangeNotifier {
  MainScreenNavigationPage _currentPage = MainScreenNavigationPage.HOME;
  MainScreenNavigationPage get currentPage => _currentPage;

  MainScreenNavigationState({
    currentPage = MainScreenNavigationPage.HOME,
  }) {
    _currentPage = currentPage;
  }

  void setCurrentPage({required MainScreenNavigationPage page}) {
    _currentPage = page;
    notifyListeners();
  }

  void setPageToHome() {
    setCurrentPage(page: MainScreenNavigationPage.HOME);
  }

  void setPageToPersonalInfo() {
    setCurrentPage(page: MainScreenNavigationPage.PERSONAL_INFORMATION);
  }

  void setPageToChangePassword() {
    setCurrentPage(page: MainScreenNavigationPage.CHANGE_PASSWORD);
  }

  void setPageToContactUs() {
   setCurrentPage(page: MainScreenNavigationPage.CONTACT_US);
  }

  void setPageToNews() {
   setCurrentPage(page: MainScreenNavigationPage.NEWS);
  }

  void setPageToSetting() {
   setCurrentPage(page: MainScreenNavigationPage.SETTING);
  }

  void setPageToSignOut() {
   setCurrentPage(page: MainScreenNavigationPage.SIGN_OUT);
    // Navigator.of(context).popUntil((route) => route.isFirst);
    
      //TODO:
  }

}

enum MainScreenNavigationPage {
  HOME,
  PERSONAL_INFORMATION,
  CHANGE_PASSWORD,
  CONTACT_US,
  NEWS,
  SETTING,
  SIGN_OUT,
}
