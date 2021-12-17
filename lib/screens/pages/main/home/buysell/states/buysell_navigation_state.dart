import 'package:flutter/cupertino.dart';

class BuySellNavigationState extends ChangeNotifier {
  BuySellNavigationPage _currentPage = BuySellNavigationPage.FORECAST;

  BuySellNavigationPage get currentPage => _currentPage;

  setCurrentPage(BuySellNavigationPage page) {
    _currentPage = page;
    notifyListeners();
  }
}

enum BuySellNavigationPage {
  FORECAST,
  BILATERAL,
  POOL,
}
