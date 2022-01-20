import 'package:egat_flutter/screens/pages/main/home/buysell/pool/buy/pool_market_buy_page.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:egat_flutter/constant.dart';

import 'apis/models/TransactionSubmitItem.dart';
import 'pool_market_short_term_buy_page.dart';
import 'pool_market_short_term_sell_page.dart';
import 'pool_market_short_term_sell_screen.dart';
import 'sell/pool_market_sell_page.dart';
import 'states/pool_market_short_term_buy.dart';
import 'states/pool_market_short_term_sell.dart';
import 'states/pool_market_trade.dart';

class PoolMarketTradeScreen extends StatefulWidget {
  const PoolMarketTradeScreen({Key? key}) : super(key: key);

  @override
  _PoolMarketTradeScreenState createState() => _PoolMarketTradeScreenState();
}

class _PoolMarketTradeScreenState extends State<PoolMarketTradeScreen> {
  var dateItem = <String>[];

  var timeItem = ["06:00-18:00", "18:00-06:00"];
  var offerItem = ["Bid to Buy", "Offer to Sell"];
  String _time = "";
  String _date = "";
  String _offerInit = "";
  var _poolMarketList = [];
  var _poolMarketBuyList = [];
  var _poolMarketSellList = [];

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

    _time = timeItem.first;
    _date = dateItem.first.toString();
    int hour = DateTime.now().hour;
    if (hour < 18 && hour >= 6) {
      _time = timeItem.first;
    }
    {
      _time = timeItem.last;
    }
    _offerInit = offerItem.first;

