import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'buy_sell_screen.dart';
import 'states/buysell_navigation_state.dart';

class BuySellPage extends StatelessWidget {
  const BuySellPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BuySellNavigationState()),
      ],
      child: BuySellScreen(),
    );
  }
}
