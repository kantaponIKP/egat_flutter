import 'package:egat_flutter/screens/page/state/bilateral/bilateral_long_term_buy.dart';
import 'package:egat_flutter/screens/page/widgets/logo_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/navigation_back.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_bottom_navigation_bar.dart';
import 'package:egat_flutter/screens/page/widgets/side_menu.dart';
import 'package:egat_flutter/screens/page/trade/tabbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BilateralLongTermBuyScreen extends StatefulWidget {
  const BilateralLongTermBuyScreen({Key? key}) : super(key: key);

  @override
  _BilateralLongTermBuyScreenState createState() =>
      _BilateralLongTermBuyScreenState();
}

class _BilateralLongTermBuyScreenState
    extends State<BilateralLongTermBuyScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar:
            PageAppbar(firstTitle: "Long Term", secondTitle: "Bilateral (Buy)"),
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
    BilateralLongTermBuy model =
        Provider.of<BilateralLongTermBuy>(context, listen: false);
    model.setPageBack();
    return false;
  }

  void _onSubmitPressed() {
    //Navigate
    BilateralLongTermBuy model =
        Provider.of<BilateralLongTermBuy>(context, listen: false);
    model.setPageBilateralTrade();
  }
}
