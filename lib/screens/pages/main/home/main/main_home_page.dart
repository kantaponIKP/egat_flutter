import 'package:egat_flutter/screens/pages/main/home/main/main_home_screen.dart';
import 'package:egat_flutter/screens/pages/main/home/main/states/main_selected_date_state.dart';
import 'package:egat_flutter/screens/pages/main/home/main/states/main_state.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class MainHomePage extends StatelessWidget {
  const MainHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProxyProvider<LoginSession, MainHomeState>(
          create: (_) => MainHomeState(),
          update: (context, value, previous) {
            if (previous == null) {
              previous = MainHomeState();
            }

            return previous..setLoginSession(value);
          },
        ),
        ChangeNotifierProxyProvider<MainHomeState, MainHomeSelectedDateState>(
          create: (_) => MainHomeSelectedDateState(),
          update: (context, value, previous) {
            if (previous == null) {
              previous = MainHomeSelectedDateState();
            }

            return previous..setMainHomeState(value);
          },
        ),
      ],
      child: MainHomeScreen(),
    );
  }
}
