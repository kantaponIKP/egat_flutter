import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/page/state/home.dart';
import 'package:egat_flutter/screens/page/widgets/logo_appbar.dart';
import 'package:egat_flutter/screens/page/widgets/page_bottom_navigation_bar.dart';
import 'package:egat_flutter/screens/page/widgets/side_menu.dart';
import 'package:egat_flutter/screens/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _yearValue = '2021';
  String _monthValue = 'May';
  String _dayValue = '20';
  String _timeValue = '0:00';
  List<String> _years = ['2021', '2020', '2019'];
  List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  List<String> _days = ['20', '19', '18'];
  bool _isDaily = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LogoAppbar(),
      drawer: NavigationMenuWidget(),
      body: SafeArea(
        child: _buildAction(context),
      ),
      bottomNavigationBar: PageBottomNavigationBar(),
    );
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

  Widget _buildDateSection() {
    return Column(children: [
      Row(
        children: [
        Expanded(
          child: DropdownButton(
            isExpanded: true,
            value: _yearValue,
            iconSize: 24.0,
            items: _years.map(
              (val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(val),
                );
              },
            ).toList(),
            onChanged: (val) {
              setState(
                () {
                  _yearValue = val.toString();
                },
              );
            },
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: DropdownButton(
            isExpanded: true,
            value: _monthValue,
            iconSize: 24.0,
            items: _months.map(
              (val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(val),
                );
              },
            ).toList(),
            onChanged: (val) {
              setState(
                () {
                  _monthValue = val.toString();
                },
              );
            },
          ),
        ),
        SizedBox(width: 16),
        // Expanded(
        //   child: DropdownButton(
        //     isExpanded: true,
        //     value: _dayValue,
        //     iconSize: 24.0,
        //     items: _days.map(
        //       (val) {
        //         return DropdownMenuItem<String>(
        //           value: val,
        //           child: Text(val),
        //         );
        //       },
        //     ).toList(),
        //     onChanged: (val) {
        //       setState(
        //         () {
        //           _dayValue = val.toString();
        //         },
        //       );
        //     },
        //   ),
        // ),
        // Spacer(),
        Expanded(child: Text('${AppLocalizations.of(context).translate('daily')}')),
        Switch(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          value: _isDaily,
          onChanged: (val) {
            setState(
              () {
                _isDaily = !_isDaily;
              },
            );
          },
        )
      ]),
      Text('${_dayValue} ${_monthValue} ${_yearValue} at ${_timeValue}')
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
    var model = Provider.of<Home>(context, listen: false);
    model.setPageGraph();
  }

  void onTradeBuyPressed() {
    var model = Provider.of<Home>(context, listen: false);
    model.setPageGraph();
  }

  void onGridUsedPressed() {
    var model = Provider.of<Home>(context, listen: false);
    model.setPageGraph();
  }

  void onEnergyStoragePressed() {
    var model = Provider.of<Home>(context, listen: false);
    model.setPageGraph();
  }

  void onPVPressed() {
    var model = Provider.of<Home>(context, listen: false);
    model.setPageGraph();
  }

  void onGridPressed() {
    var model = Provider.of<Home>(context, listen: false);
    model.setPageGraph();
  }
}
