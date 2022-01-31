import 'package:flutter/widgets.dart';

import 'bilateral_buy_screen.dart';

class BilateralBuyPage extends StatelessWidget {
  final DateTime date;
  final bool enabled;

  const BilateralBuyPage({
    Key? key,
    required this.date,
    required this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BilateralBuyScreen(date: date, enabled: enabled);
  }
}
