import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_language.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/pages/main/setting/add_payment/add_payment_page.dart';
import 'package:egat_flutter/screens/pages/main/setting/change_pin/change_pin_page.dart';
import 'package:egat_flutter/screens/pages/main/setting/change_pin/states/pin_state.dart';
import 'package:egat_flutter/screens/pages/main/widgets/navigation_menu_widget.dart';
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
  bool _isNotiMessage = false;
  bool _isNotiEmail = true;
  List<String> _cards = [];
  bool _hasPin = false;
  String _pin = "";

  @override
  void initState() {
    super.initState();
    _getCards();
    _getPin();
    _setLanguage();
  }

  Future<void> _getCards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _cards = prefs.getStringList('cards') ?? [];
    });
  }

  void _setLanguage() {
    // Locale _nowLocale = Localizations.localeOf(context);
    // if (_nowLocale.toString() == 'th') {
    //   setState(() {
    //     _languageValue = 'Thai';
    //   });
    // } else {
    //   setState(() {
    //     _languageValue = 'English';
    //   });
    // }
  }

  void _getPin() {
    PinState pinState = Provider.of<PinState>(context, listen: false);
    pinState.getPinFromStorage();
    setState(() {
      _hasPin = pinState.hasPin();
      _pin = pinState.currentPin;
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
        // appBar: PageAppbar(
        //     firstTitle: AppLocalizations.of(context).translate('title-setting'),secondTitle: ""
        //   ),
        drawer: NavigationMenuWidget(),
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
      padding: const EdgeInsets.only(left: 48, right: 48, top: 12, bottom: 6),
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

            // setState(
            //   () {
            //     _languageValue = val.toString();
            //   },
            // );
          },
        ),
      ],
    );
  }

  void _changeLanguage(val) {
    AppLocale locale = Provider.of<AppLocale>(context, listen: false);
    print(val.toString());
    if (val.toString() == "English") {
      locale.changeLanguage(Locale("en"));
    } else {
      locale.changeLanguage(Locale("th"));
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
        Switch(
          activeColor: switchActiveColor,
          value: _isNotiMessage,
          onChanged: (val) {
            setState(
              () {
                _isNotiMessage = !_isNotiMessage;
              },
            );
          },
        )
      ]),
      Row(children: [
        Text(AppLocalizations.of(context)
            .translate('setting-notification-email')),
        Spacer(),
        Switch(
          activeColor: switchActiveColor,
          value: _isNotiEmail,
          onChanged: (val) {
            setState(
              () {
                _isNotiEmail = !_isNotiEmail;
              },
            );
          },
        )
      ])
    ]);
  }

  Widget _buildPinSection() {
    PinState pinState = Provider.of<PinState>(context, listen: false);
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
          const AddPaymentPage(),
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
    // var model =
    //     Provider.of<SettingScreenNavigationState>(context, listen: false);
    // model.setPageToAddPayment();
    // MainScreenTitleState mainScreenTitle =
    //     Provider.of<MainScreenTitleState>(context, listen: false);
    // mainScreenTitle.setTitleOneTitle(
    //     title: AppLocalizations.of(context).translate('title-addPayment'));
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
              String expireDate = 'Expire ' + cardDetail[1];
              return ListTile(
                leading: SvgPicture.asset(
                    'assets/images/icons/payment/cardPayment.svg'),
                title: Text(title),
                subtitle: Text(expireDate),
                trailing: GestureDetector(
                    onTap: () {
                      showAlertDialog(context, index);
                    },
                    child: Icon(Icons.delete_outline, color: redColor)),
              );
            },
          ),
        ),
      ],
    );
  }

  void showAlertDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Do you want to remove this payment method?",
            style: TextStyle(color: blackColor, fontWeight: FontWeight.bold),
          ),
          content: Text(
            "You cannot undo this action.",
            style: TextStyle(color: blackColor),
          ),
          backgroundColor: whiteColor,
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: blackColor),
                )),
            TextButton(
                onPressed: () {
                  _onRemovePressed(index);
                  Navigator.pop(context);
                },
                child: Text(
                  "Remove",
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _cards.removeAt(index);
    prefs.setStringList('cards', _cards);
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
