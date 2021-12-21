import 'dart:math';

import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/pages/main/states/main_screen_title_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MainHomeScreen extends StatefulWidget {
  MainHomeScreen({Key? key}) : super(key: key);

  @override
  _MainHomeScreenState createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  @override
  void initState() {
    super.initState();

    final mainScreenTitleState =
        Provider.of<MainScreenTitleState>(context, listen: false);
    mainScreenTitleState.setTitleLogo();
  }

  @override
  Widget build(BuildContext context) {
    return _buildAction(context);
  }

  Padding _buildAction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 6),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDateSection(),
                  Placeholder(),
                  Column(
                    children: [
                      _buildBalanceSection(),
                      _buildFundSection(),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void setYear(int year) {
    // TODO: set state
  }

  void setMonth(int month) {
    // TODO: set state
  }

  Widget _buildDateSection() {
    final now = DateTime.now();

    final availableMinYear = 2019;
    final availableMaxYear = DateTime.now().year;

    var availableYears = List<int>.generate(
      availableMaxYear - availableMinYear + 1,
      (index) => availableMinYear + index,
    );

    // TODO: use state.
    var yearSelected = now.year;

    final availableMinMonth = 1;
    var availableMaxMonth = 12;

    if (yearSelected == now.year) {
      availableMaxMonth = now.month;
    }

    var availableMonths = List<int>.generate(
      availableMaxMonth - availableMinMonth + 1,
      (index) => availableMinMonth + index,
    );

    // TODO: use state
    var monthSelected = now.month;
    var monthFormat = DateFormat.MMMM();
    var monthNameSelected =
        monthFormat.format(DateTime(yearSelected, monthSelected));

    final minDate = 1;
    var maxDate = DateTime(yearSelected, monthSelected + 1)
        .subtract(Duration(days: 1))
        .day;

    if (yearSelected == now.year && monthSelected == now.month) {
      maxDate = now.day;
    }

    var dateAvailables = List<int>.generate(
      maxDate - minDate + 1,
      (index) => minDate + index,
    );

    var dateSelected = min(now.day, maxDate);

    // TODO: use state
    var isDaily = false;

    var latestUpdateDate = now;
    var latestUpdateDateForamt = DateFormat("yyyy MMMM dd at HH:mm");
    var latestUpdateDateString =
        latestUpdateDateForamt.format(latestUpdateDate);

    return Column(children: [
      Row(children: [
        Expanded(
          child: DropdownButton<int>(
            isExpanded: true,
            value: yearSelected,
            iconSize: 24.0,
            items: availableYears.map(
              (val) {
                return DropdownMenuItem<int>(
                  value: val,
                  child: Text(val.toString()),
                );
              },
            ).toList(),
            onChanged: (value) {
              if (value != null) {
                setYear(value);
              }
            },
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: DropdownButton<int>(
            isExpanded: true,
            value: monthSelected,
            iconSize: 24.0,
            items: availableMonths.map(
              (month) {
                
                final monthNameFormat = DateFormat.MMMM(AppLocalizations.of(context).getLocale().toString());
                final monthName =
                    monthNameFormat.format(DateTime(yearSelected, month));

                return DropdownMenuItem<int>(
                  value: month,
                  child: Text(monthName),
                );
              },
            ).toList(),
            onChanged: (month) {
              if (month != null) {
                setMonth(month);
              }
            },
          ),
        ),
        SizedBox(width: 16),
        Expanded(
            child: Text('${AppLocalizations.of(context).translate('daily')}')),
        Switch(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          value: isDaily,
          onChanged: (val) {
            setDaily(enabled: val);
          },
        )
      ]),
      Text(latestUpdateDateString),
    ]);
  }

  Widget _buildBalanceSection() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  '${AppLocalizations.of(context).translate('energy-can-be-sold')}'),
              Row(
                children: [
                  Text("33.64", style: TextStyle(fontSize: (24))),
                  SizedBox(width: 16),
                  Text("kWh", style: TextStyle(fontSize: (16))),
                ],
              ),
            ],
          ),
        ),
        // Spacer(),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("Total 0.001 REC"),
              Text("Acc 0.201 REC"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFundSection() {
    return Row(
      children: [
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: InkWell(
              onTap: () {
                onTradeSellPressed();
              },
              child: SizedBox(
                height: 80,
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      SizedBox(
                        height: 32,
                        width: 56,
                        child: SvgPicture.asset(
                          'assets/images/icons/home/total_sell.svg',
                          fit: BoxFit.contain,
                          height: 32,
                        ),
                      ),
                      Text('492.80 Bath', style: TextStyle(color: greenColor)),
                      Text('Trade Sell')
                    ])),
              ),
            ),
          ),
        ),
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: InkWell(
              onTap: () {
                onTradeBuyPressed();
              },
              child: SizedBox(
                height: 80,
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      SizedBox(
                        height: 32,
                        width: 56,
                        child: SvgPicture.asset(
                          'assets/images/icons/home/total_buy.svg',
                          fit: BoxFit.contain,
                          height: 32,
                        ),
                      ),
                      Text('211.75 Bath', style: TextStyle(color: redColor)),
                      Text('Trade Buy')
                    ])),
              ),
            ),
          ),
        ),
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: InkWell(
              onTap: () {
                onGridUsedPressed();
              },
              child: SizedBox(
                height: 80,
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      SizedBox(
                        height: 32,
                        width: 56,
                        child: Image(
                          image: AssetImage(
                            'assets/images/icons/home/total_grid.png',
                            // fit: BoxFit.contain,
                            // height: 32,
                          ),
                        ),
                      ),
                      Text('104.65 Bath', style: TextStyle(color: redColor)),
                      Text('Grid Used')
                    ])),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void onTradeSellPressed() {
    // var model = Provider.of<Home>(context, listen: false);
    // model.setPageGraph();
  }

  void onTradeBuyPressed() {
    // var model = Provider.of<Home>(context, listen: false);
    // model.setPageGraph();
  }

  void onGridUsedPressed() {
    // var model = Provider.of<Home>(context, listen: false);
    // model.setPageGraph();
  }

  void onEnergyStoragePressed() {
    // var model = Provider.of<Home>(context, listen: false);
    // model.setPageGraph();
  }

  void onPVPressed() {
    // var model = Provider.of<Home>(context, listen: false);
    // model.setPageGraph();
  }

  void onGridPressed() {
    // var model = Provider.of<Home>(context, listen: false);
    // model.setPageGraph();
  }

  Widget buildSlideTransition(Widget child, Animation<double> animation) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.ease;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }

  void setDaily({required bool enabled}) {}
}
