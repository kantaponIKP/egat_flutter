import 'package:egat_flutter/screens/page/state/bilateral/bilateral_trade.dart';
import 'package:egat_flutter/screens/page/widgets/logo_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_bottom_navigation_bar.dart';
import 'package:egat_flutter/screens/page/widgets/side_menu.dart';
import 'package:egat_flutter/screens/page/trade/tabbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BilateralTradeScreen extends StatefulWidget {
  const BilateralTradeScreen({Key? key}) : super(key: key);

  @override
  _BilateralTradeScreenState createState() => _BilateralTradeScreenState();
}

class _BilateralTradeScreenState extends State<BilateralTradeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppbar(firstTitle: "Bilateral",secondTitle: "Trade"),
      drawer: NavigationMenuWidget(),
      body: SafeArea(
        child: _buildAction(context),
      ),
      bottomNavigationBar: PageBottomNavigationBar(),
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
                  Tabbar(),
                  TextButton(
                    onPressed: _onListTileBuyPressed,
                    child: Text('ListTileBuy'),
                  ),
                  TextButton(
                    onPressed: _onListTileSellPressed,
                    child: Text('ListTileSell'),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _onListTileBuyPressed() {
    //Navigate
    BilateralTrade model = Provider.of<BilateralTrade>(context, listen: false);
    model.setPageBilateralBuy();
  }

  void _onListTileSellPressed() {
    //Navigate
    BilateralTrade model = Provider.of<BilateralTrade>(context, listen: false);
    model.setPageBilateralSell();
  }
}
