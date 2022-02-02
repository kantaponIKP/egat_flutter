import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/page/state/forecast.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/bilateral/apis/models/TransactionSubmitItem.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/bilateral/buy/bilateral_buy_page.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/bilateral/buy/short_term/bilateral_short_term_sell_page.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/bilateral/sell/bilateral_sell_page.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/pool/pool_market_short_term_buy_page.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/pool/pool_market_short_term_sell_page.dart';
import 'package:egat_flutter/screens/pages/main/states/main_screen_title_state.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'controller/buy_sell_action_controller.dart';
import 'state/forecast_selected_date_state.dart';
import 'state/forecast_state.dart';
import 'state/forecast_tradeable_time_state.dart';
import 'widgets/forecast_graph.dart';

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

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({Key? key}) : super(key: key);

  @override
  _ForecastScreenState createState() => _ForecastScreenState();
}

class __BuySellSectionHeaderState extends State<_BuySellSectionHeader> {
  var _isSelected = false;

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
                      Text(AppLocalizations.of(context)
                          .translate('trade-forecast-all')),
                    ]),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    flex: 2,
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                          text: AppLocalizations.of(context)
                              .translate('trade-forecast-period')),
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
                              text: TextSpan(
                                  text: AppLocalizations.of(context)
                                      .translate('trade-forecast-canSell')),
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
                            text: TextSpan(
                                text: AppLocalizations.of(context)
                                    .translate('trade-forecast-mustBuy')),
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
}

class _BuySellActionListTile extends StatelessWidget {
  final List<BuySellItem> buySellItems;

  final BuySellActionController controller;

  const _BuySellActionListTile({
    required this.buySellItems,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedDateState = Provider.of<ForecastSelectedDateState>(context);

    final availableDateInUtcIsoString = selectedDateState.availableDateTimes
        .map((time) => time.toUtc().toIso8601String())
        .toList();

    var toDisplayActions = buySellItems.toList();

    toDisplayActions.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    if (!selectedDateState.isToday) {
      toDisplayActions = toDisplayActions.take(24).toList();
    }

    // This sorting is not needed. Just for sure
    toDisplayActions.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    final limit = DateTime.now().add(Duration(hours: 2));

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
              enabled: action.dateTime.isAfter(limit) &&
                  availableDateInUtcIsoString.contains(
                    action.dateTime.toUtc().toIso8601String(),
                  ),
              defaultSelected: !availableDateInUtcIsoString.contains(
                action.dateTime.toUtc().toIso8601String(),
              ),
            ),
          SizedBox(height: 50),
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
  final bool enabled;
  final bool defaultSelected;

  const _BuySellActionTile({
    required this.startDateTime,
    required this.expectingAmount,
    required this.action,
    required this.controller,
    required this.enabled,
    this.defaultSelected = false,
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
  Widget build(BuildContext context) {
    final selectedDateState = Provider.of<ForecastSelectedDateState>(context);

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

    var buySellInfo = widget.controller.getBuySellInfoAtDateTime(useDateTime);

    double? height = null;
    final today = DateTime.now().toUtc();
    final selectedDate = selectedDateState.selectedDate;
    if (!widget.controller.isNoneSelected &&
        (widget.controller.currentAction != widget.action || !widget.enabled)) {
      height = 0;
    }

    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      height: height ?? (_isSelectable ? 60 : 60),
      child: ClipRect(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _isSelectable && widget.enabled
                      ? () {
                          _showButtomSheet();
                        }
                      : null,
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
                            child: widget.action == BuySellAction.SELL
                                ? Opacity(
                                    opacity: widget.enabled ? 1 : 0.3,
                                    child: Checkbox(
                                      activeColor: widget.enabled
                                          ? primaryColor
                                          : greyColor,
                                      value: widget.enabled
                                          ? buySellInfo?.isSelected ?? false
                                          : widget.defaultSelected,
                                      onChanged: (value) {
                                        if (!widget.enabled) {
                                          return;
                                        }

                                        if (value != null && value) {
                                          widget.controller.updateOptions(
                                            action: widget.action,
                                            dateTime: useDateTime,
                                            expectingAmount:
                                                widget.expectingAmount,
                                            isSelected: true,
                                            uniqueKey: _buySellInfo!.key,
                                          );
                                        } else {
                                          widget.controller.updateOptions(
                                            action: widget.action,
                                            dateTime: useDateTime,
                                            expectingAmount:
                                                widget.expectingAmount,
                                            isSelected: false,
                                            uniqueKey: _buySellInfo!.key,
                                          );
                                        }
                                      },
                                    ),
                                  )
                                : SizedBox(),
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
                                    "${(widget.expectingAmount.abs()).toStringAsFixed(2)} kWh",
                                    style: TextStyle(
                                        color: widget.enabled
                                            ? Color(0xFFFEC908)
                                            : greyColor),
                                  ),
                                ),
                              )
                            : Flexible(
                                fit: FlexFit.tight,
                                flex: 2,
                                child: Center(
                                  child: Text(
                                    "0",
                                    style: TextStyle(
                                      color: widget.enabled
                                          ? Colors.white
                                          : greyColor,
                                    ),
                                  ),
                                ),
                              ),
                        widget.action == BuySellAction.BUY
                            ? Flexible(
                                fit: FlexFit.tight,
                                flex: 2,
                                child: Center(
                                  child: Text(
                                    "${widget.expectingAmount.toStringAsFixed(2)} kWh",
                                    style: TextStyle(
                                        color: widget.enabled
                                            ? Color(0xFFED8235)
                                            : greyColor),
                                  ),
                                ),
                              )
                            : Flexible(
                                fit: FlexFit.tight,
                                flex: 2,
                                child: Center(
                                  child: Text(
                                    "0",
                                    style: TextStyle(
                                      color: widget.enabled
                                          ? Colors.white
                                          : greyColor,
                                    ),
                                  ),
                                ),
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

  @override
  void dispose() {
    super.dispose();

    widget.controller.removeListener(_controllerListener);

    if (!widget.enabled) {
      return;
    }

    if (_buySellInfo != null) {
      widget.controller.removeOptions(
        buySellInfo: _buySellInfo!,
      );
      _buySellInfo = null;
    }
  }

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_controllerListener);

    if (!widget.enabled) {
      return;
    }

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
      _isSelected = false;
      _isSelectable = false;
      setState(() {});
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

  void _showButtomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _BuySellActionTileBottomSheet(
        action: widget.action,
        startDateTime: widget.startDateTime,
        expectingAmount: widget.expectingAmount,
      ),
    );
  }
}

