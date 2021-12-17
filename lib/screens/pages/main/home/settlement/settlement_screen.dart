import 'package:egat_flutter/screens/pages/main/home/settlement/energy_transfer/energy_transfer_page.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/order/order_page.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/settlement_report/settlement_report_page.dart';

import 'states/settlement_navigation_state.dart';
import 'widgets/settlement_navigation_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class SettlementScreen extends StatefulWidget {
  SettlementScreen({Key? key}) : super(key: key);

  @override
  _SettlementScreenState createState() => _SettlementScreenState();
}

class _SettlementScreenState extends State<SettlementScreen> {
  @override
  Widget build(BuildContext context) {
    final settlementNavigateState =
        Provider.of<SettlementNavigationState>(context);

    Widget widget = Container();

    switch (settlementNavigateState.currentPage) {
      case SettlementNavigationPage.ORDER:
        widget = OrderPage(key: Key('order'));
        break;
      case SettlementNavigationPage.ENERGY_TRANSFER:
        widget = EnergyTransferPage(key: Key('energy_transfer'));
        break;
      case SettlementNavigationPage.SETTLEMENT_REPORT:
        widget = SettlementReportPage(key: Key('settlement_report'));
        break;
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: SettlementNavigationWidget(),
          ),
          Expanded(child: widget),
        ],
      );
    });
  }
}
