import 'package:egat_flutter/screens/login/login.dart';
import 'package:flutter/material.dart';

class LoginTextButton extends StatefulWidget {
  const LoginTextButton({ Key? key }) : super(key: key);

  @override
  _LoginTextButtonState createState() => _LoginTextButtonState();
}

class _LoginTextButtonState extends State<LoginTextButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Already have an account ?"),
            TextButton(
              onPressed: () {
                _onRegister(context);
              },
              child: Text('Login',
                  style: TextStyle(color: Theme.of(context).primaryColor)),
            )
          ],
        ),
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