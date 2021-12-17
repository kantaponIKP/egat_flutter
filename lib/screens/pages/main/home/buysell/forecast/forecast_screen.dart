import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/page/state/forecast.dart';
import 'package:egat_flutter/screens/pages/main/states/main_screen_title_state.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'controller/buy_sell_action_controller.dart';
import 'state/forecast_selected_date_state.dart';
import 'state/forecast_state.dart';
import 'state/forecast_tradeable_time_state.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({Key? key}) : super(key: key);

  @override
  _ForecastScreenState createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    final MainScreenTitleState mainScreenTitleState =
        Provider.of<MainScreenTitleState>(context, listen: false);

    mainScreenTitleState.setTitleLogo();

    Future.delayed(Duration.zero, () {
      initForecastState();
    });
  }

  initForecastState() async {
    final ForecastState forecastState =
        Provider.of<ForecastState>(context, listen: false);

    try {
      showLoading();
      await forecastState.init();
    } catch (e) {
      showException(context, e.toString());
    } finally {
      hideLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 6),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildEnergyBalance(),
            _ForecastEnergyWidgetListTile(),
            Container(height: 300, child: Placeholder()),
            _BuySellSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildEnergyBalance() {
    return Container(
      child: Column(children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Saleable Energy (24 hr. Ahead)'),
                ],
              ),
            ),
            Expanded(
              child: _ForecastEnergyBalanceTotal(),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            new RichText(
              text: new TextSpan(
                children: <TextSpan>[
                  new TextSpan(text: "Past 7-day Forecast"),
                ],
              ),
            )
          ],
        ),
      ]),
    );
  }

  void _buttomSheet() {
    showModalBottomSheet(
        backgroundColor: whiteColor,
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              //TODO
              ListTile(
                leading: new Icon(Icons.handyman, color: blackColor),
                title: Text(
                  'Bilateral Trade (Buy)',
                  style: TextStyle(color: blackColor),
                ),
                onTap: () {
                  _onBilateralTradeBuyPressed();
                },
              ),
              ListTile(
                leading: new Icon(Icons.refresh, color: blackColor),
                title: Text(
                  'Pool Market Trade (Buy)',
                  style: TextStyle(color: blackColor),
                ),
                onTap: () {
                  _onPoolMarketTradeBuyPressed();
                },
              ),
              ListTile(
                leading: new Icon(Icons.handyman, color: blackColor),
                title: Text(
                  'Bilateral Trade (Sell)',
                  style: TextStyle(color: blackColor),
                ),
                onTap: () {
                  _onBilateralTradeSellPressed();
                },
              ),
              ListTile(
                leading: new Icon(Icons.refresh, color: blackColor),
                title: Text(
                  'Pool Market Trade (Sell)',
                  style: TextStyle(color: blackColor),
                ),
                onTap: () {
                  _onPoolMarketTradeSellPressed();
                },
              ),
            ],
          );
        });
  }

  void _onBilateralTradeBuyPressed() {
    Navigator.pop(context);
    Forecast model = Provider.of<Forecast>(context, listen: false);
    model.setPageBilateralBuy();
  }

  void _onBilateralTradeSellPressed() {
    Navigator.pop(context);
    Forecast model = Provider.of<Forecast>(context, listen: false);
    model.setPageBilateralShortTermSell();
  }

  void _onPoolMarketTradeBuyPressed() {
    Navigator.pop(context);
    Forecast model = Provider.of<Forecast>(context, listen: false);
    model.setPagePoolMarketShortTermBuy();
  }

  void _onPoolMarketTradeSellPressed() {
    Navigator.pop(context);
    Forecast model = Provider.of<Forecast>(context, listen: false);
    model.setPagePoolMarketShortTermSell();
  }
}

class _BuySellSectionHeader extends StatefulWidget {
  final BuySellActionController controller;

