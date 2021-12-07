import 'package:egat_flutter/screens/page/api/page_api.dart';
import 'package:egat_flutter/screens/page/api/page_api_mock.dart';
import 'package:egat_flutter/screens/page/state/bilateral/bilateral_buy.dart';
import 'package:egat_flutter/screens/page/state/bilateral/bilateral_long_term_buy.dart';
import 'package:egat_flutter/screens/page/state/bilateral/bilateral_long_term_sell.dart';
import 'package:egat_flutter/screens/page/state/bilateral/bilateral_short_term_sell.dart';
import 'package:egat_flutter/screens/page/state/bilateral/bilateral_sell.dart';
import 'package:egat_flutter/screens/page/state/bilateral/bilateral_trade.dart';
import 'package:egat_flutter/screens/page/state/pool_market/pool_market_short_term_buy.dart';
import 'package:egat_flutter/screens/page/state/pool_market/pool_market_short_term_sell.dart';
import 'package:egat_flutter/screens/page/state/pool_market/pool_market_trade.dart';
import 'package:egat_flutter/screens/page/state/bottom_navigation_bar.dart';
import 'package:egat_flutter/screens/page/state/change_password.dart';
import 'package:egat_flutter/screens/page/state/forecast.dart';
import 'package:egat_flutter/screens/page/state/home.dart';
import 'package:egat_flutter/screens/page/state/page_status.dart';
import 'package:egat_flutter/screens/page/state/personal_info.dart';
import 'package:egat_flutter/screens/page/state/sidebar.dart';
import 'package:egat_flutter/screens/page/state/trading_tabbar.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/widgets.dart';

class PageModel extends ChangeNotifier {
  late final PageStatus status;
  late final Sidebar sidebar;
  late final PersonalInfo personalInfo;
  late final Home home;
  late final ChangePassword changePassword;
  late final BottomNavigationBarPage bottomNavigation;
  late final TradingTabbar tradingTabbar;
  late final Forecast forecast;
  late final BilateralTrade bilateralTrade;
  late final BilateralBuy bilateralBuy;
  late final BilateralLongTermBuy bilateralLongTermBuy;
  late final BilateralLongTermSell bilateralLongTermSell;
  late final BilateralShortTermSell bilateralOrderSell;
  late final BilateralSell bilateralSell;
  late final PoolMarketTrade poolMarketTrade;
  late final PoolMarketShortTermBuy poolMarketOrderBuy;
  late final PoolMarketShortTermSell poolMarketOrderSell;
  LoginSession session;

  PageModel({required this.session}) {
    status = PageStatus(this);
    sidebar = Sidebar(this);
    personalInfo = PersonalInfo(this);
    home = Home(this);
    changePassword = ChangePassword(this);
    bottomNavigation = BottomNavigationBarPage(this);
    tradingTabbar = TradingTabbar(this);
    forecast = Forecast(this);
    bilateralTrade = BilateralTrade(this);
    bilateralBuy = BilateralBuy(this);
    bilateralLongTermBuy = BilateralLongTermBuy(this);
    bilateralLongTermSell = BilateralLongTermSell(this);
    bilateralOrderSell = BilateralShortTermSell(this);
    bilateralSell = BilateralSell(this);
    poolMarketTrade = PoolMarketTrade(this);
    poolMarketOrderBuy = PoolMarketShortTermBuy(this);
    poolMarketOrderSell = PoolMarketShortTermSell(this);
  }

  // TODO : API
  PageApi api = PageApi();
  // PageApiMock api = PageApiMock();

  void whenPageStatusChanged() {}
}
