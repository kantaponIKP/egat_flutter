import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/login/login.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginTextButton extends StatefulWidget {
  const LoginTextButton({Key? key}) : super(key: key);

  @override
  _LoginTextButtonState createState() => _LoginTextButtonState();
}

class _LoginTextButtonState extends State<LoginTextButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      '${AppLocalizations.of(context).translate('already-have-an-account')}',
                  style: TextStyle(fontSize: 16),
                ),
                WidgetSpan(child: Container(padding: EdgeInsets.only(left: 8))),
                TextSpan(
                  text: '${AppLocalizations.of(context).translate('login')}',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 16),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      _onRegister(context);
                    },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _onRegister(BuildContext context) {
    // Navigator.of(context).popUntil((route) => false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Login(),
      ),
      (route) => false,
    );
  }
}
