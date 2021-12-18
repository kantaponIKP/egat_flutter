import 'package:egat_flutter/screens/pages/main/home/buysell/bilateral/bilateral_trade_screen.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/bilateral/states/bilateral_selected_time_state.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/bilateral/states/bilateral_state.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:egat_flutter/screens/session.dart';

class BilateralPage extends StatelessWidget {
  const BilateralPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProxyProvider<LoginSession, BilateralState>(
          create: (_) => BilateralState(),
          update: (_, loginSession, bilateralState) {
            if (bilateralState == null) {
              bilateralState = BilateralState();
            }

            return bilateralState..setLoginSession(loginSession);
          },
        ),
        ChangeNotifierProxyProvider<BilateralState, BilateralSelectedTimeState>(
          create: (_) => BilateralSelectedTimeState(),
          update: (_, bilateralState, bilateralSelectedTimeState) {
            if (bilateralSelectedTimeState == null) {
              bilateralSelectedTimeState = BilateralSelectedTimeState();
            }

            return bilateralSelectedTimeState
              ..setBilateralState(bilateralState);
          },
        ),
      ],
      child: BilateralTradeScreen(),
    );
  }
}
