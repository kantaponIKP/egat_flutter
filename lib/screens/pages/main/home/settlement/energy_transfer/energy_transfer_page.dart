import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'energy_transfer_screen.dart';
import 'states/energy_transfer_selected_date_state.dart';
import 'states/energy_transfer_state.dart';

class EnergyTransferPage extends StatelessWidget {
  const EnergyTransferPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProxyProvider<LoginSession, EnergyTransferState>(
          create: (_) => EnergyTransferState(),
          update: (context, loginSession, order) {
            if (order == null) {
              order = EnergyTransferState();
            }

            return order..setLoginSession(loginSession);
          },
        ),
        ChangeNotifierProxyProvider<EnergyTransferState,
            EnergyTransferSelectedDateState>(
          create: (_) => EnergyTransferSelectedDateState(),
          update: (context, order, orderSelectedDate) {
            if (orderSelectedDate == null) {
              orderSelectedDate = EnergyTransferSelectedDateState();
            }

            return orderSelectedDate..setOrderState(order);
          },
        ),
      ],
      child: EnergyTransferScreen(),
    );
  }
}
