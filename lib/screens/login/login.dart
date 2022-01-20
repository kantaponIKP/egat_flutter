import 'package:egat_flutter/screens/login/login_screen.dart';
import 'package:egat_flutter/screens/login/state/login_model.dart';
import 'package:egat_flutter/screens/session.dart';
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
        ChangeNotifierProxyProvider<LoginSession, LoginModel>(
          create: (context) {
            LoginSession session =
                Provider.of<LoginSession>(context, listen: false);
            return LoginModel(loginSession: session);
          },
          update: (
            BuildContext context,
            LoginSession model,
            LoginModel? previous,
          ) {
            if (previous == null) {
              LoginSession session =
                  Provider.of<LoginSession>(context, listen: false);
              return LoginModel(loginSession: session);
            } else {
              previous.setSession(model);
              return previous;
            }
          },
        ),
        // ChangeNotifierProxyProvider<LoginSession, PersonalInfoState>(
        //   create: (_) => PersonalInfoState(),
        //   update: (_, loginSession, personalInfoState) {
        //     if (personalInfoState == null) {
        //       personalInfoState = PersonalInfoState();
        //     }

        //     return personalInfoState..setLoginSession(loginSession);
        //   },
        // ),
      ],
      child: LoginScreen(),
    );
  }
}
