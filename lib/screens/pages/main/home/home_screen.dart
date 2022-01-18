import 'dart:math';

import 'package:egat_flutter/screens/pages/main/home/billing/billing_page.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/buy_sell_page.dart';
import 'package:egat_flutter/screens/pages/main/home/notification/notification_page.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/settlement_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'main/main_home_page.dart';
import 'states/home_screen_navigation.state.dart';
import 'widgets/page_bottom_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildNavigation(context),
      bottomNavigationBar: PageBottomNavigationBar(),
    );
  }

  Widget _buildNavigation(BuildContext context) {
    final navigationState = Provider.of<HomeScreenNavigationState>(context);
    Widget widget = Container();

    switch (navigationState.currentPage) {
      case HomeScreenNavigationPage.MAIN:
        widget = MainHomePage(key: Key('main_home_screen'));
        break;
      case HomeScreenNavigationPage.BUYSELL:
        widget = BuySellPage(key: Key('buy_sell_screen'));
        break;
      case HomeScreenNavigationPage.SETTLEMENT:
        widget = SettlementPage(key: Key('settlement_screen'));
        break;
      case HomeScreenNavigationPage.BILLING:
        widget = BillingPage(key: Key('billing_screen'));
        break;
      case HomeScreenNavigationPage.NOTIFICATION:
        widget = NotificationPage(key: Key('notification_screen'));
        break;
      default:
        widget = Container(key: Key('main_blank_screen'));
    }

    return widget;
  }
}
