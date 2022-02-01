import 'dart:async';
import 'dart:io';

import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_language.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/pages/main/setting/add_payment/add_payment_screen.dart';
import 'package:egat_flutter/screens/pages/main/setting/change_pin/change_pin_page.dart';
import 'package:egat_flutter/screens/pages/main/setting/change_pin/states/pin_state.dart';
import 'package:egat_flutter/screens/pages/main/setting/state/notification_state.dart';
import 'package:egat_flutter/screens/pages/main/states/main_screen_title_state.dart';
import 'package:egat_flutter/screens/pages/main/widgets/navigation_menu_widget.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingMainScreen extends StatefulWidget {
  const SettingMainScreen({Key? key}) : super(key: key);

  @override
  _SettingMainScreenState createState() => _SettingMainScreenState();
}

class _SettingMainScreenState extends State<SettingMainScreen> {
  final _formKey = GlobalKey<FormState>();

  String _languageValue = 'English';
  List<String> _languages = ['English', 'ไทย'];
  bool? _receiveMessage;
  bool _isNotiEmail = true;
  List<String> _cards = [];

  @override
  void initState() {
    super.initState();
    _getCards();
    _getPin();
    _getReceiveNotification();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getReceiveNotificationFromState();
    _setTitle();
    // _getPin();
  }

  void _setTitle() {
    MainScreenTitleState mainScreenTitle =
        Provider.of<MainScreenTitleState>(context, listen: false);
    mainScreenTitle.setTitleOneTitle(
        title: AppLocalizations.of(context).translate('title-setting'));
  }

  void _getReceiveNotificationFromState() {
    NotificationState notificationState =
        Provider.of<NotificationState>(context);
    setState(() {
      _receiveMessage = notificationState.currentReceiveMessage;
    });
  }

