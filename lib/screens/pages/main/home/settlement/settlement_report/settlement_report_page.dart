import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'settlement_report_screen.dart';
import 'states/settlement_report_selected_date_state.dart';
import 'states/settlement_report_state.dart';

class SettlementReportPage extends StatelessWidget {
  const SettlementReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProxyProvider<LoginSession, SettlementReportState>(
          create: (_) => SettlementReportState(),
          update: (context, loginSession, settlementReportState) {
            if (settlementReportState == null) {
              settlementReportState = SettlementReportState();
            }

            return settlementReportState..setLoginSession(loginSession);
          },
        ),
        ChangeNotifierProxyProvider<SettlementReportState,
            SettlementReportSelectedDateState>(
          create: (_) => SettlementReportSelectedDateState(),
          update:
              (context, settlementReportState, settlementReportSelectedDate) {
            if (settlementReportSelectedDate == null) {
              settlementReportSelectedDate =
                  SettlementReportSelectedDateState();
            }

            return settlementReportSelectedDate
              ..setSettlementReportState(settlementReportState);
          },
        ),
      ],
      child: SettlementReportScreen(),
    );
  }
}
