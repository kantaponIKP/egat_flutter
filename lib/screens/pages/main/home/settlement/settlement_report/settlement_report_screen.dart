import 'package:egat_flutter/constant.dart';
import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/models/contract_direction.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/models/settlement_report_info.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/settlement_report/states/settlement_report_state.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/widgets/horizontal_positioned_list_view_with_controller.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/widgets/settlement_report_box/bilateal_seller_energy_excess_settlement_report_info.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/widgets/settlement_report_box/bilateal_seller_energy_shortfall_settlement_report_info.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/widgets/settlement_report_box/bilateral_buyer_energy_excess_settlement_report_info.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/widgets/settlement_report_box/bilateral_buyer_energy_shortfall_settlement_report_info.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/widgets/settlement_report_box/pool_buyer_energy_excess_settlement_report_info.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/widgets/settlement_report_box/pool_buyer_energy_shortfall_settlement_report_info%20copy.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/widgets/settlement_report_box/pool_seller_energy_excess_settlement_report_info.dart';
import 'package:egat_flutter/screens/pages/main/home/settlement/widgets/settlement_report_box/pool_seller_energy_shortfall_settlement_report_info.dart';
import 'package:egat_flutter/screens/pages/main/home/widgets/collapsable_report_row.dart';
import 'package:egat_flutter/screens/pages/main/states/main_screen_title_state.dart';
import 'package:egat_flutter/screens/widgets/loading_dialog.dart';
import 'package:egat_flutter/screens/widgets/show_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'states/settlement_report_selected_date_state.dart';

class _DataDisplaySection extends StatelessWidget {
  final bool isBuyerSelected;
  final bool isSellerSelected;

  const _DataDisplaySection({
    Key? key,
    required this.isSellerSelected,
    required this.isBuyerSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SettlementReportSelectedDateState selectedDateState =
        context.watch<SettlementReportSelectedDateState>();

    final isDaily = selectedDateState.isDaily;

    if (isDaily) {
      return SingleChildScrollView(
        key: const Key('data_display_section'),
        child: _DailyDataDisplaySection(
          isBuyerSelected: isBuyerSelected,
          isSellerSelected: isSellerSelected,
        ),
      );
    } else {
      return SingleChildScrollView(
        key: const Key('data_display_section'),
        child: _MonthlyDataDisplaySection(
          isBuyerSelected: isBuyerSelected,
          isSellerSelected: isSellerSelected,
        ),
      );
    }
  }
}

class _DailyDataDisplaySection extends StatelessWidget {
  final bool isBuyerSelected;
  final bool isSellerSelected;