  Future<void> _getCards() async {
    LoginSession login = Provider.of<LoginSession>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _cards = prefs.getStringList('cards-${login.info!.userId}') ?? [];
    });
  }

  Future<void> _getPin() async {
    PinState pinState = Provider.of<PinState>(context, listen: false);
    // pinState.getPinFromStorage();
    pinState.getPinFromStorage();
  }

  void _getReceiveNotification() {
    NotificationState notificationState =
        Provider.of<NotificationState>(context, listen: false);
    notificationState.getReceiveMessageFromStorage();
    setState(() {
      _receiveMessage = notificationState.currentReceiveMessage;
    });
  }

  void _setReceiveNotification(bool receiveMessage) {
    NotificationState notificationState =
        Provider.of<NotificationState>(context, listen: false);
    notificationState.setReceiveMessageToStorage(
        receiveMessage: receiveMessage);
    setState(() {
      _receiveMessage = receiveMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    Locale _nowLocale = Localizations.localeOf(context);
    if (_nowLocale.toString() == 'th') {
      setState(() {
        _languageValue = 'ไทย';
      });
    } else {
      setState(() {
        _languageValue = 'English';
      });
    }
    return Scaffold(
        body: SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color(0xFF303030),
              Colors.black,
            ],
          ),
        ),
        child: _buildAction(context),
      ),
    ));
  }

  Padding _buildAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 6),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildLanguageSection(),
                  _buildNotificationSection(),
                  _buildPinSection(),
                  _buildPaymentMethodsSection(constraints),
                  _buildAddPayment(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLanguageSection() {
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
                AppLocalizations.of(context)
                    .translate('setting-changeLanguage'),
                style: TextStyle(color: primaryColor))),
        DropdownButton(
          isExpanded: true,
          value: _languageValue,
          iconSize: 30.0,
          items: _languages.map(
            (val) {
              return DropdownMenuItem<String>(
                value: val,
                child: Text(val),
              );
            },
          ).toList(),
          onChanged: (val) {
            _changeLanguage(val);
          },
        ),
      ],
    );
  }

  Future<void> _changeLanguage(val) async {
    AppLocale locale = Provider.of<AppLocale>(context, listen: false);
    await showLoading();
    try {
      if (val.toString() == "English") {
        locale.changeLanguage(Locale("en"), context);
      } else {
        locale.changeLanguage(Locale("th"), context);
      }
    } catch (e) {
      showException(context, e.toString());
    } finally {
      await hideLoading();
    }

    //   _setLanguage();
  }

  Widget _buildNotificationSection() {
    return Column(children: [
      Align(
          alignment: Alignment.centerLeft,
          child: Text(
              AppLocalizations.of(context).translate('setting-notification'),
              style: TextStyle(color: primaryColor))),
      Row(children: [
        Text(AppLocalizations.of(context)
            .translate('setting-notification-message')),
        Spacer(),
        _buildReceiveNotificationSwitch(context),
      ]),
      Row(children: [
        Text(AppLocalizations.of(context)
            .translate('setting-notification-email')),
        Spacer(),
        _buildReceiveEmailSwitch(context),
      ])
    ]);
  }

  Widget _buildReceiveNotificationSwitch(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoSwitch(
        trackColor: disabledColor,
        value: _receiveMessage!,
        onChanged: (val) {
          setState(
            () {
              _setReceiveNotification(val);
            },
          );
        },
      );
    } else {
      return Switch(
        activeColor: switchActiveColor,
        inactiveTrackColor: disabledColor,
        activeTrackColor: Colors.green[100],
        value: _receiveMessage!,
        onChanged: (val) {
          setState(
            () {
              _setReceiveNotification(val);
            },
          );
        },
      );
    }
  }

  Widget _buildReceiveEmailSwitch(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoSwitch(
        trackColor: disabledColor,
        value: _isNotiEmail,
        onChanged: (val) {
          setState(
            () {
              _isNotiEmail = !_isNotiEmail;
            },
          );
        },
      );
    } else {
      return Switch(
        activeColor: switchActiveColor,
        activeTrackColor: Colors.green[100],
        inactiveTrackColor: disabledColor,
        value: _isNotiEmail,
        onChanged: (val) {
          setState(
            () {
              _isNotiEmail = !_isNotiEmail;
            },
          );
        },
      );
    }
  }

  Widget _buildPinSection() {
    PinState pinState = Provider.of<PinState>(context, listen: true);
    return Column(children: [
      Align(
          alignment: Alignment.centerLeft,
          child: Text('PIN', style: TextStyle(color: primaryColor))),
      Row(children: [
        _buildPinMessage(hasPin: pinState.hasPin()),
        Spacer(),
        SizedBox(
          child: ElevatedButton(
            onPressed: onAddPinPressed, // null return disabled
            child: Text(
                (pinState.hasPin())
                    ? AppLocalizations.of(context).translate('setting-editPin')
                    : AppLocalizations.of(context).translate('setting-addPin'),
                style: TextStyle(color: primaryColor)),
            style: ElevatedButton.styleFrom(
              primary: surfaceGreyColor,
              elevation: 0,
            ),
          ),
        ),
      ]),
    ]);
  }

  Widget _buildPinMessage({required bool hasPin}) {
    String message = "";
    if (hasPin == true) {
      return Text("******");
    } else {
      message = AppLocalizations.of(context).translate('pin-register');
    }
    return Text(message);
  }

  Future<void> onAddPinPressed() async {
    final result =
        await Navigator.of(context).push(_createChangePinPageRoute());

    if (result != null && result) {
      _getPin();
    }
  }

  Route _createChangePinPageRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const ChangePinPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  Route _createAddPaymentPageRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const AddPaymentScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  Future<void> onAddPaymentPressed() async {
    final result =
        await Navigator.of(context).push(_createAddPaymentPageRoute());

    if (result != null && result) {
      _getCards();
    }
  }

  Widget _buildPaymentMethodsSection(constraints) {
    //TODO: action
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            AppLocalizations.of(context).translate('setting-paymentMethods'),
            style: TextStyle(color: primaryColor),
          ),
        ),
        Container(
          height: constraints.maxHeight - 420,
          child: ListView.builder(
            itemCount: _cards.length,
            itemBuilder: (context, index) {
              final card = _cards[index];
              final cardDetail = card.split(";");
              String title =
                  cardDetail[0].replaceRange(0, 12, "**** **** **** ");
              String expireDate =
                  AppLocalizations.of(context).translate('setting-expire') +
                      ' ' +
                      cardDetail[1];
              return ListTile(
                  leading: SvgPicture.asset(
                      'assets/images/icons/payment/cardPayment.svg'),
                  title: Text(title),
                  subtitle: Text(
                    expireDate,
                    style: TextStyle(color: whiteColor.withAlpha(160)),
                  ),
                  trailing:
                      // GestureDetector(
                      //     onTap: () {
                      //       onRemovePressed(context, index);
                      //     },
                      //     child:
                      IconButton(
                    icon: Icon(Icons.delete_outline),
                    color: redColor,
                    onPressed: () {
                      onRemovePressed(context, index);
                    },
                  ));
              // );
            },
          ),
        ),
      ],
    );
  }

  void onRemovePressed(BuildContext context, int index) {
    if (Platform.isIOS) {
      showIOSAlertDialog(context, index);
    } else {
      showAndriodAlertDialog(context, index);
    }
  }

  showAndriodAlertDialog(BuildContext context, int index) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => buildAndroidAlerDialog(context, index),
    );
  }

  showIOSAlertDialog(BuildContext context, int index) {
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => buildIOSAlerDialog(context, index),
    );
  }

  Widget buildIOSAlerDialog(BuildContext context, int index) {
    return CupertinoAlertDialog(
      title: new Text(
        AppLocalizations.of(context).translate('message-removePayment-title'),
      ),
      content: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: new Text(
          AppLocalizations.of(context)
              .translate('message-removePayment-content'),
        ),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: Text(
            AppLocalizations.of(context)
                .translate('message-removePayment-cancel'),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        CupertinoDialogAction(
          child: Text(
            AppLocalizations.of(context)
                .translate('message-removePayment-remove'),
          ),
          isDestructiveAction: true,
          onPressed: () {
            _onRemovePressed(index);
            Navigator.pop(context);
          },
        )
      ],
    );
  }

  Widget buildAndroidAlerDialog(BuildContext context, int index) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context).translate('message-removePayment-title'),
        style: TextStyle(
            color: blackColor, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: Text(
        AppLocalizations.of(context).translate('message-removePayment-content'),
        style: TextStyle(color: blackColor),
      ),
      backgroundColor: whiteColor,
      actionsAlignment: MainAxisAlignment.end,
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context)
                  .translate('message-removePayment-cancel'),
              style: TextStyle(color: blackColor),
            )),
        TextButton(
            onPressed: () {
              _onRemovePressed(index);
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context)
                  .translate('message-removePayment-remove'),
              style: TextStyle(color: redColor),
            )),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  void showAlertDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)
                .translate('message-removePayment-title'),
            style: TextStyle(
                color: blackColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Text(
            AppLocalizations.of(context)
                .translate('message-removePayment-content'),
            style: TextStyle(color: blackColor),
          ),
          backgroundColor: whiteColor,
          actionsAlignment: MainAxisAlignment.end,
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  AppLocalizations.of(context)
                      .translate('message-removePayment-cancel'),
                  style: TextStyle(color: blackColor),
                )),
            TextButton(
                onPressed: () {
                  _onRemovePressed(index);
                  Navigator.pop(context);
                },
                child: Text(
                  AppLocalizations.of(context)
                      .translate('message-removePayment-remove'),
                  style: TextStyle(color: redColor),
                )),
          ],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        );
      },
    );
  }

  Future<void> _onRemovePressed(int index) async {
    LoginSession login = Provider.of<LoginSession>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _cards.removeAt(index);
    prefs.setStringList('cards-${login.info!.userId}', _cards);
    prefs.reload();
    _getCards();
  }

  Widget _buildAddPayment() {
    return SizedBox(
      child: ElevatedButton(
        onPressed: onAddPaymentPressed, // null return disabled
        child: Container(
          width: 120,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Text(AppLocalizations.of(context).translate('payment-addPayment'),
                style: TextStyle(color: primaryColor)),
            Icon(Icons.add_circle_outline, color: primaryColor, size: 16),
          ]),
        ), //TODO plus icon
        style: ElevatedButton.styleFrom(
          primary: surfaceGreyColor,
          elevation: 0,
        ),
      ),
    );
  }
}
