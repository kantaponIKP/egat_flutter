import 'dart:math';

import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/pages/main/setting/addPayment_step_indicator.dart';
import 'package:egat_flutter/screens/pages/main/setting/state/setting_screen_navigation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardPaymentScreen extends StatefulWidget {
  const CardPaymentScreen({Key? key}) : super(key: key);

  @override
  _CardPaymentScreenState createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isValidated = false;
  TextEditingController? _cardNumberController;
  TextEditingController? _expireDateController;
  TextEditingController? _cvvCodeController;

  @override
  void initState() {
    super.initState();

    _cardNumberController = TextEditingController();
    _expireDateController = TextEditingController();
    _cvvCodeController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
         SettingScreenNavigationState settingScreenNavigationState =
        Provider.of<SettingScreenNavigationState>(context, listen: false);
    settingScreenNavigationState.setPageToCardPayment();
    return Scaffold(
      appBar: PageAppbar(
          firstTitle: "",
          secondTitle:
              AppLocalizations.of(context).translate('title-cardPayment')),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // SizedBox(height: 24),

                  _buildTextField(),
                  _buildPaymentMethodsSection(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          Container(height: 90, child: _buildCardNumber()),
          SizedBox(height: 24),
          // _buildSecondLine(),
          Container(
            height: 90,
            child: Row(
              // mainAxisSize: MainAxisSize.max,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                new Flexible(
                  child: _buildExpireDate(),
                ),
                SizedBox(width: 48),
                new Flexible(
                  child: _buildCVVCode(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardNumber() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Card number',
            style: TextStyle(color: primaryColor),
          ),
        ),
        TextFormField(
          controller: _cardNumberController,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.only(top: 20), // add padding to adjust text
            // isDense: true,
            // hintText: "Email",
            prefixIcon: Padding(
              padding: EdgeInsets.only(
                  top: 10, right: 10), // add padding to adjust icon
              // child: Icon(Icons.credit_card,color: whiteColor),
              child: SvgPicture.asset(
                  "assets/images/icons/payment/cardNumber.svg"),
            ),
            counter: Offstage(),
          ),
          maxLength: 20,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Required";
            } else if (value.length < 16) {
              return "Required";
            }
            return null;
          },
          onChanged: (newValue) {
            _setValidated();
          },
        ),
      ],
    );
  }

  Widget _buildExpireDate() {
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Text('Expire Date', style: TextStyle(color: primaryColor))),
        TextFormField(
          controller: _expireDateController,
          inputFormatters: [CardExpireDateFormatter()],
          decoration: InputDecoration(
            counter: Offstage(),
            // contentPadding: EdgeInsets.only(top: 8),
            // border: InputBorder.none,
            hintText: 'MM/YYYY',
          ),
          maxLength: 7,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Required";
            } else if (value.length != 7) {
              return "Required";
            }
            return null;
          },
          onChanged: (newValue) {
            _setValidated();
          },
        ),
      ],
    );
  }

  Widget _buildCVVCode() {
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Text('CVV Code', style: TextStyle(color: primaryColor))),
        Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: TextFormField(
            controller: _cvvCodeController,
            decoration: InputDecoration(
              counter: Offstage(),
              // contentPadding: EdgeInsets.only(top: 8),
              // border: InputBorder.none,
              hintText: '000',
            ),
            maxLength: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Required";
              } else if (value.length != 3) {
                return "Required";
              }
              return null;
            },
            onChanged: (newValue) {
              _setValidated();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodsSection() {
    return Column(
      children: [
        SizedBox(
          child: ElevatedButton(
            onPressed:
                (_isValidated) ? _onAddPressed : null, // null return disabled
            child: Row(
              children: [
                Spacer(),
                Text(AppLocalizations.of(context).translate('payment-add')),
                Spacer(),
              ],
            ),
            style: ElevatedButton.styleFrom(
              elevation: 0,
            ),
          ),
        ),
        SizedBox(
          height: 30.0,
          child: AddPaymentStepIndicator(),
        ),
      ],
    );
  }

  Future<void> _onAddPressed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String cardNumber = _cardNumberController!.text;
    String expireDate = _expireDateController!.text;
    String cvvCode = _cvvCodeController!.text;

    List<String> cards = prefs.getStringList('cards') ?? [];
    cards.add(cardNumber+";"+expireDate+";"+cvvCode);
    print('cards: $cards');
    await prefs.setStringList('cards', cards);
    int count = 0;
    // Navigator.of(context).popUntil((_) => count++ >= 2);
    Navigator.pop(context);
    Navigator.pop(context, true);
  }

  void _setValidated() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isValidated = true;
      });
    } else {
      setState(() {
        _isValidated = false;
      });
    }
  }
}

class CardExpireDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    var selection = newValue.selection;

    if (newValue.selection.baseOffset == newValue.selection.extentOffset) {
      if (newValue.selection.baseOffset == text.length) {
        if (oldValue.text.length == 1 && newValue.text.length == 2) {
          text = text + "/";
          selection = selection.copyWith(
            baseOffset: selection.baseOffset + 1,
            extentOffset: selection.extentOffset + 1,
          );
        }
      }
    }

    var textEnd = min(text.length, 7);
    selection = selection.copyWith(
      baseOffset: min(textEnd, selection.baseOffset),
      extentOffset: min(textEnd, selection.extentOffset),
    );

    return TextEditingValue(
      text: text.toUpperCase().substring(0, textEnd),
      selection: selection,
    );
  }
}
