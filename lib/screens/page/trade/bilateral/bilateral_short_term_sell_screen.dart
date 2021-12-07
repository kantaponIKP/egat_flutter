import 'package:egat_flutter/screens/page/page.dart';
import 'package:egat_flutter/screens/page/state/bilateral/bilateral_short_term_sell.dart';
import 'package:egat_flutter/screens/page/widgets/logo_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_bottom_navigation_bar.dart';
import 'package:egat_flutter/screens/page/widgets/side_menu.dart';
import 'package:egat_flutter/screens/page/trade/tabbar.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:egat_flutter/screens/widgets/show_success_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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
  List<bool> _isChecked = [];
  List<BilateralOfferToSellTile> _bilateralTileList = [];
  List<BilateralOfferToSellTile> _initBilateralTileList = [];
  // bool _isChecked = false;
  double _currentSliderValue = 9;
  List<TradingFee> _tradingFeeList = [];
  double _totalTradingFee = 0;
  double _totalEstimatedSales = 0;

  @override
  void initState() {
    super.initState();

    _getData();
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
                              GestureDetector(
                                onTap: _onLongTermBilateralPressed,
                                child: Container(
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
                                ),
                              )
                            ],
                          ),
                          Container(
                            height: constraints.maxHeight,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: _bilateralTileList.length,
                              itemBuilder: (context, index) {
                                return _buildExpansionTile(
                                    _bilateralTileList[index].date!,
                                    _bilateralTileList[index].energyToSale!,
                                    _bilateralTileList[index].offerToSellPrice!,
                                    index);
                              },
                            ),
                          )
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
                                      _totalTradingFee.toString(),
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
                                      _totalEstimatedSales.toStringAsFixed(2),
                                      style: TextStyle(
                                          fontSize: 20, color: primaryColor),
                                    )),
                                Text("THB"),
                              ],
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showAlertDialog(context);
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
              ]);
        },
      ),
    );
  }

  // Widget _testlisttile() {
  //   return Column(
  //     children: [_bodyExpand(), _bodyExpand()],
  //   );
  // }

  Widget _headerTile(String date, int index) {
    var startDate = DateTime.parse(date).toLocal();
    var endDate = DateTime.parse(date).toLocal().add(new Duration(hours: 1));
    var startHour = DateFormat('HH').format(startDate);
    var endHour = DateFormat('HH').format(endDate);
    String displayTime =
        startHour.toString() + ":00-" + endHour.toString() + ":00";
    String displayDate =
        DateFormat('dd MMMM yyyy').format(DateTime.parse(date).toLocal());
    return ListTile(
      title: CheckboxListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        contentPadding: EdgeInsets.all(0),
        title: Text("Date : $displayDate, Period: $displayTime"),
        activeColor: primaryColor,
        checkColor: backgroundColor,
        controlAffinity: ListTileControlAffinity.leading,
        value: _isChecked[index],
        onChanged: (bool? value) {
          setState(() {
            _isChecked[index] = value!;
            calculateTradingFee();
          });
        },
      ),
    );
  }

  Widget _buildExpansionTile(
      String date, double energyToSell, double offterToSellPrice, int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: ExpansionTile(
          tilePadding: EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 15),
          controlAffinity: ListTileControlAffinity.platform,
          title: _headerTile(date, index),
          collapsedBackgroundColor: surfaceGreyColor,
          backgroundColor: surfaceGreyColor,
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
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d*'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(
                                () {
                                  if (value != "") {
                                    _bilateralTileList[index].energyToSale =
                                        double.parse(value);
                                    calculateTradingFee();
                                  }
                                },
                              );
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
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d*'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(
                                  () {
                                    if (value != "") {
                                      _bilateralTileList[index]
                                              .offerToSellPrice =
                                          double.parse(value);
                                      calculateTradingFee();
                                    }
                                  },
                                );
                              },
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

  void calculateTradingFee() {
    double totalTradingFee = 0;
    double totalEstimatedSales = 0;
    int i = 0;
    for (var _bilateral in _bilateralTileList) {
      if (_isChecked[i] == true) {
        totalTradingFee = totalTradingFee + (_tradingFeeList[i].tradingFee! * _bilateral.energyToSale!);
        totalEstimatedSales =
            _bilateral.energyToSale! * _bilateral.offerToSellPrice!;
      }
      i++;
    }
    totalEstimatedSales = totalEstimatedSales + totalTradingFee;
    setState(() {
      _totalTradingFee = totalTradingFee;
      _totalEstimatedSales = totalEstimatedSales;
    });
  }

  void _getData() async {
    BilateralShortTermSell model =
        Provider.of<BilateralShortTermSell>(context, listen: false);

    List<BilateralOfferToSellTile> list = [];
    for (var i = 0; i < model.info.dateList!.length; i++) {
      list.add(BilateralOfferToSellTile(
          date: model.info.dateList![i], energyToSale: 0, offerToSellPrice: 0));
    }

    // await model.getBilateralBuy();
    setState(() {
      _bilateralTileList = list;
      // _initBilateralTileList = model.info.bilateralTileList!;
      _isChecked = List<bool>.filled(_bilateralTileList.length, false);
    });

    await showLoading();
    try {
      await model.getBilateralTradingFee();
    } catch (e) {
      showException(context, e.toString());
    } finally {
      await hideLoading();
    }

    setState(() {
      _tradingFeeList = model.info.tradingFee!;
    });
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

  void _onSubmitPressed() async {
    //Navigate
    List<BilateralOfferToSellTile> _bilateralTileListOutput = [];
    int i = 0;
    for (var _bilateral in _bilateralTileList) {
      if (_isChecked[i] == true) {
        _bilateralTileListOutput.add(_bilateral);
      }
      i++;
    }
    bool response = false;
    await showLoading();
    BilateralShortTermSell model =
        Provider.of<BilateralShortTermSell>(context, listen: false);
    try {
      response = await model.bilateralShortTermSell(_bilateralTileListOutput);
    } catch (e) {
      showException(context, e.toString());
    } finally {
      await hideLoading();
      
    }

    if(response == true){
      model.setPageBilateralTrade();
      showSuccessSnackBar(context, "ทำรายการสำเร็จ");
    }else{
      //TODO
      showException(context, "ไม่สามารถทำรายการได้");
    }
    // model.setPageBilateralTrade();
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Short term Bilateral",
                  style: TextStyle(color: primaryColor, fontSize: 24),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Offer to sell",
                  style: TextStyle(color: greenColor, fontSize: 18),
                ),
              ],
            ),
            content: Container(
              padding: EdgeInsets.all(5),
              width: MediaQuery.of(context).size.width / 1.5,
              height: MediaQuery.of(context).size.width / 3.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: _bilateralTileList
                      .map((item) => new Text(
                            "Period: ${item.date.toString()} Price ${item.offerToSellPrice.toString()} THB/kWh",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: blackColor),
                          ))
                      .toList(),
                ),
              ),
            ),
            backgroundColor: Colors.grey[800],
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              FlatButton(
                  onPressed: () {
                    _onSubmitPressed();
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Text(
                        "Agree",
                        style: TextStyle(color: blackColor),
                      ),
                    ),
                  )),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: greyColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: blackColor),
                      ),
                    ),
                  )),
            ],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          );
        });
  }
}
