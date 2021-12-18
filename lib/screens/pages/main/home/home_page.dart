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
      ],
      child: HomeScreen(),
    );
  }
}
