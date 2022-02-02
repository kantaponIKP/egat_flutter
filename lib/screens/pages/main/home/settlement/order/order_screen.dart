import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/models/contract_direction.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/models/contract_status.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/models/trade_info.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/order/states/order_selected_date_state.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/order/widgets/order_graph.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/widgets/dated_trade_detail_box.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/widgets/trade_info_box/matched_bid_to_buy_trade_info_box.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/widgets/trade_info_box/matched_choose_to_buy_trade_info_box.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/widgets/trade_info_box/matched_offer_to_sell_bid_trade_info.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/widgets/trade_info_box/matched_offer_to_sell_trade_info.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/widgets/trade_info_box/open_offer_to_sell_trade_info_box.dart';
import 'package:egat_flutter/screens/pages/main/states/main_screen_title_state.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'states/order_state.dart';

class OrderScreen extends StatefulWidget {
  OrderScreen({Key? key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool _isBilateralSelected = true;
  bool _isPoolMarketSelected = true;

  bool get isBilateralSelected => _isBilateralSelected;
  bool get isPoolMarketSelected => _isPoolMarketSelected;

  @override
  void initState() {
    super.initState();
    final MainScreenTitleState titleState =
        Provider.of<MainScreenTitleState>(context, listen: false);

    titleState.setTitleLogo();
  }

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
      child: _buildBody(context),
    );
  }

  Padding _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
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
                        SizedBox(height: 16),
                        _DateSelectionBar(),
                        _filterSelectionBar(),
                        Expanded(
                          child: _DataDisplaySection(
                            isBilateralSelected: _isBilateralSelected,
                            isPoolMarketSelected: _isPoolMarketSelected,
                          ),
                        ),
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

  Widget _filterSelectionBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _FilterCheckbox(
                title: AppLocalizations.of(context)
                    .translate('settlement-order-bilateralTrade'),
                isSelected: isBilateralSelected,
                onTap: () {
                  setState(() {
                    _isBilateralSelected = !_isBilateralSelected;
                  });
                },
              ),
              _FilterCheckbox(
                title: AppLocalizations.of(context)
                    .translate('settlement-order-poolMarketTrade'),
                isSelected: isPoolMarketSelected,
                onTap: () {
                  setState(() {
                    _isPoolMarketSelected = !_isPoolMarketSelected;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterCheckbox extends StatelessWidget {
  final String title;
  final bool isSelected;
  final void Function()? onTap;

  const _FilterCheckbox({
    required this.title,
    required this.isSelected,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isSelected,
          visualDensity: VisualDensity.compact,
          onChanged: onTap != null
              ? (_) {
                  onTap?.call();
                }
              : null,
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(title),
        ),
      ],
    );
  }
}

class _DataDisplaySection extends StatelessWidget {
  final bool isBilateralSelected;
  final bool isPoolMarketSelected;

  const _DataDisplaySection({
    Key? key,
    required this.isBilateralSelected,
    required this.isPoolMarketSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderState = Provider.of<OrderState>(context);

    final infos = <TradeInfo>[...orderState.tradeInfos];

    if (!isBilateralSelected) {
      infos.retainWhere((info) =>
          info is OpenOfferToSellTradeInfo ||
          info is MatchedOfferToSellTradeInfoBox);
    }

    if (!isPoolMarketSelected) {
      infos.retainWhere((info) =>
          info is MatchedBidToBuyTradeInfo ||
          info is MatchedOfferToSellBidTradeInfo);
    }

    var defaultExpanded = true;
    final boxes = <Widget>[];
    for (var tradeInfo in infos) {
      if (tradeInfo is OpenOfferToSellTradeInfo) {
        boxes.add(OpenOfferToSellTradeInfoBox(
          tradeInfo: tradeInfo,
          defaultExpanded: defaultExpanded,
        ));
      } else if (tradeInfo is MatchedOfferToSellTradeInfo) {
        boxes.add(MatchedOfferToSellTradeInfoBox(
          tradeInfo: tradeInfo,
          defaultExpanded: defaultExpanded,
        ));
      } else if (tradeInfo is MatchedChooseToBuyTradeInfo) {
        boxes.add(MatchedChooseToBuyTradeInfoBox(
          tradeInfo: tradeInfo,
          defaultExpanded: defaultExpanded,
        ));
      } else if (tradeInfo is MatchedOfferToSellBidTradeInfo) {
        boxes.add(MatchedOfferToSellBidTradeInfoBox(
          tradeInfo: tradeInfo,
          defaultExpanded: defaultExpanded,
        ));
      } else if (tradeInfo is MatchedBidToBuyTradeInfo) {
        boxes.add(MatchedBidToBuyTradeInfoBox(
          tradeInfo: tradeInfo,
          defaultExpanded: defaultExpanded,
        ));
      }

      defaultExpanded = false;
    }

    final selectedDateState = Provider.of<OrderSelectedDateState>(context);
    final selectedDate = selectedDateState.selectedDate;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SizedBox(
              height: 230,
              child: OrderGraph(
                startHour: selectedDate,
                energyData: infos,
              ),
            ),
            SizedBox(height: 16),
            ...boxes.map((box) =>
                Padding(padding: EdgeInsets.only(bottom: 16), child: box)),
          ],
        ),
      ),
    );
  }
}

