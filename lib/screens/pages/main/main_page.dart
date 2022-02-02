import 'package:egat_flutter/screens/login/state/login_model.dart';
import 'package:egat_flutter/screens/pages/main/main_screen.dart';
import 'package:egat_flutter/screens/pages/main/setting/change_pin/states/pin_state.dart';
import 'package:egat_flutter/screens/pages/main/states/main_screen_navigation_state.dart';
import 'package:egat_flutter/screens/pages/main/states/main_screen_title_state.dart';
import 'package:egat_flutter/screens/pages/main/states/personal_info_state.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MainScreenNavigationState>(
          create: (_) => MainScreenNavigationState(),
        ),
        ChangeNotifierProvider<MainScreenTitleState>(
          create: (_) => MainScreenTitleState(),
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
        
        // ChangeNotifierProxyProvider<LoginSession, LoginModel>(
        //   create: (context) {
        //     LoginSession session =
        //         Provider.of<LoginSession>(context, listen: false);
        //     return LoginModel(loginSession: session);
        //   },
        //   update: (
        //     BuildContext context,
        //     LoginSession model,
        //     LoginModel? previous,
        //   ) {
        //     if (previous == null) {
        //       LoginSession session =
        //           Provider.of<LoginSession>(context, listen: false);
        //       return LoginModel(loginSession: session);
        //     } else {
        //       previous.setSession(model);
        //       return previous;
        //     }
        //   },
        // ),
      ],
      child: MainScreen(),
    );
  }
}