class _BuySellActionTileBottomSheet extends StatelessWidget {
  final BuySellAction action;
  final DateTime startDateTime;
  final double expectingAmount;

  const _BuySellActionTileBottomSheet({
    Key? key,
    required this.action,
    required this.startDateTime,
    required this.expectingAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title;
    switch (action) {
      case BuySellAction.BUY:
        title = AppLocalizations.of(context).translate('trade-forecast-chooseToBuy');
        break;
      case BuySellAction.SELL:
        title = AppLocalizations.of(context).translate('trade-forecast-offerToSell');
        break;
    }

    var useDateTime = DateTime(
      startDateTime.year,
      startDateTime.month,
      startDateTime.day,
      startDateTime.hour,
      0,
      0,
    );

    var timeFormatter = DateFormat('HH:mm');

    var startTimeString = timeFormatter.format(useDateTime);
    var endTimeString = timeFormatter.format(
      useDateTime.add(Duration(hours: 1)),
    );

    title += " : $startTimeString-$endTimeString";

    return DefaultTextStyle(
      style: TextStyle(
        color: Colors.black,
        fontSize: 15,
        fontWeight: FontWeight.w300,
      ),
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style: TextStyle(
                  color: Color(0xFF797979),
                  fontSize: 16,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BuySellBottomSheetTile(
                  svgIcon: 'assets/images/icons/tabbar/bilateral.svg',
                  title: AppLocalizations.of(context).translate('trade-forecast-bilateralTrade'),
                  onTap: () => _onBilateralSelected(context),
                ),
                _BuySellBottomSheetTile(
                  svgIcon: 'assets/images/icons/tabbar/poolMarket.svg',
                  title: AppLocalizations.of(context).translate('trade-forecast-poolMarketTrade'),
                  onTap: () => _onPoolSelected(context),
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }

  void _onBilateralSelected(BuildContext context) async {
    final state = Provider.of<ForecastState>(context, listen: false);
    final selectedDate =
        Provider.of<ForecastSelectedDateState>(context, listen: false);

    Navigator.pop(context);
    switch (action) {
      case BuySellAction.BUY:
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BilateralBuyPage(
              date: startDateTime,
              enabled: true,
            ),
          ),
        );
        state.fetchForecastsFromDate(selectedDate.selectedDate);
        break;
      case BuySellAction.SELL:
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BilateralShortTermSellPage(
              requestItems: [
                TransactionSubmitItem(
                  date: startDateTime,
                  amount: expectingAmount.abs(),
                  price: 3,
                ),
              ],
            ),
          ),
        );
        state.fetchForecastsFromDate(selectedDate.selectedDate);
        break;
      default:
    }
  }

