import 'package:flutter/widgets.dart';

import 'bilateral_sell_screen.dart';

class BilateralSellPage extends StatelessWidget {
  final DateTime date;
  final bool enabled;

  const BilateralSellPage({
    Key? key,
    required this.date,
    required this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BilateralSellScreen(date: date, enabled: enabled);
  }
}
