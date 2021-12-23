import 'package:flutter/cupertino.dart';

class HomeScreenNavigationState extends ChangeNotifier {
  HomeScreenNavigationPage _currentPage = HomeScreenNavigationPage.MAIN;

  HomeScreenNavigationPage get currentPage => _currentPage;

  setCurrentPage(HomeScreenNavigationPage page) {
    _currentPage = page;
    notifyListeners();
  }
}

enum HomeScreenNavigationPage {
  MAIN,
  BUYSELL,
  SETTLEMENT,
  BILLING,
  NOTIFICATION,
}
