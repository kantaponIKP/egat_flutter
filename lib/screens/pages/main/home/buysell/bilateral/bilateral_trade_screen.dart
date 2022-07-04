import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/bilateral/models/bilateral_model.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/bilateral/sell/bilateral_sell_page.dart';
import 'package:egat_flutter/screens/pages/main/home/buysell/bilateral/states/bilateral_selected_time_state.dart';
import 'package:egat_flutter/screens/pages/main/states/main_screen_title_state.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'buy/bilateral_buy_page.dart';
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
    final titleState =
        Provider.of<MainScreenTitleState>(context, listen: false);

    titleState.setTitleLogo();
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                children: [
                                  _DateSelectionDropdown(),
                                ],
                              ),
                              _ViewModeSelectionButton(
                                viewModeSelected: _viewModeSelected,
                                onChange: (newItem) => setState(() {
                                  _viewModeSelected = newItem;
                                }),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child:
                              (_viewModeSelected == _ViewModeType.CHOOSE_TO_BUY)
                                  ? _BuyItemList(
                                      onItemTap: _onListTileBuyPressed,
                                    )
                                  : _SellItemList(
                                      onItemTap: _onListTileSellPressed,
                                    ),
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

  void _onListTileBuyPressed(BilateralTradeItemModel item) async {
    final isoDate = item.time;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BilateralBuyPage(
          date: isoDate,
          enabled: item.status == BilateralTradeItemStatus.OPEN,
        ),
      ),
    );

    await _reloadContent();
  }

  Future<void> _reloadContent() async {
    final bilateralState = Provider.of<BilateralState>(context, listen: false);
    final selectedTimeState =
        Provider.of<BilateralSelectedTimeState>(context, listen: false);

    showLoading();
    try {
      await bilateralState.fetchTradeAtTime(selectedTimeState.selectedTime);
    } catch (e) {
      showException(context, 'Loading Bilaterals failed');
    } finally {
      await hideLoading();
    }
  }

  void _onListTileSellPressed(BilateralTradeItemModel item) async {
    final isoDate = item.time;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BilateralSellPage(
            date: isoDate,
            enabled: item.status == BilateralTradeItemStatus.OPEN),
      ),
    );

    _reloadContent();
  }
}

class _SellItemList extends StatelessWidget {
  final Function(BilateralTradeItemModel)? onItemTap;

  const _SellItemList({
    Key? key,
    this.onItemTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bilateralState = Provider.of<BilateralState>(context);
    final tradeItems = bilateralState.tradeItems;
    final sellItems = tradeItems
        .where((element) => element.type == BilateralTradeItemType.SELL)
        .toList();

    return _TradeItemList(
      items: sellItems,
      onItemTap: onItemTap,
    );
  }
}

class _TradeItemCard extends StatelessWidget {
  final BilateralTradeItemModel item;
  final Function()? onTap;

  const _TradeItemCard({
    required this.item,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: surfaceGreyColor,
          child: IntrinsicHeight(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    _buildStatus(context),
                    _buildAmount(context),
                    _buildOfferCount(context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _buildStatus(context) {
    final timeFormat = DateFormat('HH:mm');
    final startTime = item.time;
    final endTime = item.time.add(new Duration(hours: 1));

    final displayTime =
        '${timeFormat.format(startTime)}-${timeFormat.format(endTime)}';

    String statusString;
    switch (item.status) {
      case BilateralTradeItemStatus.OPEN:
        statusString =
            AppLocalizations.of(context).translate('trade-status-open');
        break;
      case BilateralTradeItemStatus.CLOSE:
        statusString =
            AppLocalizations.of(context).translate('trade-status-close');
        break;
      case BilateralTradeItemStatus.MATCHED:
        statusString =
            AppLocalizations.of(context).translate('trade-status-matched');
        break;
      default:
        statusString =
            AppLocalizations.of(context).translate('trade-status-close');
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

  Widget _buildOfferCount(context) {
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
                child: Text(
                    AppLocalizations.of(context).translate('trade-offers') +
                        "\n" +
                        AppLocalizations.of(context).translate('trade-toSell'),
                    textAlign: TextAlign.center),
                // child: Text("Offers \nto sell"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAmount(context) {
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
                            AppLocalizations.of(context).translate('amount'),
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
                            AppLocalizations.of(context).translate('price'),
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
  final Function(BilateralTradeItemModel)? onItemTap;

  const _BuyItemList({
    Key? key,
    this.onItemTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bilateralState = Provider.of<BilateralState>(context);
    final tradeItems = bilateralState.tradeItems;
    final buyItems = tradeItems
        .where((element) => element.type == BilateralTradeItemType.BUY)
        .toList();

    return _TradeItemList(
      items: buyItems,
      onItemTap: onItemTap,
    );
  }
}

class _TradeItemList extends StatelessWidget {
  final Function(BilateralTradeItemModel)? onItemTap;

  const _TradeItemList({
    Key? key,
    required this.items,
    this.onItemTap,
  }) : super(key: key);

  final List<BilateralTradeItemModel> items;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: items.length,
        itemBuilder: (context, index) => _TradeItemCard(
          item: items[index],
          onTap: onItemTap != null
              ? () {
                  onItemTap?.call(items[index]);
                }
              : null,
        ),
      ),
    );
  }
}

typedef _ViewModeOnChangeCallback = Function(_ViewModeType newItem);

class _ViewModeSelectionButton extends StatelessWidget {
  final _ViewModeType viewModeSelected;

  final _ViewModeOnChangeCallback onChange;

  _ViewModeSelectionButton({
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
      child: Row(
        children: [
          ElevatedButton(
            onPressed: viewModeSelected != _ViewModeType.OFFER_TO_SELL
                ? () => onChange(_ViewModeType.OFFER_TO_SELL)
                : null,
            child: Text(
              AppLocalizations.of(context).translate('trade-offerToSell'),
            ),
          ),
          ElevatedButton(
            onPressed: viewModeSelected != _ViewModeType.CHOOSE_TO_BUY
                ? () => onChange(_ViewModeType.CHOOSE_TO_BUY)
                : null,
            child: Text(
              AppLocalizations.of(context).translate('trade-chooseToBuy'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewModeSelectionDropdown extends StatelessWidget {
  final _ViewModeType viewModeSelected;

  final _ViewModeOnChangeCallback onChange;

  _ViewModeSelectionDropdown({
    Key? key,
    required this.viewModeSelected,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _viewModeDropdownItems = <_ViewDropdownItem>[
      _ViewDropdownItem(
        type: _ViewModeType.OFFER_TO_SELL,
        title: AppLocalizations.of(context).translate('trade-offerToSell'),
      ),
      _ViewDropdownItem(
        type: _ViewModeType.CHOOSE_TO_BUY,
        title: AppLocalizations.of(context).translate('trade-chooseToBuy'),
        // title: 'Choose to Buy',
      ),
    ];
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

    final nowRelative = DateTime.now();
    final nowStartDay =
        DateTime(nowRelative.year, nowRelative.month, nowRelative.day, 0, 0, 0);

    final selectableDays = <DateTime>[];
    for (var i = 0; i < 2; i++) {
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
              0,
              0,
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
              DateFormat(
                'dd MMMM yyyy',
                AppLocalizations.of(context).getLocale().toString(),
              ).format(item.toLocal()),
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
