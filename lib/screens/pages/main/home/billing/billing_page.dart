import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'billing_screen.dart';

class BillingPage extends StatelessWidget {
  const BillingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [],
      child: BillingScreen(),
    );
  }
}
