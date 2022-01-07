import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'pool_market_trade_screen.dart';
import 'states/pool_market_short_term_buy.dart';
import 'states/pool_market_short_term_sell.dart';
import 'states/pool_market_trade.dart';

class PoolMarketTradePage extends StatelessWidget {
  const PoolMarketTradePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<PoolMarketTrade>(
        create: (_) => PoolMarketTrade(),
      ),
    ], child: PoolMarketTradeScreen());
  }
}
