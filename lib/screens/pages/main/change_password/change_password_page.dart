
import 'package:egat_flutter/screens/pages/main/change_password/change_password_screen.dart';
import 'package:egat_flutter/screens/pages/main/change_password/state/change_password_state.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
                ChangeNotifierProxyProvider<LoginSession, ChangePasswordState>(
          create: (_) => ChangePasswordState(),
          update: (_, loginSession, changePasswordState) {
            if (changePasswordState == null) {
              changePasswordState = ChangePasswordState();
            }

            return changePasswordState..setLoginSession(loginSession);
          },
        ),
      ],
      child: ChangePasswordScreen(),
    );
  }
}