  const _BuySellSectionHeader({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  __BuySellSectionHeaderState createState() => __BuySellSectionHeaderState();
}

class __BuySellSectionHeaderState extends State<_BuySellSectionHeader> {
  var _isSelected = false;

  @override
  void initState() {
    super.initState();

    _isSelected = widget.controller.isAllSelected;

    widget.controller.addListener(() {
      try {
        setState(() {
          _isSelected = widget.controller.isAllSelected;
        });
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Container(
              // decoration: BoxDecoration(borderRadius: ),
              height: 50,
              child: Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 2,
                    child: Row(children: [
                      Checkbox(
                        value: _isSelected,
                        onChanged: (value) {
                          if (value != null && value) {
                            widget.controller.selectAll();
                          } else {
                            widget.controller.deselectAll();
                          }
                        },
                      ),
                      Text("All"),
                    ]),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 2,
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(text: "Period"),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 2,
                    child: Container(
                      child: Row(
                        children: [
                          Container(width: 12, height: 12, color: primaryColor),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(text: "Can Sell"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 2,
                    child: //
                        Row(
                      children: [
                        Container(width: 12, height: 12, color: orangeColor),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(text: "Must buy"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _BuySellSection extends StatefulWidget {
  _BuySellSection({Key? key}) : super(key: key);

  @override
  _BuySellSectionState createState() => _BuySellSectionState();
}

class _BuySellSectionState extends State<_BuySellSection> {
  BuySellActionController _controller = BuySellActionController();

  @override
  void initState() {
    super.initState();

    _controller.clearInfos();
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedDateState = Provider.of<ForecastSelectedDateState>(context);

    List<BuySellItem> buySellItemList = [];

    final selectedDateForecastData = selectedDateState.forecastData;
    final selectedDate = selectedDateState.selectedDate;
    final selectedDateStartHour = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedDate.hour,
      0,
      0,
    );

    if (selectedDateForecastData != null) {
      for (var hour = 0; hour < 24; hour++) {
        var forecast = selectedDateForecastData.forecastInGrids[hour] ?? 0.0;

        final buySellItem = BuySellItem(
          action: forecast > 0 ? BuySellAction.BUY : BuySellAction.SELL,
          dateTime: selectedDateStartHour.add(Duration(hours: hour)),
          expectingAmount: forecast,
        );
        buySellItemList.add(buySellItem);
      }
    }

    final nextDayForecastData = selectedDateState.nextDayForecastData;
    final nextDay = selectedDateState.nextDate;
    final nextDayStartHour = DateTime(
      nextDay.year,
      nextDay.month,
      nextDay.day,
      nextDay.hour,
      0,
      0,
    );

    if (nextDayForecastData != null) {
      for (var hour = 0; hour < 24; hour++) {
        var forecast = nextDayForecastData.forecastInGrids[hour] ?? 0.0;

        final buySellItem = BuySellItem(
          action: forecast > 0 ? BuySellAction.BUY : BuySellAction.SELL,
          dateTime: nextDayStartHour.add(Duration(hours: hour)),
          expectingAmount: forecast,
        );
        buySellItemList.add(buySellItem);
      }
    }

    final availableDateInUtcIsoString = selectedDateState.availableDateTimes
        .map((time) => time.toUtc().toIso8601String());

    final limitTime = DateTime.now().add(Duration(days: 1)).toUtc();

    buySellItemList = buySellItemList
        .where((element) => element.dateTime.isBefore(limitTime))
        .where(
          (item) => availableDateInUtcIsoString
              .contains(item.dateTime.toUtc().toIso8601String()),
        )
        .toList();

    return Column(
      children: [
        _BuySellSectionHeader(controller: _controller),
        _BuySellActionListTile(
          controller: _controller,
          buySellItems: buySellItemList,
        ),
      ],
    );
  }
}

class _BuySellActionListTile extends StatelessWidget {
  final List<BuySellItem> buySellItems;

  const _BuySellActionListTile({
    required this.buySellItems,
    required this.controller,
    Key? key,
  }) : super(key: key);

  final BuySellActionController controller;

  @override
  Widget build(BuildContext context) {
    final forecastTradableTimeState =
        Provider.of<ForecastTradeableTimeState>(context);

    var toDisplayActions = buySellItems
        .where(
          (action) => action.dateTime.isAfter(
            forecastTradableTimeState.forecastTradeableTime,
          ),
        )
        .toList();

    toDisplayActions.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    toDisplayActions = toDisplayActions.take(24).toList();

    // This sorting is not needed. Just for sure
    toDisplayActions.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return Container(
      // height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[
          for (var action in toDisplayActions)
            _BuySellActionTile(
              controller: controller,
              startDateTime: action.dateTime,
              action: action.action,
              expectingAmount: action.expectingAmount,
              key: Key(action.dateTime.toIso8601String()),
            ),
        ],
      ),
    );
  }
}

class _BuySellActionTile extends StatefulWidget {
  final DateTime startDateTime;
  final BuySellActionController controller;
  final double expectingAmount;
  final BuySellAction action;

  const _BuySellActionTile({
    required this.startDateTime,
    required this.expectingAmount,
    required this.action,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  _BuySellActionTileState createState() => _BuySellActionTileState();
}

class _BuySellActionTileState extends State<_BuySellActionTile> {
  var _isSelected = false;
  var _isSelectable = true;
  BuySellInfo? _buySellInfo;

  @override
  void initState() {
    super.initState();

    var useDateTime = DateTime(
      widget.startDateTime.year,
      widget.startDateTime.month,
      widget.startDateTime.day,
      widget.startDateTime.hour,
      0,
      0,
    );

    _buySellInfo = widget.controller.addOptions(
      dateTime: useDateTime,
      action: widget.action,
      expectingAmount: widget.expectingAmount,
    );

    var buySellInfo = widget.controller.getBuySellInfoAtDateTime(useDateTime);

    if (buySellInfo == null) {
      _isSelected = false;
      _isSelectable = true;
      return;
    }

    _isSelected = buySellInfo.isSelected;
    _isSelectable = buySellInfo.isSelectable;

    widget.controller.addListener(_controllerListener);
  }

  void _controllerListener() {
    var useDateTime = DateTime(
      widget.startDateTime.year,
      widget.startDateTime.month,
      widget.startDateTime.day,
      widget.startDateTime.hour,
      0,
      0,
    );

    var buySellInfo = widget.controller.getBuySellInfoAtDateTime(useDateTime);

    if (buySellInfo == null) {
      return;
    }

    try {
      setState(() {
        _isSelected = buySellInfo.isSelected;
        _isSelectable = buySellInfo.isSelectable;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();

    widget.controller.removeListener(_controllerListener);

    if (_buySellInfo != null) {
      widget.controller.removeOptions(
        buySellInfo: _buySellInfo!,
      );
      _buySellInfo = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var useDateTime = DateTime(
      widget.startDateTime.year,
      widget.startDateTime.month,
      widget.startDateTime.day,
      widget.startDateTime.hour,
      0,
      0,
    );

    var timeFormatter = DateFormat('HH:mm');

    var startTimeString = timeFormatter.format(useDateTime);
    var endTimeString = timeFormatter.format(
      useDateTime.add(Duration(hours: 1)),
    );

    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      height: _isSelectable ? 60 : 0,
      child: ClipRect(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    // _buttomSheet();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: surfaceGreyColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    height: 50,
                    // color: Colors.grey[800],
                    child: Row(
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Checkbox(
                              value: _isSelected,
                              onChanged: (value) {
                                if (value != null && value) {
                                  widget.controller.updateOptions(
                                    action: widget.action,
                                    dateTime: useDateTime,
                                    expectingAmount: widget.expectingAmount,
                                    isSelected: true,
                                    uniqueKey: _buySellInfo!.key,
                                  );
                                } else {
                                  widget.controller.updateOptions(
                                    action: widget.action,
                                    dateTime: useDateTime,
                                    expectingAmount: widget.expectingAmount,
                                    isSelected: false,
                                    uniqueKey: _buySellInfo!.key,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child: Text("$startTimeString-$endTimeString"),
                        ),
                        widget.action == BuySellAction.SELL
                            ? Flexible(
                                fit: FlexFit.tight,
                                flex: 2,
                                child: Center(
                                  child: Text(
                                    "${(-widget.expectingAmount).toStringAsFixed(2)} kWh",
                                    style: TextStyle(color: primaryColor),
                                  ),
                                ),
                              )
                            : Flexible(
                                fit: FlexFit.tight,
                                flex: 2,
                                child: Center(child: Text("0")),
                              ),
                        widget.action == BuySellAction.BUY
                            ? Flexible(
                                fit: FlexFit.tight,
                                flex: 2,
                                child: Center(
                                  child: Text(
                                    "${widget.expectingAmount.toStringAsFixed(2)} kWh",
                                    style: TextStyle(color: primaryColor),
                                  ),
                                ),
                              )
                            : Flexible(
                                fit: FlexFit.tight,
                                flex: 2,
                                child: Center(child: Text("0")),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ForecastEnergyBalanceTotal extends StatelessWidget {
  const _ForecastEnergyBalanceTotal({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final forecastState = Provider.of<ForecastState>(context);
    final forecastValues = forecastState.forecastDataOffsets.values;

    var totalForecastEnergy = 0.0;
    for (final forecastDay in forecastValues) {
      if (forecastDay == null) {
        continue;
      }

      final forecastDayTotalEnergy = forecastDay.forecastInGrids.reduce(
        (value, element) => (value ?? 0.0) + (element ?? 0.0),
      )!;

      totalForecastEnergy += forecastDayTotalEnergy;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          //important for overflow text
          child: new RichText(
            text: new TextSpan(
              children: <TextSpan>[
                new TextSpan(
                    text: totalForecastEnergy.toStringAsFixed(2),
                    style: TextStyle(fontSize: 24, color: primaryColor)),
                new TextSpan(text: 'kWh'),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _ForecastEnergyWidgetListTile extends StatelessWidget {
  const _ForecastEnergyWidgetListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var dates = <DateTime>[];
    for (var day = 0; day < 7; day++) {
      dates.add(DateTime.now().add(Duration(days: -day)));
    }

    var dateWidgets = <Widget>[];
    for (var date in dates) {
      final dateMidnight = DateTime(date.year, date.month, date.day);

      dateWidgets.add(
        _ForecastEnergyWidget(
          date: date,
          key: Key('forecast-date-${dateMidnight.toString()}'),
        ),
      );
    }

    return Container(
      height: 84,
      child: new ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: dateWidgets,
      ),
    );
  }
}

class _ForecastEnergyWidget extends StatelessWidget {
  final DateTime date;

  const _ForecastEnergyWidget({
    required this.date,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final forecastState = Provider.of<ForecastState>(context);
    final forecastSelectedDateState =
        Provider.of<ForecastSelectedDateState>(context);

    var isSelected = false;
    final midnightDate = DateTime(date.year, date.month, date.day);
    final dateDifference =
        forecastSelectedDateState.selectedDate.difference(midnightDate);

    if (dateDifference.inDays == 0) {
      isSelected = true;
    }

    final opacity = isSelected ? 1.0 : 0.3;

    final today = forecastState.today;
    final todayMidnight = DateTime(today.year, today.month, today.day);
    final dateMidnight = DateTime(date.year, date.month, date.day);

    var dateName = "Today";
    if (todayMidnight.difference(dateMidnight).inDays == 0) {
      dateName = "Today";
    } else {
      final dateFormat = DateFormat('dd MMM yyyy');
      dateName = dateFormat.format(this.date);
    }

    var summaryEnergy = 0.0;
    var forecastData = forecastState.getForecastData(date);
    if (forecastData != null) {
      summaryEnergy = forecastData.forecastInGrids.reduce(
        (value, element) {
          return (value ?? 0.0) + (element ?? 0.0);
        },
      )!;
    }

    return GestureDetector(
      onTap: () {
        forecastState.selectDate(date);
      },
      child: Opacity(
        opacity: opacity,
        child: Card(
          // color: onBgColor,
          child: Container(
            constraints: BoxConstraints(minHeight: 72),
            width: 132,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: TextStyle(fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(text: dateName),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                    decoration: BoxDecoration(
                      color: onPrimaryBgColor.withAlpha(60),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          //important for overflow text
                          child: new RichText(
                            text: new TextSpan(
                              children: <TextSpan>[
                                new TextSpan(
                                    text: summaryEnergy.toStringAsFixed(2),
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: primaryColor,
                                    )),
                                new TextSpan(text: ' kWh'),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BuySellItem {
  final BuySellAction action;
  final double expectingAmount;
  final DateTime dateTime;

  const BuySellItem({
    required this.action,
    required this.expectingAmount,
    required this.dateTime,
  });

  copyWith({
    BuySellAction? action,
    double? expectingAmount,
    DateTime? dateTime,
    bool? isSelected,
  }) {
    return BuySellItem(
      action: action ?? this.action,
      expectingAmount: expectingAmount ?? this.expectingAmount,
      dateTime: dateTime ?? this.dateTime,
    );
  }
}
