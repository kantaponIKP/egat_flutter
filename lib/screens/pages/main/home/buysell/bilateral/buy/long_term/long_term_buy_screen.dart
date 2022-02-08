import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/page/trade/bottom_button.dart';
import 'package:egat_flutter/screens/page/widgets/logo_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/navigation_back.dart';
import 'package:egat_flutter/screens/page/widgets/page_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_bottom_navigation_bar.dart';
import 'package:egat_flutter/screens/page/widgets/side_menu.dart';
import 'package:egat_flutter/screens/page/trade/tabbar.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/bilateral/buy/long_term/states/long_term_buy_state.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/pin_input_blocker.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:egat_flutter/screens/widgets/show_success_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BilateralLongTermBuyScreen extends StatefulWidget {
  const BilateralLongTermBuyScreen({Key? key}) : super(key: key);

  @override
  _BilateralLongTermBuyScreenState createState() =>
      _BilateralLongTermBuyScreenState();
}

class _BilateralLongTermBuyScreenState
    extends State<BilateralLongTermBuyScreen> {
  int _groupValue = 0;
  var _daysMap = {
    0: 7,
    1: 30,
    2: 90,
    3: 365,
  };
  List<bool> _isChecked = [];
  int _days = 0;
  List<BilateralLongtermBuyTile> _bilateralTileList = [];
  List<BilateralLongtermBuyTile> _initBilateralTileList = [];

  String _offerinit = "";
  var offerItem = ["16:00-17:00", "17:00-18:00", "18:00-19:00", "19:00-20:00"];
  var _time = [];
  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    _offerinit = offerItem.first;
    _setTime();
    _getData();
  }

  void _setTime() {
    BilateralLongTermBuy model =
        Provider.of<BilateralLongTermBuy>(context, listen: false);
    DateTime dateTemp = DateTime.parse(model.info.date!);
    setState(() {
      _date = dateTemp;
    });
  }

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
                          Container(
                            height: constraints.maxHeight,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: _bilateralTileList.length,
                              itemBuilder: (context, index) {
                                return _buildExpansionTile(
                                  _bilateralTileList[index].name!,
                                  _bilateralTileList[index].time!,
                                  _bilateralTileList[index].energyToBuy!,
                                  _bilateralTileList[index].netEnergyPrice!,
                                  _bilateralTileList[index].energyTariff!,
                                  _bilateralTileList[index]
                                      .wheelingChargeTariff!,
                                  _bilateralTileList[index].tradingFee!,
                                  index,
                                  _bilateralTileList[index].energyTariff!,
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                BottomButton(
                    onAction: _onSubmitPressed,
                    actionLabel:
                        Text(AppLocalizations.of(context).translate('submit')))
              ]);
        },
      ),
    );
  }

  Widget _headerTile(
      String title, String date, double estimated, double price, int index) {
    var startDate = DateTime.parse(date).toLocal();
    var endDate = DateTime.parse(date).toLocal().add(new Duration(hours: 1));
    var startHour = DateFormat('HH').format(startDate);
    var endHour = DateFormat('HH').format(endDate);
    String displayDate = startHour.toString() +
        ":00-" +
        endHour.toString() +
        ":00 ${AppLocalizations.of(context).translate('everyday')}";
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          // ListTile(
          //   title: CheckboxListTile(
          //     value: _isChecked[index],
          //     onChanged: (bool? value) {
          //       setState(() {
          //         _isChecked[index] = value!;
          //       });
          //     },
          //     controlAffinity: ListTileControlAffinity.leading,
          //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          //     activeColor: primaryColor,
          //     checkColor: backgroundColor,
          //     contentPadding: EdgeInsets.all(0),
          //     title:
          Radio<int>(
              value: index,
              groupValue: _groupValue,
              onChanged: (val) {
                setState(() {
                  _groupValue = val!;
                });
              }),
          Expanded(
            child: Container(
              // color: greyColor,
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
                          displayDate,
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
                          estimated.toStringAsFixed(2),
                          style: TextStyle(color: primaryColor, fontSize: 10),
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
                      padding: EdgeInsets.only(
                          top: 12, bottom: 12, left: 0, right: 0),
                      child: Column(
                        children: [
                          RichText(
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              style: TextStyle(fontSize: 8),
                              children: <TextSpan>[
                                TextSpan(text: "Estimated buy "),
                                TextSpan(text: estimated.toStringAsFixed(2)),
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
                                TextSpan(text: price.toStringAsFixed(2)),
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
        ],
      ),
    );
  }

  Widget _buildExpansionTile(
    String title,
    String date,
    double energyToBuy,
    double netEstimatedPrice,
    double energyTariff,
    double wheelingChargeTariff,
    double tradingFee,
    int index,
    double energyPrice,
  ) {
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
            title:
                _headerTile(title, date, energyToBuy, netEstimatedPrice, index),
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
                                energyToBuy.toStringAsFixed(2),
                                style: TextStyle(
                                    color: primaryColor, fontSize: 12),
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
                              "Energy tariff",
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
                                energyTariff.toStringAsFixed(2),
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
                                wheelingChargeTariff.toStringAsFixed(2),
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
                                tradingFee.toStringAsFixed(2),
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
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  AppLocalizations.of(context)
                                      .translate('trade-netEnergyPrice'),
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
                                  AppLocalizations.of(context)
                                      .translate('trade-notIncludeVat'),
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 8,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                netEstimatedPrice.toStringAsFixed(2),
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
              child: Radio<int>(
                value: 0,
                groupValue: _days,
                onChanged: (value) {
                  _setDays(value);
                },
              ),
            ),
            Text(
              '7 ${AppLocalizations.of(context).translate('days')}',
              style: TextStyle(fontSize: 14.0),
            ),
            SizedBox(width: 4)
          ]),
          Row(children: <Widget>[
            SizedBox(
              width: 30,
              child: Radio<int>(
                value: 1,
                groupValue: _days,
                onChanged: (value) {
                  _setDays(value);
                },
              ),
            ),
            Text(
              '30 ${AppLocalizations.of(context).translate('days')}',
              style: TextStyle(fontSize: 14.0),
            ),
            SizedBox(width: 4)
          ]),
          Row(children: <Widget>[
            SizedBox(
              width: 30,
              child: Radio<int>(
                value: 2,
                groupValue: _days,
                onChanged: (value) {
                  _setDays(value);
                },
              ),
            ),
            Text(
              '90 ${AppLocalizations.of(context).translate('days')}',
              style: TextStyle(fontSize: 14.0),
            ),
            SizedBox(width: 4)
          ]),
          Row(children: <Widget>[
            SizedBox(
              width: 30,
              child: Radio<int>(
                value: 3,
                groupValue: _days,
                onChanged: (value) {
                  _setDays(value);
                },
              ),
            ),
            Text(
              '1 ${AppLocalizations.of(context).translate('year')}',
              style: TextStyle(fontSize: 14.0),
            ),
          ]),
        ]);
  }

  void _setDays(int? value) {
    setState(() {
      _days = value!;
      _groupValue = _days;
      _getData();
    });
  }

  Widget _buildPeriodSection() {
    BilateralLongTermBuy model = Provider.of<BilateralLongTermBuy>(context);
    DateTime dateTemp = DateTime.parse(model.info.date!).toUtc();
    var dateList = <DateTime>[];
    for (int i = 0; i < 24; i++) {
      dateList.add(dateTemp.add(new Duration(hours: i)));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).translate('trade-bilateral-period'),
            ),
            Text(
              AppLocalizations.of(context).translate('everyday'),
            ),
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
            value: _date.toUtc().toString(),
            icon: Icon(Icons.arrow_drop_down_rounded),
            iconSize: 20,
            iconEnabledColor: whiteColor,
            dropdownColor: surfaceGreyColor,
            style: TextStyle(fontSize: 16, color: whiteColor),
            alignment: Alignment.center,
            borderRadius: BorderRadius.circular(20),
            onChanged: (String? newValue) {
              if (newValue != null) {
                _setNewDate(newValue);
              }
            },
            items: dateList.map((DateTime item) {
              var hourFormat = DateFormat('HH:mm');
              var startHour = hourFormat.format(item.toLocal());
              var endHour = hourFormat.format(item.toLocal().add(
                    Duration(
                      hours: 1,
                    ),
                  ));
              return DropdownMenuItem(
                value: item.toString(),
                child: Text('$startHour-$endHour'),
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
              hintText: AppLocalizations.of(context).translate('search'),
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

  void _setNewDate(String newValue) {
    setState(
      () {
        _date = DateTime.parse(newValue);
        _getData();
      },
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
    Navigator.of(context).pop();
    return false;
  }

  void _onSubmitPressed() async {
    bool? isPassed = await PinInputBlocker.pushTo(context);
    if (isPassed != true) {
      showException(context, 'PIN is required!');
      return;
    }

    // print(_groupValue);

    //Navigate
    // print(_days);
    // print(_daysMap[_days]);
    await showLoading();
    BilateralLongtermBuyTile _bilateralTileListOutput =
        _bilateralTileList[_groupValue];

    BilateralLongTermBuy model =
        Provider.of<BilateralLongTermBuy>(context, listen: false);

    LoginSession session = Provider.of<LoginSession>(context, listen: false);

    bool response = false;
    try {
      response = await model.bilateralLongTermBuy(
          _bilateralTileListOutput, session.info!.accessToken);
    } catch (e) {
      showException(context, e.toString());
    } finally {
      await hideLoading();
    }
    if (response == true) {
      Navigator.of(context).pop(true);
      showSuccessSnackBar(context, "ทำรายการสำเร็จ");
    } else {
      showException(context, "ไม่สามารถทำรายการได้");
    }
  }

  void _getData() async {
    BilateralLongTermBuy model =
        Provider.of<BilateralLongTermBuy>(context, listen: false);
    print(DateTime.parse(model.info.date!).toLocal());

    LoginSession session = Provider.of<LoginSession>(context, listen: false);

    await showLoading();
    try {
      await model.getBilateralLongTermBuyInfo(
        _date,
        _daysMap[_groupValue] ?? 7,
        session.info!.accessToken,
      );
      setState(() {
        _bilateralTileList = model.info.bilateralTileList!;
        _initBilateralTileList = model.info.bilateralTileList!;
        _isChecked = List<bool>.filled(_bilateralTileList.length, false);
      });
    } catch (e) {
      showException(context, e.toString());
    } finally {
      await hideLoading();
    }
  }
}
