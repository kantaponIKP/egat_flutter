import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/bilateral/models/bilateral_model.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/bilateral/states/bilateral_selected_time_state.dart';
import 'package:egat_flutter/screens/pages/main/states/main_screen_title_state.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'states/bilateral_state.dart';

enum _ViewModeType { OFFER_TO_SELL, CHOOSE_TO_BUY }

class _ViewDropdownItem {
  final _ViewModeType type;
  final String title;

  const _ViewDropdownItem({
    required this.type,
    required this.title,
  });
}

class BilateralTradeScreen extends StatefulWidget {
  const BilateralTradeScreen({Key? key}) : super(key: key);

  @override
  _BilateralTradeScreenState createState() => _BilateralTradeScreenState();
}

class _BilateralTradeScreenState extends State<BilateralTradeScreen> {
  _ViewModeType _viewModeSelected = _ViewModeType.OFFER_TO_SELL;

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

  @override
  void initState() {
    super.initState();

    final titleState =
        Provider.of<MainScreenTitleState>(context, listen: false);

    titleState.setTitleTwoTitles(
      title: 'Bilateral',
      secondaryTitle: 'Trade',
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
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                      maxHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      // mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Flexible(
                              flex: 2,
                              fit: FlexFit.tight,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: _TimeSelectionDropdown(),
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              fit: FlexFit.tight,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: 8,
                                ),
                                child: _DateSelectionDropdown(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 8,
                              ),
                              child: _ViewModeSelectionDropdown(
                                viewModeSelected: _viewModeSelected,
                                onChange: (newItem) => setState(() {
                                  _viewModeSelected = newItem;
                                }),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child:
                              (_viewModeSelected == _ViewModeType.CHOOSE_TO_BUY)
                                  ? _BuyItemList()
                                  : _SellItemList(),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // void _onListTileBuyPressed(String isoDate) async {
  //   // DateTime newDate = DateTime.parse(_dateInit).add(new Duration(hours: int.parse(time.substring(0,2))));
  //   DateTime newDate = DateTime.parse(isoDate);
  //   await showLoading();
  //   BilateralBuy bilateralBuy =
  //       Provider.of<BilateralBuy>(context, listen: false);

  //   try {
  //     await bilateralBuy.getBilateralShortTermBuyInfo(
  //         date: newDate.toUtc().toIso8601String());
  //   } catch (e) {
  //     showException(context, e.toString());
  //   } finally {
  //     await hideLoading();
  //   }
  //   BilateralTrade model = Provider.of<BilateralTrade>(context, listen: false);
  //   model.setPageBilateralBuy();
  // }

  // void _onListTileSellPressed(String isoDate) async {
  //   // DateTime newDate = DateTime.parse(_dateInit).add(new Duration(hours: int.parse(time.substring(0,2))));
  //   DateTime newDate = DateTime.parse(isoDate);
  //   await showLoading();
  //   BilateralSell bilateralBuy =
  //       Provider.of<BilateralSell>(context, listen: false);
  //   try {
  //     await bilateralBuy.getBilateralShortTermSellInfo(
  //         date: newDate.toUtc().toIso8601String());
  //   } catch (e) {
  //     showException(context, e.toString());
  //   } finally {
  //     await hideLoading();
  //   }
  //   BilateralTrade model = Provider.of<BilateralTrade>(context, listen: false);
  //   model.setPageBilateralSell();
  // }
}

class _SellItemList extends StatelessWidget {
  const _SellItemList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bilateralState = Provider.of<BilateralState>(context);
    final tradeItems = bilateralState.tradeItems;
    final sellItems = tradeItems
        .where((element) => element.type == BilateralTradeItemType.SELL)
        .toList();

    return _TradeItemList(items: sellItems);
  }
}

class _TradeItemCard extends StatelessWidget {
  final BilateralTradeItemModel item;

