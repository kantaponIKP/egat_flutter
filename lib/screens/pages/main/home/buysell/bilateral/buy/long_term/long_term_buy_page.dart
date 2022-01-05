import 'package:egat_flutter/screens/pages/main/home/buysell/bilateral/buy/long_term/states/long_term_buy_state.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'long_term_buy_screen.dart';

class LongTermBuyPage extends StatelessWidget {
  const LongTermBuyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<BilateralLongTermBuy>(
          create: (_) => BilateralLongTermBuy()),
    ], child: BilateralLongTermBuyScreen());
  }
}