  void _onPoolSelected(BuildContext context) async {
    final state = Provider.of<ForecastState>(context, listen: false);
    final selectedDate =
        Provider.of<ForecastSelectedDateState>(context, listen: false);

    Navigator.pop(context);
    switch (action) {
      case BuySellAction.BUY:
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PoolMarketShortTermBuyPage(
              isoDate: startDateTime.toUtc().toIso8601String(),
            ),
          ),
        );
        state.fetchForecastsFromDate(selectedDate.selectedDate);
        break;
      case BuySellAction.SELL:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PoolMarketShortTermSellPage(
                isoDate: [startDateTime.toUtc().toIso8601String()]),
          ),
        );
        state.fetchForecastsFromDate(selectedDate.selectedDate);
        break;
      default:
    }
  }
}

class _BuySellBottomSheetTile extends StatelessWidget {
  final void Function()? onTap;
  final String svgIcon;
  final String title;

  const _BuySellBottomSheetTile({
    Key? key,
    this.onTap,
    required this.svgIcon,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 16,
            ),
            SvgPicture.asset(svgIcon,
                fit: BoxFit.contain, height: 18, color: Colors.black),
            // Icon(
            //   icon,
            //   color: Colors.black,
            // ),
            SizedBox(
              width: 24,
            ),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BuySellSection extends StatefulWidget {
  final BuySellActionController controller;
  _BuySellSection({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  _BuySellSectionState createState() => _BuySellSectionState();
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

class _BuySellSectionState extends State<_BuySellSection> {
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
          action: forecast >= 0 ? BuySellAction.BUY : BuySellAction.SELL,
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
          action: forecast >= 0 ? BuySellAction.BUY : BuySellAction.SELL,
          dateTime: nextDayStartHour.add(Duration(hours: hour)),
          expectingAmount: forecast,
        );
        buySellItemList.add(buySellItem);
      }
    }

    final limitTime = DateTime.now().add(Duration(days: 1)).toUtc();

    buySellItemList = buySellItemList
        .where((element) => element.dateTime.isBefore(limitTime))
        .toList();

    return Column(
      children: [
        _BuySellSectionHeader(controller: widget.controller),
        _BuySellActionListTile(
          controller: widget.controller,
          buySellItems: buySellItemList,
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
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

      final forecastDayTotalEnergy = forecastDay.loadInGrids.reduce(
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
            textAlign: TextAlign.right,
            text: new TextSpan(
              
              children: <TextSpan>[
                new TextSpan(
                    text: totalForecastEnergy.toStringAsFixed(2),
                    style: TextStyle(fontSize: 24, color: primaryColor)),
                new TextSpan(text: '\nkWh'),
              ],
            ),
          ),
        )
      ],
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

    var dateName = AppLocalizations.of(context).translate('trade-forecast-today');
    if (todayMidnight.difference(dateMidnight).inDays == 0) {
      dateName = AppLocalizations.of(context).translate('trade-forecast-today');
    } else {
      final dateFormat = DateFormat('dd MMM yyyy',AppLocalizations.of(context).getLocale().toString());
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
          color: surfaceGreyColor,
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
                          child: FittedBox(
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

class _ForecastEnergyWidgetListTile extends StatefulWidget {
  _ForecastEnergyWidgetListTile({Key? key}) : super(key: key);

  @override
  _ForecastEnergyWidgetListTileState createState() =>
      _ForecastEnergyWidgetListTileState();
}

class _ForecastEnergyWidgetListTileState
    extends State<_ForecastEnergyWidgetListTile> {
  @override
  void initState() {
    super.initState();
  }

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
      height: 90,
      child: new ListView(
        reverse: true,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: dateWidgets,
      ),
    );
  }
}

class _SubmitSection extends StatefulWidget {
  _SubmitSection({Key? key}) : super(key: key);

  @override
  _SubmitSectionState createState() => _SubmitSectionState();
}

class _SubmitSectionState extends State<_SubmitSection> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _SubmitAllButton extends StatefulWidget {
  final BuySellActionController controller;

  _SubmitAllButton({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  __SubmitAllButtonState createState() => __SubmitAllButtonState();
}

class __SubmitAllButtonState extends State<_SubmitAllButton> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(onUpdate);
  }

  onUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(onUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<ForecastState>(context);
    final selectedDate = Provider.of<ForecastSelectedDateState>(context);

    final items = widget.controller.buySellInfos
        .where((element) => element.isSelected)
        .toList();

    if (items.isEmpty) {
      return Container();
    }

    if (items[0].action == BuySellAction.BUY) {
      return Container();
    }

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BilateralShortTermSellPage(
                    requestItems: [
                      for (var item in items)
                        TransactionSubmitItem(
                          date: item.dateTime,
                          amount: item.expectingAmount.abs(),
                          price: 3,
                        ),
                    ],
                  ),
                ),
              );
              state.fetchForecastsFromDate(selectedDate.selectedDate);
            },
            child: Text('Offer to Sell (Bilateral Trade)'),
          ),
        ],
      ),
    );
  }
}

