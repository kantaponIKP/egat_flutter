import 'package:egat_flutter/screens/forgot_password/forgot_password_model.dart';
import 'package:egat_flutter/screens/forgot_password/forgot_password_screen.dart';
import 'package:egat_flutter/screens/forgot_password/state/email.dart';
import 'package:egat_flutter/screens/forgot_password/state/forgot_password_session.dart';
import 'package:egat_flutter/screens/forgot_password/state/forgot_password_status.dart';
import 'package:egat_flutter/screens/forgot_password/state/otp.dart';
import 'package:egat_flutter/screens/forgot_password/state/password.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({
    Key? key,
  }) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  _ForgotPasswordState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return ForgotPasswordModel();
        }),
        ChangeNotifierProxyProvider<ForgotPasswordModel, Email>(
          create: (context) {
            var model =
                Provider.of<ForgotPasswordModel>(context, listen: false);
            return model.email;
          },
          update: (
            BuildContext context,
            ForgotPasswordModel model,
            Email? previous,
          ) {
            return model.email;
          },
        ),
        ChangeNotifierProxyProvider<ForgotPasswordModel, Otp>(
          create: (context) {
            var model =
                Provider.of<ForgotPasswordModel>(context, listen: false);
            return model.otp;
          },
          update: (
            BuildContext context,
            ForgotPasswordModel model,
            Otp? previous,
          ) {
            return model.otp;
          },
        ),
        ChangeNotifierProxyProvider<ForgotPasswordModel, Password>(
          create: (context) {
            var model =
                Provider.of<ForgotPasswordModel>(context, listen: false);
            return model.password;
          },
          update: (
            BuildContext context,
            ForgotPasswordModel model,
            Password? previous,
          ) {
            return model.password;
          },
        ),
        ChangeNotifierProxyProvider<ForgotPasswordModel, ForgotPasswordSession>(
          create: (context) {
            var model =
                Provider.of<ForgotPasswordModel>(context, listen: false);
            return model.session;
          },
          update: (
            BuildContext context,
            ForgotPasswordModel model,
            ForgotPasswordSession? previous,
          ) {
            return model.session;
          },
        ),
        ChangeNotifierProxyProvider<ForgotPasswordModel, ForgotPasswordStatus>(
          create: (context) {
            var model =
                Provider.of<ForgotPasswordModel>(context, listen: false);
            return model.status;
          },
          update: (
            BuildContext context,
            ForgotPasswordModel model,
            ForgotPasswordStatus? previous,
          ) {
            return model.status;
          },
        ),
      ],
      child: ForgotPasswordScreen(),
    );
  }
}
