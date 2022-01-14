import 'package:egat_flutter/screens/pages/main/setting/card_payment/card_payment_screen.dart';
import 'package:egat_flutter/screens/pages/main/setting/card_payment/states/card_payment_state.dart';
import 'package:egat_flutter/screens/pages/main/setting/state/setting_screen_navigation_state.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class CardPaymentPage extends StatelessWidget {
  const CardPaymentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<CardPaymentState>(
          create: (_) => CardPaymentState()),
      ChangeNotifierProvider<SettingScreenNavigationState>(
        create: (_) => SettingScreenNavigationState(),
      ),
    ], child: CardPaymentScreen());
  }
}
