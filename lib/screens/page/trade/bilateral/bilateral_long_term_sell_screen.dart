import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/page/state/bilateral/bilateral_long_term_sell.dart';
import 'package:egat_flutter/screens/page/widgets/logo_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_bottom_navigation_bar.dart';
import 'package:egat_flutter/screens/page/widgets/side_menu.dart';
import 'package:egat_flutter/screens/page/trade/tabbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BilateralLongTermSellScreen extends StatefulWidget {
  const BilateralLongTermSellScreen({Key? key}) : super(key: key);
  @override
  _BilateralLongTermSellScreenState createState() =>
      _BilateralLongTermSellScreenState();
}

class _BilateralLongTermSellScreenState
    extends State<BilateralLongTermSellScreen> {
  bool _isChecked = false;
  double _currentSliderValue = 9;
  String _date = "";
  var _dateList = ["7 Days", "30 Days", "90 Days", "1 Year"];
  @override
  void initState() {
    super.initState();
    _date = "7 Days";
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
                          _testlisttile(),
                          _testlisttile(),
                          _testlisttile(),
                          _testlisttile()
                        ],
                      ),
                    ),
                  ),
                ),
              ]);
        },
      ),
    );
  }

  Widget _testlisttile() {
    return Column(
      children: [_bodyExpand(), _bodyExpand()],
    );
  }

  Widget _headerExpand() {
    return ListTile(
      title: CheckboxListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        contentPadding: EdgeInsets.all(0),
        title: Text("12:00-13:00"),
        activeColor: primaryColor,
        checkColor: backgroundColor,
        controlAffinity: ListTileControlAffinity.leading,
        value: _isChecked,
        onChanged: (bool? value) {
          setState(() {
            _isChecked = value!;
          });
        },
      ),
    );
  }

  Widget _bodyExpand() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: ExpansionTile(
          tilePadding: EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 15),
          controlAffinity: ListTileControlAffinity.platform,
          title: _headerExpand(),
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
                        child: DropdownButton(
                          value: _date,
                          icon: Icon(Icons.arrow_drop_down_rounded),
                          iconSize: 20,
                          iconEnabledColor: backgroundColor,
                          dropdownColor: primaryColor,
                          style: TextStyle(fontSize: 16, color: backgroundColor),
                          alignment: Alignment.center,
                          borderRadius: BorderRadius.circular(20),
                          onChanged: (String? newValue) {
                            setState(() {
                              _date = newValue!;
                            });
                          },
                          items: _dateList.map((String items) {
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

  void _onSubmitPressed() {
    //Navigate
    BilateralLongTermSell model =
        Provider.of<BilateralLongTermSell>(context, listen: false);
    model.setPageBilateralTrade();
  }

  Future<bool> _onWillPop() async {
    BilateralLongTermSell model =
        Provider.of<BilateralLongTermSell>(context, listen: false);
    model.setPageBack();
    return false;
  }
}
