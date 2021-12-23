import 'package:egat_flutter/screens/page/page_model.dart';
import 'package:egat_flutter/screens/page/state/bilateral/bilateral_buy.dart';
import 'package:egat_flutter/screens/page/state/bilateral/bilateral_long_term_buy.dart';
import 'package:egat_flutter/screens/page/state/bilateral/bilateral_long_term_sell.dart';
import 'package:egat_flutter/screens/page/state/bilateral/bilateral_short_term_sell.dart';
import 'package:egat_flutter/screens/page/state/bilateral/bilateral_sell.dart';
import 'package:egat_flutter/screens/page/state/bilateral/bilateral_trade.dart';
import 'package:egat_flutter/screens/page/state/bottom_navigation_bar.dart';
import 'package:egat_flutter/screens/page/state/change_password.dart';
import 'package:egat_flutter/screens/page/state/forecast.dart';
import 'package:egat_flutter/screens/page/state/home.dart';
import 'package:egat_flutter/screens/page/state/page_status.dart';
import 'package:egat_flutter/screens/page/state/personal_info.dart';
import 'package:egat_flutter/screens/page/state/pool_market/pool_market_short_term_buy.dart';
import 'package:egat_flutter/screens/page/state/pool_market/pool_market_short_term_sell.dart';
import 'package:egat_flutter/screens/page/state/pool_market/pool_market_trade.dart';
import 'package:egat_flutter/screens/page/state/sidebar.dart';
import 'package:egat_flutter/screens/page/state/trading_tabbar.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'page_screen.dart';

class ManagePage extends StatefulWidget {
  final bool isResume;

  ManagePage({
    this.isResume = false,
    Key? key,
  }) : super(key: key);

