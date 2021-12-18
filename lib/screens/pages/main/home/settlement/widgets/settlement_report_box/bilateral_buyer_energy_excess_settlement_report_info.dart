import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../models/contract_direction.dart';
import '../../models/energy_transfer_info.dart';
import '../../models/settlement_report_info.dart';
import '../dated_energy_transfer_detail_box.dart';
import '../dated_settlement_report_detail_box.dart';

class BilateralBuyerEnergyExcessSettlementReportInfoBox
    extends StatelessWidget {
  final BilateralBuyerEnergyExcessSettlementReportInfo tradeInfo;
  final bool defaultExpanded;

  const BilateralBuyerEnergyExcessSettlementReportInfoBox({
    Key? key,
    required this.tradeInfo,
    this.defaultExpanded = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeStart = tradeInfo.date;
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
          name: 'Energy Commited/Delivered',
          value:
              '${tradeInfo.energyCommitted.toStringAsFixed(2)}/${tradeInfo.energyDelivered.toStringAsFixed(2)} kWh',
          fontSize: 13,
        ),
        DatedSettlementReportDetailBoxItem(
          name: 'Seller imbalance amount',
          value: '${tradeInfo.sellerImbalanceAmount.toStringAsFixed(2)} THB',
          fontSize: 13,
          fontColor: Color(0xFFA10C09),
        ),
        DatedSettlementReportDetailBoxItem(
          name: 'Seller imbalance',
          value: '${tradeInfo.sellerImbalance.toStringAsFixed(2)} kWh',
          fontSize: 13,
          fontColor: Color(0xFFA10C09),
        ),
      ],
    );
  }
}