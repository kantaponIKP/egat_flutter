import 'package:egat_flutter/screens/pages/main/main_screen.dart';
import 'package:egat_flutter/screens/pages/main/states/main_screen_navigation_state.dart';
import 'package:egat_flutter/screens/pages/main/states/main_screen_title_state.dart';
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
      ],
      child: MainScreen(),
    );
  }
}
