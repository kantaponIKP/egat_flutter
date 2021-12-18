import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'bilateral/bilateral_page.dart';
import 'forecast/forecast_page.dart';
import 'states/buysell_navigation_state.dart';
import 'widgets/buy_sell_navigation_widget.dart';

class BuySellScreen extends StatefulWidget {
  BuySellScreen({Key? key}) : super(key: key);

  @override
  _BuySellScreenState createState() => _BuySellScreenState();
}

class _BuySellScreenState extends State<BuySellScreen> {
  @override
  Widget build(BuildContext context) {
    final buySellNavigationState = Provider.of<BuySellNavigationState>(context);

    Widget widget = Container();

    switch (buySellNavigationState.currentPage) {
      case BuySellNavigationPage.FORECAST:
        widget = ForecastPage(key: Key('ForecastPage'));
        break;
      case BuySellNavigationPage.BILATERAL:
        widget = BilateralPage(key: Key('BilateralPage'));
        break;
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: BuySellNavigationWidget(),
          ),
          Expanded(child: widget),
        ],
      );
    });
  }
}
