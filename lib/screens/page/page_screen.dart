import 'package:egat_flutter/screens/pages/main/main_page.dart';
import 'package:egat_flutter/screens/page/change_password/change_password_screen.dart';
import 'package:egat_flutter/screens/page/contact_us/contact_us_screen.dart';
import 'package:egat_flutter/screens/page/graph/graph_screen.dart';
import 'package:egat_flutter/screens/page/home/home_screen.dart';
import 'package:egat_flutter/screens/page/news/news_page.dart';
import 'package:egat_flutter/screens/page/news/news_screen.dart';
import 'package:egat_flutter/screens/page/personal_info/personal_info_screen.dart';
import 'package:egat_flutter/screens/page/setting/setting_screen.dart';
import 'package:egat_flutter/screens/page/state/page_status.dart';
import 'package:egat_flutter/screens/page/trade/bilateral/bilateral_buy_screen.dart';
import 'package:egat_flutter/screens/page/trade/bilateral/bilateral_long_term_buy_screen.dart';
import 'package:egat_flutter/screens/page/trade/bilateral/bilateral_long_term_sell_screen.dart';
import 'package:egat_flutter/screens/page/trade/bilateral/bilateral_short_term_sell_screen.dart';
import 'package:egat_flutter/screens/page/trade/bilateral/bilateral_sell_screen.dart';
import 'package:egat_flutter/screens/page/trade/bilateral/bilateral_trade_screen.dart';
import 'package:egat_flutter/screens/page/trade/forecast/forecast_page.dart';
import 'package:egat_flutter/screens/page/trade/pool_market/pool_market_short_term_buy_screen.dart';
import 'package:egat_flutter/screens/page/trade/pool_market/pool_market_short_term_sell_screen.dart';
import 'package:egat_flutter/screens/page/trade/pool_market/pool_market_trade_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class PageScreen extends StatefulWidget {
  PageScreen({Key? key}) : super(key: key);

  @override
  _PageScreenState createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {
  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    PageStatus page = Provider.of<PageStatus>(context);

    Widget screen = Container();
    Duration duration = Duration.zero;

    if (page.state == PageState.Home) {
      // screen = HomeScreen(key: Key('home_screen'));
      screen = MainPage();
      // duration = Duration(milliseconds: 200);
    }

    if (page.state == PageState.PersonalInfo) {
      screen = PersonalInfoScreen(key: Key('personal_info_screen'));
      duration = Duration(milliseconds: 200);
    }

    if (page.state == PageState.ChangePassword) {
      screen = ChangePasswordScreen(key: Key('change_password_screen'));
      duration = Duration(milliseconds: 200);
    }

    if (page.state == PageState.ContactUs) {
      screen = ContactUsScreen(key: Key('contact_us_screen'));
      duration = Duration(milliseconds: 200);
    }

    if (page.state == PageState.News) {
      screen = NewsPage(key: Key('news_screen'));
      duration = Duration(milliseconds: 200);
    }

    if (page.state == PageState.Setting) {
      screen = SettingScreen(key: Key('setting_screen'));
      duration = Duration(milliseconds: 200);
    }

    if (page.state == PageState.Graph) {
      screen = GraphScreen(key: Key('graph_screen'));
      duration = Duration(milliseconds: 200);
    }

    if (page.state == PageState.Forecast) {
      screen = ForecastPage(key: Key('forecast_screen'));
      // duration = Duration(milliseconds: 200);
    }

    if (page.state == PageState.BilateralTrade) {
      screen = BilateralTradeScreen(key: Key('bilateral_trade_screen'));
    }

    if (page.state == PageState.BilateralBuy) {
      screen = BilateralBuyScreen(key: Key('bilateral_buy_screen'));
    }

    if (page.state == PageState.BilateralLongTermBuy) {
      screen = BilateralLongTermBuyScreen(
          key: Key('bilateral_long_term_buy_screen'));
    }

    if (page.state == PageState.BilateralLongTermSell) {
      screen = BilateralLongTermSellScreen(
          key: Key('bilateral_long_term_sell_screen'));
    }

    if (page.state == PageState.BilateralShortTermSell) {
      screen = BilateralShortTermSellScreen(
          key: Key('bilateral_short_term_sell_screen'));
    }

    if (page.state == PageState.BilateralSell) {
      screen = BilateralSellScreen(key: Key('bilateral_sell_screen'));
    }

    if (page.state == PageState.PoolMarketTrade) {
      screen = PoolMarketTradeScreen(key: Key('pool_market_screen'));
    }

    if (page.state == PageState.PoolMarketShortTermBuy) {
      screen = PoolMarketShortTermBuyScreen(
          key: Key('pool_market_short_term_buy_screen'));
    }

    if (page.state == PageState.PoolMarketShortTermSell) {
      screen = PoolMarketShortTermSellScreen(
          key: Key('pool_market_short_term_sell_screen'));
    }

    // if (page.state == PageState.Detail) {
    //   screen = SuccessScreen(key: Key('dtail_screen'));
    //   duration = Duration(milliseconds: 200);
    // }

    return AnimatedSwitcher(
      duration: duration,
      child: screen,
      transitionBuilder: buildSlideTransition,
    );
    
  }

  Widget buildSlideTransition(Widget child, Animation<double> animation) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.ease;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }

  

  @override
  void initState() {
    super.initState();
    _initStateListener();
  }

    void _initStateListener() {
    PageStatus page =
        Provider.of<PageStatus>(context, listen: false);

    page.addListener(_whenStateChanged);
  }

    void _whenStateChanged() {
    PageStatus page = Provider.of<PageStatus>(context, listen: false);
     if (page.state == PageState.Signout) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      //TODO:
    }
  }

  // void _initStateListener() {
  //   PageStatus page =
  //       Provider.of<PageStatus>(context, listen: false);

  //   page.addListener(_whenStateChanged);
  // }

  
}
