import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../models/contract_direction.dart';
import '../../models/energy_transfer_info.dart';
import '../../models/settlement_report_info.dart';
import '../dated_energy_transfer_detail_box.dart';
import '../dated_settlement_report_detail_box.dart';

class BilateralBuyerEnergyShortfallSettlementReportInfoBox
    extends StatelessWidget {
  final BilateralBuyerEnergyShortfallSettlementReportInfo tradeInfo;
  final bool defaultExpanded;

  const BilateralBuyerEnergyShortfallSettlementReportInfoBox({
    Key? key,
    required this.tradeInfo,
    this.defaultExpanded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeStart = tradeInfo.date.toLocal();
    final timeStartHour = DateTime(
      timeStart.year,
      timeStart.month,
      timeStart.day,
      timeStart.hour,
    );

    final dateFormat = DateFormat('HH:mm');
    final timeStartString = dateFormat.format(timeStartHour);
    final timeEndString =
        dateFormat.format(timeStartHour.add(Duration(hours: 1)));

    final dateText = "Delivery Time $timeStartString-$timeEndString";

    return DatedSettlementReportDetail(
      marketType: MarketType.BILATERAL,
      resultType: SettlementResultType.ENERGY_SHORTFALL,
      role: ContractRole.BUYER,
      date: Text(dateText),
      contractId: tradeInfo.contractId,
      targetName: tradeInfo.targetName.join(', '),
      items: [
        DatedSettlementReportDetailBoxItem(
          name: 'Energy commited/Used',
          value:
              '${tradeInfo.energyCommitted.toStringAsFixed(2)}/${tradeInfo.energyUsed.toStringAsFixed(2)} kWh',
          fontSize: 13,
        ),
        DatedSettlementReportDetailBoxItem(
          name: 'NET buy',
          value: '${tradeInfo.netBuy.toStringAsFixed(2)} THB',
          fontSize: 13,
        ),
        DatedSettlementReportDetailBoxItem(
          name: 'Buyer imbalance amount',
          value: '${tradeInfo.buyerImbalanceAmount.toStringAsFixed(2)} kWh',
          fontSize: 13,
          fontColor: Color(0xFFA10C09),
        ),
        DatedSettlementReportDetailBoxItem(
          name: 'Buyer imbalance',
          value: '${tradeInfo.buyerImbalance.toStringAsFixed(2)} THB',
          fontSize: 13,
          fontColor: Color(0xFFA10C09),
        ),
        DatedSettlementReportDetailBoxItem(
          name: 'Wheeling charge Tariff',
          value: '${tradeInfo.wheelingChargeTariff.toStringAsFixed(2)} THB/kWh',
          fontSize: 10,
        ),
        DatedSettlementReportDetailBoxItem(
          name: 'Wheeling charge',
          value: '${tradeInfo.wheelingCharge.toStringAsFixed(2)} THB',
          fontSize: 10,
        ),
        DatedSettlementReportDetailBoxItem(
          name: 'NET energy price(NET buy/Used)',
          value: '${tradeInfo.netEnergyPrice.toStringAsFixed(2)} kWh',
          fontSize: 10,
        ),
      ],
    );
  }
}
