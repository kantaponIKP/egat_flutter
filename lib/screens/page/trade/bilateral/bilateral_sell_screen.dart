import 'package:egat_flutter/screens/page/state/bilateral/bilateral_sell.dart';
import 'package:egat_flutter/screens/page/widgets/logo_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_bottom_navigation_bar.dart';
import 'package:egat_flutter/screens/page/widgets/side_menu.dart';
import 'package:egat_flutter/screens/page/trade/tabbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BilateralSellScreen extends StatefulWidget {
  const BilateralSellScreen({Key? key}) : super(key: key);

  @override
  _BilateralSellScreenState createState() => _BilateralSellScreenState();
}

class _BilateralSellScreenState extends State<BilateralSellScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: PageAppbar(firstTitle: "Bilateral", secondTitle: "Sell"),
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
                    onPressed: _onPlaceOrderPressed,
                    child: Text('Place Order'),
                  ),
                  TextButton(
                    onPressed: _onLongTermBilateralPressed,
                    child: Text('Long term'),
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
    BilateralSell model = Provider.of<BilateralSell>(context, listen: false);
    model.setPageBack();
    return false;
  }

  void _onPlaceOrderPressed() {
    //Navigate
    BilateralSell model = Provider.of<BilateralSell>(context, listen: false);
    model.setPageBilateralShortTermSell();
  }

  void _onLongTermBilateralPressed() {
    //Navigate
    BilateralSell model = Provider.of<BilateralSell>(context, listen: false);
    model.setPageBilateralLongTermSell();
  }
}
