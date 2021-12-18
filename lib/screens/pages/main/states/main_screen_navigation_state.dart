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
}

enum MainScreenNavigationPage {
  HOME,
}
