import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'setting_screen.dart';
import 'states/setting_screen_navigation.state.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingScreenNavigationState()),
      ],
      child: SettingScreen(),
    );
  }
}
