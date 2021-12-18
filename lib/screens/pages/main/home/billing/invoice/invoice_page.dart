import 'package:flutter/widgets.dart';

import 'invoice_screen.dart';

class InvoicePage extends StatelessWidget {
  final DateTime month;

  const InvoicePage({
    Key? key,
    required this.month,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InvoiceScreen(month: month);
  }
}