  const _DailyDataDisplaySection({
    Key? key,
    required this.isSellerSelected,
    required this.isBuyerSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SettlementReportState settlementReportState =
        context.watch<SettlementReportState>();

    if (settlementReportState.dailyReport == null) {
      return Container();
    }

    final report = settlementReportState.dailyReport!;

    final defaulTextStyle = TextStyle(fontSize: 15);
    final defaultCollapseTextStyle = TextStyle(fontSize: 12);
    final defaultImbalanceTextStyle =
        TextStyle(fontSize: 15, color: Color(0xFFF6645A));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)
                      .translate('settlement-settlementReport-total'),
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              CollapsableReportRow(
                title: Text(
                  AppLocalizations.of(context)
                      .translate('settlement-completedContracts'),
                ),
                value: Text(report.completedContracts.toStringAsFixed(0)),
                textStyle: defaulTextStyle,
                collapseTextStyle: defaultCollapseTextStyle,
                collapseItems: [
                  CollapsableReportRow(
                      title: Text(
                        AppLocalizations.of(context).translate(
                            'settlement-settlementReport-shortTermBilateralTrade'),
                      ),
                      value: Text(report.completedContractsShortTermBilateral
                          .toStringAsFixed(0))),
                  CollapsableReportRow(
                      title: Text(
                        AppLocalizations.of(context).translate(
                            'settlement-settlementReport-longTermBilateralTrade'),
                      ),
                      value: Text(report.completedContractsLongTermBilateral
                          .toStringAsFixed(0))),
                  CollapsableReportRow(
                      title: Text(
                        AppLocalizations.of(context).translate(
                            'settlement-settlementReport-poolMarketTrade'),
                      ),
                      value: Text(
                          report.completedContractsPool.toStringAsFixed(0))),
                ],
              ),
              CollapsableReportRow(
                title: Text(
                  AppLocalizations.of(context).translate(
                      'settlement-settlementReport-scheduledContracts'),
                ),
                value: Text(report.scheduledContracts.toStringAsFixed(0)),
                textStyle: defaulTextStyle,
                collapseTextStyle: defaultCollapseTextStyle,
                collapseItems: [
                  CollapsableReportRow(
                      title: Text(
                        AppLocalizations.of(context).translate(
                            'settlement-settlementReport-shortTermBilateralTrade'),
                      ),
                      value: Text(report.scheduledContractsShortTermBilateral
                          .toStringAsFixed(0))),
                  CollapsableReportRow(
                      title: Text(
                        AppLocalizations.of(context).translate(
                            'settlement-settlementReport-longTermBilateralTrade'),
                      ),
                      value: Text(report.scheduledContractsLongTermBilateral
                          .toStringAsFixed(0))),
                  CollapsableReportRow(
                      title: Text(
                        AppLocalizations.of(context).translate(
                            'settlement-settlementReport-poolMarketTrade'),
                      ),
                      value: Text(
                          report.scheduledContractsPool.toStringAsFixed(0))),
                ],
              ),
              CollapsableReportRow(
                title: Text(
                  AppLocalizations.of(context).translate(
                          'settlement-settlementReport-sellerEnergyCommited') +
                      AppLocalizations.of(context).translate(
                          'settlement-settlementReport-sellerEnergyCommited-delivered'),
                ),
                value: Text(
                    '${report.sellerEnergyCommited.toStringAsFixed(2)}/${report.sellerEnergyDelivered.toStringAsFixed(2)} kWh'),
                textStyle: defaulTextStyle,
              ),
              CollapsableReportRow(
                title: Text(
                  AppLocalizations.of(context).translate(
                          'settlement-settlementReport-buyerEnergyCommited') +
                      AppLocalizations.of(context).translate(
                          'settlement-settlementReport-buyerEnergyCommited-used'),
                ),
                value: Text(
                    '${report.buyerEnergyCommited.toStringAsFixed(2)}/${report.buyerEnergyUsed.toStringAsFixed(2)} kWh'),
                textStyle: defaulTextStyle,
              ),
              CollapsableReportRow(
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: AppLocalizations.of(context)
                            .translate('settlement-netSales'),
                      ),
                      TextSpan(
                        text:
                            "\n(${AppLocalizations.of(context).translate('settlement-settlementReport-includeImbalanceFees')})",
                        style: defaulTextStyle.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                value: Text('${report.netSales.toStringAsFixed(2)} THB'),
                textStyle: defaulTextStyle,
              ),
              CollapsableReportRow(
                title: Text(
                  AppLocalizations.of(context)
                      .translate('settlement-settlementReport-imbalanceAmount'),
                ),
                value: Text('${report.imbalanceAmount.toStringAsFixed(2)} THB'),
                textStyle: defaultImbalanceTextStyle,
              ),
              CollapsableReportRow(
                title: Text(
                  AppLocalizations.of(context)
                      .translate('settlement-settlementReport-sellerImbalance'),
                ),
                value: Text('${report.sellerImbalance.toStringAsFixed(2)} kWh'),
                textStyle: defaultImbalanceTextStyle,
              ),
              CollapsableReportRow(
                title: Text(
                  AppLocalizations.of(context)
                      .translate('settlement-settlementReport-buyerImbalance'),
                ),
                value: Text('${report.buyerImbalance.toStringAsFixed(2)} kWh'),
                textStyle: defaultImbalanceTextStyle,
              ),
              CollapsableReportRow(
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Buy from Grid amount',
                      ),
                    ],
                  ),
                ),
                value:
                    Text('${report.buyFromGridAmount.toStringAsFixed(2)} kWh'),
                textStyle: defaulTextStyle,
              ),
              CollapsableReportRow(
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Buy from Grid',
                      ),
                    ],
                  ),
                ),
                value: Text('${report.buyFromGrid.toStringAsFixed(2)} THB'),
                textStyle: defaulTextStyle,
              ),
              CollapsableReportRow(
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Sell to Grid amount',
                      ),
                    ],
                  ),
                ),
                value:
                    Text('${report.sellToGridAmount.toStringAsFixed(2)} kWh'),
                textStyle: defaulTextStyle,
              ),
              CollapsableReportRow(
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Sell to Grid',
                      ),
                    ],
                  ),
                ),
                value: Text('${report.sellToGrid.toStringAsFixed(2)} THB'),
                textStyle: defaulTextStyle,
              ),
              CollapsableReportRow(
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: AppLocalizations.of(context)
                              .translate('settlement-netEnergyPrice')),
                      TextSpan(
                        text:
                            "\n(${AppLocalizations.of(context).translate('settlement-settlementReport-netSell')}/${AppLocalizations.of(context).translate('settlement-settlementReport-energyDelivered')})",
                        style: defaulTextStyle.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                value:
                    Text('${report.netEnergyPrice.toStringAsFixed(2)} THB/kWh'),
                textStyle: defaulTextStyle,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 25),
          child: Divider(
            height: 1,
            thickness: 1,
            color: Colors.white,
          ),
        ),
        _DailyReportItemSection(),
      ],
    );
  }
}

