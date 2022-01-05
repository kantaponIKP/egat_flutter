import 'package:egat_flutter/screens/pages/main/home/buysell/pool/apis/models/TransactionSubmitItem.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/pool/sell/pool_market_sell_screen.dart';
import 'package:flutter/widgets.dart';

class PoolMarketSellPage extends StatelessWidget {
  final List<TransactionSubmitItem> requestItems;

  const PoolMarketSellPage({
    Key? key,
    required this.requestItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PoolMarketSellScreen(
      requestItems: requestItems,
    );
  }
}
