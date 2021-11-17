import 'package:egat_flutter/screens/page/state/pool_market/pool_market_short_term_sell.dart';
import 'package:egat_flutter/screens/page/widgets/logo_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_bottom_navigation_bar.dart';
import 'package:egat_flutter/screens/page/widgets/side_menu.dart';
import 'package:egat_flutter/screens/page/trade/tabbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PoolMarketShortTermSellScreen extends StatefulWidget {
  const PoolMarketShortTermSellScreen({Key? key}) : super(key: key);

  @override
  _PoolMarketShortTermSellScreenState createState() =>
      _PoolMarketShortTermSellScreenState();
}

class _PoolMarketShortTermSellScreenState
    extends State<PoolMarketShortTermSellScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: PageAppbar(
            firstTitle: "Pool Market", secondTitle: "Short Term Sell"),
        body: SafeArea(
          child: _buildAction(context),
        ),
        bottomNavigationBar: PageBottomNavigationBar(),
      ),
    );
  }

  Padding _buildAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: _onSubmitPressed,
                    child: Text('Submit'),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<bool> _onWillPop() async {
    PoolMarketShortTermSell model =
        Provider.of<PoolMarketShortTermSell>(context, listen: false);
    model.setPageBack();
    return false;
  }

  void _onSubmitPressed() {
    //Navigate
    PoolMarketShortTermSell model =
        Provider.of<PoolMarketShortTermSell>(context, listen: false);
    model.setPagePoolMarketTrade();
  }
}
