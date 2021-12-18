import 'package:egat_flutter/screens/pages/main/home/billing/states/billing_selected_date_state.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'billing_screen.dart';
import 'states/billing_state.dart';

class BillingPage extends StatelessWidget {
  const BillingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProxyProvider<LoginSession, BillingState>(
          create: (_) => BillingState(),
          update: (_, loginSession, billingState) {
            if (billingState == null) {
              billingState = BillingState();
            }

            return billingState..setLoginSession(loginSession);
          },
        ),
        ChangeNotifierProxyProvider<BillingState, BillingSelectedDateState>(
          create: (_) => BillingSelectedDateState(),
          update: (_, billingState, selectedDateState) {
            if (selectedDateState == null) {
              selectedDateState = BillingSelectedDateState();
            }

            return selectedDateState..setBillingState(billingState);
          },
        ),
      ],
      child: BillingScreen(),
    );
  }
}
