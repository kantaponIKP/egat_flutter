import 'package:egat_flutter/screens/pages/main/setting/add_payment/add_payment_screen.dart';
import 'package:egat_flutter/screens/pages/main/setting/add_payment/states/add_payment_state.dart';
import 'package:egat_flutter/screens/pages/main/setting/state/setting_screen_navigation_state.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class AddPaymentPage extends StatelessWidget {
  const AddPaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<SettingScreenNavigationState>(
        create: (_) => SettingScreenNavigationState(),
      ),
      ChangeNotifierProxyProvider<SettingScreenNavigationState,
          AddPaymentState>(create: (_) {
        SettingScreenNavigationState settingState =
            Provider.of<SettingScreenNavigationState>(context, listen: false);
        return AddPaymentState(settingScreenNavigationState: settingState);
      }, update: (
        BuildContext context,
        SettingScreenNavigationState model,
        AddPaymentState? previous,
      ) {
        if (previous == null) {
          SettingScreenNavigationState settingState =
              Provider.of<SettingScreenNavigationState>(context, listen: false);
          return AddPaymentState(settingScreenNavigationState: settingState);
        } else {
          previous.setNavigationState(model);
          return previous;
        }
      }),
    ], child: AddPaymentScreen());
  }
}
