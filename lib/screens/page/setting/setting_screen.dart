import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/page/state/personal_info.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_bottom_navigation_bar.dart';
import 'package:egat_flutter/screens/page/widgets/side_menu.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _formKey = GlobalKey<FormState>();

  String _languageValue = 'English';
  List<String> _languages = ['English', 'Thai'];
  bool _isNotiMessage = false;
  bool _isNotiEmail = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppbar(firstTitle: "", secondTitle: "Setting"), //TODO:
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
            onPressed: null, // null return disabled
            child: Text('Add PIN'),
            style: ElevatedButton.styleFrom(
              elevation: 0,
            ),
          ),
        ),
      ]),
    ]);
  }

  Widget _buildPaymentMethodsSection() {
    //TODO: action
    return Column(children: [
      Align(
          alignment: Alignment.centerLeft,
          child:
              Text('Payment Methods', style: TextStyle(color: primaryColor))),
      ListTile(
        leading: Icon(Icons.payment),
        title: Text('**** **** **** 4146'),
        subtitle: Text('Expire 10/24'),
        trailing: Icon(Icons.delete_outline, color: redColor),
      ),
            ListTile(
        leading: Icon(Icons.payments_outlined),
        title: Text('**** **** **** 1859'),
        subtitle: Text('Expire 04/24'),
        trailing: Icon(Icons.delete_outline, color: redColor),
      ),
      SizedBox(
        child: ElevatedButton(
          onPressed: null, // null return disabled
          child: Text('Add Payment'), //TODO plus icon
          style: ElevatedButton.styleFrom(
            elevation: 0,
          ),
        ),
      )
    ]);
  }

  void _onSubmitPressed() {}
}
