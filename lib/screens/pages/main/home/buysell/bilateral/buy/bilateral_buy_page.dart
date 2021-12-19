import 'package:flutter/widgets.dart';

import 'bilateral_buy_screen.dart';

class BilateralBuyPage extends StatelessWidget {
  final DateTime date;

  const BilateralBuyPage({
    Key? key,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BilateralBuyScreen(date: date);
  }
}
