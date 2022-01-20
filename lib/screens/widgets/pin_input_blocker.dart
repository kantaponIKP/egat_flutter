import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/errors/IntlException.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/pages/main/setting/change_pin/change_pin_page.dart';
import 'package:egat_flutter/screens/pages/main/setting/change_pin/states/change_pin_state.dart';
import 'package:egat_flutter/screens/pages/main/setting/change_pin/states/pin_state.dart';
import 'package:egat_flutter/screens/pages/main/widgets/navigation_menu_widget.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

class PinInputBlocker extends StatefulWidget {
  const PinInputBlocker({Key? key}) : super(key: key);

  static Future<bool?> pushTo(BuildContext context) async {
    final pinState = Provider.of<PinState>(context, listen: false);

    if (!pinState.hasPin()) {
      await Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const ChangePinPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
                position: animation.drive(tween), child: child);
          },
        ),
      );
    }

    if (!pinState.hasPin()) {
      return false;
    }

    return await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => PinInputBlocker(),
      ),
    );
  }

  @override
  _PinInputBlockerState createState() => _PinInputBlockerState();
}

class _PinInputBlockerState extends State<PinInputBlocker> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController? _pinController;
  double buttonSize = 60.0;
  String _title = "";
  String _newPin = "";

  @override
  void initState() {
    super.initState();
    _pinController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setTitle();
  }

  void _setTitle() {
    final appLocalizations = AppLocalizations.of(context);
    Future.delayed(Duration.zero).then((value) {
      setState(() {
        _title = appLocalizations.translate('setting-pin-enterYourCurrentPin');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppbar(firstTitle: '', secondTitle: ""),
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      Text('Enter your PIN'),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 16.0, left: 34.0, right: 34.0),
                        child: _buildOTPPin(constraints),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: _buildNumberpad(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void handleState() {
    PinState pinState = Provider.of<PinState>(context, listen: false);

    if (pinState.verifyPin(_pinController!.text)) {
      Navigator.of(context).pop(true);
    } else {
      showIntlException(
        context,
        IntlException(
          message: "Error",
          intlMessage: "error-incorrectInformationError",
        ),
      );
    }

    _pinController!.clear();
  }

  Widget _buttonWidget(String buttonText) {
    return Container(
      height: buttonSize,
      width: buttonSize,
      child: RaisedButton(
        color: greyColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonSize / 2),
        ),
        focusColor: surfaceGreyColor,
        hoverColor: surfaceGreyColor,
        highlightColor: surfaceGreyColor,
        onPressed: () {
          if (_pinController!.text.length < 6) {
            _pinController!.text = _pinController!.text + buttonText;
          }
        },
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
          ),
        ),
      ),
    );
  }

  Widget _buildNumberpad() {
    return Column(
      children: [
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buttonWidget('1'),
            _buttonWidget('2'),
            _buttonWidget('3'),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buttonWidget('4'),
            _buttonWidget('5'),
            _buttonWidget('6'),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buttonWidget('7'),
            _buttonWidget('8'),
            _buttonWidget('9'),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(width: buttonSize),
            // buttonWidget('0'),
            _buttonWidget('0'),
            iconButtonWidget(Icons.backspace_outlined)
          ],
        ),
      ],
    );
  }

  void removePIN() {
    if (_pinController!.text.length > 0) {
      _pinController!.text =
          _pinController!.text.substring(0, _pinController!.text.length - 1);
    }
  }

  Widget iconButtonWidget(IconData icon) {
    // double buttonSize = 60.0;
    return InkWell(
      onTap: removePIN,
      child: Container(
        height: buttonSize,
        width: buttonSize,
        child: Center(
          child: Icon(
            icon,
            size: 30,
            //  color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildOTPPin(BoxConstraints constraints) {
    double containerWidth = 0;
    double otpFieldWidth = 25; //default from widgets

    if (constraints.maxWidth > 361) {
      containerWidth = 425;
      otpFieldWidth = otpFieldWidth + (containerWidth * 0.02);
    } else {
      containerWidth = constraints.maxWidth;
    }
    // logger.d(
    //     'constraints max width: ${constraints.maxWidth} | containerWidth: ${containerWidth}, constraints minx width: ${constraints.minWidth} , otpFieldWidth : ${otpFieldWidth}');
    // logger.d('width size ${MediaQuery.of(context).size.width} constraints : ${constraints.maxWidth}');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Container(
          constraints: BoxConstraints(
            minWidth: containerWidth,
            maxWidth: containerWidth,
          ),
          child: PinCodeTextField(
            // enabled: false,

            // autoDismissKeyboard: false,
            // enableInteractiveSelection: ,
            enableActiveFill: true,
            textStyle: TextStyle(color: Colors.transparent),
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.circle,
              activeColor: Theme.of(context).primaryColor,
              activeFillColor: Theme.of(context).primaryColor,
              inactiveFillColor: Colors.transparent,
              selectedFillColor: Colors.transparent,
              selectedColor: Theme.of(context).primaryColor,
              inactiveColor: Theme.of(context).primaryColor,

              // fieldHeight: otpBoxWidth,
              fieldWidth: otpFieldWidth,
              // fieldOuterPadding: EdgeInsets.fromLTRB(0, 5,0,50),
            ),
            // boxShadows: [

            //   BoxShadow(
            //     color: backgroundColor,
            //   ),
            //                 BoxShadow(
            //     color: whiteColor,
            //   )
            // ],
            inputFormatters: [],
            keyboardType: TextInputType.numberWithOptions(
              signed: false,
              decimal: false,
            ),
            length: 6,
            onChanged: (value) {
              // setState(() {
              //   _validated = false;
              // });
            },
            onCompleted: (v) {
              handleState();
              // setState(() {
              //   _validated = true;
              // });
            },
            validator: (value) {
              if (value == null) {
                return "";
              }

              if (value.trim().length != 6) {
                return "";
              }

              if (!_isNumeric(value)) {
                return "";
              }
              return null;
            },
            controller: _pinController,
            appContext: context,
          ),
        ),
      ),
    );
  }

  bool _isNumeric(String string) {
    final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

    return numericRegex.hasMatch(string);
  }

  void _onSubmitPressed() {}
}
