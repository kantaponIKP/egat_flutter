import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../models/contract_direction.dart';
import '../../models/energy_transfer_info.dart';
import '../dated_energy_transfer_detail_box.dart';

class ScheduledOfferToSellBidEnergyTransferInfoBox extends StatelessWidget {
  final ScheduledOfferToSellBidEnergyTransferInfo tradeInfo;
  final bool defaultExpanded;

  const ScheduledOfferToSellBidEnergyTransferInfoBox({
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

    return DatedEnergyDetail(
      direction: TransferDirection.OFFER_TO_SELL,
      date: Text(dateText),
      contractId: tradeInfo.contractId,
      status: EnergyTransferStatus.SCHEDULED,
      targetName: tradeInfo.targetName.join(', '),
      defaultExpanded: defaultExpanded,
      items: [
        DatedEnergyDetailBoxItem(
          name: 'Offered amount(Matched)',
          value: '${tradeInfo.offeredAmount.toStringAsFixed(2)} kWh',
          fontSize: 13,
          fontColor: Color(0xFF0329F2),
        ),
        DatedEnergyDetailBoxItem(
          name: 'Market clearing price',
          value: '${tradeInfo.marketClearingPrice.toStringAsFixed(2)} THB/kWh',
          fontSize: 13,
          fontColor: Color(0xFF0329F2),
        ),
        DatedEnergyDetailBoxItem(
          name: 'NET Sales',
          value: '${tradeInfo.netSales.toStringAsFixed(2)} THB',
          fontSize: 13,
        ),
        DatedEnergyDetailBoxItem(
          name: 'NET energy price(NET Sales/Energy Delivered)',
          value: '${tradeInfo.netEnergyPrice.toStringAsFixed(2)} THB/kWh',
          fontSize: 10,
        ),
        DatedEnergyDetailBoxItem(
          name: 'Trading Fee',
          value: '${tradeInfo.tradingFee.toStringAsFixed(2)} THB/kWh',
          fontSize: 10,
        ),
      ],
    );
  }
}
