import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/page/state/bilateral/bilateral_long_term_buy.dart';
import 'package:egat_flutter/screens/page/trade/bottom_button.dart';
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
  bool _checkBox7days = false;
  bool _checkBox30days = false;
  bool _checkBox90days = false;
  bool _checkBox1years = false;
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _offerinit = offerItem.first;
    _checkBox7days = false;
    _checkBox30days = false;
    _checkBox90days = false;
    _checkBox1years = false;
  }

  String _offerinit = "";
  var offerItem = ["16:00-17:00", "17:00-18:00", "18:00-19:00", "19:00-20:00"];

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
      ),
    );
  }

  Padding _buildAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        // mainAxisSize: MainAxisSize.max,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildPeriodSection(),
                          _selectionSection(),
                          _buildExpansionTile("Prosumer P02", "14:23, 20 Aug",
                              18.48, 4.45, 4.00, 3.15, 12.60, 18.48, 4.62),
                        ],
                      ),
                    ),
                  ),
                ),
                BottomButton(
                    onAction: _onSubmitPressed, actionLabel: Text("Submit"))
              ]);
        },
      ),
    );
  }

  Widget _headerTile(
      String title, String date, double estimated, double price) {
    return
        // Container(
        //     padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        //     child:
        ListTile(
      title: CheckboxListTile(
        value: _isChecked,
        onChanged: (bool? value) {
          setState(() {
            _isChecked = value!;
          });
        },
        controlAffinity: ListTileControlAffinity.leading,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        activeColor: primaryColor,
        checkColor: backgroundColor,
        contentPadding: EdgeInsets.all(0),
        title: Container(
          // color: greyColor,
          child: IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        date,
                        style: TextStyle(fontSize: 10),
                      )
                    ],
                  ),
                ),
                VerticalDivider(
                  indent: 10,
                  endIndent: 10,
                  width: 12,
                  thickness: 2,
                  color: greyColor,
                ),
                Container(
                  padding:
                      EdgeInsets.only(top: 12, bottom: 12, left: 0, right: 0),
                  child: Column(
                    children: [
                      Text(
                        price.toString(),
                        style: TextStyle( color: primaryColor, fontSize: 10),
                      ),
                      Text(
                        "kWh",
                        style: TextStyle(fontSize: 8),
                      )
                    ],
                  ),
                ),
                VerticalDivider(
                  indent: 10,
                  endIndent: 10,
                  width: 12,
                  thickness: 2,
                  color: greyColor,
                ),
                Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.only(top: 12, bottom: 12, left: 0, right: 0),
                    child: Column(
                      children: [
                        RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: TextStyle(fontSize: 8),
                            children: <TextSpan>[
                              TextSpan(text: "Estimated buy "),
                              TextSpan(text: estimated.toString()),
                              TextSpan(text: " THB"),
                            ],
                          ),
                        ),
                        RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: TextStyle(fontSize: 8),
                            children: <TextSpan>[
                              TextSpan(text: "NET energy price "),
                              TextSpan(text: price.toString()),
                              TextSpan(text: " THB/kWh"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpansionTile(
      String title,
      String date,
      double estimated,
      double price,
      double energyToBuy,
      double energyTariff,
      double wheelingChargeTariff,
      double tradingFee,
      double netEstimated) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: ExpansionTile(
            // tilePadding: EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0),
            // controlAffinity: ListTileControlAffinity.platform,
            // title: _headerTile(position, title, date, estimated, price),
            tilePadding: EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 15),
            controlAffinity: ListTileControlAffinity.platform,
            title: _headerTile(title, date, estimated, price),
            collapsedBackgroundColor: surfaceGreyColor,
            backgroundColor: surfaceGreyColor,
            textColor: textColor,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Energy to buy",
                              style: TextStyle(
                                color: textColor,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                energyToBuy.toString(),
                                style: TextStyle(color: primaryColor, fontSize: 12),
                              ),
                              Text(
                                " kWh",
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Energy to tariff",
                              style: TextStyle(
                                color: textColor,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                energyTariff.toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                " THB/kWh",
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Wheeling charge Tariff",
                              style: TextStyle(
                                color: textColor,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                wheelingChargeTariff.toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                " THB/kWh",
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Trading fee",
                              style: TextStyle(
                                color: textColor,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                tradingFee.toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                " THB/kWh",
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Net estimated energy price",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 10,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "(Not include VAT 7%)",
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            ],),
                          Row(
                            children: [
                              Text(
                                netEstimated.toString(),
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                " THB/kWh",
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ]),
      ),
    );
  }

  Widget _selectionSection() {
    return Row(mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(children: <Widget>[
            SizedBox(
              width: 30,
              child: Checkbox(
                value: _checkBox7days,
                onChanged: (bool? value) {
                  setState(() {
                    _checkBox7days = value!;
                  });
                },
              ),
            ),
            Text(
              '7 Days',
              style: TextStyle(fontSize: 14.0),
            ),
            SizedBox(width: 4)
          ]),
          Row(children: <Widget>[
            SizedBox(
              width: 30,
              child: Checkbox(
                value: _checkBox30days,
                onChanged: (bool? value) {
                  setState(() {
                    _checkBox30days = value!;
                  });
                },
              ),
            ),
            Text(
              '30 Days',
              style: TextStyle(fontSize: 14.0),
            ),
            SizedBox(width: 4)
          ]),
          Row(children: <Widget>[
            SizedBox(
              width: 30,
              child: Checkbox(
                value: _checkBox90days,
                onChanged: (bool? value) {
                  setState(() {
                    _checkBox90days = value!;
                  });
                },
              ),
            ),
            Text(
              '90 Days',
              style: TextStyle(fontSize: 14.0),
            ),
            SizedBox(width: 4)
          ]),
          Row(children: <Widget>[
            SizedBox(
              width: 30,
              child: Checkbox(
                value: _checkBox1years,
                onChanged: (bool? value) {
                  setState(() {
                    _checkBox1years = value!;
                  });
                },
              ),
            ),
            Text(
              '1 Years',
              style: TextStyle(fontSize: 14.0),
            ),
          ]),
        ]);
  }

  Widget _buildPeriodSection() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Period"),
            Text("Everyday"),
          ],
        ),
        SizedBox(
          width: 12,
        ),
        Container(
          height: 35,
          padding: EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: surfaceGreyColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButton(
            value: _offerinit,
            icon: Icon(Icons.arrow_drop_down_rounded),
            iconSize: 20,
            iconEnabledColor: whiteColor,
            dropdownColor: surfaceGreyColor,
            style: TextStyle(fontSize: 16, color: whiteColor),
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
          ),
        ),
        SizedBox(
          width: 12,
        ),
        Flexible(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search",
              hintStyle: TextStyle(
                color: whiteColor,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: whiteColor),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: whiteColor),
              ),
              suffixIcon: Icon(
                Icons.search,
                color: whiteColor,
              ),
            ),
            onChanged: (String keyword) {},
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionSection() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Column(
        children: [],
      ),
    ]);
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
