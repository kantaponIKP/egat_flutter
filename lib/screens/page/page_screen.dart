import 'package:egat_flutter/screens/page/change_password/change_password_screen.dart';
import 'package:egat_flutter/screens/page/contact_us/contact_us_screen.dart';
import 'package:egat_flutter/screens/page/graph/graph_screen.dart';
import 'package:egat_flutter/screens/page/home/home_screen.dart';
import 'package:egat_flutter/screens/page/news/news_screen.dart';
import 'package:egat_flutter/screens/page/personal_info/personal_info_screen.dart';
import 'package:egat_flutter/screens/page/setting/setting_screen.dart';
import 'package:egat_flutter/screens/page/state/page_status.dart';
import 'package:egat_flutter/screens/page/trade/trade_screen.dart';
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
      screen = HomeScreen(key: Key('home_screen'));
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
      screen = NewsScreen(key: Key('news_screen'));
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

    if (page.state == PageState.Trade) {
      screen = TradeScreen(key: Key('trade_screen'));
      // duration = Duration(milliseconds: 200);
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

    // _initStateListener();
  }

  // void _initStateListener() {
  //   PageStatus page =
  //       Provider.of<PageStatus>(context, listen: false);

  //   page.addListener(_whenStateChanged);
  // }

  // void _whenStateChanged() {
  //   PageStatus page =
  //       Provider.of<PageStatus>(context, listen: false);
  //   if (page.state == PageState.ChangePassword) {
  //     Navigator.of(context).pop();
  //   }
  // }
}
