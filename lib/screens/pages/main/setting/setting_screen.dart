import 'package:egat_flutter/screens/pages/main/setting/add_payment/add_payment_screen.dart';
import 'package:egat_flutter/screens/pages/main/setting/card_payment/card_payment_screen.dart';
import 'package:egat_flutter/screens/pages/main/setting/change_pin/change_pin_screen.dart';
import 'package:egat_flutter/screens/pages/main/setting/main/main_screen.dart';
import 'package:egat_flutter/screens/pages/main/setting/state/setting_screen_navigation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

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
      // bottomNavigationBar: PageBottomNavigationBar(),
    );
  }

  Widget _buildNavigation(BuildContext context) {
    final navigationState = Provider.of<SettingScreenNavigationState>(context);
    Widget widget = Container();

    switch (navigationState.currentPage) {
      case SettingScreenNavigationPage.MAIN:
        widget = SettingMainScreen(key: Key('main_screen'));
        break;
      case SettingScreenNavigationPage.ADD_PAYMENT:
        widget = AddPaymentScreen(key: Key('add_payment_screen'));
        break;
      case SettingScreenNavigationPage.CARD_PAYMENT:
        widget = CardPaymentScreen(key: Key('card_payment_screen'));
        break;
      case SettingScreenNavigationPage.CHANGE_PIN:
        widget = ChangePinScreen(key: Key('change_pin_screen'));
        break;
      default:
        widget = Container(key: Key('main_blank_screen'));
    }

    return widget;
  }
}
