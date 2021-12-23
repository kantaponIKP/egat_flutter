import 'package:egat_flutter/screens/pages/main/home/settlement/states/settlement_navigation_state.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'settlement_screen.dart';

class SettlementPage extends StatelessWidget {
  const SettlementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettlementNavigationState()),
      ],
      child: SettlementScreen(),
    );
  }
}
