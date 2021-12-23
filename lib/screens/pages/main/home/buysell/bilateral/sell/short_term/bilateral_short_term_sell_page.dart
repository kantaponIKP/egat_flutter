import 'package:egat_flutter/screens/pages/main/home/buysell/bilateral/apis/models/TransactionSubmitItem.dart';
import 'package:flutter/widgets.dart';

import 'bilateral_short_term_sell_screen.dart';

class BilateralShortTermSellPage extends StatelessWidget {
  final List<TransactionSubmitItem> requestItems;

  const BilateralShortTermSellPage({
    Key? key,
    required this.requestItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BilateralShortTermSellScreen(
      requestItems: requestItems,
    );
  }
}
