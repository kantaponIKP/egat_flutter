import 'package:egat_flutter/screens/forgot_password/email/email_screen.dart';
import 'package:egat_flutter/screens/forgot_password/password/password_screen.dart';
import 'package:egat_flutter/screens/forgot_password/state/forgot_password_status.dart';
import 'package:egat_flutter/screens/forgot_password/otp/otp_screen.dart';
import 'package:egat_flutter/screens/registration/success/success_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    ForgotPasswordStatus forgotPassword =
        Provider.of<ForgotPasswordStatus>(context);

    Widget screen = Container();
    Duration duration = Duration.zero;

    if (forgotPassword.state == ForgotPasswordState.Email) {
      screen = EmailScreen(key: Key('email_screen'));
      duration = Duration(milliseconds: 200);
    }

    if (forgotPassword.state == ForgotPasswordState.Otp) {
      screen = OtpScreen(key: Key('otp_screen'));
      duration = Duration(milliseconds: 200);
    }

    if (forgotPassword.state == ForgotPasswordState.Password) {
      screen = PasswordScreen(key: Key('password_screen'));
      duration = Duration(milliseconds: 200);
    }

    return AnimatedSwitcher(
      duration: duration,
      child: screen,
      transitionBuilder: buildSlideTransition,
    );
  }

  Widget buildSlideTransition(Widget child, Animation<double> animation) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.ease;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }

  @override
  void initState() {
    super.initState();

    _initStateListener();
  }

  void _initStateListener() {
    ForgotPasswordStatus forgotPassword =
        Provider.of<ForgotPasswordStatus>(context, listen: false);

    forgotPassword.addListener(_whenStateChanged);
  }

  void _whenStateChanged() {
    ForgotPasswordStatus forgotPassword =
        Provider.of<ForgotPasswordStatus>(context, listen: false);
    if (forgotPassword.state == ForgotPasswordState.Dismiss) {
      Navigator.of(context).pop();
    }
  }
}
