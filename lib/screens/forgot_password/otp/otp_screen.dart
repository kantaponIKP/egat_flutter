import 'dart:async';

import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/forgot_password/forgot_password_step_indicator.dart';
import 'package:egat_flutter/screens/forgot_password/state/email.dart';
import 'package:egat_flutter/screens/forgot_password/state/otp.dart';
import 'package:egat_flutter/screens/registration/widgets/registration_action.dart';
import 'package:egat_flutter/screens/registration/registration_step_indicator.dart';
import 'package:egat_flutter/screens/registration/widgets/signup_appbar.dart';
import 'package:egat_flutter/screens/registration/widgets/login_text_button.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatefulWidget {
  OtpScreen({Key? key}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _pinController;
  Timer? _timer;
  int _countdown = 20;
  bool _validated = false;

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pinController = TextEditingController();
    _sendOTP();

    // startTimer();
  }

  void startTimer() {
    //todo: memory leak
    const tenSecond = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      tenSecond,
      (Timer timer) {
        if (_countdown == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          if (mounted) {
            setState(() {
              _countdown--;
            });
          }else{
            _timer!.cancel();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            // TODO
            // backgroundBlendMode: ,
            image: DecorationImage(
                image: AssetImage("assets/images/register_background.png")),
            gradient: RadialGradient(colors: [
              Color(0xFF303030),
              Colors.black,
            ])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          appBar: SignupAppbar(
              firstTitle: '${AppLocalizations.of(context).translate('forgotPassword-first')}',
              secondTitle:
                  '${AppLocalizations.of(context).translate('forgotPassword-second')}',
              onAction: _onBackPressed),
          body: SafeArea(
            child: _buildAction(context),
          ),
        ));
  }

  Padding _buildAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32, bottom: 16),
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
                  Column(
                    children: [
                      _buildForm(),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 48.0),
                      //   child: _buildTimer(),
                      // ),
                      Padding(
                        padding: EdgeInsets.only(top: 64.0),
                        child: _buildOTPPin(constraints),
                      ),
                      // _buildResendOTP(),
                    ],
                  ),
                  Column(
                    children: [
                      RegistrationAction(
                          actionLabel: Text(
                              '${AppLocalizations.of(context).translate('next')}'),
                          onAction: (_formKey.currentState != null)
                              ? (_validated)
                                  ? _onNextPressed
                                  : null
                              : null),
                      SizedBox(
                        height: 30.0,
                        child: ForgotPasswordStepIndicator(),
                      ),
                      SizedBox(
                        height: 20.0,
                        child: LoginTextButton(),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOTPPin(BoxConstraints constraints) {
    double containerWidth = 0;
    double otpFieldWidth = 50; //default from widgets

    if (constraints.maxWidth > 361) {
      containerWidth = 425;
      otpFieldWidth = otpFieldWidth + (containerWidth * 0.02);
    } else {
      containerWidth = constraints.maxWidth;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Form(
        key: _formKey,
        child: Container(
          constraints: BoxConstraints(
            minWidth: containerWidth,
            maxWidth: containerWidth,
          ),
          child: PinCodeTextField(
            textStyle: TextStyle(color: Colors.black),
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              activeColor: Theme.of(context).textTheme.bodyText2!.color,
              selectedColor: Theme.of(context).primaryColor,
              inactiveColor: Theme.of(context).textTheme.bodyText2!.color,
            ),
            boxShadows: [
              BoxShadow(
                color: Colors.white,
              )
            ],
            inputFormatters: [],
            keyboardType: TextInputType.numberWithOptions(
              signed: false,
              decimal: false,
            ),
            length: 6,
            onChanged: (value) {
              setState(() {
                _validated = false;
              });
            },
            onCompleted: (v) {
              setState(() {
                _validated = true;
              });
            },
            validator: (value) {
              if (value == null) {
                return "Must be number 6 digits";
              }

              if (value.trim().length != 6) {
                return "Must be number 6 digits";
              }

              if (!_isNumeric(value)) {
                return "Must be number 6 digits";
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

  Widget _buildTimer() {
    return Container(
        child: Align(
      alignment: Alignment.center,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
                text: '${AppLocalizations.of(context).translate('otp-sent')}'),
            (_countdown > 0)
                ? TextSpan(text: '(' + _countdown.toString() + 's)')
                : TextSpan(text: ''),
          ],
        ),
      ),
    ));
  }

  Widget _buildForm() {
    var email = Provider.of<Email>(context, listen: false);
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text.rich(
            TextSpan(
              text:
                  '${AppLocalizations.of(context).translate('enter-OTP-code')}',
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:
                      '${AppLocalizations.of(context).translate('otp-has-been-sent-email')}',
                ),
                TextSpan(
                  text: ' (${email.info.email})',
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget _buildResendOTP() {
  //   if (_countdown == 0) {
  //     return Container(
  //       child: RichText(
  //         text: TextSpan(
  //           text: '${AppLocalizations.of(context).translate('resend-OTP')}',
  //           style: TextStyle(
  //             decoration: TextDecoration.underline,
  //             color: textButton,
  //           ),
  //           recognizer: TapGestureRecognizer()
  //             ..onTap = () {
  //               _onResendOTPPressed(context);
  //             },
  //         ),
  //       ),
  //     );
  //   } else {
  //     return Container(
  //       child: RichText(
  //         text: TextSpan(
  //           text: '${AppLocalizations.of(context).translate('resend-OTP')}',
  //           style: TextStyle(
  //             decoration: TextDecoration.underline,
  //             color: Theme.of(context).disabledColor,
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  // }

  bool _isNumeric(String string) {
    final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

    return numericRegex.hasMatch(string);
  }

  // void _onResendOTPPressed(context) {
  //   _sendOTP();
  //   logger.d('call resend OTP');
  // }

  void _sendOTP() async {
    // FocusScope.of(context).unfocus();
    setState(() {
      _countdown = 20;
    });
    startTimer();

    await showLoading();

    try {
      var otp = Provider.of<Otp>(context, listen: false);

      // await otp.submitFirstTimeOtp();
      await otp.sendOtp();
    } catch (e) {
      showIntlException(context, e);
    } finally {
      await hideLoading();
    }
  }

  void _onNextPressed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    await showLoading();

    try {
      var otp = Provider.of<Otp>(context, listen: false);
      //   // await otp.submitFirstTimeOtp();
      await otp.submitOtp(_pinController!.text);
      _timer!.cancel();
      otp.nextPage();
    } catch (e) {
      showIntlException(context, e);
    } finally {
      await hideLoading();
    }
  }

  void _onBackPressed() {
    var model = Provider.of<Otp>(context, listen: false);
    model.backPage();
  }
}
