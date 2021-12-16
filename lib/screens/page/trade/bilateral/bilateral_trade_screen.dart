import 'package:egat_flutter/screens/page/state/bilateral/bilateral_buy.dart';
import 'package:egat_flutter/screens/page/state/bilateral/bilateral_long_term_buy.dart';
import 'package:egat_flutter/screens/page/state/bilateral/bilateral_sell.dart';
import 'package:egat_flutter/screens/page/state/bilateral/bilateral_trade.dart';
import 'package:egat_flutter/screens/page/widgets/logo_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_bottom_navigation_bar.dart';
import 'package:egat_flutter/screens/page/widgets/side_menu.dart';
import 'package:egat_flutter/screens/page/trade/tabbar.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:egat_flutter/constant.dart';
import 'package:intl/intl.dart';

class BilateralTradeScreen extends StatefulWidget {
  const BilateralTradeScreen({Key? key}) : super(key: key);

  @override
  _BilateralTradeScreenState createState() => _BilateralTradeScreenState();
}

class _BilateralTradeScreenState extends State<BilateralTradeScreen> {
  var dateItem = <String>[];

  var timeItem = ["06:00-18:00", "18:00-6:00"];
  var offerItem = ["Choose to Buy", "Offer to Sell"];
  String _timeInit = "";
  String _dateInit = "";
  String _offerInit = "";
  var _bilateralList = [];
  var _bilateralBuyList = [];
  var _bilateralSellList = [];

  void setBilateralList(bilateralList) {
    var bilateralBuyList = [];
    var bilateralSellList = [];

    for (var bilateral in bilateralList) {
      if (bilateral.type == "buy") {
        bilateralBuyList.add(bilateral);
      } else {
        bilateralSellList.add(bilateral);
      }
    }
    setState(() {
      _bilateralSellList = bilateralSellList;
      _bilateralBuyList = bilateralBuyList;
    });
  }

