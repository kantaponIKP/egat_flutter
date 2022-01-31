import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../models/contract_direction.dart';
import '../../models/energy_transfer_info.dart';
import '../../models/settlement_report_info.dart';
import '../dated_energy_transfer_detail_box.dart';
import '../dated_settlement_report_detail_box.dart';

class BilateralSellerEnergyShortfallSettlementReportInfoBox
    extends StatelessWidget {
  final BilateralSellerEnergyShortfallSettlementReportInfo tradeInfo;
  final bool defaultExpanded;

  const BilateralSellerEnergyShortfallSettlementReportInfoBox({
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
      role: ContractRole.SELLER,
      date: Text(dateText),
      contractId: tradeInfo.contractId,
      targetName: tradeInfo.targetName.join(', '),
      items: [
        DatedSettlementReportDetailBoxItem(
          name: 'Energy Commited/Delivered',
          value:
              '${tradeInfo.energyCommitted.toStringAsFixed(3)}/${tradeInfo.energyDelivered.toStringAsFixed(3)} kWh',
          fontSize: 13,
        ),
        DatedSettlementReportDetailBoxItem(
          name: 'Seller imbalance amount',
          value: '${tradeInfo.sellerImbalanceAmount.toStringAsFixed(3)} kWh',
          fontSize: 13,
          fontColor: Color(0xFFA10C09),
        ),
        DatedSettlementReportDetailBoxItem(
          name: 'Seller imbalance',
          value: '${tradeInfo.sellerImbalance.toStringAsFixed(3)} THB',
          fontSize: 13,
          fontColor: Color(0xFFA10C09),
        ),
        DatedSettlementReportDetailBoxItem(
          name: 'NET Sales',
          value: '${tradeInfo.netSales.toStringAsFixed(3)} THB',
          fontSize: 13,
        ),
        DatedSettlementReportDetailBoxItem(
          name: 'NET energy price(NET Sales/Energy Delivered)',
          value: '${tradeInfo.netEnergyPrice.toStringAsFixed(3)} THB/kWh',
          fontSize: 10,
        ),
      ],
    );
  }
}
