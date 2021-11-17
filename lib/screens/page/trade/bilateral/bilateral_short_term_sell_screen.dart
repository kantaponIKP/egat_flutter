import 'package:egat_flutter/screens/page/page.dart';
import 'package:egat_flutter/screens/page/state/bilateral/bilateral_short_term_sell.dart';
import 'package:egat_flutter/screens/page/widgets/logo_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_bottom_navigation_bar.dart';
import 'package:egat_flutter/screens/page/widgets/side_menu.dart';
import 'package:egat_flutter/screens/page/trade/tabbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:egat_flutter/constant.dart';

class BilateralShortTermSellScreen extends StatefulWidget {
  const BilateralShortTermSellScreen({Key? key}) : super(key: key);

  @override
  _BilateralShortTermSellScreenState createState() =>
      _BilateralShortTermSellScreenState();
}

class _BilateralShortTermSellScreenState
    extends State<BilateralShortTermSellScreen> {
  bool _isChecked = false;
  double _currentSliderValue = 9;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        decoration: BoxDecoration(
            gradient: RadialGradient(colors: [
          Color(0xFF303030),
          Colors.black,
        ])),
        child: Scaffold(
          appBar: PageAppbar(
              firstTitle: "Bilateral", secondTitle: "Short Term Sell"),
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: _buildAction(context),
          ),
          //bottomNavigationBar: PageBottomNavigationBar(),
        ),
      ),
    );
  }

  Padding _buildAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 12, bottom: 6),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                // TextButton(
                //   onPressed: _onLongTermBilateralPressed,
                //   child: Text('Long term'),
                // ),
                // TextButton(
                //   onPressed: _onSubmitPressed,
                //   child: Text('Submit'),
                // ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      //margin: EdgeInsets.only(bottom: 20),
                                      //alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Offer to Sell",
                                        style: TextStyle(
                                          color: greenColor,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      //alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Short term Bilateral",
                                        style: TextStyle(
                                          color: whiteColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ]),
                              Container(
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10)),
                                height: 30,
                                width: MediaQuery.of(context).size.width / 2,
                                child: RichText(
                                  text: TextSpan(children: [
                                    WidgetSpan(
                                        child: Icon(
                                      Icons.more_time_rounded,
                                      color: blackColor,
                                    )),
                                    TextSpan(
                                      text: "Register to long term Bilateral",
                                      style: TextStyle(
                                        color: backgroundColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ]),
                                ),
                              )
                            ],
                          ),
                          _testlisttile(),
                          _testlisttile(),
                          _testlisttile(),
                          _testlisttile()
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(color: backgroundColor),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "Trading Fee",
                              style: TextStyle(fontSize: 16),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Text(
                                      "(0.08)",
                                      style: TextStyle(
                                          fontSize: 20, color: primaryColor),
                                    )),
                                Text("THB")
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "Estimated Sales",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Text(
                                      "28.27",
                                      style: TextStyle(
                                          fontSize: 20, color: primaryColor),
                                    )),
                                Text("THB"),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(15)),
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            "Submit",
                            style: TextStyle(
                                color: backgroundColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ]);
        },
      ),
    );
  }

  Widget _testlisttile() {
    return Column(
      children: [_bodyExpand(), _bodyExpand()],
    );
  }

  Widget _headerExpand() {
    return ListTile(
      title: CheckboxListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        contentPadding: EdgeInsets.all(0),
        title: Text("Date : 21 Aug 2021, Period: 13:00-14:00"),
        activeColor: primaryColor,
        checkColor: backgroundColor,
        controlAffinity: ListTileControlAffinity.leading,
        value: _isChecked,
        onChanged: (bool? value) {
          setState(() {
            _isChecked = value!;
          });
        },
      ),
    );
  }

  Widget _bodyExpand() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: ExpansionTile(
          tilePadding: EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 15),
          controlAffinity: ListTileControlAffinity.platform,
          title: _headerExpand(),
          collapsedBackgroundColor: surfaceColor,
          backgroundColor: surfaceColor,
          textColor: textColor,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Energy to Sale",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 30,
                          child: TextField(
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: textColor))),
                          ),
                        ),
                        Text(
                          "kWh",
                          style: TextStyle(color: primaryColor),
                        )
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "0 kWh",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "10KwH",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 1,
                    activeTickMarkColor: primaryColor,
                    valueIndicatorColor: primaryColor,
                    valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                    valueIndicatorTextStyle: TextStyle(color: textColor),
                  ),
                  child: Slider(
                    value: _currentSliderValue,
                    activeColor: primaryColor,
                    thumbColor: primaryColor,
                    min: 0.00,
                    max: 10.00,
                    divisions: 1000,
                    label: _currentSliderValue.toStringAsFixed(2),
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValue = value;
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Offer to Sell Price",
                              style: TextStyle(color: textColor, fontSize: 18),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Market price = THB 3.00",
                              style: TextStyle(color: textColor),
                              textAlign: TextAlign.left,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 30,
                            child: TextField(
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: textColor))),
                            ),
                          ),
                          Text(
                            "THB/kWh",
                            style: TextStyle(color: primaryColor),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    BilateralShortTermSell model =
        Provider.of<BilateralShortTermSell>(context, listen: false);
    model.setPageBack();
    return false;
  }

  void _onLongTermBilateralPressed() {
    //Navigate
    BilateralShortTermSell model =
        Provider.of<BilateralShortTermSell>(context, listen: false);
    model.setPageBilateralLongTermSell();
  }

  void _onSubmitPressed() {
    //Navigate
    BilateralShortTermSell model =
        Provider.of<BilateralShortTermSell>(context, listen: false);
    model.setPageBilateralTrade();
  }
}
