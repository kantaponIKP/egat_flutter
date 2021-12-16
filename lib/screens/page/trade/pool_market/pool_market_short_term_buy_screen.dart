import 'package:egat_flutter/screens/page/state/pool_market/pool_market_short_term_buy.dart';
import 'package:egat_flutter/screens/page/state/pool_market/pool_market_short_term_sell.dart';
import 'package:egat_flutter/screens/page/widgets/logo_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_bottom_navigation_bar.dart';
import 'package:egat_flutter/screens/page/widgets/side_menu.dart';
import 'package:egat_flutter/screens/page/trade/tabbar.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:egat_flutter/screens/widgets/show_success_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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

  DateTime? _date;
  double? _energyToBuy;
  double? _energyTariff;
  double? _energyPrice;
  double? _wheelingChargeTariff;
  double? _wheelingCharge;
  double? _totalTradingFee;
  double? _vat;
  double? _estimatedBuy;
  double? _estimateNetPrice;
  double? _tradingFee;

  List<bool> _isChecked = [];
  // List<TextEditingController> _energyToSaleTextController = [];
  // List<TextEditingController> _offerToSellPriceTextController = [];
  PoolMarketShortTermSellTile? _poolMarketTile;
  // List<PoolMarketShortTermSellTile> _poolMarketTileList = [];
  final _energyToBuyTextController = TextEditingController();
  final _offerToSellPriceTextController= TextEditingController();

  Icon _Togglevisible = Icon(
    Icons.arrow_drop_down_rounded,
    size: 30,
  );
  PoolMarketReference _poolMarketShortTermBuyDetail = PoolMarketReference();

  @override
  void initState() {
    super.initState();

    _energyToBuyTextController.text = "0";
    _offerToSellPriceTextController.text = "0";
    _date = DateTime.now();
    _energyToBuy = 0;
    _energyTariff = 0;
    _energyPrice = 0;
    _wheelingChargeTariff = 0;
    _wheelingCharge = 0;
    _tradingFee = 0;
    _totalTradingFee = 0;
    _vat = 0;
    _estimatedBuy = 0;
    _estimateNetPrice = 0;

    _setTime();
    _getData();
  }

  void _setTime() {
    PoolMarketShortTermBuy model =
        Provider.of<PoolMarketShortTermBuy>(context, listen: false);
    DateTime date = DateTime.parse(model.info.date!);
    setState(() {
      _date = date;
    });
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
              _buildDetail(),
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
                                      _estimatedBuy!.toStringAsFixed(2),
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
                            "Estimate Net Price",
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
                                    _estimateNetPrice!.toStringAsFixed(2),
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

  Widget _buildDetail() {
    PoolMarketShortTermBuy model =
        Provider.of<PoolMarketShortTermBuy>(context, listen: false);
    return Visibility(
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
                        Text(_energyToBuy!.toStringAsFixed(2)),
                        SizedBox(
                          width: 5,
                        ),
                        Text("kWh")
                      ],
                    ),
                    Row(
                      children: [
                        Text(_energyTariff!.toStringAsFixed(2)),
                        SizedBox(
                          width: 5,
                        ),
                        Text("THB/kWh")
                      ],
                    ),
                    Row(
                      children: [
                        Text(_energyPrice!.toStringAsFixed(2)),
                        SizedBox(
                          width: 5,
                        ),
                        Text("THB")
                      ],
                    ),
                    Row(
                      children: [
                        Text(_wheelingChargeTariff!.toStringAsFixed(2)),
                        SizedBox(
                          width: 5,
                        ),
                        Text("THB/kWh")
                      ],
                    ),
                    Row(
                      children: [
                        Text(_wheelingCharge!.toStringAsFixed(2)),
                        SizedBox(
                          width: 5,
                        ),
                        Text("THB")
                      ],
                    ),
                    Row(
                      children: [
                        Text(_tradingFee!.toStringAsFixed(2)),
                        SizedBox(
                          width: 5,
                        ),
                        Text("THB")
                      ],
                    ),
                    Row(
                      children: [
                        Text(_vat!.toStringAsFixed(2)),
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
    );
  }

  Widget _bodyExpand() {
    var startDate = _date!.toLocal();
    var endDate = _date!.toLocal().add(new Duration(hours: 1));
    var startHour = DateFormat('HH').format(startDate);
    var endHour = DateFormat('HH').format(endDate);
    String displayDate = "Date: " +
        DateFormat('dd MMMM yyyy').format(startDate) +
        ", Period: " +
        startHour.toString() +
        ":00-" +
        endHour.toString() +
        ":00";
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
          decoration: BoxDecoration(color: surfaceColor),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayDate,
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
                        "Energy to Buy",
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
                            controller: _energyToBuyTextController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d*'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != "") {
                                calculateEstimated();
                              }
                            },
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
                            controller: _offerToSellPriceTextController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d*'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != "") {
                                calculateEstimated();
                              }
                            },
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
          ),
          ),
    );
  }

  void calculateEstimated() {
    setState(() {
      _energyToBuy = double.parse(_energyToBuyTextController.text);
      _energyTariff = double.parse(_offerToSellPriceTextController.text);
      _energyPrice = _energyToBuy! * _energyTariff!;
      _wheelingCharge = _wheelingChargeTariff! * _energyToBuy!;
      _totalTradingFee = _energyToBuy! * _tradingFee!;
      _vat = (_energyPrice! + _wheelingCharge! + _totalTradingFee!) * 0.07;
      _estimatedBuy =
          _energyPrice! + _wheelingCharge! + _totalTradingFee! + _vat!;
      _estimateNetPrice = _estimatedBuy! / _energyToBuy!;
    });
  }

  void _getData() async {
    PoolMarketShortTermBuy model =
        Provider.of<PoolMarketShortTermBuy>(context, listen: false);

    await showLoading();
    try {
      _wheelingChargeTariff =
          model.info.poolMarketReference!.wheelingChargeTariff;
      _tradingFee = model.info.poolMarketReference!.tradingFee;
      // await model.getPoolMarketReferences();
      // setState(() {
      //   _poolMarketShortTermBuyDetail =
      //       model.info.poolMarketShortTermBuyDetail!;
      //   _isChecked = List<bool>.filled(_poolMarketTileList.length, false);
      //   _energyToSaleTextController = List.generate(
      //       _poolMarketTileList.length, (i) => TextEditingController());
      //   _offerToSellPriceTextController = List.generate(
      //       _poolMarketTileList.length, (i) => TextEditingController());
      // });
    } catch (e) {
      showException(context, e.toString());
    } finally {
      await hideLoading();
    }
  }

  void _onSubmitPressed() async {
    //Navigate
    await showLoading();
    // List<PoolMarketShortTermSellTile> _poolMarketTileListOutput = [];
    // int i = 0;
    // for (var _poolMarket in _poolMarketTileList) {
    //   if (_isChecked[i] == true) {
    //     _poolMarket.energyToSale =
    //         double.parse(_energyToSaleTextController[i].text);
    //     _poolMarket.offerToSellPrice =
    //         double.parse(_offerToSellPriceTextController[i].text);
    //     _poolMarketTileListOutput.add(_poolMarket);
    //   }
    //   i++;
    // }

    PoolMarketShortTermBuy model =
        Provider.of<PoolMarketShortTermBuy>(context, listen: false);

    bool response = false;
    try {
      //TODO
      response = await model.poolMarketShortTermBuy(
          date: _date!.toUtc().toIso8601String(),
          energy: _energyToBuy!,
          price: _energyPrice!);
    } catch (e) {
      showException(context, e.toString());
    } finally {
      await hideLoading();
    }
    if (response == true) {
      model.setPagePoolMarketTrade();
      showSuccessSnackBar(context, "ทำรายการสำเร็จ");
    } else {
      //TODO
      showException(context, "ไม่สามารถทำรายการได้");
    }
    // model.setPageBilateralTrade();
  }

  Future<bool> _onWillPop() async {
    PoolMarketShortTermBuy model =
        Provider.of<PoolMarketShortTermBuy>(context, listen: false);
    model.setPageBack();
    return false;
  }
}