    _getData(_date, _time);
  }

  void setPoolMarketList(poolMarketList) {
    var poolMarketBuyList = [];
    var poolMarketSellList = [];

    for (var poolMarket in poolMarketList) {
      if (poolMarket.type == "buy") {
        poolMarketBuyList.add(poolMarket);
      } else {
        poolMarketSellList.add(poolMarket);
      }
    }
    setState(() {
      _poolMarketSellList = poolMarketSellList;
      _poolMarketBuyList = poolMarketBuyList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Color(0xFF303030),
            Colors.black,
          ],
        ),
      ),
      child: _buildAction(context),
    );
  }

  Padding _buildAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            // Row of dropdown box
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 35,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[900],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: DropdownButton(
                                      value: _time,
                                      icon: Icon(
                                        Icons.arrow_drop_down_rounded,
                                      ),
                                      iconSize: 20,
                                      alignment: Alignment.center,
                                      borderRadius: BorderRadius.circular(20),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _time = newValue!;
                                          _getData(_date, newValue);
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
                                    ),
                                  ),
                                  Container(
                                    height: 35,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[900],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: DropdownButton(
                                      value: _date,
                                      icon: Icon(Icons.arrow_drop_down_rounded),
                                      iconSize: 20,
                                      alignment: Alignment.center,
                                      borderRadius: BorderRadius.circular(20),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _date = newValue!;
                                          _getData(newValue, _time);
                                        });
                                      },
                                      items: dateItem.map((String items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(DateFormat('dd MMMM yyyy')
                                              .format(DateTime.parse(items)
                                                  .toLocal())),
                                        );
                                      }).toList(),
                                      underline: DropdownButtonHideUnderline(
                                        child: Container(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                                      fontSize: 18, color: backgroundColor),
                                  alignment: Alignment.center,
                                  borderRadius: BorderRadius.circular(20),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _offerInit = newValue!;
                                      _getData(_date, _time);
                                    });
                                  },
                                  items: offerItem.map(
                                    (String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(
                                          items,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                  underline: DropdownButtonHideUnderline(
                                    child: Container(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        (_offerInit == "Bid to Buy")
                            ? Container(
                                height: constraints.maxHeight - 55,
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: _poolMarketBuyList.length,
                                  itemBuilder: (context, index) {
                                    if (_poolMarketBuyList[index].price !=
                                        null) {
                                      return _buildCard(
                                          time: _poolMarketBuyList[index].time,
                                          status:
                                              _poolMarketBuyList[index].status,
                                          offer: _poolMarketBuyList[index]
                                              .offerCount,
                                          matched:
                                              _poolMarketBuyList[index].matched,
                                          price:
                                              _poolMarketBuyList[index].price,
                                          volume:
                                              _poolMarketBuyList[index].volume,
                                          isoDate:
                                              _poolMarketBuyList[index].isoDate,
                                          offerAmount: _poolMarketBuyList[index]
                                              .offerAmount,
                                          offerPrice: _poolMarketBuyList[index]
                                              .offerPrice,
                                          isMatched: _poolMarketBuyList[index]
                                              .isMatched);
                                    } else {
                                      return _buildCard(
                                        time: _poolMarketBuyList[index].time,
                                        status:
                                            _poolMarketBuyList[index].status,
                                        offer: _poolMarketBuyList[index]
                                            .offerCount,
                                        matched:
                                            _poolMarketBuyList[index].matched,
                                        price: null,
                                        volume: null,
                                        isoDate:
                                            _poolMarketBuyList[index].isoDate,
                                        offerAmount: _poolMarketBuyList[index]
                                            .offerAmount,
                                        offerPrice: _poolMarketBuyList[index]
                                            .offerPrice,
                                        isMatched:
                                            _poolMarketBuyList[index].isMatched,
                                      );
                                    }
                                  },
                                ),
                              )
                            : Container(
                                height: constraints.maxHeight - 55,
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: _poolMarketSellList.length,
                                  itemBuilder: (context, index) {
                                    if (_poolMarketSellList[index].price !=
                                        null) {
                                      return _buildCard(
                                          time: _poolMarketSellList[index].time,
                                          status:
                                              _poolMarketSellList[index].status,
                                          offer: _poolMarketSellList[index]
                                              .offerCount,
                                          matched: _poolMarketSellList[index]
                                              .matched,
                                          price:
                                              _poolMarketSellList[index].price,
                                          volume:
                                              _poolMarketSellList[index].volume,
                                          isoDate: _poolMarketSellList[index]
                                              .isoDate,
                                          offerAmount:
                                              _poolMarketSellList[index]
                                                  .offerAmount,
                                          offerPrice: _poolMarketSellList[index]
                                              .offerPrice,
                                          isMatched: _poolMarketSellList[index]
                                              .isMatched);
                                    } else {
                                      return _buildCard(
                                          time: _poolMarketSellList[index].time,
                                          status:
                                              _poolMarketSellList[index].status,
                                          offer: _poolMarketSellList[index]
                                              .offerCount,
                                          matched: _poolMarketSellList[index]
                                              .matched,
                                          price: null,
                                          volume: null,
                                          isoDate: _poolMarketSellList[index]
                                              .isoDate,
                                          offerAmount:
                                              _poolMarketSellList[index]
                                                  .offerAmount,
                                          offerPrice: _poolMarketSellList[index]
                                              .offerPrice,
                                          isMatched: _poolMarketSellList[index]
                                              .isMatched);
                                    }
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildCard({
    String? time,
    String? status,
    int? offer,
    int? matched,
    double? price,
    double? volume,
    String? isoDate,
    double? offerAmount,
    double? offerPrice,
    bool? isMatched,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: GestureDetector(
        onTap: price == null && offerAmount == null && status != 'CLOSE'
            ? () {
                (_offerInit == "Bid to Buy")
                    ? _onListTileBuyPressed(isoDate!)
                    : _onListTileSellPressed(isoDate!);
              }
            : null,
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
                        time!,
                        style: TextStyle(fontSize: 26),
                      ),
                      Text(
                        status!,
                        style: TextStyle(
                            fontSize: 23,
                            color: (status == "CLOSE") ? redColor : greenColor),
                      )
                    ],
                  ),
                ),
                (offerAmount != 0 && offerAmount != null && status == "OPEN")
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
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        child: Text("Amount",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: primaryColor))),
                                    Text(
                                      offerAmount.toString(),
                                      style: TextStyle(
                                          fontSize: 12, color: primaryColor),
                                    ),
                                    Text(
                                      " kWh",
                                      style: TextStyle(
                                          fontSize: 12, color: primaryColor),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        child: Text("Price",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: primaryColor))),
                                    Text(
                                      offerPrice.toString(),
                                      style: TextStyle(
                                          fontSize: 12, color: primaryColor),
                                    ),
                                    Text(
                                      " THB/kWh",
                                      style: TextStyle(
                                          fontSize: 12, color: primaryColor),
                                    ),
                                  ],
                                ),
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
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          (status == "CLOSE")
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                      Text(offer.toString(),
                                          style: TextStyle(
                                              fontSize: 24,
                                              color: (isMatched!)
                                                  ? primaryColor
                                                  : whiteColor)),
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        child: Text(
                                          (_offerInit == "Bid to Buy")
                                              ? "Offers \nto buy"
                                              : "Offers \nto sell",
                                          style: TextStyle(
                                              color: (isMatched)
                                                  ? primaryColor
                                                  : whiteColor),
                                        ),
                                      ),
                                    ])
                              : Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                      Text(offer.toString(),
                                          style: TextStyle(
                                              fontSize: 24,
                                              color: (isMatched! &&
                                                      status == "CLOSE")
                                                  ? primaryColor
                                                  : whiteColor)),
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        child: Text(
                                          (_offerInit == "Bid to Buy")
                                              ? "Offers \nto buy"
                                              : "Offers \nto sell",
                                          style: TextStyle(
                                              color: (isMatched &&
                                                      status == "CLOSE")
                                                  ? primaryColor
                                                  : whiteColor),
                                        ),
                                      ),
                                    ]),
                          (status == "CLOSE")
                              ? Container(
                                  height: 20,
                                  width: 80,
                                  child: Divider(
                                    color: whiteColor,
                                    height: 10,
                                    thickness: 1,
                                  ),
                                )
                              : Container(),
                          (status == "CLOSE")
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      matched.toString(),
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: (isMatched)
                                              ? primaryColor
                                              : whiteColor),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      child: Text(
                                        "Matched",
                                        style: TextStyle(
                                            color: (isMatched)
                                                ? primaryColor
                                                : whiteColor),
                                      ),
                                    )
                                  ],
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            (price != null && volume != null)
                ? Container(
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
                                  price.toStringAsFixed(2),
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
                                  volume.toStringAsFixed(2),
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
                  )
                : Container(),

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
      ),
    );
  }

  void _onListTileBuyPressed(String isoDate) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PoolMarketBuyPage(
          requestItems: [
            TransactionSubmitItem(
              date: DateTime.parse(isoDate),
              amount: 1,
              price: 3,
            ),
          ],
        ),
      ),
    );

    _getData(_date, _time);
  }

  void _onListTileSellPressed(String isoDate) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PoolMarketSellPage(
          requestItems: [
            TransactionSubmitItem(
              date: DateTime.parse(isoDate),
              amount: 1,
              price: 3,
            ),
          ],
        ),
      ),
    );
  }

  void _getData(String date, String time) async {
    DateTime newDate = DateTime.parse(date)
        .add(new Duration(hours: int.parse(time.substring(0, 2))));

    await showLoading();
    PoolMarketTrade model =
        Provider.of<PoolMarketTrade>(context, listen: false);

    LoginSession session = Provider.of<LoginSession>(context, listen: false);
    try {
      await model.getPoolMarket(
        date: newDate.toUtc().toIso8601String(),
        accessToken: session.info!.accessToken,
      );
    } catch (e) {
      showException(context, e.toString());
    } finally {
      await hideLoading();
    }
    setState(() {
      setPoolMarketList(model.info.poolMarketTileList!);
    });
  }
}
