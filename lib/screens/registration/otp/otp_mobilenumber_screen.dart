import 'dart:math';

import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/registration/otp/otp_pin_screen.dart';
import 'package:egat_flutter/screens/registration/registration_action.dart';
import 'package:egat_flutter/screens/registration/registration_screen.dart';
import 'package:egat_flutter/screens/registration/registration_step_indicator.dart';
import 'package:egat_flutter/screens/registration/state/otp.dart';
import 'package:egat_flutter/screens/registration/state/registration_session.dart';
import 'package:egat_flutter/screens/registration/widgets/login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpMobileNumberScreen extends StatefulWidget {
  OtpMobileNumberScreen({Key? key}) : super(key: key);

  @override
  _OtpMobileNumberScreenState createState() => _OtpMobileNumberScreenState();
}

class _OtpMobileNumberScreenState extends State<OtpMobileNumberScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _pinController;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: RadialGradient(colors: [
          Color(0xFF303030),
          Colors.black,
        ])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          appBar: _buildAppbar(context),
          body: SafeArea(
            child: _buildAction(context),
          ),
        ));
  }

  Padding _buildAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32, bottom: 16),
      child: Column(
        children: [
          _buildForm(),
          Spacer(),
          _buildTimer(),
          SizedBox(height: 16),
          _buildOTPPin(),
          _buildResendOTP(),
          Spacer(),
          RegistrationAction(
            actionLabel: const Text("Sign up"),
            onAction: _onSubmit,
          ),
          LoginButton()
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  AppBar _buildAppbar(BuildContext context) {
    return AppBar(
      title: Text("Back",
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText2!.color,
            fontSize: 16,
          ),
          textAlign: TextAlign.left),
      leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).textTheme.bodyText2!.color),
          onPressed: () => Navigator.pop(context)),
      centerTitle: false,
      titleSpacing: 0.0,
      leadingWidth: 32,
      elevation: 0,
      backgroundColor: Colors.transparent,
      bottom: PreferredSize(
          child: Container(
              padding: const EdgeInsets.only(left: 32, right: 32, bottom: 16),
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  // style: DefaultTextStyle.of(context).style,
                  style: TextStyle(fontSize: 30),
                  children: <TextSpan>[
                    TextSpan(text: 'Create'),
                    TextSpan(
                        text: ' Account',
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                  ],
                ),
              )),
          preferredSize: Size.fromHeight(50)),
    );
  }

  Widget _buildOTPPin() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
        onChanged: (String value) {},
        appContext: context,
      ),
    );
  }

  Widget _buildTimer() {
    return Container(
        child: Align(
      alignment: Alignment.center,
      child: Text.rich(
        TextSpan(
          text: "OTP sent (20s)",
        ),
      ),
    ));
  }

  Widget _buildForm() {
    // var session = Provider.of<RegistrationSession>(context);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(
                text: "Enter OTP Code",
              ),
            ),
          ),
          SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(
                text:
                    "One Time Password (OTP) has been sent to your mobile number. ()",
                // TODO
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResendOTP() {
    return Container(
        child: TextButton(
      onPressed: () {
        _onResendOTPPressed(context);
      },
      child: const Text(
        'Resend OTP',
        style: TextStyle(
          decoration: TextDecoration.underline,
        ),
      ),
    ));
  }

  Widget _buildMobilePhoneLogo() {
    return FittedBox(child: Icon(Icons.sms, color: Colors.indigo.shade700));
  }

  bool _isNumeric(String string) {
    final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

    return numericRegex.hasMatch(string);
  }

  void _onResendOTPPressed(context) {}

  void _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();

    await showLoading();

    try {
      var otp = Provider.of<Otp>(context, listen: false);

      await otp.submitFirstTimeOtp();
    } catch (e) {
      showException(context, e.toString());
    } finally {
      await hideLoading();
    }
  }
}