  const _TradeItemCard({
    required this.item,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: GestureDetector(
        child: Card(
          child: IntrinsicHeight(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _buildStatus(),
                    _buildAmount(),
                    _buildOfferCount(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _buildStatus() {
    final timeFormat = DateFormat('HH:mm');
    final startTime = item.time;
    final endTime = item.time.add(new Duration(hours: 1));

    final displayTime =
        '${timeFormat.format(startTime)}-${timeFormat.format(endTime)}';

    String statusString;
    switch (item.status) {
      case BilateralTradeItemStatus.OPEN:
        statusString = 'OPEN';
        break;
      case BilateralTradeItemStatus.CLOSE:
        statusString = 'CLOSE';
        break;
      case BilateralTradeItemStatus.MATCHED:
        statusString = 'MATCHED';
        break;
      default:
        statusString = 'CLOSE';
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(displayTime, style: TextStyle(fontSize: 26)),
          Text(
            statusString,
            style: TextStyle(
              fontSize: 23,
              color: (item.status == BilateralTradeItemStatus.CLOSE)
                  ? redColor
                  : greenColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCount() {
    return Row(
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
          padding: EdgeInsets.all(4),
          child: Column(
            children: [
              Text(
                item.offerCount.toString(),
                style: TextStyle(fontSize: 24),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Text("Offers \nto sell"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAmount() {
    return (item.amount != null)
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
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            "Amount",
                            style: TextStyle(
                              fontSize: 12,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        Text(
                          item.amount.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: primaryColor,
                          ),
                        ),
                        Text(
                          " kWh",
                          style: TextStyle(
                            fontSize: 12,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            "Price",
                            style: TextStyle(
                              fontSize: 12,
                              color: primaryColor,
                            ),
                          ),
                        ),
                        Text(
                          item.price.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: primaryColor,
                          ),
                        ),
                        Text(
                          " THB/kWh",
                          style: TextStyle(
                            fontSize: 12,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                    (item.isLongterm)
                        ? Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  "Long term Bilateral",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container()
                  ],
                ),
              )
            ],
          )
        : Container();
  }
}

class _BuyItemList extends StatelessWidget {
  const _BuyItemList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bilateralState = Provider.of<BilateralState>(context);
    final tradeItems = bilateralState.tradeItems;
    final buyItems = tradeItems
        .where((element) => element.type == BilateralTradeItemType.BUY)
        .toList();

    return _TradeItemList(items: buyItems);
  }
}

class _TradeItemList extends StatelessWidget {
  const _TradeItemList({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List<BilateralTradeItemModel> items;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        itemBuilder: (context, index) => _TradeItemCard(item: items[index]),
      ),
    );
  }
}

typedef _ViewModeOnChangeCallback = Function(_ViewModeType newItem);

class _ViewModeSelectionDropdown extends StatelessWidget {
  final _viewModeDropdownItems = const <_ViewDropdownItem>[
    const _ViewDropdownItem(
      type: _ViewModeType.OFFER_TO_SELL,
      title: 'Offer to sell',
    ),
    const _ViewDropdownItem(
      type: _ViewModeType.CHOOSE_TO_BUY,
      title: 'Choose to buy',
    ),
  ];

  final _ViewModeType viewModeSelected;

  final _ViewModeOnChangeCallback onChange;

  const _ViewModeSelectionDropdown({
    Key? key,
    required this.viewModeSelected,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      padding: EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButton<_ViewModeType>(
        value: viewModeSelected,
        icon: Icon(Icons.arrow_drop_down_rounded),
        iconSize: 20,
        iconEnabledColor: backgroundColor,
        dropdownColor: primaryColor,
        style: TextStyle(fontSize: 16, color: backgroundColor),
        alignment: Alignment.center,
        borderRadius: BorderRadius.circular(20),
        onChanged: (_ViewModeType? newValue) {
          if (newValue != null) {
            onChange(newValue);
          }
        },
        items: _viewModeDropdownItems.map(
          (_ViewDropdownItem item) {
            return DropdownMenuItem(
              value: item.type,
              child: Text(
                item.title,
                style: TextStyle(fontSize: 14),
              ),
            );
          },
        ).toList(),
        underline: DropdownButtonHideUnderline(
          child: Container(),
        ),
      ),
    );
  }
}

class _DateSelectionDropdown extends StatelessWidget {
  const _DateSelectionDropdown({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedTimeState = Provider.of<BilateralSelectedTimeState>(context);

    final selectedTime = selectedTimeState.selectedTime;
    final selectedDay =
        DateTime(selectedTime.year, selectedTime.month, selectedTime.day);

    final nowRelative = DateTime.now().add(Duration(hours: -6));
    final nowStartDay =
        DateTime(nowRelative.year, nowRelative.month, nowRelative.day, 0, 0, 0);

    final selectableDays = <DateTime>[];
    for (var i = 0; i < 8; i++) {
      selectableDays.add(
        nowStartDay.add(Duration(days: i)),
      );
    }

    return Container(
      height: 35,
      padding: EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButton<DateTime>(
        value: selectedDay,
        icon: Icon(Icons.arrow_drop_down_rounded),
        iconSize: 20,
        alignment: Alignment.center,
        borderRadius: BorderRadius.circular(20),
        onChanged: (DateTime? newValue) {
          if (newValue != null) {
            final newDate = DateTime(
              newValue.year,
              newValue.month,
              newValue.day,
              selectedTime.hour,
              selectedTime.minute,
            );
            _setSelectedTime(context, selectedTimeState, newDate);
          }
        },
        items: selectableDays.map((
          DateTime item,
        ) {
          return DropdownMenuItem(
            value: item,
            child: Text(
              DateFormat('dd MMMM yyyy').format(item.toLocal()),
            ),
          );
        }).toList(),
        underline: DropdownButtonHideUnderline(
          child: Container(),
        ),
      ),
    );
  }

  _setSelectedTime(
    BuildContext context,
    BilateralSelectedTimeState bilateralSelectedTimeState,
    DateTime newDate,
  ) async {
    showLoading();
    try {
      await bilateralSelectedTimeState.setSelectedTime(newDate);
    } catch (e) {
      showException(context, e.toString());
    } finally {
      hideLoading();
    }
  }
}

class _TimeSelectionDropdown extends StatelessWidget {
  final _dropdownItems = const <_TimeSelectionDropdownItem>[
    const _TimeSelectionDropdownItem(startHour: 6, durationHour: 12),
    const _TimeSelectionDropdownItem(startHour: 18, durationHour: 12),
  ];

  const _TimeSelectionDropdown({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bilateralSelectedTimeState =
        Provider.of<BilateralSelectedTimeState>(context);

    final selectedTime = bilateralSelectedTimeState.selectedTime;
    final selectedDay = DateTime(
      selectedTime.year,
      selectedTime.month,
      selectedTime.day,
    );

    return Container(
      height: 35,
      padding: EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButton<DateTime>(
        value: selectedTime,
        icon: Icon(
          Icons.arrow_drop_down_rounded,
        ),
        iconSize: 20,
        alignment: Alignment.center,
        borderRadius: BorderRadius.circular(20),
        onChanged: (DateTime? newValue) {
          if (newValue != null) {
            _setSelectedTime(context, bilateralSelectedTimeState, newValue);
          }
        },
        items: _dropdownItems.map(
          (
            _TimeSelectionDropdownItem item,
          ) {
            final dateFormat = DateFormat('H:mm');
            final startTime = DateTime(
              selectedDay.year,
              selectedDay.month,
              selectedDay.day,
              item.startHour,
            );
            final endTime = DateTime(
              selectedDay.year,
              selectedDay.month,
              selectedDay.day,
              item.startHour + item.durationHour,
            );

            final displayTime =
                '${dateFormat.format(startTime)}-${dateFormat.format(endTime)}';

            return DropdownMenuItem<DateTime>(
              value: startTime,
              child: Text(displayTime),
            );
          },
        ).toList(),
        underline: DropdownButtonHideUnderline(
          child: Container(),
        ),
      ),
    );
  }

  _setSelectedTime(
    BuildContext context,
    BilateralSelectedTimeState bilateralSelectedTimeState,
    DateTime newValue,
  ) async {
    showLoading();
    try {
      await bilateralSelectedTimeState.setSelectedTime(newValue);
    } catch (e) {
      showException(context, e.toString());
    } finally {
      hideLoading();
    }
  }
}

class _TimeSelectionDropdownItem {
  final int startHour;
  final int durationHour;

  const _TimeSelectionDropdownItem({
    required this.startHour,
    required this.durationHour,
  });

  String get title {
    final now = DateTime.now();
    final dateFormat = DateFormat('HH:mm');

    final startHourString = dateFormat.format(
      DateTime(now.year, now.month, now.day, this.startHour),
    );
    final durationHourString = dateFormat.format(
      DateTime(
          now.year, now.month, now.day, this.startHour + this.durationHour),
    );

    return '$startHourString - $durationHourString';
  }
}