class _DateSelectionBar extends StatelessWidget {
  const _DateSelectionBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 4,
          ),
          child: _MonthSelectionDropdown(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          child: _DateSelectionDropdown(),
        ),
        Flexible(
          flex: 3,
          // fit: FlexFit.tight,
          child: Container(),
        ),
      ],
    );
  }
}

class _MonthSelectionDropdown extends StatelessWidget {
  const _MonthSelectionDropdown({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedDateState = Provider.of<OrderSelectedDateState>(context);

    final selectedDate = selectedDateState.selectedDate;

    final selectedMonth = DateTime(selectedDate.year, selectedDate.month, 1);

    final now = DateTime.now();

    final selectableMonthes = <DateTime>[];
    for (var i = -12; i < 24; i++) {
      selectableMonthes.add(DateTime(now.year, now.month - i, 1));
    }

    return Container(
      height: 35,
      padding: EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButton<DateTime>(
        value: selectedMonth,
        icon: Icon(Icons.arrow_drop_down_rounded),
        iconSize: 20,
        alignment: Alignment.center,
        borderRadius: BorderRadius.circular(20),
        onChanged: (DateTime? newValue) {
          if (newValue != null) {
            var newDate = DateTime(
              newValue.year,
              newValue.month,
              selectedDate.day,
            );

            if (newDate.month != newValue.month) {
              newDate = DateTime(
                newDate.year,
                newDate.month,
                0,
              );
            }

            _setSelectedDate(context, selectedDateState, newDate);
          }
        },
        items: selectableMonthes.map((
          DateTime item,
        ) {
          return DropdownMenuItem(
            value: item,
            child: Text(
              DateFormat(
                'MMMM yyyy',
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

  _setSelectedDate(
    BuildContext context,
    OrderSelectedDateState bilateralSelectedTimeState,
    DateTime newDate,
  ) async {
    showLoading();
    try {
      await bilateralSelectedTimeState.setSelectedDate(newDate);
    } catch (e) {
      showException(context, e.toString());
    } finally {
      hideLoading();
    }
  }
}

class _DateSelectionDropdown extends StatelessWidget {
  const _DateSelectionDropdown({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedDateState = Provider.of<OrderSelectedDateState>(context);

    final selectedDate = selectedDateState.selectedDate;

    final now = DateTime.now();
    final maxDate = DateTime(selectedDate.year, selectedDate.month, 0).day;

    final selectableDates = <DateTime>[];
    for (var i = 0; i < maxDate; i++) {
      selectableDates.add(
        DateTime(selectedDate.year, selectedDate.month, i + 1),
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
        value: selectedDate,
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
            );
            _setSelectedDate(context, selectedDateState, newDate);
          }
        },
        items: selectableDates.map((
          DateTime item,
        ) {
          return DropdownMenuItem(
            value: item,
            child: Text(
              DateFormat('d').format(item.toLocal()),
            ),
          );
        }).toList(),
        underline: DropdownButtonHideUnderline(
          child: Container(),
        ),
      ),
    );
  }

  _setSelectedDate(
    BuildContext context,
    OrderSelectedDateState bilateralSelectedTimeState,
    DateTime newDate,
  ) async {
    showLoading();
    try {
      await bilateralSelectedTimeState.setSelectedDate(newDate);
    } catch (e) {
      showException(context, e.toString());
    } finally {
      hideLoading();
    }
  }
}
