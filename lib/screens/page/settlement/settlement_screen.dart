import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/page/trade/tabbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_bottom_navigation_bar.dart';
import 'package:egat_flutter/screens/page/widgets/side_menu.dart';
import 'package:flutter/material.dart';

class SettlementScreen extends StatefulWidget {
  const SettlementScreen({Key? key}) : super(key: key);

  @override
  _SettlementScreenState createState() => _SettlementScreenState();
}

class _SettlementScreenState extends State<SettlementScreen> {
  var monthItem = ["August 2021", "September 2021", "October 2021"];
  var dateItem = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];
  bool isSwitched = false;
  bool _allischecked = true;
  bool _buyerischecked = false;
  bool _sellerischecked = false;
  bool _isCompletedExpand = false;
  bool _isScheduledExpand = false;
  String _monthinit = "";
  String _dateinit = "";

  @override
  void initState() {
    super.initState();
    _monthinit = monthItem.first;
    _dateinit = dateItem.first;
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
        appBar: PageAppbar(firstTitle: "Settlement", secondTitle: ""),
        drawer: NavigationMenuWidget(),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: _buildAction(context),
        ),
        //bottomNavigationBar: PageBottomNavigationBar(),
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
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //Tabbar(),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        //month and date
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
                                value: _monthinit,
                                icon: Icon(
                                  Icons.arrow_drop_down_rounded,
                                ),
                                iconSize: 20,
                                alignment: Alignment.center,
                                borderRadius: BorderRadius.circular(20),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _monthinit = newValue!;
                                  });
                                },
                                items: monthItem.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                underline: DropdownButtonHideUnderline(
                                  child: Container(),
                                ),
                              )),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                              height: 35,
                              padding: EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: DropdownButton(
                                menuMaxHeight:
                                    MediaQuery.of(context).size.height / 2,
                                value: _dateinit,
                                icon: Icon(
                                  Icons.arrow_drop_down_rounded,
                                ),
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
                        ],
                      ),
                      //Toggle daily
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Daily"),
                          Switch(
                            value: isSwitched,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value;
                              });
                            },
                            activeTrackColor: greenColor,
                            activeColor: greenColor,
                          ),
                        ],
                      ),
                      //Toggle daily
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Checkbox(
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        value: _allischecked,
                        onChanged: (value) {
                          setState(() {
                            _isCompletedExpand = false;
                            _isScheduledExpand = false;
                            if (_allischecked == false) {
                              _allischecked = true;
                            }
                            _buyerischecked = false;
                            _sellerischecked = false;
                          });
                        },
                      ),
                      Text("All"),
                      Checkbox(
                          visualDensity: VisualDensity.compact,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          value: _buyerischecked,
                          onChanged: (value) {
                            setState(() {
                              _isCompletedExpand = false;
                              _isScheduledExpand = false;
                              if (_buyerischecked == false) {
                                _buyerischecked = true;
                              }
                              _allischecked = false;
                              _sellerischecked = false;
                            });
                          }),
                      Text("Buyer"),
                      Checkbox(
                          visualDensity: VisualDensity.compact,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          value: _sellerischecked,
                          onChanged: (value) {
                            setState(() {
                              _isCompletedExpand = false;
                              _isScheduledExpand = false;
                              if (_sellerischecked == false) {
                                _sellerischecked = true;
                              }
                              _buyerischecked = false;
                              _allischecked = false;
                            });
                          }),
                      Text("Seller")
                    ],
                  ),
                  _buyerischecked
                      ? _BuyerDetail()
                      : _sellerischecked
                          ? _SellerDetail()
                          : _allischecked
                              ? _AllDetail()
                              : Text("BUG"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _DailyCard(bool Shortfall, bool isbuyer, bool isBilateral) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 30,
            // height: 50,
            color: Colors.grey[800],
            child: Container(
              height: 60,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                          text: TextSpan(
                              style: TextStyle(
                                  fontFamily: 'Montserrat', fontSize: 14),
                              children: [
                            isbuyer
                                ? TextSpan(
                                    text: "Buyer ",
                                    style: TextStyle(color: redColor),
                                  )
                                : TextSpan(
                                    text: "Seller ",
                                    style: TextStyle(color: greenColor)),
                            TextSpan(text: "Contract #1485434482")
                          ])),
                      Text(
                        "From Prosumer P03",
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                          text: TextSpan(
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 14,
                                  color: Shortfall ? redColor : greenColor),
                              children: [
                            WidgetSpan(
                                child: Container(
                              padding: EdgeInsets.all(5),
                              width: 13,
                              height: 13,
                              decoration: BoxDecoration(
                                  color: Shortfall ? redColor : greenColor,
                                  shape: BoxShape.circle),
                            )),
                            TextSpan(
                                text: Shortfall
                                    ? " Energy shortfall"
                                    : " Energy excess")
                          ])),
                      isBilateral
                          ? Text(
                              "Short term Bilateral Trade",
                              style: TextStyle(fontSize: 12),
                            )
                          : Text(
                              "Pool Market Trade",
                              style: TextStyle(fontSize: 12),
                            )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 30,
            // height: 150,
            color: Colors.grey[500],
            child: Container(
              padding:
                  EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                          text: TextSpan(
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 14,
                                  color: blackColor),
                              children: [
                            TextSpan(text: "Energy Commited"),
                            TextSpan(text: "/"),
                            TextSpan(
                              text: !isbuyer
                                  ? "Delivered"
                                  : (!Shortfall && isBilateral)
                                      ? "Delivered"
                                      : "Used",
                              style: TextStyle(color: greenColor),
                            ),
                          ])),
                      RichText(
                          text: TextSpan(
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 16,
                                  color: blackColor),
                              children: [
                            TextSpan(text: "8.00"),
                            TextSpan(text: "/"),
                            TextSpan(
                              text: Shortfall ? "6.45" : "9.45",
                              style: TextStyle(color: greenColor),
                            ),
                            TextSpan(text: " kWh")
                          ]))
                    ],
                  ),
                  ((!isbuyer && isBilateral) || (isbuyer && Shortfall))
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 16,
                                        color: blackColor),
                                    children: [
                                  TextSpan(
                                      text: isbuyer
                                          ? "NET buy  "
                                          : "NET Sales  "),
                                  WidgetSpan(
                                      child: Container(
                                    child: Tooltip(
                                      preferBelow: false,
                                      message: isbuyer
                                          ? "Include imbalance, fees, Wheeling charge, VAT"
                                          : "Include imbalance, fees",
                                      textStyle: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Montserrat',
                                          color: blackColor),
                                      height: 30,
                                      triggerMode: TooltipTriggerMode.tap,
                                      decoration: BoxDecoration(
                                          color: whiteColor,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Icon(
                                        Icons.info_outline_rounded,
                                        size: 18,
                                      ),
                                    ),
                                  )),
                                ])),
                            Text(
                              "24.07 THB",
                              style: TextStyle(fontSize: 16, color: blackColor),
                            ),
                          ],
                        )
                      : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isbuyer
                            ? "Buyer imbalance amount"
                            : "Seller imbalance amount",
                        style: TextStyle(fontSize: 16, color: redColor),
                      ),
                      Text(
                        "1.55 kWh",
                        style: TextStyle(fontSize: 16, color: redColor),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isbuyer ? "Buyer imbalance" : "Seller imbalance",
                        style: TextStyle(fontSize: 16, color: redColor),
                      ),
                      Text(
                        "(0.25) THB",
                        style: TextStyle(fontSize: 16, color: redColor),
                      )
                    ],
                  ),
                  (isbuyer && Shortfall)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Wheeling charge Tariff",
                              style: TextStyle(fontSize: 12, color: blackColor),
                            ),
                            Text("1.15 THB/kWh",
                                style:
                                    TextStyle(fontSize: 12, color: blackColor))
                          ],
                        )
                      : Container(),
                  (isbuyer && Shortfall)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Wheeling charge",
                                style:
                                    TextStyle(fontSize: 12, color: blackColor)),
                            Text("10.06 THB",
                                style:
                                    TextStyle(fontSize: 12, color: blackColor))
                          ],
                        )
                      : Container(),
                  ((!isbuyer && isBilateral) || (isbuyer && Shortfall))
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                                text: TextSpan(
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 10,
                                        color: blackColor),
                                    children: [
                                  TextSpan(text: "NET energy price(NET buy/"),
                                  TextSpan(
                                    text: isbuyer ? "Used" : "Energy Delivered",
                                    style: TextStyle(color: greenColor),
                                  ),
                                  TextSpan(text: ")")
                                ])),
                            Text(
                              "3.83 THB/kWh",
                              style: TextStyle(fontSize: 12, color: blackColor),
                            )
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _BuyerDetail() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 35),
          width: MediaQuery.of(context).size.width,
          child: Text("Total"),
        ),
        Container(
          //height: MediaQuery.of(context).size.height / 3,
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          child: Row(
            //Buyer Summary Window
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Completed Contracts",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Visibility(
                    visible: _isCompletedExpand,
                    child: Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Short term Bilateral trade"),
                            Text("Long term Bilateral trade"),
                            Text("Pool Market trade")
                          ],
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Scheduled Contracts",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Visibility(
                    visible: _isScheduledExpand,
                    child: Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Short term Bilateral trade"),
                            Text("Long term Bilateral trade"),
                            Text("Pool Market trade")
                          ],
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "Energy Commited/",
                        style: TextStyle(fontSize: 16)),
                    TextSpan(
                        text: "Used",
                        style: TextStyle(color: greenColor, fontSize: 16)),
                  ])),
                  // Text(
                  //   "Energy Commited/Used",
                  //   style: TextStyle(fontSize: 16),
                  // ),r
                  SizedBox(
                    height: 5,
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(text: "NET Buy", style: TextStyle(fontSize: 16)),
                    WidgetSpan(
                        child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 3),
                      child: Icon(
                        Icons.info_outline,
                        size: 15,
                      ),
                    ))
                  ])),
                  // Text(
                  //   "NET Buy",
                  //   style: TextStyle(fontSize: 16),
                  // ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Imbalance amount",
                    style: TextStyle(fontSize: 16, color: redColor),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Buyer imbalance",
                    style: TextStyle(fontSize: 16, color: redColor),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Wheeling charge",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "NET Energy price",
                        style: TextStyle(fontSize: 16),
                      ),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: "(NET Buy/",
                            style: TextStyle(fontSize: 12),
                          ),
                          TextSpan(
                              text: "Used",
                              style:
                                  TextStyle(color: greenColor, fontSize: 12)),
                          TextSpan(text: ")", style: TextStyle(fontSize: 12))
                        ]),
                      )
                    ],
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(text: "5", style: TextStyle(fontSize: 16)),
                    WidgetSpan(
                        child: Padding(
                      padding: EdgeInsets.zero,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isCompletedExpand = !_isCompletedExpand;
                          });
                        },
                        child: _isCompletedExpand
                            ? Icon(
                                Icons.arrow_drop_up_rounded,
                                size: 20,
                              )
                            : Icon(
                                Icons.arrow_drop_down_rounded,
                                size: 20,
                              ),
                      ),
                    ))
                  ])),
                  SizedBox(
                    height: 5,
                  ),
                  Visibility(
                    visible: _isCompletedExpand,
                    child: Container(
                      padding: EdgeInsets.only(right: 20),
                      child: Column(
                        children: [Text("3"), Text("1"), Text("1")],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(text: "2", style: TextStyle(fontSize: 16)),
                    WidgetSpan(
                        child: Padding(
                      padding: EdgeInsets.zero,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isScheduledExpand = !_isScheduledExpand;
                          });
                        },
                        child: _isScheduledExpand
                            ? Icon(Icons.arrow_drop_up_rounded, size: 20)
                            : Icon(
                                Icons.arrow_drop_down_rounded,
                                size: 20,
                              ),
                      ),
                    ))
                  ])),
                  SizedBox(
                    height: 5,
                  ),
                  Visibility(
                    visible: _isScheduledExpand,
                    child: Container(
                      padding: EdgeInsets.only(right: 20),
                      child: Column(
                        children: [Text("3"), Text("1"), Text("1")],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(text: "8.00/", style: TextStyle(fontSize: 16)),
                    TextSpan(
                        text: "6.45",
                        style: TextStyle(color: greenColor, fontSize: 16)),
                    TextSpan(text: " kWh", style: TextStyle(fontSize: 16))
                  ])),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "12 THB",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "10 kWh",
                    style: TextStyle(fontSize: 16, color: redColor),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "(0.25) THB",
                    style: TextStyle(fontSize: 16, color: redColor),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "0.25 THB",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "3.83 THB/kWh",
                    style: TextStyle(fontSize: 16),
                  )
                ],
              )
            ],
          ),
        ),
        Divider(
          height: 15,
          color: whiteColor,
          indent: 30,
          endIndent: 30,
          thickness: 1,
        ),
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(top: 2, bottom: 2, right: 20),
          child: Text("Delivery Time 15:00-16:00"),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _DailyCard(true, true, true),
                    SizedBox(
                      width: 10,
                    ),
                    _DailyCard(true, true, true),
                    SizedBox(
                      width: 10,
                    ),
                    _DailyCard(true, true, true),
                  ],
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
            ),
          ],
        ),
      ],
    );
  }

  Widget _SellerDetail() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 35),
          width: MediaQuery.of(context).size.width,
          child: Text("Total"),
        ),
        Container(
          //height: MediaQuery.of(context).size.height / 3,
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          child: Row(
            //Buyer Summary Window
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Completed Contracts",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Visibility(
                    visible: _isCompletedExpand,
                    child: Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Short term Bilateral trade"),
                            Text("Long term Bilateral trade"),
                            Text("Pool Market trade")
                          ],
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Scheduled Contracts",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Visibility(
                    visible: _isScheduledExpand,
                    child: Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Short term Bilateral trade"),
                            Text("Long term Bilateral trade"),
                            Text("Pool Market trade")
                          ],
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "Energy Commited/",
                        style: TextStyle(fontSize: 16)),
                    TextSpan(
                        text: "Delivered",
                        style: TextStyle(color: greenColor, fontSize: 16)),
                  ])),
                  // Text(
                  //   "Energy Commited/Used",
                  //   style: TextStyle(fontSize: 16),
                  // ),r
                  SizedBox(
                    height: 5,
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(text: "NET Buy\n", style: TextStyle(fontSize: 16)),
                    TextSpan(
                        text: "(Include imbalance, fees)",
                        style: TextStyle(fontSize: 12))
                  ])),
                  // Text(
                  //   "NET Buy",
                  //   style: TextStyle(fontSize: 16),
                  // ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Imbalance amount",
                    style: TextStyle(fontSize: 16, color: redColor),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Buyer imbalance",
                    style: TextStyle(fontSize: 16, color: redColor),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Wheeling charge",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "NET Energy price",
                        style: TextStyle(fontSize: 16),
                      ),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: "(NET Buy/",
                            style: TextStyle(fontSize: 12),
                          ),
                          TextSpan(
                              text: "Energy Delivered",
                              style:
                                  TextStyle(color: greenColor, fontSize: 12)),
                          TextSpan(text: ")", style: TextStyle(fontSize: 12))
                        ]),
                      )
                    ],
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(text: "5", style: TextStyle(fontSize: 16)),
                    WidgetSpan(
                        child: Padding(
                      padding: EdgeInsets.zero,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isCompletedExpand = !_isCompletedExpand;
                          });
                        },
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isCompletedExpand = !_isCompletedExpand;
                            });
                          },
                          child: _isCompletedExpand
                              ? Icon(Icons.arrow_drop_up_rounded, size: 20)
                              : Icon(
                                  Icons.arrow_drop_down_rounded,
                                  size: 20,
                                ),
                        ),
                      ),
                    ))
                  ])),
                  SizedBox(
                    height: 5,
                  ),
                  Visibility(
                    visible: _isCompletedExpand,
                    child: Container(
                      padding: EdgeInsets.only(right: 20),
                      child: Column(
                        children: [Text("3"), Text("1"), Text("1")],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(text: "2", style: TextStyle(fontSize: 16)),
                    WidgetSpan(
                        child: Padding(
                      padding: EdgeInsets.zero,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isScheduledExpand = !_isScheduledExpand;
                          });
                        },
                        child: _isScheduledExpand
                            ? Icon(
                                Icons.arrow_drop_up_rounded,
                                size: 20,
                              )
                            : Icon(
                                Icons.arrow_drop_down_rounded,
                                size: 20,
                              ),
                      ),
                    ))
                  ])),
                  SizedBox(
                    height: 5,
                  ),
                  Visibility(
                    visible: _isScheduledExpand,
                    child: Container(
                      padding: EdgeInsets.only(right: 20),
                      child: Column(
                        children: [Text("3"), Text("1"), Text("1")],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(text: "8.00/", style: TextStyle(fontSize: 16)),
                    TextSpan(
                        text: "6.45",
                        style: TextStyle(color: greenColor, fontSize: 16)),
                    TextSpan(text: " kWh", style: TextStyle(fontSize: 16))
                  ])),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "12 THB",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "10 kWh",
                    style: TextStyle(fontSize: 16, color: redColor),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "(0.25) THB",
                    style: TextStyle(fontSize: 16, color: redColor),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "0.25 THB",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "3.83 THB/kWh",
                    style: TextStyle(fontSize: 16),
                  )
                ],
              )
            ],
          ),
        ),
        Divider(
          height: 15,
          color: whiteColor,
          indent: 30,
          endIndent: 30,
          thickness: 1,
        ),
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(top: 2, bottom: 2, right: 20),
          child: Text("Delivery Time 15:00-16:00"),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _DailyCard(false, false, false),
                    SizedBox(
                      width: 10,
                    ),
                    _DailyCard(false, false, false),
                    SizedBox(
                      width: 10,
                    ),
                    _DailyCard(false, false, false)
                  ],
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
            ),
          ],
        ),
      ],
    );
  }

  Widget _AllDetail() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          child: Row(
            //Buyer Summary Window
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Completed Contracts",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Visibility(
                    visible: _isCompletedExpand,
                    child: Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Short term Bilateral trade"),
                            Text("Long term Bilateral trade"),
                            Text("Pool Market trade")
                          ],
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Scheduled Contracts",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Visibility(
                    visible: _isScheduledExpand,
                    child: Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Short term Bilateral trade"),
                            Text("Long term Bilateral trade"),
                            Text("Pool Market trade")
                          ],
                        )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "Seller Energy Commited/",
                        style: TextStyle(fontSize: 14)),
                    TextSpan(
                        text: "Delivered",
                        style: TextStyle(color: greenColor, fontSize: 14)),
                  ])),
                  SizedBox(
                    height: 5,
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "Buyer Energy Commited/",
                        style: TextStyle(fontSize: 14)),
                    TextSpan(
                        text: "Used",
                        style: TextStyle(color: greenColor, fontSize: 14)),
                  ])),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "NET Sell",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "NET Buy",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Seller Imbalance amount",
                    style: TextStyle(fontSize: 16, color: redColor),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Buyer Imbalance amount",
                    style: TextStyle(fontSize: 16, color: redColor),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "NET imbalance",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Wheeling charge",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: "NET Energy Sales price\n",
                        style: TextStyle(fontSize: 16),
                      ),
                      TextSpan(
                        text: "(NET Sales/",
                        style: TextStyle(fontSize: 12),
                      ),
                      TextSpan(
                          text: "Energy Delivered",
                          style: TextStyle(color: greenColor, fontSize: 12)),
                      TextSpan(text: ")", style: TextStyle(fontSize: 12))
                    ]),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: "NET Energy Buy price\n",
                        style: TextStyle(fontSize: 16),
                      ),
                      TextSpan(
                        text: "(NET Buy/",
                        style: TextStyle(fontSize: 12),
                      ),
                      TextSpan(
                          text: "Used",
                          style: TextStyle(color: greenColor, fontSize: 12)),
                      TextSpan(text: ")", style: TextStyle(fontSize: 12))
                    ]),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(text: "10", style: TextStyle(fontSize: 16)),
                    WidgetSpan(
                        child: Padding(
                      padding: EdgeInsets.zero,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isCompletedExpand = !_isCompletedExpand;
                          });
                        },
                        child: _isCompletedExpand
                            ? Icon(
                                Icons.arrow_drop_up_rounded,
                                size: 20,
                              )
                            : Icon(
                                Icons.arrow_drop_down_rounded,
                                size: 20,
                              ),
                      ),
                    ))
                  ])),
                  SizedBox(
                    height: 5,
                  ),
                  Visibility(
                    visible: _isCompletedExpand,
                    child: Container(
                      padding: EdgeInsets.only(right: 20),
                      child: Column(
                        children: [Text("3"), Text("1"), Text("1")],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(text: "4", style: TextStyle(fontSize: 16)),
                    WidgetSpan(
                        child: Padding(
                      padding: EdgeInsets.zero,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isScheduledExpand = !_isScheduledExpand;
                          });
                        },
                        child: _isScheduledExpand
                            ? Icon(
                                Icons.arrow_drop_up_rounded,
                                size: 20,
                              )
                            : Icon(
                                Icons.arrow_drop_down_rounded,
                                size: 20,
                              ),
                      ),
                    ))
                  ])),
                  SizedBox(
                    height: 5,
                  ),
                  Visibility(
                    visible: _isScheduledExpand,
                    child: Container(
                      padding: EdgeInsets.only(right: 20),
                      child: Column(
                        children: [Text("3"), Text("1"), Text("1")],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(text: "8.00/", style: TextStyle(fontSize: 14)),
                    TextSpan(
                        text: "6.45",
                        style: TextStyle(color: greenColor, fontSize: 14)),
                    TextSpan(text: " kWh", style: TextStyle(fontSize: 14))
                  ])),
                  SizedBox(
                    height: 5,
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(text: "8.00/", style: TextStyle(fontSize: 14)),
                    TextSpan(
                        text: "6.45",
                        style: TextStyle(color: greenColor, fontSize: 14)),
                    TextSpan(text: " kWh", style: TextStyle(fontSize: 14))
                  ])),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "12 THB",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "12 THB",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "10 kWh",
                    style: TextStyle(fontSize: 16, color: redColor),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "10 kWh",
                    style: TextStyle(fontSize: 16, color: redColor),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "(0.25) THB",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "0.25 THB",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "3.83 THB/kWh",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "3.83 THB/kWh",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
