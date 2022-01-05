import 'package:egat_flutter/screens/pages/main/home/buysell/pool/apis/models/TransactionSubmitItem.dart';
import 'package:flutter/widgets.dart';

import 'pool_market_buy_screen.dart';

class PoolMarketBuyPage extends StatelessWidget {
  final List<TransactionSubmitItem> requestItems;

  const PoolMarketBuyPage({
    Key? key,
    required this.requestItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PoolMarketBuyScreen(requestItems: requestItems);
  }
}
