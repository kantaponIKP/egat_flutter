import 'package:egat_flutter/screens/pages/main/home/states/notification.state.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';
import 'states/home_screen_navigation.state.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeScreenNavigationState()),
        ChangeNotifierProxyProvider<LoginSession, NotificationState>(
          create: (_) => NotificationState(),
          update: (_, LoginSession loginSession, notificationState) {
            if (notificationState == null) {
              notificationState = NotificationState();
            }

            return notificationState..setLoginSession(loginSession);
          },
        ),
      ],
      child: HomeScreen(),
    );
  }
}
