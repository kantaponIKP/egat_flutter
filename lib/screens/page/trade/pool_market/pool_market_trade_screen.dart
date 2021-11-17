import 'package:egat_flutter/screens/page/state/pool_market/pool_market_trade.dart';
import 'package:egat_flutter/screens/page/widgets/logo_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_bottom_navigation_bar.dart';
import 'package:egat_flutter/screens/page/widgets/side_menu.dart';
import 'package:egat_flutter/screens/page/trade/tabbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PoolMarketTradeScreen extends StatefulWidget {
  const PoolMarketTradeScreen({Key? key}) : super(key: key);

  @override
  _PoolMarketTradeScreenState createState() => _PoolMarketTradeScreenState();
}

class _PoolMarketTradeScreenState extends State<PoolMarketTradeScreen>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageAppbar(firstTitle: "Pool Market",secondTitle: "Trade"),
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
          return
              SingleChildScrollView(
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
    PoolMarketTrade model = Provider.of<PoolMarketTrade>(context, listen: false);
    model.setPagePoolMarketShortTermBuy();
  }

  void _onListTileSellPressed() {
    //Navigate
    PoolMarketTrade model = Provider.of<PoolMarketTrade>(context, listen: false);
    model.setPagePoolMarketShortTermBuy();
  }
}
