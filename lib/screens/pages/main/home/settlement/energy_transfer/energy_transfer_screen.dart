import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/models/contract_direction.dart';
import 'package:egat_flutter/screens/pages/main/states/main_screen_title_state.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/energy_transfer_info.dart';
import '../widgets/energy_info_box/completed_bid_to_buy_energy_transfer_info.dart';
import '../widgets/energy_info_box/completed_choose_to_buy_energy_transfer_info.dart';
import '../widgets/energy_info_box/completed_offer_to_sell_bid_energy_transfer_info.dart';
import '../widgets/energy_info_box/completed_offer_to_sell_energy_transfer_info.dart';
import '../widgets/energy_info_box/scheduled_bid_to_buy_energy_transfer_info.dart';
import '../widgets/energy_info_box/scheduled_choose_to_buy_energy_transfer_info.dart';
import '../widgets/energy_info_box/scheduled_offer_to_sell_bid_energy_transfer_info.dart';
import '../widgets/energy_info_box/scheduled_offer_to_sell_energy_transfer_info.dart';
import 'states/energy_transfer_selected_date_state.dart';
import 'states/energy_transfer_state.dart';
import 'widgets/energy_transfer_graph.dart';

class EnergyTransferScreen extends StatefulWidget {
  EnergyTransferScreen({Key? key}) : super(key: key);

  @override
  _EnergyTransferScreenState createState() => _EnergyTransferScreenState();
}

class _DataDisplaySection extends StatelessWidget {
  final bool isBilateralSelected;

  final bool isPoolMarketSelected;

  const _DataDisplaySection({
    required this.isBilateralSelected,
    required this.isPoolMarketSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final energyTransferState = Provider.of<EnergyTransferState>(context);

    final infos = <EnergyTransferInfo>[
      ...energyTransferState.energyTransferInfos
    ];

    if (!isBilateralSelected) {
      infos.retainWhere((info) =>
          info.direction == TransferDirection.CHOOSE_TO_BUY ||
          info.direction == TransferDirection.OFFER_TO_SELL);
    }

    if (!isPoolMarketSelected) {
      infos.retainWhere((info) =>
          info.direction == TransferDirection.BID_TO_BUY ||
          info.direction == TransferDirection.OFFER_TO_SELL_BID);
    }

    var defaultExpanded = true;
    final boxes = <Widget>[];
    for (var tradeInfo in infos) {
      if (tradeInfo is CompletedBidToBuyEnergyTransferInfo) {
        boxes.add(CompletedBidToBuyEnergyTransferInfoBox(
          tradeInfo: tradeInfo,
          defaultExpanded: defaultExpanded,
        ));
      } else if (tradeInfo is CompletedChooseToBuyEnergyTransferInfo) {
        boxes.add(CompletedChooseToBuyEnergyTransferInfoBox(
          tradeInfo: tradeInfo,
          defaultExpanded: defaultExpanded,
        ));
      } else if (tradeInfo is CompletedOfferToSellBidEnergyTransferInfo) {
        boxes.add(CompletedOfferToSellBidEnergyTransferInfoBox(
          tradeInfo: tradeInfo,
          defaultExpanded: defaultExpanded,
        ));
      } else if (tradeInfo is CompletedOfferToSellEnergyTransferInfo) {
        boxes.add(CompletedOfferToSellEnergyTransferInfoBox(
          tradeInfo: tradeInfo,
          defaultExpanded: defaultExpanded,
        ));
      } else if (tradeInfo is ScheduledBidToBuyEnergyTransferInfo) {
        boxes.add(ScheduledBidToBuyEnergyTransferInfoBox(
          tradeInfo: tradeInfo,
          defaultExpanded: defaultExpanded,
        ));
      } else if (tradeInfo is ScheduledChooseToBuyEnergyTransferInfo) {
        boxes.add(ScheduledChooseToBuyEnergyTransferInfoBox(
          tradeInfo: tradeInfo,
          defaultExpanded: defaultExpanded,
        ));
      } else if (tradeInfo is ScheduledOfferToSellBidEnergyTransferInfo) {
        boxes.add(ScheduledOfferToSellBidEnergyTransferInfoBox(
          tradeInfo: tradeInfo,
          defaultExpanded: defaultExpanded,
        ));
      } else if (tradeInfo is ScheduledOfferToSellEnergyTransferInfo) {
        boxes.add(ScheduledOfferToSellEnergyTransferInfoBox(
          tradeInfo: tradeInfo,
          defaultExpanded: defaultExpanded,
        ));
      }

      defaultExpanded = false;
    }

    final selectedDateState =
        Provider.of<EnergyTransferSelectedDateState>(context);
    final selectedDate = selectedDateState.selectedDate;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 2,
              child: EnergyTransferGraph(
                energyData: infos,
                startHour: selectedDate,
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

class _DateSelectionDropdown extends StatelessWidget {
  const _DateSelectionDropdown({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedDateState =
        Provider.of<EnergyTransferSelectedDateState>(context);

    final selectedDate = selectedDateState.selectedDate;

    final now = DateTime.now();
    final maxDate = DateTime(selectedDate.year, selectedDate.month, 0).day;

    final selectableDates = <DateTime>[];
    if (now.month == selectedDate.month && now.year == selectedDate.year) {
      for (var i = 0; i < maxDate; i++) {
        selectableDates.add(
          DateTime(selectedDate.year, selectedDate.month, i + 1),
        );
      }
    } else {
      for (var i = 0; i < maxDate; i++) {
        selectableDates.add(
          DateTime(selectedDate.year, selectedDate.month, i + 1),
        );
      }
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
    EnergyTransferSelectedDateState bilateralSelectedTimeState,
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

class _EnergyTransferScreenState extends State<EnergyTransferScreen> {
  bool _isBilateralSelected = true;
  bool _isPoolMarketSelected = true;

  bool get isBilateralSelected => _isBilateralSelected;
  bool get isPoolMarketSelected => _isPoolMarketSelected;

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

  @override
  void initState() {
    super.initState();
    final MainScreenTitleState titleState =
        Provider.of<MainScreenTitleState>(context, listen: false);

    titleState.setTitleLogo();
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
                            isBilateralSelected: isBilateralSelected,
                            isPoolMarketSelected: isPoolMarketSelected,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _FilterCheckbox(
              title: AppLocalizations.of(context)
                  .translate('settlement-bilateralTrade'),
              isSelected: isBilateralSelected,
              onTap: () {
                setState(() {
                  _isBilateralSelected = !_isBilateralSelected;
                });
              },
            ),
            _FilterCheckbox(
              title: AppLocalizations.of(context)
                  .translate('settlement-poolMarketTrade'),
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

class _MonthSelectionDropdown extends StatelessWidget {
  const _MonthSelectionDropdown({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedDateState =
        Provider.of<EnergyTransferSelectedDateState>(context);

    final selectedDate = selectedDateState.selectedDate;

    final selectedMonth = DateTime(selectedDate.year, selectedDate.month, 1);

    final now = DateTime.now();

    final selectableMonthes = <DateTime>[];
    for (var i = -1; i < 24; i++) {
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
              DateFormat('MMMM yyyy').format(item.toLocal()),
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
    EnergyTransferSelectedDateState bilateralSelectedTimeState,
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