class _DailyReportItemSection extends StatelessWidget {
  const _DailyReportItemSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settlementReportState = Provider.of<SettlementReportState>(context);

    if (settlementReportState.dailyReport == null) {
      return Container();
    }

    var reportItems = settlementReportState.dailyReport!.settlementReportInfos;

    if (reportItems.isEmpty) {
      return Container();
    }

    final members = <Widget>[];
    for (var item in reportItems) {
      Widget? widget;
      if (item is BilateralBuyerEnergyShortfallSettlementReportInfo) {
        widget = BilateralBuyerEnergyShortfallSettlementReportInfoBox(
          tradeInfo: item,
        );
      } else if (item is PoolBuyerEnergyShortfallSettlementReportInfo) {
        widget = PoolBuyerEnergyShortfallSettlementReportInfoBox(
          tradeInfo: item,
        );
      } else if (item is BilateralBuyerEnergyExcessSettlementReportInfo) {
        widget = BilateralBuyerEnergyExcessSettlementReportInfoBox(
          tradeInfo: item,
        );
      } else if (item is PoolBuyerEnergyExcessSettlementReportInfo) {
        widget = PoolBuyerEnergyExcessSettlementReportInfoBox(
          tradeInfo: item,
        );
      } else if (item is BilateralSellerEnergyShortfallSettlementReportInfo) {
        widget = BilateralSellerEnergyShortfallSettlementReportInfoBox(
          tradeInfo: item,
        );
      } else if (item is BilateralSellerEnergyExcessSettlementReportInfo) {
        widget = BilateralSellerEnergyExcessSettlementReportInfoBox(
          tradeInfo: item,
        );
      } else if (item is PoolSellerEnergyShortfallSettlementReportInfo) {
        widget = PoolSellerEnergyShortfallSettlementReportInfoBox(
          tradeInfo: item,
        );
      } else if (item is PoolSellerEnergyExcessSettlementReportInfo) {
        widget = PoolSellerEnergyExcessSettlementReportInfoBox(
          tradeInfo: item,
        );
      }

      if (widget != null) {
        members.add(widget);
      }
    }

    return HorizontalPositionedListViewWithController(
      controllerWidth: 40,
      children: members,
    );
  }
}

class _MonthlyDataDisplaySection extends StatelessWidget {
  final bool isBuyerSelected;
  final bool isSellerSelected;