  @override
  _ManagePageState createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  _ManagePageState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (context) {
        //   return PageModel();
        // }),
        ChangeNotifierProxyProvider<LoginSession, PageModel>(
          create: (context) {
            var loginSession =
                Provider.of<LoginSession>(context, listen: false);
            PageModel pageModel = PageModel(session: loginSession);
            return pageModel;
          },
          update: (
            BuildContext context,
            LoginSession session,
            PageModel? previous,
          ) {
            if (previous == null) {
              PageModel pageModel = PageModel(session: session);
              return pageModel;
            }
            previous.session = session;
            return previous;
          },
        ),
        ChangeNotifierProxyProvider<PageModel, PageStatus>(
          create: (context) {
            var model = Provider.of<PageModel>(context, listen: false);
            return model.status;
          },
          update: (
            BuildContext context,
            PageModel model,
            PageStatus? previous,
          ) {
            return model.status;
          },
        ),
        ChangeNotifierProxyProvider<PageModel, Sidebar>(
          create: (context) {
            var model = Provider.of<PageModel>(context, listen: false);
            return model.sidebar;
          },
          update: (
            BuildContext context,
            PageModel model,
            Sidebar? previous,
          ) {
            return model.sidebar;
          },
        ),
        ChangeNotifierProxyProvider<PageModel, PersonalInfo>(
          create: (context) {
            var model = Provider.of<PageModel>(context, listen: false);
            return model.personalInfo;
          },
          update: (
            BuildContext context,
            PageModel model,
            PersonalInfo? previous,
          ) {
            return model.personalInfo;
          },
        ),
        ChangeNotifierProxyProvider<PageModel, Home>(
          create: (context) {
            var model = Provider.of<PageModel>(context, listen: false);
            return model.home;
          },
          update: (
            BuildContext context,
            PageModel model,
            Home? previous,
          ) {
            return model.home;
          },
        ),
        ChangeNotifierProxyProvider<PageModel, ChangePassword>(
          create: (context) {
            var model = Provider.of<PageModel>(context, listen: false);
            return model.changePassword;
          },
          update: (
            BuildContext context,
            PageModel model,
            ChangePassword? previous,
          ) {
            return model.changePassword;
          },
        ),
        ChangeNotifierProxyProvider<PageModel, BottomNavigationBarPage>(
          create: (context) {
            var model = Provider.of<PageModel>(context, listen: false);
            return model.bottomNavigation;
          },
          update: (
            BuildContext context,
            PageModel model,
            BottomNavigationBarPage? previous,
          ) {
            return model.bottomNavigation;
          },
        ),
        ChangeNotifierProxyProvider<PageModel, Forecast>(
          create: (context) {
            var model = Provider.of<PageModel>(context, listen: false);
            return model.forecast;
          },
          update: (
            BuildContext context,
            PageModel model,
            Forecast? previous,
          ) {
            return model.forecast;
          },
        ),
        ChangeNotifierProxyProvider<PageModel, TradingTabbar>(
          create: (context) {
            var model = Provider.of<PageModel>(context, listen: false);
            return model.tradingTabbar;
          },
          update: (
            BuildContext context,
            PageModel model,
            TradingTabbar? previous,
          ) {
            return model.tradingTabbar;
          },
        ),
        ChangeNotifierProxyProvider<PageModel, BilateralTrade>(
          create: (context) {
            var model = Provider.of<PageModel>(context, listen: false);
            return model.bilateralTrade;
          },
          update: (
            BuildContext context,
            PageModel model,
            BilateralTrade? previous,
          ) {
            return model.bilateralTrade;
          },
        ),
        ChangeNotifierProxyProvider<PageModel, BilateralBuy>(
          create: (context) {
            var model = Provider.of<PageModel>(context, listen: false);
            return model.bilateralBuy;
          },
          update: (
            BuildContext context,
            PageModel model,
            BilateralBuy? previous,
          ) {
            return model.bilateralBuy;
          },
        ),
        ChangeNotifierProxyProvider<PageModel, BilateralLongTermBuy>(
          create: (context) {
            var model = Provider.of<PageModel>(context, listen: false);
            return model.bilateralLongTermBuy;
          },
          update: (
            BuildContext context,
            PageModel model,
            BilateralLongTermBuy? previous,
          ) {
            return model.bilateralLongTermBuy;
          },
        ),
        ChangeNotifierProxyProvider<PageModel, BilateralLongTermSell>(
          create: (context) {
            var model = Provider.of<PageModel>(context, listen: false);
            return model.bilateralLongTermSell;
          },
          update: (
            BuildContext context,
            PageModel model,
            BilateralLongTermSell? previous,
          ) {
            return model.bilateralLongTermSell;
          },
        ),
        ChangeNotifierProxyProvider<PageModel, BilateralShortTermSell>(
          create: (context) {
            var model = Provider.of<PageModel>(context, listen: false);
            return model.bilateralOrderSell;
          },
          update: (
            BuildContext context,
            PageModel model,
            BilateralShortTermSell? previous,
          ) {
            return model.bilateralOrderSell;
          },
        ),
        ChangeNotifierProxyProvider<PageModel, BilateralSell>(
          create: (context) {
            var model = Provider.of<PageModel>(context, listen: false);
            return model.bilateralSell;
          },
          update: (
            BuildContext context,
            PageModel model,
            BilateralSell? previous,
          ) {
            return model.bilateralSell;
          },
        ),
        ChangeNotifierProxyProvider<PageModel, PoolMarketTrade>(
          create: (context) {
            var model = Provider.of<PageModel>(context, listen: false);
            return model.poolMarketTrade;
          },
          update: (
            BuildContext context,
            PageModel model,
            PoolMarketTrade? previous,
          ) {
            return model.poolMarketTrade;
          },
        ),
        ChangeNotifierProxyProvider<PageModel, PoolMarketShortTermBuy>(
          create: (context) {
            var model = Provider.of<PageModel>(context, listen: false);
            return model.poolMarketOrderBuy;
          },
          update: (
            BuildContext context,
            PageModel model,
            PoolMarketShortTermBuy? previous,
          ) {
            return model.poolMarketOrderBuy;
          },
        ),
        ChangeNotifierProxyProvider<PageModel, PoolMarketShortTermSell>(
          create: (context) {
            var model = Provider.of<PageModel>(context, listen: false);
            return model.poolMarketOrderSell;
          },
          update: (
            BuildContext context,
            PageModel model,
            PoolMarketShortTermSell? previous,
          ) {
            return model.poolMarketOrderSell;
          },
        ),
        ChangeNotifierProxyProvider<PageModel, BilateralSell>(
          create: (context) {
            var model = Provider.of<PageModel>(context, listen: false);
            return model.bilateralSell;
          },
          update: (
            BuildContext context,
            PageModel model,
            BilateralSell? previous,
          ) {
            return model.bilateralSell;
          },
        ),
      ],
      child: PageScreen(),
    );
  }
}
