import 'package:flutter/cupertino.dart';

class SettlementNavigationState extends ChangeNotifier {
  SettlementNavigationPage _currentPage = SettlementNavigationPage.ORDER;

  SettlementNavigationPage get currentPage => _currentPage;

  setCurrentPage(SettlementNavigationPage page) {
    _currentPage = page;
    notifyListeners();
  }
}

enum SettlementNavigationPage {
  ORDER,
  ENERGY_TRANSFER,
  SETTLEMENT_REPORT,
}