  const _MonthlyDataDisplaySection({
    Key? key,
    required this.isSellerSelected,
    required this.isBuyerSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SettlementReportState settlementReportState =
        context.watch<SettlementReportState>();

    if (settlementReportState.monthlyReport == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final report = settlementReportState.monthlyReport!;

    final defaulTextStyle = TextStyle(fontSize: 15);
    final defaultCollapseTextStyle = TextStyle(fontSize: 12);
    final defaultImbalanceTextStyle =
        TextStyle(fontSize: 15, color: Color(0xFFF6645A));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 8,
              ),
              CollapsableReportRow(
                title: Text(
                  AppLocalizations.of(context)
                      .translate('settlement-completedContracts'),
                ),
                value: Text(report.completedContracts.toStringAsFixed(0)),
                textStyle: defaulTextStyle,
                collapseTextStyle: defaultCollapseTextStyle,
                collapseItems: [
                  CollapsableReportRow(
                      title: Text(
                        AppLocalizations.of(context).translate(
                            'settlement-settlementReport-shortTermBilateralTrade'),
                      ),
                      value: Text(report.completedContractsShortTermBilateral
                          .toStringAsFixed(0))),
                  CollapsableReportRow(
                      title: Text(
                        AppLocalizations.of(context).translate(
                            'settlement-settlementReport-longTermBilateralTrade'),
                      ),
                      value: Text(report.completedContractsLongTermBilateral
                          .toStringAsFixed(0))),
                  CollapsableReportRow(
                    title: Text(
                      AppLocalizations.of(context).translate(
                          'settlement-settlementReport-poolMarketTrade'),
                    ),
                    value:
                        Text(report.completedContractsPool.toStringAsFixed(0)),
                  ),
                ],
              ),
              CollapsableReportRow(
                title: Text(
                  AppLocalizations.of(context)
                      .translate('settlement-scheduledContracts'),
                ),
                value: Text(report.scheduledContracts.toStringAsFixed(0)),
                textStyle: defaulTextStyle,
                collapseTextStyle: defaultCollapseTextStyle,
                collapseItems: [
                  CollapsableReportRow(
                      title: Text(
                        AppLocalizations.of(context).translate(
                            'settlement-settlementReport-shortTermBilateralTrade'),
                      ),
                      value: Text(report.scheduledContractsShortTermBilateral
                          .toStringAsFixed(0))),
                  CollapsableReportRow(
                      title: Text(
                        AppLocalizations.of(context).translate(
                            'settlement-settlementReport-longTermBilateralTrade'),
                      ),
                      value: Text(report.scheduledContractsLongTermBilateral
                          .toStringAsFixed(0))),
                  CollapsableReportRow(
                    title: Text(
                      AppLocalizations.of(context).translate(
                          'settlement-settlementReport-poolMarketTrade'),
                    ),
                    value:
                        Text(report.scheduledContractsPool.toStringAsFixed(0)),
                  ),
                ],
              ),
              CollapsableReportRow(
                title: Text(
                  AppLocalizations.of(context).translate(
                          'settlement-settlementReport-sellerEnergyCommited') +
                      AppLocalizations.of(context).translate(
                          'settlement-settlementReport-sellerEnergyCommited-delivered'),
                ),
                value: Text(
                    '${report.sellerEnergyCommited.toStringAsFixed(2)}/${report.sellerEnergyDelivered.toStringAsFixed(2)} kWh'),
                textStyle: defaulTextStyle,
              ),
              CollapsableReportRow(
                title: Text(
                  AppLocalizations.of(context).translate(
                          'settlement-settlementReport-buyerEnergyCommited') +
                      AppLocalizations.of(context).translate(
                          'settlement-settlementReport-buyerEnergyCommited-used'),
                ),
                value: Text(
                    '${report.buyerEnergyCommited.toStringAsFixed(2)}/${report.buyerEnergyUsed.toStringAsFixed(2)} kWh'),
                textStyle: defaulTextStyle,
              ),
              CollapsableReportRow(
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: AppLocalizations.of(context)
                            .translate('settlement-settlementReport-netSell'),
                      ),
                      TextSpan(
                        text:
                            "\n(${AppLocalizations.of(context).translate('settlement-settlementReport-includeImbalanceFees')})",
                        style: defaulTextStyle.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                value: Text('${report.netSell.toStringAsFixed(2)} THB'),
                textStyle: defaulTextStyle,
              ),
              CollapsableReportRow(
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: AppLocalizations.of(context)
                            .translate('settlement-settlementReport-netBuy'),
                      ),
                      TextSpan(
                        text:
                            "\n(${AppLocalizations.of(context).translate('settlement-settlementReport-includeImbalanceFees')})",
                        style: defaulTextStyle.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                value: Text('${report.netBuy.toStringAsFixed(2)} THB'),
                textStyle: defaulTextStyle,
              ),
              CollapsableReportRow(
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Buy from Grid amount',
                      ),
                    ],
                  ),
                ),
                value:
                    Text('${report.buyFromGridAmount.toStringAsFixed(2)} kWh'),
                textStyle: defaulTextStyle,
              ),
              CollapsableReportRow(
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Buy from Grid',
                      ),
                    ],
                  ),
                ),
                value: Text('${report.buyFromGrid.toStringAsFixed(2)} THB'),
                textStyle: defaulTextStyle,
              ),
              CollapsableReportRow(
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Sell to Grid amount',
                      ),
                    ],
                  ),
                ),
                value:
                    Text('${report.sellToGridAmount.toStringAsFixed(2)} kWh'),
                textStyle: defaulTextStyle,
              ),
              CollapsableReportRow(
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Sell to Grid',
                      ),
                    ],
                  ),
                ),
                value: Text('${report.sellToGrid.toStringAsFixed(2)} THB'),
                textStyle: defaulTextStyle,
              ),
              CollapsableReportRow(
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "NET Sales",
                      ),
                    ],
                  ),
                ),
                value: Text('${report.netSell.toStringAsFixed(2)} THB'),
                textStyle: defaulTextStyle,
              ),
              CollapsableReportRow(
                title: Text(
                  AppLocalizations.of(context).translate(
                      'settlement-settlementReport-sellerImbalanceAmount'),
                ),
                value: Text(
                    '${report.sellerImbalanceAmount.toStringAsFixed(2)} kWh'),
                textStyle: defaultImbalanceTextStyle,
              ),
              CollapsableReportRow(
                title: Text(
                  AppLocalizations.of(context).translate(
                      'settlement-settlementReport-buyerImbalanceAmount'),
                ),
                value: Text(
                    '${report.buyerImbalanceAmount.toStringAsFixed(2)} kWh'),
                textStyle: defaultImbalanceTextStyle,
              ),
              CollapsableReportRow(
                title: Text(
                  AppLocalizations.of(context)
                      .translate('settlement-settlementReport-netImbalance'),
                ),
                value: Text('${report.netImbalance.toStringAsFixed(2)} THB'),
                textStyle: defaulTextStyle,
              ),
              CollapsableReportRow(
                title: Text(
                  AppLocalizations.of(context)
                      .translate('settlement-wheelingCharge'),
                ),
                value: Text('${report.wheelingCharge.toStringAsFixed(2)} THB'),
                textStyle: defaulTextStyle,
              ),
              CollapsableReportRow(
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: AppLocalizations.of(context).translate(
                            'settlement-settlementReport-netEnergySalesPrice'),
                      ),
                      TextSpan(
                        text:
                            "\n(${AppLocalizations.of(context).translate('settlement-settlementReport-netSell')}/${AppLocalizations.of(context).translate('settlement-settlementReport-energyDelivered')})",
                        style: defaulTextStyle.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                value: Text(
                    '${report.netEnergySalesPrice.toStringAsFixed(2)} THB/kWh'),
                textStyle: defaulTextStyle,
              ),
              CollapsableReportRow(
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: AppLocalizations.of(context).translate(
                            'settlement-settlementReport-netEnergyBuyPrice'),
                      ),
                      TextSpan(
                        text:
                            "\n(${AppLocalizations.of(context).translate('settlement-settlementReport-netBuy')}/${AppLocalizations.of(context).translate('settlement-settlementReport-used')})",
                        style: defaulTextStyle.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                value: Text(
                    '${report.netEnergyBuyPrice.toStringAsFixed(2)} THB/kWh'),
                textStyle: defaulTextStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SettlementReportScreen extends StatefulWidget {
  SettlementReportScreen({Key? key}) : super(key: key);

  @override
  _SettlementReportScreenState createState() => _SettlementReportScreenState();
}

class _DateSelectionBar extends StatelessWidget {
  const _DateSelectionBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settlementReportSelectedDateState =
        Provider.of<SettlementReportSelectedDateState>(context);

    var isDaily = settlementReportSelectedDateState.isDaily;

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
        Visibility(
          visible: isDaily,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: _DateSelectionDropdown(),
          ),
        ),
        Flexible(
          flex: 3,
          // fit: FlexFit.tight,
          child: Container(),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Row(
            children: [
              Text(AppLocalizations.of(context)
                  .translate('settlement-settlementReport-daily')),
              Switch(
                value: isDaily,
                onChanged: (value) => _updateIsDaily(context, value),
                activeColor: primaryColor,
              )
            ],
          ),
        )
      ],
    );
  }

  void _updateIsDaily(BuildContext context, bool value) async {
    showLoading();

    try {
      final settlementReportSelectedDateState =
          Provider.of<SettlementReportSelectedDateState>(context,
              listen: false);

      await settlementReportSelectedDateState.setIsDaily(value);
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
    final selectedDateState =
        Provider.of<SettlementReportSelectedDateState>(context);

    final selectedDate = selectedDateState.selectedDate;

    final now = DateTime.now();
    final daysInMonth =
        DateTime(selectedDate.year, selectedDate.month + 1, 0).day;

    final selectableDates = <DateTime>[];
    if (now.month == selectedDate.month && now.year == selectedDate.year) {
      for (var i = 0; i < daysInMonth; i++) {
        selectableDates.add(
          DateTime(selectedDate.year, selectedDate.month, i + 1),
        );
      }
    } else {
      for (var i = 0; i < daysInMonth; i++) {
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
    SettlementReportSelectedDateState bilateralSelectedTimeState,
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

class _SettlementReportScreenState extends State<SettlementReportScreen> {
  bool _isSellerSelected = true;
  bool _isBuyerSelected = true;
  bool get _isAllSelected => _isSellerSelected && _isBuyerSelected;

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
                        // _filterSelectionBar(),
                        SizedBox(height: 8),
                        Expanded(
                          child: _DataDisplaySection(
                            isSellerSelected: _isSellerSelected,
                            isBuyerSelected: _isBuyerSelected,
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
                  .translate('settlement-settlementReport-all'),
              isSelected: _isAllSelected,
              onTap: () {
                setState(() {
                  final isAllSelected = _isAllSelected;
                  _isSellerSelected = isAllSelected ? false : true;
                  _isBuyerSelected = isAllSelected ? false : true;
                });
              },
            ),
            _FilterCheckbox(
              title: AppLocalizations.of(context)
                  .translate('settlement-settlementReport-buyer'),
              isSelected: _isBuyerSelected,
              onTap: () {
                setState(() {
                  _isBuyerSelected = !_isBuyerSelected;
                });
              },
            ),
            _FilterCheckbox(
              title: AppLocalizations.of(context)
                  .translate('settlement-settlementReport-seller'),
              isSelected: _isSellerSelected,
              onTap: () {
                setState(() {
                  _isSellerSelected = !_isSellerSelected;
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
        Provider.of<SettlementReportSelectedDateState>(context);

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
    SettlementReportSelectedDateState bilateralSelectedTimeState,
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
