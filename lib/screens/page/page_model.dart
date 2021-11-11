import 'package:egat_flutter/screens/page/api/page_api_mock.dart';
import 'package:egat_flutter/screens/page/state/pool_market_trade.dart';
import 'package:egat_flutter/screens/page/state/bilateral_trade.dart';
import 'package:egat_flutter/screens/page/state/bottom_navigation_bar.dart';
import 'package:egat_flutter/screens/page/state/change_password.dart';
import 'package:egat_flutter/screens/page/state/forecast.dart';
import 'package:egat_flutter/screens/page/state/home.dart';
import 'package:egat_flutter/screens/page/state/page_status.dart';
import 'package:egat_flutter/screens/page/state/personal_info.dart';
import 'package:egat_flutter/screens/page/state/sidebar.dart';
import 'package:egat_flutter/screens/page/state/trading_tabbar.dart';
import 'package:flutter/widgets.dart';

class PageModel extends ChangeNotifier {
  late final PageStatus status;
  late final Sidebar sidebar;
  late final PersonalInfo personalInfo;
  late final Home home;
  late final ChangePassword changePassword;
  late final BottomNavigationBarPage bottomNavigation;
  late final Forecast forecast;
  late final BilateralTrade bilateralTrade;
  late final PoolMarketTrade poolMarketTrade;
  late final TradingTabbar tradingTabbar;
  
  PageModel() {
    status = PageStatus(this);
    sidebar = Sidebar(this);
    personalInfo = PersonalInfo(this);
    home = Home(this);
    changePassword = ChangePassword(this);
    bottomNavigation = BottomNavigationBarPage(this);
    forecast = Forecast(this);
    bilateralTrade = BilateralTrade(this);
    poolMarketTrade = PoolMarketTrade(this);
    tradingTabbar = TradingTabbar(this);
  }

  // TODO : API
  // PageApi api = PageApi();
  PageApiMock api = PageApiMock();


  // Future<void> cancelRegistration() async {
  //   status.setStateDismiss();
  // }

  // void requestFaceNextState() {
  //   status.setStatePassword();
  // }

  void whenPageStatusChanged() {}

  // void finish() {
  //   if (status.state == RegistrationState.Success) {
  //     status.setStateDismiss();
  //   }
  // }
}
