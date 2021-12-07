import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/page/state/bilateral/bilateral_long_term_sell.dart';
import 'package:egat_flutter/screens/page/trade/bottom_button.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_bottom_navigation_bar.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:egat_flutter/screens/widgets/show_success_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BilateralLongTermSellScreen extends StatefulWidget {
  const BilateralLongTermSellScreen({Key? key}) : super(key: key);
  @override
  _BilateralLongTermSellScreenState createState() =>
      _BilateralLongTermSellScreenState();
}

class _BilateralLongTermSellScreenState
    extends State<BilateralLongTermSellScreen> {
  List<bool> _isChecked = [];
  List<TextEditingController> _energyToSaleTextController = [];
  List<TextEditingController> _offerToSellPriceTextController = [];
  double _currentSliderValue = 9;
  List<BilateralLongtermSellTile> _bilateralTileList = [];
  List<BilateralLongtermSellTile> _initBilateralTileList = [];

  String _date = "";
  var _daysList = [7, 30, 90, 365];
  var _daysMap = {
    7: '7 Days',
    30: '30 Days',
    90: '90 Days',
    365: '1 Year',
  };

  @override
  void initState() {
    super.initState();

    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: PageAppbar(
            firstTitle: "Long Term", secondTitle: "Bilateral (Sell)"),
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
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Period",
                                            style: TextStyle(
                                              fontSize: 24,
                                            ),
                                          ),
                                          Text(
                                            "Everyday",
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ]),
                            ],
                          ),
                          Container(
                            height: constraints.maxHeight,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: _bilateralTileList.length,
                              itemBuilder: (context, index) {
                                if (_bilateralTileList[index]
                                        .dayOptions!
                                        .length >
                                    0) {
                                  return __bilateralTile(
                                      _bilateralTileList[index].time!,
                                      _bilateralTileList[index].days!,
                                      _bilateralTileList[index].energy!,
                                      _bilateralTileList[index].price!,
                                      index);
                                }
                                return __bilateralTile(
                                    _bilateralTileList[index].time!,
                                    30,
                                    0,
                                    0,
                                    index);
                              },
                            ),
                          )
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

  Widget _headerExpand(String time, index) {
    var startDate = DateTime.parse(time).toLocal();
    var endDate = DateTime.parse(time).toLocal().add(new Duration(hours: 1));
    var startHour = DateFormat('HH').format(startDate);
    var endHour = DateFormat('HH').format(endDate);
    String displayDate =
        startHour.toString() + ":00-" + endHour.toString() + ":00";
    return ListTile(
      title: CheckboxListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        contentPadding: EdgeInsets.all(0),
        title: Text(
          displayDate,
          style: (_bilateralTileList[index].isActive == true)
              ? TextStyle(color: textColor.withAlpha(300))
              : TextStyle(color: textColor),
        ),
        activeColor: primaryColor,
        checkColor: backgroundColor,
        controlAffinity: ListTileControlAffinity.leading,
        value: _isChecked[index],
        onChanged: (bool? value) {
          setState(() {
            if (_bilateralTileList[index].isActive == true) {
            } else {
              _isChecked[index] = value!;
            }
          });
        },
      ),
    );
  }

  Widget __bilateralTile(String time, int days, double energyToSale,
      double offerToSellPrice, int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: ExpansionTile(
          tilePadding: EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 15),
          controlAffinity: ListTileControlAffinity.platform,
          title: _headerExpand(time, index),
          collapsedBackgroundColor: surfaceGreyColor,
          backgroundColor: surfaceGreyColor,
          textColor: textColor,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Days",
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Container(
                        height: 35,
                        padding: EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButton<int>(
                          // value: _date,
                          //TODO
                          value: days,
                          icon: Icon(Icons.arrow_drop_down_rounded),
                          iconSize: 20,
                          iconEnabledColor: backgroundColor,
                          dropdownColor: primaryColor,
                          style:
                              TextStyle(fontSize: 16, color: backgroundColor),
                          alignment: Alignment.center,
                          borderRadius: BorderRadius.circular(20),
                          onChanged: (newValue) {
                            setState(() {
                              _bilateralTileList[index].days = newValue;
                            });
                          },
                          items: _daysList.map((int items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(_daysMap[items]!),
                            );
                          }).toList(),
                          underline: DropdownButtonHideUnderline(
                            child: Container(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
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
                              controller: _energyToSaleTextController[index],
                              // onChanged: (value) {
                              // setState(
                              //   () {
                              //     _bilateralTileList[index].energy =
                              //         double.parse(value);
                              //   },
                              // );
                              // },
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: primaryColor))),
                            ),
                          ),
                          Text(
                            "kWh",
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
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
                    value: energyToSale,
                    activeColor: primaryColor,
                    thumbColor: primaryColor,
                    min: 0.00,
                    max: 10.00,
                    divisions: 1000,
                    label: energyToSale.toStringAsFixed(2),
                    onChanged: (double value) {
                      setState(() {
                        energyToSale = value;
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
                              controller:
                                  _offerToSellPriceTextController[index],
                              // onChanged: (value) {
                              //   setState(
                              //     () {
                              //       _bilateralTileList[index].price =
                              //           double.parse(value);
                              //     },
                              //   );
                              // },
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: primaryColor))),
                            ),
                          ),
                          Text(
                            "THB/kWh",
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

  void _getData() async {
    BilateralLongTermSell model =
        Provider.of<BilateralLongTermSell>(context, listen: false);
    try {
      await model.getBilateralLongTermSellInfo();
    } catch (e) {
      showException(context, e.toString());
    } finally {
      await hideLoading();
    }
    setState(() {
      _bilateralTileList = model.info.bilateralTileList!;
      _initBilateralTileList = model.info.bilateralTileList!;
      _isChecked = List<bool>.filled(_bilateralTileList.length, false);
      _energyToSaleTextController = List.generate(
          _bilateralTileList.length, (i) => TextEditingController());
      _offerToSellPriceTextController = List.generate(
          _bilateralTileList.length, (i) => TextEditingController());
      for (int i = 0; i < _bilateralTileList.length; i++) {
        _energyToSaleTextController[i].text =
            _bilateralTileList[i].energy.toString();
        _offerToSellPriceTextController[i].text =
            _bilateralTileList[i].price.toString();
      }
    });
  }

  void _onSubmitPressed() async {
    //Navigate
    await showLoading();
    List<BilateralLongtermSellTile> _bilateralTileListOutput = [];
    int i = 0;
    for (var _bilateral in _bilateralTileList) {
      if (_isChecked[i] == true) {
        _bilateral.energy = double.parse(_energyToSaleTextController[i].text);
        _bilateral.price =
            double.parse(_offerToSellPriceTextController[i].text);
        _bilateralTileListOutput.add(_bilateral);
      }
      i++;
    }

    BilateralLongTermSell model =
        Provider.of<BilateralLongTermSell>(context, listen: false);

    bool response = false;
    try {
      //TODO
      response = await model.bilateralLongTermSell(_bilateralTileListOutput);
    } catch (e) {
      showException(context, e.toString());
    } finally {
      await hideLoading();
    }
    if (response == true) {
      model.setPageBilateralTrade();
      showSuccessSnackBar(context, "ทำรายการสำเร็จ");
    } else {
      //TODO
      showException(context, "ไม่สามารถทำรายการได้");
    }
    // model.setPageBilateralTrade();
  }

  Future<bool> _onWillPop() async {
    BilateralLongTermSell model =
        Provider.of<BilateralLongTermSell>(context, listen: false);
    model.setPageBack();
    return false;
  }
}
