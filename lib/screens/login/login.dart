import 'package:egat_flutter/screens/login/login_screen.dart';
import 'package:egat_flutter/screens/login/state/login_model.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  Login({
    Key? key,
  }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  _LoginState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
              ChangeNotifierProvider(create: (context) {
          return LoginModel();
        }),
      ],
      child: LoginScreen(),
    );
  }
}
