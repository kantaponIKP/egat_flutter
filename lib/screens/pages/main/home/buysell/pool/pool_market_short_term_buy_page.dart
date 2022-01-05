import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'pool_market_short_term_buy_screen.dart';
import 'pool_market_short_term_sell_screen.dart';
import 'pool_market_trade_screen.dart';
import 'states/pool_market_short_term_buy.dart';
import 'states/pool_market_short_term_sell.dart';
import 'states/pool_market_trade.dart';

class PoolMarketShortTermBuyPage extends StatelessWidget {
  final String isoDate;

  const PoolMarketShortTermBuyPage({
    Key? key,
    required this.isoDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PoolMarketShortTermBuy>(
          create: (_) => PoolMarketShortTermBuy()
            ..setInfo(
              PoolMarketShortTermBuyModel(
                date: isoDate,
              ),
            ),
        ),
      ],
      child: PoolMarketShortTermBuyScreen(),
    );
  }
}
