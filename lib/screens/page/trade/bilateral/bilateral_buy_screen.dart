import 'package:egat_flutter/screens/page/state/bilateral/bilateral_buy.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_bottom_navigation_bar.dart';
import 'package:egat_flutter/screens/page/widgets/side_menu.dart';
import 'package:egat_flutter/screens/page/trade/tabbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BilateralBuyScreen extends StatefulWidget {
  const BilateralBuyScreen({Key? key}) : super(key: key);

  @override
  _BilateralBuyScreenState createState() => _BilateralBuyScreenState();
}

class _BilateralBuyScreenState extends State<BilateralBuyScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: PageAppbar(firstTitle: "Bilateral", secondTitle: "Buy"),
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
                    onPressed: _onLongTermBilateralPressed,
                    child: Text('Long term'),
                  ),
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
    BilateralBuy model = Provider.of<BilateralBuy>(context, listen: false);
    model.setPageBack();
    return false;
  }

  void _onLongTermBilateralPressed() {
    //Navigate
    BilateralBuy model = Provider.of<BilateralBuy>(context, listen: false);
    model.setPageBilateralLongTermBuy();
  }

  void _onSubmitPressed() {
    //Navigate
    BilateralBuy model = Provider.of<BilateralBuy>(context, listen: false);
    model.setPageBilateralTrade();
  }
}
