import 'package:egat_flutter/screens/page/settlement/energy_transfer_screen.dart';
import 'package:egat_flutter/screens/page/settlement/settlement_screen.dart';
import 'package:egat_flutter/screens/page/state/pool_market/pool_market_trade.dart';
import 'package:egat_flutter/screens/page/widgets/logo_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_bottom_navigation_bar.dart';
import 'package:egat_flutter/screens/page/widgets/side_menu.dart';
import 'package:egat_flutter/screens/page/trade/tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:egat_flutter/constant.dart';

class PoolMarketTradeScreen extends StatefulWidget {
  const PoolMarketTradeScreen({Key? key}) : super(key: key);

  @override
  _PoolMarketTradeScreenState createState() => _PoolMarketTradeScreenState();
}

class _PoolMarketTradeScreenState extends State<PoolMarketTradeScreen> {
  var dateItem = [
    "20 August 2021",
    "21 August 2021",
    "22 August 2021",
    "23 August 2021"
  ];
  var timeItem = ["6:00-18:00", "18:00-6:00"];
  var offerItem = ["Bid to Buy", "Offer to Sell"];
  String _timeinit = "";
  String _dateinit = "";
  String _offerinit = "";

  @override
  void initState() {
    super.initState();
    _timeinit = timeItem.first;
    _dateinit = dateItem.first;
    _offerinit = offerItem.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: RadialGradient(colors: [
        Color(0xFF303030),
        Colors.black,
      ])),
      child: Scaffold(
        appBar: PageAppbar(firstTitle: "Pool Market", secondTitle: "Trade"),
        drawer: NavigationMenuWidget(),
        backgroundColor: Colors.transparent,
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
                  Tabbar(),
                  SizedBox(
                    height: 10,
                  ),
                  //  TextButton(
                  //   onPressed: _onListTileBuyPressed,
                  //   child: Text('ListTileBuy'),
                  // ),
                  // TextButton(
                  //   onPressed: _onListTileSellPressed,
                  //   child: Text('ListTileSell'),
                  // ),
                  Row(
                    // Row of dropdown box
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                          height: 35,
                          padding: EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: DropdownButton(
                            value: _timeinit,
                            icon: Icon(
                              Icons.arrow_drop_down_rounded,
                            ),
                            iconSize: 20,
                            alignment: Alignment.center,
                            borderRadius: BorderRadius.circular(20),
                            onChanged: (String? newValue) {
                              setState(() {
                                _timeinit = newValue!;
                              });
                            },
                            items: timeItem.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            underline: DropdownButtonHideUnderline(
                              child: Container(),
                            ),
                          )),
                      Container(
                          height: 35,
                          padding: EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: DropdownButton(
                            value: _dateinit,
                            icon: Icon(Icons.arrow_drop_down_rounded),
                            iconSize: 20,
                            alignment: Alignment.center,
                            borderRadius: BorderRadius.circular(20),
                            onChanged: (String? newValue) {
                              setState(() {
                                _dateinit = newValue!;
                              });
                            },
                            items: dateItem.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            underline: DropdownButtonHideUnderline(
                              child: Container(),
                            ),
                          )),
                      Container(
                          height: 35,
                          padding: EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: DropdownButton(
                            value: _offerinit,
                            icon: Icon(Icons.arrow_drop_down_rounded),
                            iconSize: 20,
                            iconEnabledColor: backgroundColor,
                            dropdownColor: primaryColor,
                            style:
                                TextStyle(fontSize: 18, color: backgroundColor),
                            alignment: Alignment.center,
                            borderRadius: BorderRadius.circular(20),
                            onChanged: (String? newValue) {
                              setState(() {
                                _offerinit = newValue!;
                              });
                            },
                            items: offerItem.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items),
                              );
                            }).toList(),
                            underline: DropdownButtonHideUnderline(
                              child: Container(),
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _buildCloseCard("13:00-14:00", 5, 3),
                  _buildPeriodCard("14:00-15:00", 5),
                  _buildPeriodCard("15:00-16:00", 6),
                  _buildPeriodCard("16:00-17:00", 0),
                  _buildPeriodCard("17:00-18:00", 2)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPeriodCard(String time, int offer) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: Card(
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      time,
                      style: TextStyle(fontSize: 26),
                    ),
                    GestureDetector(
                      onTap: () {
                        _onListTileSellPressed();
                      },
                      child: Text(
                        "OPEN(Test to Sell)",
                        style: TextStyle(fontSize: 23, color: greenColor),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  VerticalDivider(
                    indent: 10,
                    endIndent: 10,
                    width: 20,
                    thickness: 2,
                    color: greyColor,
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Text(
                          offer.toString(),
                          style: TextStyle(fontSize: 26),
                        ),
                        Text("Offers \nto buy")
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCloseCard(String time, int offer, int match) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: Card(
        child: IntrinsicHeight(
            child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      time,
                      style: TextStyle(fontSize: 26),
                    ),
                    GestureDetector(
                      onTap: () {
                        _onListTileBuyPressed();
                      },
                      child: Text(
                        "CLOSED(Test Buy)",
                        style: TextStyle(fontSize: 23, color: redColor),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 100,
                    width: 0,
                    child: VerticalDivider(
                      indent: 10,
                      endIndent: 10,
                      width: 20,
                      thickness: 2,
                      color: greyColor,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                offer.toString(),
                                style: TextStyle(fontSize: 24),
                              ),
                              Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Text("Offers \nto buy")),
                            ]),
                        Container(
                          height: 20,
                          width: 80,
                          child: Divider(
                            color: whiteColor,
                            height: 10,
                            thickness: 1,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              match.toString(),
                              style: TextStyle(fontSize: 24),
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Text("Matched"))
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Market clearing price",
                      style: TextStyle(fontSize: 17),
                    ),
                    Text(
                      "Market clearing volume",
                      style: TextStyle(fontSize: 17),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          "2.70",
                          style: TextStyle(fontSize: 17),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("THB/kWh")
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "100",
                          style: TextStyle(fontSize: 17),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("kWh")
                      ],
                    )
                  ],
                )
              ],
            ),
          ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     Text("Market clearing price"),
          //     Row(
          //       children: [Text("2.70"), Text("THB/kWh")],
          //     )
          //   ],
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     Text("Market clearing volume"),
          //     Row(
          //       children: [Text("100"), Text("kWh")],
          //     )
          //   ],
          // )
        ])),
      ),
    );
  }

  void _onListTileBuyPressed() {
    //Navigate
    PoolMarketTrade model =
        Provider.of<PoolMarketTrade>(context, listen: false);
    model.setPagePoolMarketShortTermBuy();
  }

  void _onListTileSellPressed() {
    //Navigate
    PoolMarketTrade model =
        Provider.of<PoolMarketTrade>(context, listen: false);
    model.setPagePoolMarketShortTermSell();
  }
}
