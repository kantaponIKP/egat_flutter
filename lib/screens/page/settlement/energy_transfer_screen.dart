import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/side_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EnergyTransferScreen extends StatefulWidget {
  const EnergyTransferScreen({Key? key}) : super(key: key);

  @override
  _EnergyTransferScreenState createState() => _EnergyTransferScreenState();
}

class _EnergyTransferScreenState extends State<EnergyTransferScreen> {
  var monthItem = ["August 2021", "September 2021", "October 2021"];
  var dateItem = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];
  bool _bilateralCheck = true;
  bool _poolCheck = false;
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
        appBar: PageAppbar(
          firstTitle: "Energy",
          secondTitle: "Transfer",
        ),
        drawer: NavigationMenuWidget(),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: _buildAction(context),
        ),
      ),
    );
  }

  Padding _buildAction(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12, bottom: 6),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            height: 35,
                            padding: EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(5)),
                            child: DropdownButton(
                              value: _monthinit,
                              icon: Icon(Icons.arrow_drop_down_rounded),
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
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 35,
                            padding: EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(5)),
                            child: DropdownButton(
                              menuMaxHeight:
                                  MediaQuery.of(context).size.height / 2,
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
                            ),
                          ),
                        ],
                      )
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
                          value: _bilateralCheck,
                          onChanged: (value) {
                            setState(() {
                              if (_bilateralCheck != true) {
                                _bilateralCheck = true;
                                _poolCheck = false;
                              }
                            });
                          }),
                      Text("Bilateral Trade"),
                      Checkbox(
                        visualDensity: VisualDensity.compact,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        value: _poolCheck,
                        onChanged: (value) {
                          setState(() {
                            if (_poolCheck != true) {
                              _poolCheck = true;
                              _bilateralCheck = false;
                            }
                          });
                        },
                      ),
                      Text("Pool Market Trade"),
                    ],
                  ),
                  Placeholder(
                    fallbackHeight: 200,
                  ),
                  //toggle issell isbilateral iscomplete
                  // _ContractCard(
                  //     true,
                  //     true,
                  //     _bilateralCheck ? _bilateralCheck : _poolCheck,
                  //     true,
                  //     DateTime(2021, 8, 1, 14, 30)),

                  _bilateralCheck
                      ? Wrap(children: [
                          _ContractCard(
                              // offer to sell & complete & bilateral
                              false,
                              true,
                              true,
                              true,
                              DateTime(2021, 8, 1, 14, 30)),
                          _ContractCard(
                              // offer to sell & scheduled & bilateral
                              false,
                              true,
                              true,
                              false,
                              DateTime(2021, 8, 1, 14, 30)),
                          _ContractCard(
                              // choose to buy & scheduled & bilateral
                              false,
                              false,
                              true,
                              false,
                              DateTime(2021, 8, 1, 14, 30)),
                          _ContractCard(
                              // choose to buy & complete & bilateral
                              false,
                              false,
                              true,
                              true,
                              DateTime(2021, 8, 1, 14, 30)),
                        ])
                      : Wrap(children: [
                          _ContractCard(
                              // offer to sell & complete & pool market
                              false,
                              true,
                              false,
                              true,
                              DateTime(2021, 8, 1, 14, 30)),
                          _ContractCard(
                              // offer to sell & schedule & pool market
                              false,
                              true,
                              false,
                              false,
                              DateTime(2021, 8, 1, 14, 30)),
                          _ContractCard(
                              // bid to buy & schedule & pool market
                              false,
                              false,
                              false,
                              false,
                              DateTime(2021, 8, 1, 14, 30)),
                          _ContractCard(
                              // bid to buy & complete & pool market
                              false,
                              false,
                              false,
                              true,
                              DateTime(2021, 8, 1, 14, 30)),
                        ])
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _ContractCard(bool toggle, bool isSell, bool isbilateral,
      bool iscompleted, DateTime time) {
    bool _ToggleCard = toggle;
    bool _isSell = isSell;
    bool _isCompleted = iscompleted;
    String currenttime =
        time.hour.toString() + ":00" + "-" + (time.hour + 1).toString() + ":00";
    return Column(children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        child: Text("Delivery Time $currenttime"),
      ),
      ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(children: [
          Container(
            width: MediaQuery.of(context).size.width - 30,
            color: Colors.grey[800],
            child: Container(
              height: 70,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                      fontFamily: 'Montserrat', fontSize: 14),
                                  children: [
                                isSell
                                    ? TextSpan(
                                        text: "Offer to sell",
                                        style: TextStyle(color: greenColor))
                                    : isbilateral
                                        ? TextSpan(
                                            text: "Choose to Buy",
                                            style: TextStyle(color: redColor))
                                        : TextSpan(
                                            text: "Bid to Buy",
                                            style: TextStyle(color: redColor)),
                                TextSpan(text: "\t\t\tContract #1485434482")
                              ]))
                        ],
                      ),
                      (_isSell && !_isCompleted)
                          ? Container()
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  _ToggleCard = !_ToggleCard;
                                  print(_ToggleCard);
                                });
                              },
                              child: Container(
                                width: 20,
                                height: 20,
                                child: _ToggleCard
                                    ? Icon(
                                        Icons.arrow_drop_up_rounded,
                                        size: 30,
                                      )
                                    : Icon(
                                        Icons.arrow_drop_down_rounded,
                                        size: 30,
                                      ),
                              ),
                            )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                          text: TextSpan(
                              style: TextStyle(
                                  fontFamily: 'Montserrat', fontSize: 14),
                              children: [
                            WidgetSpan(
                                child: Container(
                              padding: EdgeInsets.all(5),
                              width: 13,
                              height: 13,
                              decoration: BoxDecoration(
                                  color: iscompleted
                                      ? greenColor
                                      : Colors.yellow[300],
                                  shape: BoxShape.circle),
                            )),
                            iscompleted
                                ? TextSpan(text: "\tCOMPLETED")
                                : TextSpan(text: "\tSCHEDULED")
                          ])),
                      isSell
                          ? Text(
                              "To Prosumer P03",
                              style: TextStyle(fontSize: 12),
                            )
                          : (!isSell && !isbilateral && iscompleted)
                              ? Text(
                                  "From Prosumer P03,Prosumer P04",
                                  style: TextStyle(fontSize: 12),
                                )
                              : Text(
                                  "From Prosumer P03",
                                  style: TextStyle(fontSize: 12),
                                )
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width - 30,
            color: Colors.grey[500],
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: (isSell && isbilateral && !iscompleted)
                  ? Column(
                      // Card Offer to sell SCHEDULED and From Bilateral Trade
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text("Commited amount"), Text("6.50 kWh")],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Selling Price"),
                            Text("3.05 THB/kWh")
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text("NET Sales"), Text("18.48 THB")],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text("Trading Fee"), Text("(0.08) THB")],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "NET energy price(NET Sales/Energy Delivered)",
                              style: TextStyle(fontSize: 10),
                            ),
                            Text(
                              "4.62 THB/kWh",
                              style: TextStyle(fontSize: 10),
                            )
                          ],
                        ),
                      ],
                    )
                  : (isSell && !isbilateral && !iscompleted)
                      ? Column(
                          // Card Offer to sell SCHEDULED and From Pool Market Trade
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Offered amount(Matched)",
                                  style: TextStyle(color: Colors.indigo[900]),
                                ),
                                Text(
                                  "7.50 kWh",
                                  style: TextStyle(color: Colors.indigo[900]),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Market clearing price",
                                  style: TextStyle(color: Colors.indigo[900]),
                                ),
                                Text(
                                  "3.30 THB/kWh",
                                  style: TextStyle(color: Colors.indigo[900]),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [Text("NET Sales"), Text("24.67 THB")],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Trading Fee"),
                                Text("(0.08) THB")
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                    text: TextSpan(
                                        style: TextStyle(
                                            fontFamily: "Montserrat",
                                            fontSize: 9),
                                        children: [
                                      TextSpan(
                                          text: "NET energy price(NET Sales/"),
                                      TextSpan(
                                          text: "Offered amount(Matched)",
                                          style: TextStyle(
                                              color: Colors.indigo[900])),
                                      TextSpan(text: ")")
                                    ])),
                                Text(
                                  "3.29 THB/kWh",
                                  style: TextStyle(fontSize: 9),
                                )
                              ],
                            ),
                          ],
                        )
                      : (isSell && iscompleted && isbilateral)
                          ? Column(
                              // Card Offer to sell Completed and From Bilateral Trade
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Commited amount"),
                                    Text("8.00 kWh")
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Energy Delivered",
                                      style: TextStyle(color: greenColor),
                                    ),
                                    Text(
                                      "6.45 kWh",
                                      style: TextStyle(color: greenColor),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Selling Price"),
                                    Text("3.05 THB/kWh")
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("NET Sales"),
                                    Text("24.07 THB")
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    RichText(
                                        text: TextSpan(
                                            style: TextStyle(
                                                fontFamily: "Montserrat",
                                                fontSize: 10),
                                            children: [
                                          TextSpan(
                                              text:
                                                  "NET energy price(NET Sales/"),
                                          TextSpan(
                                              text: "Energy Delivered",
                                              style:
                                                  TextStyle(color: greenColor)),
                                          TextSpan(text: ")")
                                        ])),
                                    Text(
                                      "3.83 THB/kWh",
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                                toggle
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Sales",
                                          ),
                                          Text(
                                            "24.40 THB",
                                          )
                                        ],
                                      )
                                    : Container(),
                                toggle
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Seller imbalance amount",
                                            style: TextStyle(color: redColor),
                                          ),
                                          Text(
                                            "1.55 kWh",
                                            style: TextStyle(color: redColor),
                                          )
                                        ],
                                      )
                                    : Container(),
                                toggle
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Seller imbalance",
                                            style: TextStyle(color: redColor),
                                          ),
                                          Text(
                                            "(0.25) THB",
                                            style: TextStyle(color: redColor),
                                          )
                                        ],
                                      )
                                    : Container(),
                                toggle
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Trading Fee"),
                                          Text("(0.08) THB")
                                        ],
                                      )
                                    : Container(),
                              ],
                            )
                          : (isSell && iscompleted && !isbilateral)
                              ? Column(
                                  // Card offer to sell COMPLETED and from pool market trade
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Commited amount(Matched)",
                                          style: TextStyle(
                                              color: Colors.indigo[900]),
                                        ),
                                        Text(
                                          "9.00 kWh",
                                          style: TextStyle(
                                              color: Colors.indigo[900]),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Energy Delivered",
                                          style: TextStyle(color: greenColor),
                                        ),
                                        Text(
                                          "7.50 kWh",
                                          style: TextStyle(color: greenColor),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Market clearing price",
                                          style: TextStyle(
                                              color: Colors.indigo[900]),
                                        ),
                                        Text(
                                          "3.30 THB/kWh",
                                          style: TextStyle(
                                              color: Colors.indigo[900]),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("NET Sales"),
                                        Text("24.75 THB")
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        RichText(
                                            text: TextSpan(
                                                style: TextStyle(
                                                    fontFamily: "Montserrat",
                                                    fontSize: 10),
                                                children: [
                                              TextSpan(
                                                  text:
                                                      "NET energy price(NET Sales/"),
                                              TextSpan(
                                                  text: "Energy Delivered",
                                                  style: TextStyle(
                                                      color: greenColor)),
                                              TextSpan(text: ")")
                                            ])),
                                        Text(
                                          "3.91 THB/kWh",
                                          style: TextStyle(fontSize: 10),
                                        )
                                      ],
                                    ),
                                    toggle
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Sales"),
                                              Text("29.7 THB")
                                            ],
                                          )
                                        : Container(),
                                    toggle
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Seller imbalance amount",
                                                style:
                                                    TextStyle(color: redColor),
                                              ),
                                              Text(
                                                "1.50 kWh",
                                                style:
                                                    TextStyle(color: redColor),
                                              )
                                            ],
                                          )
                                        : Container(),
                                    toggle
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Seller imbalance",
                                                style:
                                                    TextStyle(color: redColor),
                                              ),
                                              Text(
                                                "(0.25) THB",
                                                style:
                                                    TextStyle(color: redColor),
                                              )
                                            ],
                                          )
                                        : Container(),
                                    toggle
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Trading Fee"),
                                              Text("(0.08) THB")
                                            ],
                                          )
                                        : Container(),
                                  ],
                                )
                              : (!isSell && !iscompleted && isbilateral)
                                  ? Column(
                                      // Card Choose to buy SCHEDULED and From Bilateral Trade
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Commited amount"),
                                            Text("4.00 kWh")
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("NET buy"),
                                            Text("18.48 THB")
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "NET energy price(NET Sales/Energy Delivered)",
                                              style: TextStyle(fontSize: 10),
                                            ),
                                            Text(
                                              "4.62 THB/kWh",
                                              style: TextStyle(fontSize: 10),
                                            )
                                          ],
                                        ),
                                        toggle
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("Energy to buy"),
                                                  Text("4.00 kWh")
                                                ],
                                              )
                                            : Container(),
                                        toggle
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("Energy tariff"),
                                                  Text("3.15 THB/kWh")
                                                ],
                                              )
                                            : Container(),
                                        toggle
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("Energy price"),
                                                  Text("12.60 THB")
                                                ],
                                              )
                                            : Container(),
                                        toggle
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      "Wheeling charge Tariff"),
                                                  Text("1.15 THB/kWh")
                                                ],
                                              )
                                            : Container(),
                                        toggle
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("Wheeling charge"),
                                                  Text("4.60 THB")
                                                ],
                                              )
                                            : Container(),
                                        toggle
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("Trading fee"),
                                                  Text("0.08 THB")
                                                ],
                                              )
                                            : Container(),
                                        toggle
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("VAT(7%)"),
                                                  Text("1.20 THB")
                                                ],
                                              )
                                            : Container(),
                                      ],
                                    )
                                  : (!isSell && iscompleted && isbilateral)
                                      ? Column(
                                          // Card Choose to buy COMPLETED and From Bilateral Trade
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("Commited amount"),
                                                Text("8.75 kWh")
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Energy used",
                                                  style: TextStyle(
                                                      color: greenColor),
                                                ),
                                                Text(
                                                  "8.50 kWh",
                                                  style: TextStyle(
                                                      color: greenColor),
                                                )
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("NET buy"),
                                                Text("40.34 THB")
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                RichText(
                                                    text: TextSpan(
                                                        style: TextStyle(
                                                            fontFamily:
                                                                "Montserrat",
                                                            fontSize: 10),
                                                        children: [
                                                      TextSpan(
                                                          text:
                                                              "NET energy price(NET buy/"),
                                                      TextSpan(
                                                          text: "Energy used",
                                                          style: TextStyle(
                                                              color:
                                                                  greenColor)),
                                                      TextSpan(text: ")")
                                                    ])),
                                                Text(
                                                  "4.75 THB/kWh",
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                )
                                              ],
                                            ),
                                            toggle
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Buyer imbalance amount",
                                                        style: TextStyle(
                                                            color: redColor),
                                                      ),
                                                      Text(
                                                        "0.25 kWh",
                                                        style: TextStyle(
                                                            color: redColor),
                                                      )
                                                    ],
                                                  )
                                                : Container(),
                                            toggle
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Buyer imbalance",
                                                        style: TextStyle(
                                                            color: redColor),
                                                      ),
                                                      Text(
                                                        "(0.25) THB",
                                                        style: TextStyle(
                                                            color: redColor),
                                                      )
                                                    ],
                                                  )
                                                : Container(),
                                            toggle
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text("Energy to buy"),
                                                      Text("8.75 kWh")
                                                    ],
                                                  )
                                                : Container(),
                                            toggle
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text("Energy tariff"),
                                                      Text("3.15 THB/kWh")
                                                    ],
                                                  )
                                                : Container(),
                                            toggle
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text("Energy price"),
                                                      Text("27.56 THB")
                                                    ],
                                                  )
                                                : Container(),
                                            toggle
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                          "Wheeling charge Tariff"),
                                                      Text("1.15 THB/kWh")
                                                    ],
                                                  )
                                                : Container(),
                                            toggle
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text("Wheeling charge"),
                                                      Text("10.06 THB")
                                                    ],
                                                  )
                                                : Container(),
                                            toggle
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text("Trading fee"),
                                                      Text("0.08 THB")
                                                    ],
                                                  )
                                                : Container(),
                                            toggle
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text("VAT(7%)"),
                                                      Text("2.64 THB")
                                                    ],
                                                  )
                                                : Container(),
                                          ],
                                        )
                                      : (!isSell &&
                                              !iscompleted &&
                                              !isbilateral)
                                          ? Column(
                                              // Card Bid to Buy SCHEDULED and from Pool Market Trade
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Bided Amount(Matched)",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .indigo[900]),
                                                    ),
                                                    Text(
                                                      "7.00 kWh",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .indigo[900]),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Market clearing price",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .indigo[900]),
                                                    ),
                                                    Text(
                                                      "3.30 THB/kWh",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .indigo[900]),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text("NET buy"),
                                                    Text("33.41 THB")
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    RichText(
                                                        text: TextSpan(
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Montserrat",
                                                                fontSize: 9),
                                                            children: [
                                                          TextSpan(
                                                              text:
                                                                  "NET energy price(NET buy/"),
                                                          TextSpan(
                                                              text:
                                                                  "Bided amount(Matched)",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                          .indigo[
                                                                      900])),
                                                          TextSpan(text: ")")
                                                        ])),
                                                    Text(
                                                      "4.77 THB/kWh",
                                                      style: TextStyle(
                                                          fontSize: 9),
                                                    )
                                                  ],
                                                ),
                                                toggle
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text("Energy to buy"),
                                                          Text("7.00 kWh")
                                                        ],
                                                      )
                                                    : Container(),
                                                toggle
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text("Energy tariff"),
                                                          Text("3.30 THB/kWh")
                                                        ],
                                                      )
                                                    : Container(),
                                                toggle
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text("Energy price"),
                                                          Text("23.10 THB")
                                                        ],
                                                      )
                                                    : Container(),
                                                toggle
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              "Wheeling charge Tariff"),
                                                          Text("1.15 THB/kWh")
                                                        ],
                                                      )
                                                    : Container(),
                                                toggle
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                              "Wheeling charge"),
                                                          Text("8.05 THB")
                                                        ],
                                                      )
                                                    : Container(),
                                                toggle
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text("Trading fee"),
                                                          Text("0.08 THB")
                                                        ],
                                                      )
                                                    : Container(),
                                                toggle
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text("VAT(7%)"),
                                                          Text("2.18 THB")
                                                        ],
                                                      )
                                                    : Container(),
                                              ],
                                            )
                                          : (!isSell &&
                                                  iscompleted &&
                                                  !isbilateral)
                                              ? Column(
                                                  // Card Bid to Buy COMPLETE and from Pool Market Trade
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Bided Amount(Matched)",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .indigo[900]),
                                                        ),
                                                        Text(
                                                          "8.50 kWh",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .indigo[900]),
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Energy used",
                                                          style: TextStyle(
                                                              color:
                                                                  greenColor),
                                                        ),
                                                        Text(
                                                          "6.00 kWh",
                                                          style: TextStyle(
                                                              color:
                                                                  greenColor),
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Market clearing price",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .indigo[900]),
                                                        ),
                                                        Text(
                                                          "3.30 THB/kWh",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .indigo[900]),
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text("NET buy"),
                                                        Text("40.55 THB")
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        RichText(
                                                            text: TextSpan(
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        "Montserrat",
                                                                    fontSize:
                                                                        10),
                                                                children: [
                                                              TextSpan(
                                                                  text:
                                                                      "NET energy price(NET buy/"),
                                                              TextSpan(
                                                                  text:
                                                                      "Energy used",
                                                                  style: TextStyle(
                                                                      color:
                                                                          greenColor)),
                                                              TextSpan(
                                                                  text: ")")
                                                            ])),
                                                        Text(
                                                          "6.76 THB/kWh",
                                                          style: TextStyle(
                                                              fontSize: 10),
                                                        )
                                                      ],
                                                    ),
                                                    toggle
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Buyer imbalance amount",
                                                                style: TextStyle(
                                                                    color:
                                                                        redColor),
                                                              ),
                                                              Text(
                                                                "2.50 kWh",
                                                                style: TextStyle(
                                                                    color:
                                                                        redColor),
                                                              )
                                                            ],
                                                          )
                                                        : Container(),
                                                    toggle
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                "Buyer imbalance",
                                                                style: TextStyle(
                                                                    color:
                                                                        redColor),
                                                              ),
                                                              Text(
                                                                "(0.25) THB",
                                                                style: TextStyle(
                                                                    color:
                                                                        redColor),
                                                              )
                                                            ],
                                                          )
                                                        : Container(),
                                                    toggle
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  "Energy to buy"),
                                                              Text("8.50 kWh")
                                                            ],
                                                          )
                                                        : Container(),
                                                    toggle
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  "Energy tariff"),
                                                              Text(
                                                                  "3.30 THB/kWh")
                                                            ],
                                                          )
                                                        : Container(),
                                                    toggle
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  "Energy price"),
                                                              Text("28.05 THB")
                                                            ],
                                                          )
                                                        : Container(),
                                                    toggle
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  "Wheeling charge Tariff"),
                                                              Text(
                                                                  "1.15 THB/kWh")
                                                            ],
                                                          )
                                                        : Container(),
                                                    toggle
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  "Wheeling charge"),
                                                              Text("9.77 THB")
                                                            ],
                                                          )
                                                        : Container(),
                                                    toggle
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  "Trading fee"),
                                                              Text("0.08 THB")
                                                            ],
                                                          )
                                                        : Container(),
                                                    toggle
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text("VAT(7%)"),
                                                              Text("2.65 THB")
                                                            ],
                                                          )
                                                        : Container(),
                                                  ],
                                                )
                                              : Container(),
            ),
          )
        ]),
      ),
    ]);
  }
}