  @override
  void initState() {
    super.initState();
    DateTime now = new DateTime.now();
    now = now.add(Duration(hours: -6));
    DateTime date = new DateTime(now.year, now.month, now.day);

    dateItem = [
      date.toString(),
      date.add(new Duration(days: 1)).toString(),
      date.add(new Duration(days: 2)).toString(),
      date.add(new Duration(days: 3)).toString(),
      date.add(new Duration(days: 4)).toString(),
      date.add(new Duration(days: 5)).toString(),
      date.add(new Duration(days: 6)).toString(),
      date.add(new Duration(days: 7)).toString(),
    ];
    _timeInit = timeItem.first;
    _dateInit = dateItem.first.toString();
    int hour = DateTime.now().hour;
    if (hour < 18 && hour >= 6) {
      _timeInit = timeItem.first;
    }
    {
      _timeInit = timeItem.last;
    }
    _offerInit = offerItem.first;

    _getData(_dateInit, _timeInit);
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
        appBar: PageAppbar(firstTitle: "Bilateral", secondTitle: "Trade"),
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
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              Tabbar(),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
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
                                  value: _timeInit,
                                  icon: Icon(
                                    Icons.arrow_drop_down_rounded,
                                  ),
                                  iconSize: 20,
                                  alignment: Alignment.center,
                                  borderRadius: BorderRadius.circular(20),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _timeInit = newValue!;
                                      _getData(_dateInit, newValue);
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
                                  value: _dateInit,
                                  icon: Icon(Icons.arrow_drop_down_rounded),
                                  iconSize: 20,
                                  alignment: Alignment.center,
                                  borderRadius: BorderRadius.circular(20),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _dateInit = newValue!;
                                      _getData(newValue, _timeInit);
                                    });
                                  },
                                  items: dateItem.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(DateFormat('dd MMMM yyyy')
                                          .format(
                                              DateTime.parse(items).toLocal())),
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
                                  value: _offerInit,
                                  icon: Icon(Icons.arrow_drop_down_rounded),
                                  iconSize: 20,
                                  iconEnabledColor: backgroundColor,
                                  dropdownColor: primaryColor,
                                  style: TextStyle(
                                      fontSize: 16, color: backgroundColor),
                                  alignment: Alignment.center,
                                  borderRadius: BorderRadius.circular(20),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _offerInit = newValue!;
                                      _getData(_dateInit, _timeInit);
                                    });
                                  },
                                  items: offerItem.map((String items) {
                                    return DropdownMenuItem(
                                      value: items,
                                      child: Text(
                                        items,
                                        style: TextStyle(fontSize: 14),
                                      ),
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
                        (_offerInit == "Choose to Buy")
                            ? Container(
                                height: constraints.maxHeight - 80,
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: _bilateralBuyList.length,
                                  itemBuilder: (context, index) {
                                    if (_bilateralBuyList[index].amount !=
                                        null) {
                                      return _buildCard(
                                        _bilateralBuyList[index].type!,
                                        _bilateralBuyList[index].time!,
                                        _bilateralBuyList[index].status!,
                                        _bilateralBuyList[index].amount!,
                                        _bilateralBuyList[index].price!,
                                        _bilateralBuyList[index].offerCount!,
                                        _bilateralBuyList[index].isoDate!,
                                        _bilateralBuyList[index].isLongterm!,
                                      );
                                    } else {
                                      return _buildCard(
                                        _bilateralBuyList[index].type!,
                                        _bilateralBuyList[index].time!,
                                        _bilateralBuyList[index].status!,
                                        0,
                                        0,
                                        _bilateralBuyList[index].offerCount!,
                                        _bilateralBuyList[index].isoDate!,
                                        false,
                                      );
                                    }
                                  },
                                ),
                              )
                            : Container(
                                height: constraints.maxHeight - 80,
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: _bilateralSellList.length,
                                  itemBuilder: (context, index) {
                                    if (_bilateralSellList[index].amount !=
                                        null) {
                                      return _buildCard(
                                          _bilateralSellList[index].type!,
                                          _bilateralSellList[index].time!,
                                          _bilateralSellList[index].status!,
                                          _bilateralSellList[index].amount!,
                                          _bilateralSellList[index].price!,
                                          _bilateralSellList[index].offerCount!,
                                          _bilateralSellList[index].isoDate!,
                                          _bilateralSellList[index]
                                              .isLongterm!);
                                    } else {
                                      return _buildCard(
                                          _bilateralSellList[index].type!,
                                          _bilateralSellList[index].time!,
                                          _bilateralSellList[index].status!,
                                          0,
                                          0,
                                          _bilateralSellList[index].offerCount!,
                                          _bilateralSellList[index].isoDate!,
                                          false);
                                    }
                                  },
                                ),
                              ),
                        // _buildCloseCard("13:00-14:00", 5, 3),
                        // _buildPeriodCard("14:00-15:00", 5),
                        // _buildPeriodCard("15:00-16:00", 6),
                        // _buildPeriodCard("16:00-17:00", 0),
                        // _buildPeriodCard("17:00-18:00", 2)
                        // TextButton(
                        //   onPressed: _onListTileBuyPressed,
                        //   child: Text('ListTileBuy'),
                        // ),
                        // TextButton(
                        //   onPressed: _onListTileSellPressed,
                        //   child: Text('ListTileSell'),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCard(String type, String time, String status, double amount,
      double price, int offerCount, String isoDate, bool isLongterm) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: GestureDetector(
        onTap: () {
          (_offerInit == "Choose to Buy")
              ? _onListTileBuyPressed(isoDate)
              : _onListTileSellPressed(isoDate);
        },
        child: Card(
          child: IntrinsicHeight(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            time,
                            style: TextStyle(fontSize: 26),
                          ),
                          Text(
                            status,
                            style: TextStyle(
                                fontSize: 23,
                                color: (status == "CLOSE")
                                    ? redColor
                                    : greenColor),
                          ),
                        ],
                      ),
                    ),
                    (amount != 0)
                        ? Row(
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
                                padding: EdgeInsets.all(2),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: Text("Amount",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: primaryColor))),
                                        Text(
                                          amount.toString(),
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: primaryColor),
                                        ),
                                        Text(
                                          " kWh",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: primaryColor),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: Text("Price",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: primaryColor))),
                                        Text(
                                          price.toString(),
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: primaryColor),
                                        ),
                                        Text(
                                          " THB/kWh",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: primaryColor),
                                        ),
                                      ],
                                    ),
                                    (isLongterm)?
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Text(
                                            "Long term Bilateral",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: primaryColor
                                            ),
                                          ),
                                        )
                                      ],
                                    ):Container()
                                  ],
                                ),
                              )
                            ],
                          )
                        : Container(),
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
                          padding: EdgeInsets.all(4),
                          child: Column(
                            children: [
                              Text(
                                offerCount.toString(),
                                style: TextStyle(fontSize: 24),
                              ),
                              Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Text("Offers \nto sell")),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _getData(String date, String time) async {
    DateTime newDate = DateTime.parse(date)
        .add(new Duration(hours: int.parse(time.substring(0, 2))));
    await showLoading();
    BilateralTrade model = Provider.of<BilateralTrade>(context, listen: false);
    try {
      await model.getBilateral(date: newDate.toUtc().toIso8601String());
    } catch (e) {
      showException(context, e.toString());
    } finally {
      await hideLoading();
    }
    setState(() {
      setBilateralList(model.info.bilateralTileList!);
      //   // _initBilateralTileList = model.info.bilateralTileList!;
      //   // _isChecked = List<bool>.filled(_bilateralTileList.length, false);
      //   // _isChecked[0] = true;
    });
  }

  void _onListTileBuyPressed(String isoDate) async {
    // DateTime newDate = DateTime.parse(_dateInit).add(new Duration(hours: int.parse(time.substring(0,2))));
    DateTime newDate = DateTime.parse(isoDate);
    await showLoading();
    BilateralBuy bilateralBuy =
        Provider.of<BilateralBuy>(context, listen: false);

    try {
      await bilateralBuy.getBilateralShortTermBuyInfo(
          date: newDate.toUtc().toIso8601String());
    } catch (e) {
      showException(context, e.toString());
    } finally {
      await hideLoading();
    }
    BilateralTrade model = Provider.of<BilateralTrade>(context, listen: false);
    model.setPageBilateralBuy();
  }

//TODO
  void _onListTileSellPressed(String isoDate) async {
    // DateTime newDate = DateTime.parse(_dateInit).add(new Duration(hours: int.parse(time.substring(0,2))));
    DateTime newDate = DateTime.parse(isoDate);
    await showLoading();
    BilateralSell bilateralBuy =
        Provider.of<BilateralSell>(context, listen: false);
    try {
      await bilateralBuy.getBilateralShortTermSellInfo(
          date: newDate.toUtc().toIso8601String());
    } catch (e) {
      showException(context, e.toString());
    } finally {
      await hideLoading();
    }
    BilateralTrade model = Provider.of<BilateralTrade>(context, listen: false);
    model.setPageBilateralSell();
  }
}