class _ForecastScreenState extends State<ForecastScreen>
    with TickerProviderStateMixin {
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
      child: _buildLayout(context),
    );
  }

  Widget _buildLayout(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 12),
                _buildBody(context),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _SubmitAllButton(
              controller: _buySellActionController,
            ),
          ),
        ],
      );
    });
  }

  BuySellActionController _buySellActionController = BuySellActionController();

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
  void initState() {
    super.initState();

    final MainScreenTitleState mainScreenTitleState =
        Provider.of<MainScreenTitleState>(context, listen: false);

    mainScreenTitleState.setTitleLogo();
    _buySellActionController.clearInfos();

    Future.delayed(Duration.zero, () {
      initForecastState();
    });
  }

  Widget _buildBody(BuildContext context) {
    final ForecastSelectedDateState selectedDateState =
        Provider.of<ForecastSelectedDateState>(context);

    final selectedDate = selectedDateState.selectedDate;
    final startHour = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      0,
      0,
      0,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 6),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEnergyBalance(),
          _ForecastEnergyWidgetListTile(),
          SizedBox(height: 20),
          ForecastGraph(
            forecastData: selectedDateState.forecastData != null
                ? selectedDateState.forecastData!.forecastInGrids
                    .map((e) => e != null ? -e : null)
                    .toList()
                : [],
            forecastPvData: selectedDateState.forecastData != null
                ? selectedDateState.forecastData!.forecastPvInGrids
                    .map((e) => e != null ? e : null)
                    .toList()
                : [],
            pvData: selectedDateState.forecastData != null
                ? selectedDateState.forecastData!.pvInGrids
                    .map((e) => e != null ? e : null)
                    .toList()
                : [],
            forecastLoadData: selectedDateState.forecastData != null
                ? selectedDateState.forecastData!.forecastLoadInGrids
                    .map((e) => e != null ? e : null)
                    .toList()
                : [],
            loadData: selectedDateState.forecastData != null
                ? selectedDateState.forecastData!.loadInGrids
                    .map((e) => e != null ? e : null)
                    .toList()
                : [],
            startHour: startHour,
          ),
          _BuySellSection(
            controller: _buySellActionController,
          ),
        ],
      ),
    );
  }

  @override
  dispose() {
    _buySellActionController.clearInfos();
    super.dispose();
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
                  Text(AppLocalizations.of(context).translate('trade-forecast-saleableEnergy')),
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
                  new TextSpan(text: AppLocalizations.of(context).translate('trade-forecast-past7dayForecast')),
                ],
              ),
            )
          ],
        ),
      ]),
    );
  }
}
