import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/side_menu.dart';
import 'package:egat_flutter/screens/pages/main/setting/state/setting_screen_navigation_state.dart';
import 'package:egat_flutter/screens/pages/main/states/main_screen_title_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SettingMainScreen extends StatefulWidget {
  const SettingMainScreen({Key? key}) : super(key: key);

  @override
  _SettingMainScreenState createState() => _SettingMainScreenState();
}

class _SettingMainScreenState extends State<SettingMainScreen> {
  final _formKey = GlobalKey<FormState>();

  String _languageValue = 'English';
  List<String> _languages = ['English', 'Thai'];
  bool _isNotiMessage = false;
  bool _isNotiEmail = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PageAppbar(
      //     firstTitle: AppLocalizations.of(context).translate('title-setting'),secondTitle: ""
      //   ),
      drawer: NavigationMenuWidget(),
      body: SafeArea(
        child: _buildAction(context),
      ),
    );
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
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 24),
                  _buildLanguageSection(),
                  SizedBox(height: 24),
                  _buildNotificationSection(),
                  SizedBox(height: 24),
                  _buildPinSection(),
                  SizedBox(height: 24),
                  _buildPaymentMethodsSection(),
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
            child:
                Text('Change Language', style: TextStyle(color: primaryColor))),
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
            setState(
              () {
                _languageValue = val.toString();
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildNotificationSection() {
    return Column(children: [
      Align(
          alignment: Alignment.centerLeft,
          child: Text('Notification', style: TextStyle(color: primaryColor))),
      Row(children: [
        Text('Message'),
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
        Text('Email'),
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
    return Column(children: [
      Align(
          alignment: Alignment.centerLeft,
          child: Text('PIN', style: TextStyle(color: primaryColor))),
      Row(children: [
        Text('Message'),
        Spacer(),
        SizedBox(
          child: ElevatedButton(
            onPressed: onAddPinPressed, // null return disabled
            child: Text('Add PIN', style: TextStyle(color: primaryColor)),
            style: ElevatedButton.styleFrom(
              primary: surfaceGreyColor,
              elevation: 0,
            ),
          ),
        ),
      ]),
    ]);
  }

  void onAddPinPressed() {
    var model =
        Provider.of<SettingScreenNavigationState>(context, listen: false);
    model.setPageToChangePin();
    MainScreenTitleState mainScreenTitle =
        Provider.of<MainScreenTitleState>(context, listen: false);
    mainScreenTitle.setTitleTwoTitles(
        title: AppLocalizations.of(context).translate('titlle-changePin-first'),
        secondaryTitle:
            AppLocalizations.of(context).translate('title-changePin-second'));
  }

  void onAddPaymentPressed() {
    var model =
        Provider.of<SettingScreenNavigationState>(context, listen: false);
    model.setPageToAddPayment();
    MainScreenTitleState mainScreenTitle =
        Provider.of<MainScreenTitleState>(context, listen: false);
    mainScreenTitle.setTitleOneTitle(
        title: AppLocalizations.of(context).translate('title-addPayment'));
  }

  Widget _buildPaymentMethodsSection() {
    //TODO: action
    return Column(children: [
      Align(
          alignment: Alignment.centerLeft,
          child:
              Text('Payment Methods', style: TextStyle(color: primaryColor))),
      ListTile(
        leading:
            SvgPicture.asset('assets/images/icons/payment/cardPayment.svg'),
        title: Text('**** **** **** 4146'),
        subtitle: Text('Expire 10/24'),
        trailing: Icon(Icons.delete_outline, color: redColor),
      ),
      ListTile(
        leading:
            SvgPicture.asset('assets/images/icons/payment/cardPayment.svg'),
        title: Text('**** **** **** 1859'),
        subtitle: Text('Expire 04/24'),
        trailing: Icon(Icons.delete_outline, color: redColor),
      ),
      SizedBox(
        child: ElevatedButton(
          onPressed: onAddPaymentPressed, // null return disabled
          child: Container(
            width: 100,
            child: Row(children: [
              Text('Add Payment', style: TextStyle(color: primaryColor)),
              Icon(Icons.add_circle_outline, color: primaryColor, size: 16),
            ]),
          ), //TODO plus icon
          style: ElevatedButton.styleFrom(
            primary: surfaceGreyColor,
            elevation: 0,
          ),
        ),
      )
    ]);
  }
}
