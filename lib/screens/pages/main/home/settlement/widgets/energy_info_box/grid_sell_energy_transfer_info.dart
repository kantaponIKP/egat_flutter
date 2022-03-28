import 'package:egat_flutter/i18n/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../models/contract_direction.dart';
import '../../models/energy_transfer_info.dart';
import '../dated_energy_transfer_detail_box.dart';

class GridSellEnergyTransferInfoBox extends StatelessWidget {
  final GridSellInfo tradeInfo;
  final bool defaultExpanded;

  const GridSellEnergyTransferInfoBox({
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

    final dateText =
        "${AppLocalizations.of(context).translate('settlement-deliveryTime')} $timeStartString-$timeEndString";

    return DatedEnergyDetail(
      direction: TransferDirection.GRID_SELL,
      date: Text(dateText),
      contractId: tradeInfo.contractId,
      status: EnergyTransferStatus.COMPLETED,
      targetName: tradeInfo.targetName.join(', '),
      defaultExpanded: defaultExpanded,
      items: [
        DatedEnergyDetailBoxItem(
          name: 'Sold amount(Actual)',
          value: '${tradeInfo.soldAmount.toStringAsFixed(3)} kWh',
          fontSize: 13,
        ),
        DatedEnergyDetailBoxItem(
          name: 'NET Sell',
          value: '${tradeInfo.netSell.toStringAsFixed(3)} THB',
          fontSize: 13,
        ),
        DatedEnergyDetailBoxItem(
          name: 'NET energy price(Public Sector Solar)',
          value: '${tradeInfo.netEnergyPrice.toStringAsFixed(3)} THB/kWh',
          fontSize: 10,
        ),
      ],
    );
  }
}
