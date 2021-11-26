import 'package:egat_flutter/screens/page/state/pool_market/pool_market_short_term_buy.dart';
import 'package:egat_flutter/screens/page/widgets/logo_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_bottom_navigation_bar.dart';
import 'package:egat_flutter/screens/page/widgets/side_menu.dart';
import 'package:egat_flutter/screens/page/trade/tabbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:egat_flutter/constant.dart';

class PoolMarketShortTermBuyScreen extends StatefulWidget {
  const PoolMarketShortTermBuyScreen({Key? key}) : super(key: key);

  @override
  _PoolMarketShortTermBuyScreenState createState() =>
      _PoolMarketShortTermBuyScreenState();
}

class _PoolMarketShortTermBuyScreenState
    extends State<PoolMarketShortTermBuyScreen> {
  double _currentSliderValue = 9;
  bool _visible = false;
  Icon _Togglevisible = Icon(
    Icons.arrow_drop_down_rounded,
    size: 30,
  );

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
              firstTitle: "Pool Market", secondTitle: "Short Term Buy"),
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
                        // TextButton(
                        //   onPressed: _onSubmitPressed,
                        //   child: Text('Submit'),
                        // )
                        Container(
                          margin: EdgeInsets.only(bottom: 20),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Bid to Buy",
                            style: TextStyle(
                              color: redColor,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        _bodyExpand(),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: _visible,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Energy to buy"),
                              Text("Energy tariff"),
                              Text("Energy price"),
                              Text("Wheeling charge Tariff"),
                              Text("Wheeling charge"),
                              Text("Trading fee"),
                              Text("Vat (7%)")
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Text("7.50"),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("kWh")
                                ],
                              ),
                              Row(
                                children: [
                                  Text("3.00"),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("THB/kWh")
                                ],
                              ),
                              Row(
                                children: [
                                  Text("22.50"),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("THB")
                                ],
                              ),
                              Row(
                                children: [
                                  Text("1.15"),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("THB/kWh")
                                ],
                              ),
                              Row(
                                children: [
                                  Text("8.62"),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("THB")
                                ],
                              ),
                              Row(
                                children: [
                                  Text("0.08"),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("THB")
                                ],
                              ),
                              Row(
                                children: [
                                  Text("1.57"),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("THB")
                                ],
                              ),
                            ],
                          )
                        ],
                      )
                    ],
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
                            "Estimated buy",
                            style: TextStyle(fontSize: 16),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _visible = !_visible;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Text(
                                      "32.77",
                                      style: TextStyle(
                                          fontSize: 20, color: redColor),
                                    )),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text("THB"),
                                      Icon(
                                        _visible
                                            ? Icons.arrow_drop_down_rounded
                                            : Icons.arrow_drop_up_rounded,
                                        size: 30,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
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
                            "Estimated Net Price",
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
                                    "4.15",
                                    style: TextStyle(
                                        fontSize: 20, color: redColor),
                                  )),
                              Text("THB/kWh"),
                            ],
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _onSubmitPressed();
                      },
                      child: Container(
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
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _bodyExpand() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
          decoration: BoxDecoration(color: surfaceColor),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Date : 21 Aug 2021, Period: 13:00-14:00",
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "0 kWh",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "10KwH",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                    borderSide: BorderSide(color: textColor))),
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
          )),
    );
  }

  Future<bool> _onWillPop() async {
    PoolMarketShortTermBuy model =
        Provider.of<PoolMarketShortTermBuy>(context, listen: false);
    model.setPageBack();
    return false;
  }

  void _onSubmitPressed() {
    //Navigate
    PoolMarketShortTermBuy model =
        Provider.of<PoolMarketShortTermBuy>(context, listen: false);
    model.setPagePoolMarketTrade();
  }
}
