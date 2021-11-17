import 'package:egat_flutter/screens/page/state/bilateral/bilateral_long_term_sell.dart';
import 'package:egat_flutter/screens/page/widgets/logo_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_bottom_navigation_bar.dart';
import 'package:egat_flutter/screens/page/widgets/side_menu.dart';
import 'package:egat_flutter/screens/page/trade/tabbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BilateralLongTermSellScreen extends StatefulWidget {
  const BilateralLongTermSellScreen({Key? key}) : super(key: key);

  @override
  _BilateralLongTermSellScreenState createState() =>
      _BilateralLongTermSellScreenState();
}

class _BilateralLongTermSellScreenState
    extends State<BilateralLongTermSellScreen> {
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
            firstTitle: "Long Term", secondTitle: "Bilateral (Sell)"),
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

  void _onSubmitPressed() {
    //Navigate
    BilateralLongTermSell model =
        Provider.of<BilateralLongTermSell>(context, listen: false);
    model.setPageBilateralTrade();
  }

  Future<bool> _onWillPop() async {
    BilateralLongTermSell model =
        Provider.of<BilateralLongTermSell>(context, listen: false);
    model.setPageBack();
    return false;
  }
}
