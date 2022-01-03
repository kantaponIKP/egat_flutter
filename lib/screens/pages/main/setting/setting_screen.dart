import 'dart:math';

import 'package:egat_flutter/screens/pages/main/home/billing/billing_page.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/buy_sell_page.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/settlement_page.dart';
import 'package:egat_flutter/screens/pages/main/setting/main/main_setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'states/setting_screen_navigation.state.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildNavigation(context),
    );
  }

  Widget _buildNavigation(BuildContext context) {
    final navigationState = Provider.of<SettingScreenNavigationState>(context);
    Widget widget = Container();

    switch (navigationState.currentPage) {
      case SettingScreenNavigationPage.MAIN:
        widget = MainSettingScreen(key: Key('main_setting_screen'));
        break;
      // case SettingScreenNavigationPage.ADD_PAYMENT:
      //   widget = BuySellPage(key: Key('buy_sell_screen'));
      //   break;
      // case SettingScreenNavigationPage.CHANGE_PIN:
      //   widget = SettlementPage(key: Key('settlement_screen'));
      //   break;
      default:
        widget = Container(key: Key('main_blank_screen'));
    }

    return widget;
  }
}
